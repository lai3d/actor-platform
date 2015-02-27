package im.actor.model.modules;

import java.util.HashMap;

import im.actor.model.api.OutPeer;
import im.actor.model.api.base.SeqUpdate;
import im.actor.model.api.rpc.RequestClearChat;
import im.actor.model.api.rpc.RequestDeleteChat;
import im.actor.model.api.rpc.ResponseSeq;
import im.actor.model.api.updates.UpdateChatClear;
import im.actor.model.api.updates.UpdateChatDelete;
import im.actor.model.concurrency.Command;
import im.actor.model.concurrency.CommandCallback;
import im.actor.model.droidkit.actors.ActorCreator;
import im.actor.model.droidkit.actors.ActorRef;
import im.actor.model.droidkit.actors.Props;
import im.actor.model.entity.Dialog;
import im.actor.model.entity.Group;
import im.actor.model.entity.Message;
import im.actor.model.entity.Peer;
import im.actor.model.entity.PeerType;
import im.actor.model.entity.User;
import im.actor.model.modules.messages.ConversationActor;
import im.actor.model.modules.messages.DialogsActor;
import im.actor.model.modules.messages.DialogsHistoryActor;
import im.actor.model.modules.messages.OwnReadActor;
import im.actor.model.modules.messages.PlainReaderActor;
import im.actor.model.modules.messages.PlainReceiverActor;
import im.actor.model.modules.messages.SenderActor;
import im.actor.model.network.RpcCallback;
import im.actor.model.network.RpcException;
import im.actor.model.network.RpcInternalException;
import im.actor.model.storage.ListEngine;

import static im.actor.model.droidkit.actors.ActorSystem.system;

/**
 * Created by ex3ndr on 09.02.15.
 */
public class Messages extends BaseModule {

    private ListEngine<Dialog> dialogs;
    private ActorRef dialogsActor;
    private ActorRef dialogsHistoryActor;
    private ActorRef ownReadActor;
    private ActorRef plainReadActor;
    private ActorRef plainReceiverActor;
    private ActorRef sendMessageActor;

    private final HashMap<Peer, ListEngine<Message>> conversationEngines = new HashMap<Peer, ListEngine<Message>>();
    private final HashMap<Peer, ActorRef> conversationActors = new HashMap<Peer, ActorRef>();

    public Messages(final Modules messenger) {
        super(messenger);
        this.dialogs = messenger.getConfiguration().getStorage().createDialogsEngine();
    }

    public void run() {
        this.dialogsActor = system().actorOf(Props.create(DialogsActor.class, new ActorCreator<DialogsActor>() {
            @Override
            public DialogsActor create() {
                return new DialogsActor(modules());
            }
        }), "actor/dialogs");
        this.dialogsHistoryActor = system().actorOf(Props.create(DialogsHistoryActor.class, new ActorCreator<DialogsHistoryActor>() {
            @Override
            public DialogsHistoryActor create() {
                return new DialogsHistoryActor(modules());
            }
        }), "actor/dialogs/history");
        this.ownReadActor = system().actorOf(Props.create(OwnReadActor.class, new ActorCreator<OwnReadActor>() {
            @Override
            public OwnReadActor create() {
                return new OwnReadActor(modules());
            }
        }), "actor/read/own");
        this.plainReadActor = system().actorOf(Props.create(PlainReaderActor.class, new ActorCreator<PlainReaderActor>() {
            @Override
            public PlainReaderActor create() {
                return new PlainReaderActor(modules());
            }
        }), "actor/plain/read");
        this.plainReceiverActor = system().actorOf(Props.create(PlainReceiverActor.class, new ActorCreator<PlainReceiverActor>() {
            @Override
            public PlainReceiverActor create() {
                return new PlainReceiverActor(modules());
            }
        }), "actor/plain/receive");
        this.sendMessageActor = system().actorOf(Props.create(SenderActor.class, new ActorCreator<SenderActor>() {
            @Override
            public SenderActor create() {
                return new SenderActor(modules());
            }
        }), "actor/sender/small");
    }

    public ActorRef getSendMessageActor() {
        return sendMessageActor;
    }

    public ActorRef getPlainReadActor() {
        return plainReadActor;
    }

    public ActorRef getPlainReceiverActor() {
        return plainReceiverActor;
    }

    public ActorRef getOwnReadActor() {
        return ownReadActor;
    }

    public ActorRef getConversationActor(final Peer peer) {
        synchronized (conversationActors) {
            if (!conversationActors.containsKey(peer)) {
                conversationActors.put(peer, system().actorOf(Props.create(ConversationActor.class,
                        new ActorCreator<ConversationActor>() {
                            @Override
                            public ConversationActor create() {
                                return new ConversationActor(peer, modules());
                            }
                        }), "actor/conv_" + peer.getPeerType() + "_" + peer.getPeerId()));
            }
            return conversationActors.get(peer);
        }
    }

    public ListEngine<Message> getConversationEngine(Peer peer) {
        synchronized (conversationEngines) {
            if (!conversationEngines.containsKey(peer)) {
                conversationEngines.put(peer, modules().getConfiguration().getStorage().createMessagesEngine(peer));
            }
            return conversationEngines.get(peer);
        }
    }

    public ActorRef getDialogsActor() {
        return dialogsActor;
    }

    public ActorRef getDialogsHistoryActor() {
        return dialogsHistoryActor;
    }

    public ListEngine<Dialog> getDialogsEngine() {
        return dialogs;
    }

    public void loadMoreDialogs() {
        dialogsHistoryActor.send(new DialogsHistoryActor.LoadMore());
    }

