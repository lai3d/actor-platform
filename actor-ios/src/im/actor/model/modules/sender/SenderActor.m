//
//  Generated by the J2ObjC translator.  DO NOT EDIT!
//  source: /Users/ex3ndr/Develop/actor-model/actor-ios/build/java/im/actor/model/modules/sender/SenderActor.java
//

#include "IOSPrimitiveArray.h"
#include "J2ObjC_source.h"
#include "im/actor/model/api/MessageContent.h"
#include "im/actor/model/api/OutPeer.h"
#include "im/actor/model/api/Peer.h"
#include "im/actor/model/api/PeerType.h"
#include "im/actor/model/api/TextMessage.h"
#include "im/actor/model/api/rpc/RequestSendMessage.h"
#include "im/actor/model/api/rpc/ResponseSeqDate.h"
#include "im/actor/model/droidkit/actors/ActorRef.h"
#include "im/actor/model/droidkit/actors/conf/EnvConfig.h"
#include "im/actor/model/droidkit/actors/conf/JavaFactory.h"
#include "im/actor/model/entity/Message.h"
#include "im/actor/model/entity/MessageState.h"
#include "im/actor/model/entity/Peer.h"
#include "im/actor/model/entity/PeerType.h"
#include "im/actor/model/entity/User.h"
#include "im/actor/model/entity/content/AbsContent.h"
#include "im/actor/model/entity/content/TextContent.h"
#include "im/actor/model/modules/Messages.h"
#include "im/actor/model/modules/Modules.h"
#include "im/actor/model/modules/sender/SenderActor.h"
#include "im/actor/model/modules/utils/ModuleActor.h"
#include "im/actor/model/modules/utils/RandomUtils.h"
#include "im/actor/model/network/RpcException.h"

__attribute__((unused)) static void ImActorModelModulesSenderSenderActor_sendMessageWithImActorModelEntityPeer_withLong_withLong_withImActorModelEntityContentAbsContent_(ImActorModelModulesSenderSenderActor *self, ImActorModelEntityPeer *peer, jlong rid, jlong time, ImActorModelEntityContentAbsContent *content);

@interface ImActorModelModulesSenderSenderActor ()

- (void)sendMessageWithImActorModelEntityPeer:(ImActorModelEntityPeer *)peer
                                     withLong:(jlong)rid
                                     withLong:(jlong)time
      withImActorModelEntityContentAbsContent:(ImActorModelEntityContentAbsContent *)content;
@end

@interface ImActorModelModulesSenderSenderActor_SendMessage () {
 @public
  ImActorModelEntityPeer *peer_;
  ImActorModelEntityContentAbsContent *content_;
}
@end

J2OBJC_FIELD_SETTER(ImActorModelModulesSenderSenderActor_SendMessage, peer_, ImActorModelEntityPeer *)
J2OBJC_FIELD_SETTER(ImActorModelModulesSenderSenderActor_SendMessage, content_, ImActorModelEntityContentAbsContent *)

@interface ImActorModelModulesSenderSenderActor_MessageSent () {
 @public
  jlong rid_;
  jlong date_;
}
@end

@implementation ImActorModelModulesSenderSenderActor

- (instancetype)initWithImActorModelModulesModules:(ImActorModelModulesModules *)messenger {
  return [super initWithImActorModelModulesModules:messenger];
}

- (void)preStart {
}

- (void)onReceiveWithId:(id)message {
  if ([message isKindOfClass:[ImActorModelModulesSenderSenderActor_SendMessage class]]) {
    ImActorModelModulesSenderSenderActor_SendMessage *sendMessage = (ImActorModelModulesSenderSenderActor_SendMessage *) check_class_cast(message, [ImActorModelModulesSenderSenderActor_SendMessage class]);
    ImActorModelModulesSenderSenderActor_sendMessageWithImActorModelEntityPeer_withLong_withLong_withImActorModelEntityContentAbsContent_(self, ((ImActorModelModulesSenderSenderActor_SendMessage *) nil_chk(sendMessage))->peer_, ImActorModelModulesUtilsRandomUtils_nextRid(), [((id<ImActorModelDroidkitActorsConfJavaFactory>) nil_chk(ImActorModelDroidkitActorsConfEnvConfig_getJavaFactory())) getCurrentTime], sendMessage->content_);
  }
  else if ([message isKindOfClass:[ImActorModelModulesSenderSenderActor_MessageSent class]]) {
  }
}

