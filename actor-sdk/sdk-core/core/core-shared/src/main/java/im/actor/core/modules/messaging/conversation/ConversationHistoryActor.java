/*
 * Copyright (C) 2015 Actor LLC. <https://actor.im>
 */

package im.actor.core.modules.messaging.conversation;

import im.actor.core.api.rpc.RequestLoadHistory;
import im.actor.core.api.rpc.ResponseLoadHistory;
import im.actor.core.entity.Peer;
import im.actor.core.modules.ModuleContext;
import im.actor.core.modules.updates.internal.MessagesHistoryLoaded;
import im.actor.core.util.ModuleActor;
import im.actor.core.network.RpcCallback;
import im.actor.core.network.RpcException;
import im.actor.runtime.function.Consumer;

public class ConversationHistoryActor extends ModuleActor {

    private static final int LIMIT = 20;

    private final String KEY_LOADED_DATE;
    private final String KEY_LOADED;
    private final String KEY_LOADED_INIT;
    private final Peer peer;

    private long historyMaxDate;
    private boolean historyLoaded;

    private boolean isLoading = false;

    public ConversationHistoryActor(Peer peer, ModuleContext context) {
        super(context);
        this.peer = peer;
        this.KEY_LOADED_DATE = "conv_" + peer + "_history_date";
        this.KEY_LOADED = "conv_" + peer + "_history_loaded";
        this.KEY_LOADED_INIT = "conv_" + peer + "_history_inited";
    }

    @Override
    public void preStart() {
        super.preStart();
        historyMaxDate = Long.MAX_VALUE;
        historyLoaded = false;
        if (isPersistenceEnabled()) {
            historyMaxDate = preferences().getLong(KEY_LOADED_DATE, Long.MAX_VALUE);
            historyLoaded = preferences().getBool(KEY_LOADED, false);
        }
        if (!preferences().getBool(KEY_LOADED_INIT, false)) {
            self().send(new LoadMore());
        } else {
            context().getMessagesModule().markAsLoaded(peer);
        }
    }

    private void onLoadMore() {
        if (historyLoaded) {
            return;
        }
        if (isLoading) {
            return;
        }
        isLoading = true;

        api(new RequestLoadHistory(buidOutPeer(peer), historyMaxDate, LIMIT)).then(new Consumer<ResponseLoadHistory>() {
            @Override
            public void apply(ResponseLoadHistory responseLoadHistory) {
                updates().onUpdateReceived(new MessagesHistoryLoaded(peer, responseLoadHistory));
            }
        }).done(self());
    }

    private void onLoadedMore(int loaded, long maxLoadedDate) {
        isLoading = false;

        if (loaded < LIMIT) {
            historyLoaded = true;
        } else {
            historyLoaded = false;
            historyMaxDate = maxLoadedDate;
        }

        if (isPersistenceEnabled()) {
            preferences().putLong(KEY_LOADED_DATE, maxLoadedDate);
            preferences().putBool(KEY_LOADED, historyLoaded);
            preferences().putBool(KEY_LOADED_INIT, true);
        }

        if (historyLoaded) {
            context().getMessagesModule().markAsLoaded(peer);
        }
    }

    @Override
    public void onReceive(Object message) {
        if (message instanceof LoadMore) {
            onLoadMore();
        } else if (message instanceof LoadedMore) {
            LoadedMore loadedMore = (LoadedMore) message;
            onLoadedMore(loadedMore.loaded, loadedMore.maxLoadedDate);
        } else {
            drop(message);
        }
    }

    public static class LoadMore {

    }

    public static class LoadedMore {
        private int loaded;
        private long maxLoadedDate;

        public LoadedMore(int loaded, long maxLoadedDate) {
            this.loaded = loaded;
            this.maxLoadedDate = maxLoadedDate;
        }
    }
}