    public void sendMessage(final Peer peer, final String message) {
        sendMessageActor.send(new SenderActor.SendText(peer, message));
    }

    public void onInMessageShown(Peer peer, long rid, long sortDate, boolean isEncrypted) {
        ownReadActor.send(new OwnReadActor.MessageRead(peer, rid, sortDate, isEncrypted));
    }

    public void saveReadState(Peer peer, long lastReadDate) {
        preferences().putLong("read_state_" + peer.getUid(), lastReadDate);
    }

    public long loadReadState(Peer peer) {
        return preferences().getLong("read_state_" + peer.getUid(), 0);
    }

    public void saveDraft(Peer peer, String draft) {
        preferences().putString("draft_" + peer.getUid(), draft.trim());
    }

    public String loadDraft(Peer peer) {
        String res = preferences().getString("draft_" + peer.getUid());
        if (res == null) {
            return "";
        } else {
            return res;
        }
    }

    public Command<Boolean> deleteChat(final Peer peer) {
        return new Command<Boolean>() {
            @Override
            public void start(final CommandCallback<Boolean> callback) {
                OutPeer outPeer;
                final im.actor.model.api.Peer apiPeer;
                if (peer.getPeerType() == PeerType.PRIVATE) {
                    User user = users().getValue(peer.getPeerId());
                    if (user == null) {
                        runOnUiThread(new Runnable() {
                            @Override
                            public void run() {
                                callback.onError(new RpcInternalException());
                            }
                        });
                        return;
                    }
                    outPeer = new OutPeer(im.actor.model.api.PeerType.PRIVATE, user.getUid(),
                            user.getAccessHash());
                    apiPeer = new im.actor.model.api.Peer(im.actor.model.api.PeerType.PRIVATE,
                            user.getUid());
                } else if (peer.getPeerType() == PeerType.GROUP) {
                    Group group = groups().getValue(peer.getPeerId());
                    if (group == null) {
                        runOnUiThread(new Runnable() {
                            @Override
                            public void run() {
                                callback.onError(new RpcInternalException());
                            }
                        });
                        return;
                    }
                    outPeer = new OutPeer(im.actor.model.api.PeerType.GROUP, group.getGroupId(),
                            group.getAccessHash());
                    apiPeer = new im.actor.model.api.Peer(im.actor.model.api.PeerType.GROUP,
                            group.getGroupId());
                } else {
                    runOnUiThread(new Runnable() {
                        @Override
                        public void run() {
                            callback.onError(new RpcInternalException());
                        }
                    });
                    return;
                }
                request(new RequestDeleteChat(outPeer), new RpcCallback<ResponseSeq>() {
                    @Override
                    public void onResult(ResponseSeq response) {
                        updates().onUpdateReceived(new SeqUpdate(response.getSeq(),
                                response.getState(),
                                UpdateChatDelete.HEADER,
                                new UpdateChatDelete(apiPeer).toByteArray()));
                        runOnUiThread(new Runnable() {
                            @Override
                            public void run() {
                                callback.onResult(true);
                            }
                        });
                    }

                    @Override
                    public void onError(final RpcException e) {
                        runOnUiThread(new Runnable() {
                            @Override
                            public void run() {
                                callback.onError(e);
                            }
                        });
                    }
                });
            }
        };
    }

    public Command<Boolean> clearChat(final Peer peer) {
        return new Command<Boolean>() {
            @Override
            public void start(final CommandCallback<Boolean> callback) {
                OutPeer outPeer;
                final im.actor.model.api.Peer apiPeer;
                if (peer.getPeerType() == PeerType.PRIVATE) {
                    User user = users().getValue(peer.getPeerId());
                    if (user == null) {
                        runOnUiThread(new Runnable() {
                            @Override
                            public void run() {
                                callback.onError(new RpcInternalException());
                            }
                        });
                        return;
                    }
                    outPeer = new OutPeer(im.actor.model.api.PeerType.PRIVATE, user.getUid(),
                            user.getAccessHash());
                    apiPeer = new im.actor.model.api.Peer(im.actor.model.api.PeerType.PRIVATE,
                            user.getUid());
                } else if (peer.getPeerType() == PeerType.GROUP) {
                    Group group = groups().getValue(peer.getPeerId());
                    if (group == null) {
                        runOnUiThread(new Runnable() {
                            @Override
                            public void run() {
                                callback.onError(new RpcInternalException());
                            }
                        });
                        return;
                    }
                    outPeer = new OutPeer(im.actor.model.api.PeerType.GROUP, group.getGroupId(),
                            group.getAccessHash());
                    apiPeer = new im.actor.model.api.Peer(im.actor.model.api.PeerType.GROUP,
                            group.getGroupId());
                } else {
                    runOnUiThread(new Runnable() {
                        @Override
                        public void run() {
                            callback.onError(new RpcInternalException());
                        }
                    });
                    return;
                }
                request(new RequestClearChat(outPeer), new RpcCallback<ResponseSeq>() {
                    @Override
                    public void onResult(ResponseSeq response) {
                        updates().onUpdateReceived(new SeqUpdate(response.getSeq(),
                                response.getState(),
                                UpdateChatClear.HEADER,
                                new UpdateChatClear(apiPeer).toByteArray()));
                        runOnUiThread(new Runnable() {
                            @Override
                            public void run() {
                                callback.onResult(true);
                            }
                        });
                    }

                    @Override
                    public void onError(final RpcException e) {
                        runOnUiThread(new Runnable() {
                            @Override
                            public void run() {
                                callback.onError(e);
                            }
                        });
                    }
                });
            }
        };
    }
}