//
//  Generated by the J2ObjC translator.  DO NOT EDIT!
//  source: /Users/ex3ndr/Develop/actor-model/library/actor-cocoa-base/build/java/im/actor/model/modules/updates/internal/MessagesHistoryLoaded.java
//


#line 1 "/Users/ex3ndr/Develop/actor-model/library/actor-cocoa-base/build/java/im/actor/model/modules/updates/internal/MessagesHistoryLoaded.java"

#include "J2ObjC_source.h"
#include "im/actor/model/api/rpc/ResponseLoadHistory.h"
#include "im/actor/model/entity/Peer.h"
#include "im/actor/model/modules/updates/internal/InternalUpdate.h"
#include "im/actor/model/modules/updates/internal/MessagesHistoryLoaded.h"

@interface ImActorModelModulesUpdatesInternalMessagesHistoryLoaded () {
 @public
  AMPeer *peer_;
  ImActorModelApiRpcResponseLoadHistory *loadHistory_;
}

@end

J2OBJC_FIELD_SETTER(ImActorModelModulesUpdatesInternalMessagesHistoryLoaded, peer_, AMPeer *)
J2OBJC_FIELD_SETTER(ImActorModelModulesUpdatesInternalMessagesHistoryLoaded, loadHistory_, ImActorModelApiRpcResponseLoadHistory *)


#line 10
@implementation ImActorModelModulesUpdatesInternalMessagesHistoryLoaded


#line 14
- (instancetype)initWithAMPeer:(AMPeer *)peer
withImActorModelApiRpcResponseLoadHistory:(ImActorModelApiRpcResponseLoadHistory *)loadHistory {
  ImActorModelModulesUpdatesInternalMessagesHistoryLoaded_initWithAMPeer_withImActorModelApiRpcResponseLoadHistory_(self, peer, loadHistory);
  return self;
}


#line 19
- (AMPeer *)getPeer {
  return peer_;
}

- (ImActorModelApiRpcResponseLoadHistory *)getLoadHistory {
  return loadHistory_;
}

@end


#line 14
void ImActorModelModulesUpdatesInternalMessagesHistoryLoaded_initWithAMPeer_withImActorModelApiRpcResponseLoadHistory_(ImActorModelModulesUpdatesInternalMessagesHistoryLoaded *self, AMPeer *peer, ImActorModelApiRpcResponseLoadHistory *loadHistory) {
  (void) ImActorModelModulesUpdatesInternalInternalUpdate_init(self);
  
#line 15
  self->peer_ = peer;
  self->loadHistory_ = loadHistory;
}


#line 14
ImActorModelModulesUpdatesInternalMessagesHistoryLoaded *new_ImActorModelModulesUpdatesInternalMessagesHistoryLoaded_initWithAMPeer_withImActorModelApiRpcResponseLoadHistory_(AMPeer *peer, ImActorModelApiRpcResponseLoadHistory *loadHistory) {
  ImActorModelModulesUpdatesInternalMessagesHistoryLoaded *self = [ImActorModelModulesUpdatesInternalMessagesHistoryLoaded alloc];
  ImActorModelModulesUpdatesInternalMessagesHistoryLoaded_initWithAMPeer_withImActorModelApiRpcResponseLoadHistory_(self, peer, loadHistory);
  return self;
}

J2OBJC_CLASS_TYPE_LITERAL_SOURCE(ImActorModelModulesUpdatesInternalMessagesHistoryLoaded)
