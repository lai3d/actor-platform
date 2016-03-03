/*
 * Copyright (C) 2015 Actor LLC. <https://actor.im>
 */

package im.actor.core.modules.messaging;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import im.actor.core.api.ApiDialogGroup;
import im.actor.core.api.ApiMessage;
import im.actor.core.api.ApiMessageContainer;
import im.actor.core.api.ApiMessageReaction;
import im.actor.core.api.ApiPeer;
import im.actor.core.api.ApiAppCounters;
import im.actor.core.api.rpc.ResponseLoadArchived;
import im.actor.core.api.rpc.ResponseLoadHistory;
import im.actor.core.api.updates.UpdateMessage;
import im.actor.core.entity.Message;
import im.actor.core.entity.MessageState;
import im.actor.core.entity.Peer;
import im.actor.core.entity.Reaction;
import im.actor.core.entity.content.AbsContent;
import im.actor.core.entity.content.ServiceUserRegistered;
import im.actor.core.modules.AbsModule;
import im.actor.core.modules.ModuleContext;
import im.actor.core.modules.messaging.actions.ArchivedDialogsActor;
import im.actor.core.modules.messaging.actions.CursorReceiverActor;
import im.actor.core.modules.messaging.actions.OwnReadActor;
import im.actor.core.modules.messaging.actions.SenderActor;
import im.actor.core.modules.messaging.conversation.ConversationHistoryActor;
import im.actor.core.modules.messaging.entity.EntityConverter;
import im.actor.runtime.annotations.Verified;

import static im.actor.core.modules.messaging.entity.EntityConverter.convert;

public class MessagesProcessor extends AbsModule {

    public MessagesProcessor(ModuleContext context) {
        super(context);
    }

    public void onMessages(ApiPeer _peer, List<UpdateMessage> messages) {

        long outMessageSortDate = 0;
        long intMessageSortDate = 0;
        Peer peer = convert(_peer);

        ArrayList<Message> nMessages = new ArrayList<Message>();
        for (UpdateMessage u : messages) {

            AbsContent msgContent;
            try {
                msgContent = AbsContent.fromMessage(u.getMessage());
            } catch (IOException e) {
                e.printStackTrace();
                continue;
            }

            boolean isOut = myUid() == u.getSenderUid();

            // Sending message to conversation
            nMessages.add(new Message(u.getRid(), u.getDate(), u.getDate(), u.getSenderUid(),
                    isOut ? MessageState.SENT : MessageState.UNKNOWN, msgContent,
                    new ArrayList<Reaction>()));

            if (!isOut) {

                intMessageSortDate = Math.max(intMessageSortDate, u.getDate());
            } else {
                outMessageSortDate = Math.max(outMessageSortDate, u.getDate());
            }
        }

        conversationActor(peer).onMessages(nMessages);

        if (intMessageSortDate > 0) {
            plainReceiveActor().send(new CursorReceiverActor.MarkReceived(peer, intMessageSortDate));
        }

        // OwnReadActor
        for (Message m : nMessages) {
            if (m.getSenderId() != myUid()) {
                ownReadActor().send(new OwnReadActor.InMessage(peer, m));
            }
        }
    }

    @Verified
    public void onMessage(ApiPeer _peer, int senderUid, long date, long rid,
                          ApiMessage content) {

        Peer peer = convert(_peer);

        AbsContent msgContent;
        try {
            msgContent = AbsContent.fromMessage(content);
        } catch (IOException e) {
            e.printStackTrace();
            return;
        }

        boolean isOut = myUid() == senderUid;

        // Sending message to conversation
        Message message = new Message(rid, date, date, senderUid,
                isOut ? MessageState.SENT : MessageState.UNKNOWN, msgContent, new ArrayList<Reaction>());

        conversationActor(peer).onMessage(message);

        if (!isOut) {
            // mark message as received
            plainReceiveActor().send(new CursorReceiverActor.MarkReceived(peer, date));

            // Send to own read actor
            ownReadActor().send(new OwnReadActor.InMessage(peer, message));
            msgContent.onIncoming(peer, context());
        }
    }

    @Verified
    public void onUserRegistered(long rid, int uid, long date) {
        Message message = new Message(rid, date, date, uid,
                MessageState.UNKNOWN, ServiceUserRegistered.create(), new ArrayList<Reaction>());

        conversationActor(Peer.user(uid)).onMessage(message);
    }

    @Verified
    public void onMessageRead(ApiPeer _peer, long startDate) {
        Peer peer = convert(_peer);

        // We are not invalidating sequence because of this update
        if (!isValidPeer(peer)) {
            return;
        }

        // Sending event to conversation actor
        conversationActor(peer).onMessageRead(startDate);
    }

    @Verified
    public void onMessageReceived(ApiPeer _peer, long startDate) {
        Peer peer = convert(_peer);

        // We are not invalidating sequence because of this update
        if (!isValidPeer(peer)) {
            return;
        }

        // Sending event to conversation actor
        conversationActor(peer).onMessageReceived(startDate);
    }

