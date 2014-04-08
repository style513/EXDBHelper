//
//  EXUser.m
//  DBHelper
//
//  Created by zhengyj on 14-4-4.
//  Copyright (c) 2014年 zhengyj. All rights reserved.
//

#import "EXUser.h"

@implementation EXUser

@synthesize name;

- (id)init
{
    self = [super init];
    if (self) {
        static int i = 0;
        self.userId = [NSNumber numberWithInt:++i];
    }
    return self;
}

@end
