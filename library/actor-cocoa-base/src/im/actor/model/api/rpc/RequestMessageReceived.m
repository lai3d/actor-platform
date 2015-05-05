//
//  Generated by the J2ObjC translator.  DO NOT EDIT!
//  source: /Users/ex3ndr/Develop/actor-model/library/actor-cocoa-base/build/java/im/actor/model/api/rpc/RequestMessageReceived.java
//


#line 1 "/Users/ex3ndr/Develop/actor-model/library/actor-cocoa-base/build/java/im/actor/model/api/rpc/RequestMessageReceived.java"

#include "IOSClass.h"
#include "IOSPrimitiveArray.h"
#include "J2ObjC_source.h"
#include "im/actor/model/api/OutPeer.h"
#include "im/actor/model/api/rpc/RequestMessageReceived.h"
#include "im/actor/model/droidkit/bser/Bser.h"
#include "im/actor/model/droidkit/bser/BserObject.h"
#include "im/actor/model/droidkit/bser/BserValues.h"
#include "im/actor/model/droidkit/bser/BserWriter.h"
#include "im/actor/model/network/parser/Request.h"
#include "java/io/IOException.h"

@interface ImActorModelApiRpcRequestMessageReceived () {
 @public
  ImActorModelApiOutPeer *peer_;
  jlong date_;
}

@end

J2OBJC_FIELD_SETTER(ImActorModelApiRpcRequestMessageReceived, peer_, ImActorModelApiOutPeer *)


#line 24
@implementation ImActorModelApiRpcRequestMessageReceived


#line 27
+ (ImActorModelApiRpcRequestMessageReceived *)fromBytesWithByteArray:(IOSByteArray *)data {
  return ImActorModelApiRpcRequestMessageReceived_fromBytesWithByteArray_(data);
}


#line 34
- (instancetype)initWithImActorModelApiOutPeer:(ImActorModelApiOutPeer *)peer
                                      withLong:(jlong)date {
  ImActorModelApiRpcRequestMessageReceived_initWithImActorModelApiOutPeer_withLong_(self, peer, date);
  return self;
}


#line 39
- (instancetype)init {
  ImActorModelApiRpcRequestMessageReceived_init(self);
  return self;
}


#line 43
- (ImActorModelApiOutPeer *)getPeer {
  return self->peer_;
}

- (jlong)getDate {
  return self->date_;
}


#line 52
- (void)parseWithBSBserValues:(BSBserValues *)values {
  self->peer_ = [((BSBserValues *) nil_chk(values)) getObjWithInt:1 withBSBserObject:new_ImActorModelApiOutPeer_init()];
  self->date_ = [values getLongWithInt:3];
}


#line 58
- (void)serializeWithBSBserWriter:(BSBserWriter *)writer {
  if (self->peer_ == nil) {
    @throw new_JavaIoIOException_init();
  }
  [((BSBserWriter *) nil_chk(writer)) writeObjectWithInt:1 withBSBserObject:self->peer_];
  [writer writeLongWithInt:3 withLong:self->date_];
}


#line 67
- (NSString *)description {
  NSString *res = @"rpc MessageReceived{";
  res = JreStrcat("$$", res, JreStrcat("$@", @"peer=", self->peer_));
  res = JreStrcat("$$", res, JreStrcat("$J", @", date=", self->date_));
  res = JreStrcat("$C", res, '}');
  return res;
}


#line 76
- (jint)getHeaderKey {
  return ImActorModelApiRpcRequestMessageReceived_HEADER;
}

@end


#line 27
ImActorModelApiRpcRequestMessageReceived *ImActorModelApiRpcRequestMessageReceived_fromBytesWithByteArray_(IOSByteArray *data) {
  ImActorModelApiRpcRequestMessageReceived_initialize();
  
#line 28
  return ((ImActorModelApiRpcRequestMessageReceived *) BSBser_parseWithBSBserObject_withByteArray_(new_ImActorModelApiRpcRequestMessageReceived_init(), data));
}

void ImActorModelApiRpcRequestMessageReceived_initWithImActorModelApiOutPeer_withLong_(ImActorModelApiRpcRequestMessageReceived *self, ImActorModelApiOutPeer *peer, jlong date) {
  (void) ImActorModelNetworkParserRequest_init(self);
  
#line 35
  self->peer_ = peer;
  self->date_ = date;
}


#line 34
ImActorModelApiRpcRequestMessageReceived *new_ImActorModelApiRpcRequestMessageReceived_initWithImActorModelApiOutPeer_withLong_(ImActorModelApiOutPeer *peer, jlong date) {
  ImActorModelApiRpcRequestMessageReceived *self = [ImActorModelApiRpcRequestMessageReceived alloc];
  ImActorModelApiRpcRequestMessageReceived_initWithImActorModelApiOutPeer_withLong_(self, peer, date);
  return self;
}


#line 39
void ImActorModelApiRpcRequestMessageReceived_init(ImActorModelApiRpcRequestMessageReceived *self) {
  (void) ImActorModelNetworkParserRequest_init(self);
}


#line 39
ImActorModelApiRpcRequestMessageReceived *new_ImActorModelApiRpcRequestMessageReceived_init() {
  ImActorModelApiRpcRequestMessageReceived *self = [ImActorModelApiRpcRequestMessageReceived alloc];
  ImActorModelApiRpcRequestMessageReceived_init(self);
  return self;
}

J2OBJC_CLASS_TYPE_LITERAL_SOURCE(ImActorModelApiRpcRequestMessageReceived)
