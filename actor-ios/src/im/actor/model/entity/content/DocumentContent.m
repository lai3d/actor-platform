//
//  Generated by the J2ObjC translator.  DO NOT EDIT!
//  source: /Users/ex3ndr/Develop/actor-model/actor-ios/build/java/im/actor/model/entity/content/DocumentContent.java
//

#include "IOSClass.h"
#include "IOSPrimitiveArray.h"
#include "J2ObjC_source.h"
#include "im/actor/model/droidkit/bser/Bser.h"
#include "im/actor/model/droidkit/bser/BserObject.h"
#include "im/actor/model/droidkit/bser/BserValues.h"
#include "im/actor/model/droidkit/bser/BserWriter.h"
#include "im/actor/model/entity/content/AbsContent.h"
#include "im/actor/model/entity/content/DocumentContent.h"
#include "im/actor/model/entity/content/FastThumb.h"
#include "im/actor/model/entity/content/FileSource.h"
#include "java/io/IOException.h"

@implementation ImActorModelEntityContentDocumentContent

+ (ImActorModelEntityContentDocumentContent *)docFromBytesWithByteArray:(IOSByteArray *)data {
  return ImActorModelEntityContentDocumentContent_docFromBytesWithByteArray_(data);
}

- (instancetype)initWithImActorModelEntityContentFileSource:(ImActorModelEntityContentFileSource *)source
                                               withNSString:(NSString *)mimetype
                                               withNSString:(NSString *)name
                     withImActorModelEntityContentFastThumb:(ImActorModelEntityContentFastThumb *)fastThumb {
  if (self = [super init]) {
    self->source_ = source;
    self->mimetype_ = mimetype;
    self->name_ = name;
    self->fastThumb_ = fastThumb;
  }
  return self;
}

- (instancetype)init {
  return [super init];
}

- (ImActorModelEntityContentFileSource *)getSource {
  return source_;
}

- (NSString *)getName {
  return name_;
}

- (ImActorModelEntityContentFastThumb *)getFastThumb {
  return fastThumb_;
}

- (ImActorModelEntityContentAbsContent_ContentTypeEnum *)getContentType {
  return ImActorModelEntityContentAbsContent_ContentTypeEnum_get_DOCUMENT();
}

- (void)parseWithImActorModelDroidkitBserBserValues:(ImActorModelDroidkitBserBserValues *)values {
  [super parseWithImActorModelDroidkitBserBserValues:values];
  source_ = ImActorModelEntityContentFileSource_fromBytesWithByteArray_([((ImActorModelDroidkitBserBserValues *) nil_chk(values)) getBytesWithInt:2]);
  mimetype_ = [values getStringWithInt:3];
  name_ = [values getStringWithInt:4];
  IOSByteArray *ft = [values getBytesWithInt:5];
  if (ft != nil) {
    fastThumb_ = ImActorModelEntityContentFastThumb_fromBytesWithByteArray_(ft);
  }
}

- (void)serializeWithImActorModelDroidkitBserBserWriter:(ImActorModelDroidkitBserBserWriter *)writer {
  [super serializeWithImActorModelDroidkitBserBserWriter:writer];
  [((ImActorModelDroidkitBserBserWriter *) nil_chk(writer)) writeBytesWithInt:2 withByteArray:[((ImActorModelEntityContentFileSource *) nil_chk(source_)) toByteArray]];
  [writer writeStringWithInt:3 withNSString:mimetype_];
  [writer writeStringWithInt:4 withNSString:name_];
  if (fastThumb_ != nil) {
    [writer writeObjectWithInt:5 withImActorModelDroidkitBserBserObject:fastThumb_];
  }
}

- (void)copyAllFieldsTo:(ImActorModelEntityContentDocumentContent *)other {
  [super copyAllFieldsTo:other];
  other->source_ = source_;
  other->mimetype_ = mimetype_;
  other->name_ = name_;
  other->fastThumb_ = fastThumb_;
}

+ (const J2ObjcClassInfo *)__metadata {
  static const J2ObjcMethodInfo methods[] = {
    { "docFromBytesWithByteArray:", "docFromBytes", "Lim.actor.model.entity.content.DocumentContent;", 0x9, "Ljava.io.IOException;" },
    { "initWithImActorModelEntityContentFileSource:withNSString:withNSString:withImActorModelEntityContentFastThumb:", "DocumentContent", NULL, 0x1, NULL },
    { "init", "DocumentContent", NULL, 0x4, NULL },
    { "getSource", NULL, "Lim.actor.model.entity.content.FileSource;", 0x1, NULL },
    { "getName", NULL, "Ljava.lang.String;", 0x1, NULL },
    { "getFastThumb", NULL, "Lim.actor.model.entity.content.FastThumb;", 0x1, NULL },
    { "getContentType", NULL, "Lim.actor.model.entity.content.AbsContent$ContentType;", 0x4, NULL },
    { "parseWithImActorModelDroidkitBserBserValues:", "parse", "V", 0x1, "Ljava.io.IOException;" },
    { "serializeWithImActorModelDroidkitBserBserWriter:", "serialize", "V", 0x1, "Ljava.io.IOException;" },
  };
  static const J2ObjcFieldInfo fields[] = {
    { "source_", NULL, 0x4, "Lim.actor.model.entity.content.FileSource;", NULL,  },
    { "mimetype_", NULL, 0x4, "Ljava.lang.String;", NULL,  },
    { "name_", NULL, 0x4, "Ljava.lang.String;", NULL,  },
    { "fastThumb_", NULL, 0x4, "Lim.actor.model.entity.content.FastThumb;", NULL,  },
  };
  static const J2ObjcClassInfo _ImActorModelEntityContentDocumentContent = { 1, "DocumentContent", "im.actor.model.entity.content", NULL, 0x1, 9, methods, 4, fields, 0, NULL};
  return &_ImActorModelEntityContentDocumentContent;
}

@end

ImActorModelEntityContentDocumentContent *ImActorModelEntityContentDocumentContent_docFromBytesWithByteArray_(IOSByteArray *data) {
  ImActorModelEntityContentDocumentContent_init();
  return ((ImActorModelEntityContentDocumentContent *) ImActorModelDroidkitBserBser_parseWithImActorModelDroidkitBserBserObject_withByteArray_([[ImActorModelEntityContentDocumentContent alloc] init], data));
}

J2OBJC_CLASS_TYPE_LITERAL_SOURCE(ImActorModelEntityContentDocumentContent)
