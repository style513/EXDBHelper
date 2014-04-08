//
//  EXCarDB.m
//  DBHelper
//
//  Created by zhengyj on 14-4-4.
//  Copyright (c) 2014年 zhengyj. All rights reserved.
//

#import "EXCarDB.h"

@implementation EXCarDB
///返回唯一标识符
-(NSString*)voUniqueKey {
    return @"uuid";
}
///返回对应列名
-(NSString*)voClassName {
    return @"EXCarModel";
}

///返回对应表名
-(NSString*)tableName {
    return @"EXCar";
}

@end
