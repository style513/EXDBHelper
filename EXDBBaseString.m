//
//  EXDBBaseString.m
//  DBHelper
//
//  Created by zhengyj on 14-4-4.
//  Copyright (c) 2014年 zhengyj. All rights reserved.
//

#import "EXDBBaseString.h"
#import <objc/runtime.h>

@implementation EXDBBaseString


+ (NSString *)createStringWithClassName:(NSString *)className tableName:(NSString *)tableName unique:(NSString *)unique uniques:(va_list)argList {
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList(NSClassFromString(className), &outCount);
    NSMutableString *createSQL = [NSMutableString stringWithFormat:@"create table if not exists '%@'(",tableName];
    for (i = 0; i < outCount; i++) {
        objc_property_t property = *(properties + i);
        
        //获取属性名称
        NSString *propertyName = [NSString stringWithUTF8String:property_getName(property)];
        
        //获取属性类型
        const char *attribute = property_getAttributes( property);
        printf("%s\n",attribute);
        NSString *attributeStr = [NSString stringWithUTF8String:property_getAttributes( property)];
        NSRange range1 = [attributeStr rangeOfString:@"@\""];
        NSString *classTypeName = nil;
        if (range1.length != 0) {
            NSString *strTemp = [attributeStr substringFromIndex:range1.location + range1.length];
            NSRange range2 = [strTemp rangeOfString:@"\""];
            classTypeName = [strTemp substringToIndex:range2.location];
        }
        else {
            range1 = [attributeStr rangeOfString:@"T"];
            NSString *strTemp = [attributeStr substringFromIndex:range1.location + range1.length];
            NSRange range2 = [strTemp rangeOfString:@","];
            classTypeName = [strTemp substringToIndex:range2.location];
        }
        
        if ([classTypeName isEqualToString:@"NSNumber"]) {
            
            classTypeName = @"integer";
        }
        else if ([classTypeName isEqualToString:@"i"]) {
            classTypeName = @"integer";
        }
        else {
            classTypeName = @"text";
        }
        
        if ([propertyName isEqualToString:@"iObjectId"]) {
            propertyName = @"id";
        }
        
        NSString *s = [NSString stringWithFormat:@"\'%@\' %@,",propertyName,classTypeName];
        [createSQL appendString:s];
    }
    
    free(properties);
    
    //unique
    id arg = unique;
    while (arg) {
        
        if ([arg isEqualToString:@"iObjectId"]) {
            arg = @"id";
        }
        
        NSString *uniqueString = arg;
        NSRange range = [arg rangeOfString:@","];
        if (range.location != NSNotFound) {
            uniqueString = [arg stringByReplacingOccurrencesOfString:@"," withString:@"\",\""];
        }
        
        [createSQL appendFormat:@"unique(\"%@\"),",uniqueString];
        arg = va_arg(argList, id);
    }
    
    va_end(argList);
    
    NSString *retString = [NSString stringWithFormat:@"%@)",[createSQL substringToIndex:createSQL.length - 1]];
    return retString;
}


+ (NSString *)insertStringWithClass:(id)object VOTableName:(NSString *)voTableName {
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList(([object class]), &outCount);
    
    NSMutableString *sql = [NSMutableString string];
    NSMutableString *values = [NSMutableString string];
    
    [sql appendFormat: @"insert into %@ (",voTableName];
    [values appendFormat:@") values ("];
    
    for (i = 0; i < outCount; i++) {
        objc_property_t property = *(properties + i);
        
        //获取属性名称
        NSString *propertyName = [NSString stringWithUTF8String:property_getName(property)];
        
        id value = [object valueForKey:propertyName];
        if ([propertyName isEqualToString:@"iObjectId"]) {
            propertyName = @"id";
        }
        
        if ([[value class] isSubclassOfClass:[NSNull class]] || [value class] == nil) {
            value = nil;
        }
        else if([value isKindOfClass:[NSString class]]) {
            value = [NSString stringWithFormat:@"\"%@\"",value];
        }
        else {
            value = [NSString stringWithFormat:@"\"%@\"",value];
        }
        
        [sql appendFormat:@"\"%@\",",propertyName];
        [values appendFormat:@"%@,",value];
        
    }
    
    free(properties);
    
    
    //替换最后一个逗号
    NSRange range;
    range.length = 1;
    range.location = sql.length - 1;
    [sql replaceCharactersInRange:range withString:[NSString stringWithFormat:@"%@",values]];
    
    //替换最后一个逗号
    range.length = 1;
    range.location = sql.length - 1;
    [sql replaceCharactersInRange:range withString:[NSString stringWithFormat:@")"]];
    
    return sql;
}