- (void)sendMessageWithImActorModelEntityPeer:(ImActorModelEntityPeer *)peer
                                     withLong:(jlong)rid
                                     withLong:(jlong)time
      withImActorModelEntityContentAbsContent:(ImActorModelEntityContentAbsContent *)content {
  ImActorModelModulesSenderSenderActor_sendMessageWithImActorModelEntityPeer_withLong_withLong_withImActorModelEntityContentAbsContent_(self, peer, rid, time, content);
}

+ (const J2ObjcClassInfo *)__metadata {
  static const J2ObjcMethodInfo methods[] = {
    { "initWithImActorModelModulesModules:", "SenderActor", NULL, 0x1, NULL },
    { "preStart", NULL, "V", 0x1, NULL },
    { "onReceiveWithId:", "onReceive", "V", 0x1, NULL },
    { "sendMessageWithImActorModelEntityPeer:withLong:withLong:withImActorModelEntityContentAbsContent:", "sendMessage", "V", 0x2, NULL },
  };
  static const J2ObjcClassInfo _ImActorModelModulesSenderSenderActor = { 1, "SenderActor", "im.actor.model.modules.sender", NULL, 0x1, 4, methods, 0, NULL, 0, NULL};
  return &_ImActorModelModulesSenderSenderActor;
}

@end

void ImActorModelModulesSenderSenderActor_sendMessageWithImActorModelEntityPeer_withLong_withLong_withImActorModelEntityContentAbsContent_(ImActorModelModulesSenderSenderActor *self, ImActorModelEntityPeer *peer, jlong rid, jlong time, ImActorModelEntityContentAbsContent *content) {
  ImActorModelApiOutPeer *outPeer;
  ImActorModelApiPeer *apiPeer;
  if ([((ImActorModelEntityPeer *) nil_chk(peer)) getPeerType] == ImActorModelEntityPeerTypeEnum_get_PRIVATE()) {
    ImActorModelEntityUser *user = [self getUserWithInt:[peer getPeerId]];
    if (user == nil) {
      return;
    }
    outPeer = [[ImActorModelApiOutPeer alloc] initWithImActorModelApiPeerTypeEnum:ImActorModelApiPeerTypeEnum_get_PRIVATE() withInt:[peer getPeerId] withLong:[((ImActorModelEntityUser *) nil_chk(user)) getAccessHash]];
    apiPeer = [[ImActorModelApiPeer alloc] initWithImActorModelApiPeerTypeEnum:ImActorModelApiPeerTypeEnum_get_PRIVATE() withInt:[peer getPeerId]];
  }
  else {
    return;
  }
  ImActorModelApiMessageContent *outContent;
  if ([content isKindOfClass:[ImActorModelEntityContentTextContent class]]) {
    outContent = [[ImActorModelApiMessageContent alloc] initWithInt:(jint) 0x01 withByteArray:[((ImActorModelApiTextMessage *) [[ImActorModelApiTextMessage alloc] initWithNSString:[((ImActorModelEntityContentTextContent *) nil_chk(((ImActorModelEntityContentTextContent *) check_class_cast(content, [ImActorModelEntityContentTextContent class])))) getText] withInt:0 withByteArray:[IOSByteArray newArrayWithLength:0]]) toByteArray]];
  }
  else {
    return;
  }
  [((ImActorModelDroidkitActorsActorRef *) nil_chk([((ImActorModelModulesMessages *) nil_chk([((ImActorModelModulesModules *) nil_chk([self modules])) getMessagesModule])) getConversationActorWithImActorModelEntityPeer:peer])) sendWithId:[[ImActorModelEntityMessage alloc] initWithLong:rid withLong:time withLong:time withInt:[self myUid] withImActorModelEntityMessageStateEnum:ImActorModelEntityMessageStateEnum_get_PENDING() withImActorModelEntityContentAbsContent:content]];
  [self requestWithImActorModelNetworkParserRequest:[[ImActorModelApiRpcRequestSendMessage alloc] initWithImActorModelApiOutPeer:outPeer withLong:rid withImActorModelApiMessageContent:outContent] withAMRpcCallback:[[ImActorModelModulesSenderSenderActor_$1 alloc] init]];
}

J2OBJC_CLASS_TYPE_LITERAL_SOURCE(ImActorModelModulesSenderSenderActor)

@implementation ImActorModelModulesSenderSenderActor_SendMessage

