//
//  Generated by the J2ObjC translator.  DO NOT EDIT!
//  source: /Users/ex3ndr/Develop/actor-model/library/actor-cocoa-base/build/java/im/actor/model/entity/content/ServiceGroupUserKicked.java
//


#line 1 "/Users/ex3ndr/Develop/actor-model/library/actor-cocoa-base/build/java/im/actor/model/entity/content/ServiceGroupUserKicked.java"

#include "IOSClass.h"
#include "IOSPrimitiveArray.h"
#include "J2ObjC_source.h"
#include "im/actor/model/droidkit/bser/Bser.h"
#include "im/actor/model/droidkit/bser/BserObject.h"
#include "im/actor/model/droidkit/bser/BserValues.h"
#include "im/actor/model/droidkit/bser/BserWriter.h"
#include "im/actor/model/entity/content/AbsContent.h"
#include "im/actor/model/entity/content/ServiceContent.h"
#include "im/actor/model/entity/content/ServiceGroupUserKicked.h"
#include "java/io/IOException.h"

@interface AMServiceGroupUserKicked () {
 @public
  jint kickedUid_;
}

- (instancetype)init;

@end

__attribute__((unused)) static void AMServiceGroupUserKicked_init(AMServiceGroupUserKicked *self);

__attribute__((unused)) static AMServiceGroupUserKicked *new_AMServiceGroupUserKicked_init() NS_RETURNS_RETAINED;


#line 13
@implementation AMServiceGroupUserKicked

+ (AMServiceGroupUserKicked *)fromBytesWithByteArray:(IOSByteArray *)data {
  return AMServiceGroupUserKicked_fromBytesWithByteArray_(data);
}


#line 21
- (instancetype)initWithInt:(jint)kickedUid {
  AMServiceGroupUserKicked_initWithInt_(self, kickedUid);
  return self;
}

- (instancetype)init {
  AMServiceGroupUserKicked_init(self);
  return self;
}


#line 30
- (jint)getKickedUid {
  return kickedUid_;
}


#line 35
- (AMAbsContent_ContentTypeEnum *)getContentType {
  return AMAbsContent_ContentTypeEnum_get_SERVICE_KICKED();
}


#line 40
- (void)parseWithBSBserValues:(BSBserValues *)values {
  [super parseWithBSBserValues:values];
  kickedUid_ = [((BSBserValues *) nil_chk(values)) getIntWithInt:10];
}


#line 46
- (void)serializeWithBSBserWriter:(BSBserWriter *)writer {
  [super serializeWithBSBserWriter:writer];
  [((BSBserWriter *) nil_chk(writer)) writeIntWithInt:10 withInt:kickedUid_];
}

@end


#line 15
AMServiceGroupUserKicked *AMServiceGroupUserKicked_fromBytesWithByteArray_(IOSByteArray *data) {
  AMServiceGroupUserKicked_initialize();
  
#line 16
  return ((AMServiceGroupUserKicked *) BSBser_parseWithBSBserObject_withByteArray_(new_AMServiceGroupUserKicked_init(), data));
}


#line 21
void AMServiceGroupUserKicked_initWithInt_(AMServiceGroupUserKicked *self, jint kickedUid) {
  (void) AMServiceContent_initWithNSString_(self, @"User kicked");
  self->kickedUid_ = kickedUid;
}


#line 21
AMServiceGroupUserKicked *new_AMServiceGroupUserKicked_initWithInt_(jint kickedUid) {
  AMServiceGroupUserKicked *self = [AMServiceGroupUserKicked alloc];
  AMServiceGroupUserKicked_initWithInt_(self, kickedUid);
  return self;
}


#line 26
void AMServiceGroupUserKicked_init(AMServiceGroupUserKicked *self) {
  (void) AMServiceContent_init(self);
}


#line 26
AMServiceGroupUserKicked *new_AMServiceGroupUserKicked_init() {
  AMServiceGroupUserKicked *self = [AMServiceGroupUserKicked alloc];
  AMServiceGroupUserKicked_init(self);
  return self;
}

J2OBJC_CLASS_TYPE_LITERAL_SOURCE(AMServiceGroupUserKicked)