+ (NSString *)updateStringWithClass:(id)object tableName:(NSString *)tableName value2Key:(NSDictionary *)dictionary {

    NSMutableString *sql = [NSMutableString string];
    [sql appendFormat: @"update %@ set ",tableName];
    
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList(([object class]), &outCount);
    
    
    for (i = 0; i < outCount; i++) {
        objc_property_t property = *(properties + i);
        
        //获取属性名称
        NSString *propertyName = [NSString stringWithUTF8String:property_getName(property)];
        
        id value = [object valueForKey:propertyName];
        if ([propertyName isEqualToString:@"iObjectId"]) {
            propertyName = @"id";
        }
        
        
        if (value == nil || [value isEqual:[NSNull null]]) {
            //            continue;
            value = nil;
        }
        else if ([[value class] isSubclassOfClass:[NSNumber class]]) {
            value = [NSString stringWithFormat:@"%@",value];
            
        }
        else {
            value = [NSString stringWithFormat:@"\"%@\"",value];
        }
        
        [sql appendFormat:@"\"%@\" = %@,",propertyName,value];
    }
    
    free(properties);
    
    
    //替换最后一个逗号
    
    if (dictionary.count != 0) {
        
        NSRange range;
        range.length = 1;
        range.location = sql.length - 1;
        [sql replaceCharactersInRange:range withString:@" where "];
        
        
        NSEnumerator *enumerator = [dictionary keyEnumerator];
        NSString * key ;
        while ((key = [enumerator nextObject])) {
            
            id value = [dictionary valueForKey:key];
            if ([key isEqualToString:@"iObjectId"]) {
                key = @"id";
            }
            
            if([value isKindOfClass:[NSString class]]) {
                value = [NSString stringWithFormat:@"\"%@\"",value];
            }
            
            NSString *str = [NSString stringWithFormat:@"\"%@\" = %@ and",key,value];
            [sql appendString:str];
        }
        
        
        range.length = 3;
        range.location = sql.length - 3;
        [sql replaceCharactersInRange:range withString:@""];
        
    }
    else {
        
        NSRange range;
        range.length = 1;
        range.location = sql.length - 1;
        [sql replaceCharactersInRange:range withString:@""];
        
    }
    
    
    return sql;
}

+ (NSString *)getObjectStringWithTableName:(NSString *)name value2KeyForAndCondition:(NSDictionary *)dictionary {
    
    NSMutableString *sql = [NSMutableString stringWithFormat:@"select * from %@",name];
    
    NSEnumerator *keyEnum = [dictionary keyEnumerator];
	id attributeName = [keyEnum nextObject];
    if (attributeName != nil) {
        [sql appendFormat:@" where \"%@\" = \"%@\"",attributeName,[dictionary valueForKey:attributeName]];
        while ((attributeName = [keyEnum nextObject])) {
            [sql appendFormat:@" and \"%@\" = \"%@\"",attributeName,[dictionary valueForKey:attributeName]];
        }
    }
    return sql;
}

