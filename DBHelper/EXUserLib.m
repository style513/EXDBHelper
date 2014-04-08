//
//  EXUserLib.m
//  DBHelper
//
//  Created by zhengyj on 14-4-8.
//  Copyright (c) 2014年 zhengyj. All rights reserved.
//

#import "EXUserLib.h"

@implementation EXUserLib
///返回唯一标识符
-(NSString*)voUniqueKey {
    return @"name";
}
///返回对应列名
-(NSString*)voClassName {
    return @"EXUserModel";
}

///返回对应表名
-(NSString*)tableName {
    return @"EXUserModelTabel";
}

@end
