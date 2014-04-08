//
//  EXUser.m
//  DBHelper
//
//  Created by zhengyj on 14-4-4.
//  Copyright (c) 2014年 zhengyj. All rights reserved.
//
#import "EXDBHelper.h"
#import "EXUserModle.h"

@implementation EXUserModle

///返回唯一标识符
-(NSString*)voUniqueKey {
    return @"userId";
}
///返回对应列名
-(NSString*)voClassName {
    return @"EXUser";
}

///返回对应表名
-(NSString*)tableName {
    return @"EXUser";
}

@end