//
//  EXUser.h
//  DBHelper
//
//  Created by zhengyj on 14-4-4.
//  Copyright (c) 2014年 zhengyj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EXBaseModel.h"

@interface EXUser : EXBaseModel

@property (strong, nonatomic) NSString * name;
@property (strong, nonatomic) NSNumber * userId;

@end
