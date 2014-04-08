//
//  EXBaseModel.m
//  DBHelper
//
//  Created by zhengyj on 14-4-4.
//  Copyright (c) 2014年 zhengyj. All rights reserved.
//

#import "EXBaseModel.h"
#import <objc/runtime.h>

@implementation EXBaseModel


-(NSDictionary*)attributeMapDictionary{
	return nil;
}

-(void)setAttributes:(NSDictionary*)dataDic{
    NSMutableDictionary *attrMapDic = [NSMutableDictionary dictionary];
    [attrMapDic setValuesForKeysWithDictionary:dataDic];
    
	NSEnumerator *keyEnum = [attrMapDic keyEnumerator];
	id key;
	while ((key = [keyEnum nextObject])) {
        id attributeValue = [attrMapDic objectForKey:key];
        if (attributeValue == nil || [attributeValue isKindOfClass:[NSNull class]]) {
            attributeValue = nil;
            continue;
        }
        [self setValue:attributeValue forKey:key];
	}
}

-(id)initWithDataDic:(NSDictionary*)data{
	if (self = [super init]) {
		[self setAttributes:data];
	}
	return self;
}

- (NSString *)description {
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList(([self class]), &outCount);
    [self class];
    NSMutableString *description = [NSMutableString string];
    [description appendFormat:@"<%s:0x%08X>{\n",object_getClassName(self),(unsigned int)self];
    
    for (i = 0; i < outCount; i++) {
        objc_property_t property = *(properties + i);
        
        //获取属性名称
        NSString *propertyName = [NSString stringWithUTF8String:property_getName(property)];
        
        id value = [self valueForKey:propertyName];
        
        [description appendFormat:@"\t%@:%@\n",propertyName,value];
    }
    [description appendFormat:@"}"];
    
    free(properties);
    return description;
}

@end