    @Verified
    public void onMessageReadByMe(ApiPeer _peer, long startDate) {
        Peer peer = convert(_peer);

        // We are not invalidating sequence because of this update
        if (!isValidPeer(peer)) {
            return;
        }

        // Sending event to own read actor
        ownReadActor().send(new OwnReadActor.MessageReadByMe(peer, startDate));
    }

    @Verified
    public void onMessageSent(ApiPeer _peer, long rid, long date) {
        Peer peer = convert(_peer);

        // We are not invalidating sequence because of this update
        if (!isValidPeer(peer)) {
            return;
        }

        // Change message state in conversation
        conversationActor(peer).onMessageSent(rid, date);

        // Notify Sender Actor
        sendActor().send(new SenderActor.MessageSent(peer, rid));
    }

    @Verified
    public void onReactionsChanged(ApiPeer _peer, long rid, List<ApiMessageReaction> apiReactions) {
        Peer peer = convert(_peer);

        // We are not invalidating sequence because of this update
        if (!isValidPeer(peer)) {
            return;
        }

        ArrayList<Reaction> reactions = new ArrayList<>();
        for (ApiMessageReaction r : apiReactions) {
            reactions.add(new Reaction(r.getCode(), r.getUsers()));
        }

        // Change message state in conversation
        conversationActor(peer).onMessageReactionsChanged(rid, reactions);
    }

    @Verified
    public void onMessageContentChanged(ApiPeer _peer, long rid,
                                        ApiMessage message) {
        Peer peer = convert(_peer);

        // We are not invalidating sequence because of this update
        if (!isValidPeer(peer)) {
            return;
        }

        AbsContent content;
        try {
            content = AbsContent.fromMessage(message);
        } catch (IOException e) {
            e.printStackTrace();
            return;
        }

        // Change message content in conversation
        conversationActor(peer).onMessageContentChanged(rid, content);
    }

    @Verified
    public void onMessageDelete(ApiPeer _peer, List<Long> rids) {
        Peer peer = convert(_peer);

        // We are not invalidating sequence because of this update
        if (!isValidPeer(peer)) {
            return;
        }

        // Deleting messages from conversation
        conversationActor(peer).onMessagesDeleted(rids);

        // TODO: Notify send actor
    }

    @Verified
    public void onChatClear(ApiPeer _peer) {
        Peer peer = convert(_peer);

        // We are not invalidating sequence because of this update
        if (!isValidPeer(peer)) {
            return;
        }

        // Clearing conversation
        conversationActor(peer).onClearConversation();

        // TODO: Notify send actor
    }

    @Verified
    public void onChatDelete(ApiPeer _peer) {
        Peer peer = convert(_peer);

        // We are not invalidating sequence because of this update
        if (!isValidPeer(peer)) {
            return;
        }

        // Deleting conversation
        conversationActor(peer).onDeleteConversation();

        // TODO: Notify send actor
    }

    @Verified
    public void onMessagesLoaded(Peer peer, ResponseLoadHistory historyResponse) {
        ArrayList<Message> messages = new ArrayList<Message>();
        long maxLoadedDate = Long.MAX_VALUE;
        for (ApiMessageContainer historyMessage : historyResponse.getHistory()) {

            maxLoadedDate = Math.min(historyMessage.getDate(), maxLoadedDate);

            AbsContent content = null;
            try {
                content = AbsContent.fromMessage(historyMessage.getMessage());
            } catch (IOException e) {
                e.printStackTrace();
            }
            if (content == null) {
                continue;
            }
            MessageState state = EntityConverter.convert(historyMessage.getState());

            ArrayList<Reaction> reactions = new ArrayList<Reaction>();

            for (ApiMessageReaction r : historyMessage.getReactions()) {
                reactions.add(new Reaction(r.getCode(), r.getUsers()));
            }

            messages.add(new Message(historyMessage.getRid(), historyMessage.getDate(),
                    historyMessage.getDate(), historyMessage.getSenderUid(),
                    state, content, reactions));
        }

        // Sending updates to conversation actor
        if (messages.size() > 0) {
            conversationActor(peer).onHistoryLoaded(messages);
        }

        // Sending notification to conversation history actor
        conversationHistoryActor(peer).send(new ConversationHistoryActor.LoadedMore(historyResponse.getHistory().size(),
                maxLoadedDate));
    }

    public void onCountersChanged(ApiAppCounters counters) {
        context().getAppStateModule().onCountersChanged(counters);
    }

    public void onChatGroupsChanged(List<ApiDialogGroup> groups) {
        if (context().getConfiguration().isEnabledGroupedChatList()) {
            context().getMessagesModule().getDialogs().onGroupsChanged(groups);
        }
    }

    public void onArchivedDialogsLoaded(ResponseLoadArchived responseLoadArchived) {
        archivedDialogsActor().send(new ArchivedDialogsActor.LoadedMore(responseLoadArchived));
    }
}