+ (NSString *)deleteObjectStringWithTableName:(NSString *)objectName value2Key:(NSDictionary *)dictionary {
    NSMutableString *sql = [NSMutableString stringWithFormat:@"delete from %@",objectName];
    
    NSEnumerator *keyEnum = [dictionary keyEnumerator];
	id attributeName = [keyEnum nextObject];
    if (attributeName != nil) {
        [sql appendFormat:@" where \"%@\" = \"%@\"",attributeName,[dictionary valueForKey:attributeName]];
        while ((attributeName = [keyEnum nextObject])) {
            [sql appendFormat:@" and \"%@\" = \"%@\"",attributeName,[dictionary valueForKey:attributeName]];
        }
    }
    return sql;
}

+ (NSString *) getObjectWithObjectName:(NSString *)name orderBy:(NSString *)orderCondition isDesc:(BOOL)isDesc limitCount:(int)count condition:(NSArray *)conditions{
    
    
    NSMutableString *sql = [NSMutableString stringWithFormat:@"select * from %@",name];
    
    for (int i = 0; i < conditions.count; i++) {
        
        if (i == 0) {
            [sql appendFormat:@" where "];
        }
        
        NSDictionary *arg = [conditions objectAtIndex:i];
        
        NSEnumerator *keyEnum = [arg keyEnumerator];
        id attributeName = [keyEnum nextObject];
        if (attributeName != nil) {
            id value = [arg valueForKey:attributeName];
            if ([attributeName isEqualToString:@"iObjectId"]) {
                attributeName = @"id";
            }
            [sql appendFormat:@"(\"%@\" = \"%@\"",attributeName,value];
            while ((attributeName = [keyEnum nextObject])) {
                
                id value = [arg valueForKey:attributeName];
                if ([attributeName isEqualToString:@"iObjectId"]) {
                    attributeName = @"id";
                }
                [sql appendFormat:@" and \"%@\" = \"%@\"",attributeName,value];
            }
        }
        
        if (i != conditions.count - 1) {
            [sql appendString:@") or "];
        }
        else {
            [sql appendString:@")"];
        }
    }
    
    NSString *descString = @"";
    if (isDesc) {
        descString = @" desc ";
    }
    
    NSString *limitString = @"";
    if(count > 0) {
        limitString = [NSString stringWithFormat:@" limit %d",count];
    }
    
    NSString *orderString = @"";
    if (orderCondition.length != 0) {
        orderString = [NSString stringWithFormat:@" order by %@",orderCondition];
    }
    
    [sql appendFormat:@"%@%@%@",orderString,descString,limitString];
 
    return sql;
}

+ (NSString *)replaceStringWithClass:(id)object {
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList(([object class]), &outCount);
    
    NSMutableString *sql = [NSMutableString string];
    NSMutableString *values = [NSMutableString string];
    
    [sql appendFormat: @"replace into %@ (",[object class]];
    [values appendFormat:@") values ("];
    
    for (i = 0; i < outCount; i++) {
        objc_property_t property = *(properties + i);
        
        //获取属性名称
        NSString *propertyName = [NSString stringWithUTF8String:property_getName(property)];
        
        id value = [object valueForKey:propertyName];
        if ([propertyName isEqualToString:@"iObjectId"]) {
            propertyName = @"id";
        }
        
        if ([[value class] isSubclassOfClass:[NSNull class]] || [value class] == nil) {
            value = nil;
        }
        else if([value isKindOfClass:[NSString class]]) {
            value = [NSString stringWithFormat:@"\"%@\"",value];
        }
        else {
            value = [NSString stringWithFormat:@"\"%@\"",value];
        }
        
        [sql appendFormat:@"\"%@\",",propertyName];
        [values appendFormat:@"%@,",value];
        
    }
    
    free(properties);
    
    
    //替换最后一个逗号
    NSRange range;
    range.length = 1;
    range.location = sql.length - 1;
    [sql replaceCharactersInRange:range withString:[NSString stringWithFormat:@"%@",values]];
    
    //替换最后一个逗号
    range.length = 1;
    range.location = sql.length - 1;
    [sql replaceCharactersInRange:range withString:[NSString stringWithFormat:@")"]];
    
    return sql;
}

@end