- (instancetype)initWithImActorModelEntityPeer:(ImActorModelEntityPeer *)peer
       withImActorModelEntityContentAbsContent:(ImActorModelEntityContentAbsContent *)content {
  if (self = [super init]) {
    self->peer_ = peer;
    self->content_ = content;
  }
  return self;
}

- (ImActorModelEntityPeer *)getPeer {
  return peer_;
}

- (ImActorModelEntityContentAbsContent *)getContent {
  return content_;
}

- (void)copyAllFieldsTo:(ImActorModelModulesSenderSenderActor_SendMessage *)other {
  [super copyAllFieldsTo:other];
  other->peer_ = peer_;
  other->content_ = content_;
}

+ (const J2ObjcClassInfo *)__metadata {
  static const J2ObjcMethodInfo methods[] = {
    { "initWithImActorModelEntityPeer:withImActorModelEntityContentAbsContent:", "SendMessage", NULL, 0x1, NULL },
    { "getPeer", NULL, "Lim.actor.model.entity.Peer;", 0x1, NULL },
    { "getContent", NULL, "Lim.actor.model.entity.content.AbsContent;", 0x1, NULL },
  };
  static const J2ObjcFieldInfo fields[] = {
    { "peer_", NULL, 0x2, "Lim.actor.model.entity.Peer;", NULL,  },
    { "content_", NULL, 0x2, "Lim.actor.model.entity.content.AbsContent;", NULL,  },
  };
  static const J2ObjcClassInfo _ImActorModelModulesSenderSenderActor_SendMessage = { 1, "SendMessage", "im.actor.model.modules.sender", "SenderActor", 0x9, 3, methods, 2, fields, 0, NULL};
  return &_ImActorModelModulesSenderSenderActor_SendMessage;
}

@end

J2OBJC_CLASS_TYPE_LITERAL_SOURCE(ImActorModelModulesSenderSenderActor_SendMessage)

@implementation ImActorModelModulesSenderSenderActor_MessageSent

- (instancetype)initWithLong:(jlong)rid
                    withLong:(jlong)date {
  if (self = [super init]) {
    self->rid_ = rid;
    self->date_ = date;
  }
  return self;
}

- (jlong)getRid {
  return rid_;
}

- (jlong)getDate {
  return date_;
}

- (void)copyAllFieldsTo:(ImActorModelModulesSenderSenderActor_MessageSent *)other {
  [super copyAllFieldsTo:other];
  other->rid_ = rid_;
  other->date_ = date_;
}

+ (const J2ObjcClassInfo *)__metadata {
  static const J2ObjcMethodInfo methods[] = {
    { "initWithLong:withLong:", "MessageSent", NULL, 0x1, NULL },
    { "getRid", NULL, "J", 0x1, NULL },
    { "getDate", NULL, "J", 0x1, NULL },
  };
  static const J2ObjcFieldInfo fields[] = {
    { "rid_", NULL, 0x2, "J", NULL,  },
    { "date_", NULL, 0x2, "J", NULL,  },
  };
  static const J2ObjcClassInfo _ImActorModelModulesSenderSenderActor_MessageSent = { 1, "MessageSent", "im.actor.model.modules.sender", "SenderActor", 0x9, 3, methods, 2, fields, 0, NULL};
  return &_ImActorModelModulesSenderSenderActor_MessageSent;
}

@end

J2OBJC_CLASS_TYPE_LITERAL_SOURCE(ImActorModelModulesSenderSenderActor_MessageSent)

@implementation ImActorModelModulesSenderSenderActor_$1

- (void)onResultWithImActorModelNetworkParserResponse:(ImActorModelApiRpcResponseSeqDate *)response {
}

- (void)onErrorWithAMRpcException:(AMRpcException *)e {
}

- (instancetype)init {
  return [super init];
}

+ (const J2ObjcClassInfo *)__metadata {
  static const J2ObjcMethodInfo methods[] = {
    { "onResultWithImActorModelApiRpcResponseSeqDate:", "onResult", "V", 0x1, NULL },
    { "onErrorWithAMRpcException:", "onError", "V", 0x1, NULL },
    { "init", NULL, NULL, 0x0, NULL },
  };
  static const J2ObjcClassInfo _ImActorModelModulesSenderSenderActor_$1 = { 1, "$1", "im.actor.model.modules.sender", "SenderActor", 0x8000, 3, methods, 0, NULL, 0, NULL};
  return &_ImActorModelModulesSenderSenderActor_$1;
}

@end

J2OBJC_CLASS_TYPE_LITERAL_SOURCE(ImActorModelModulesSenderSenderActor_$1)
