//
//  EXDBCenter.h
//  DBHelper
//
//  Created by zhengyj on 14-4-8.
//  Copyright (c) 2014年 zhengyj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EXDBHelper.h"

@interface EXDBCenter : NSObject

+ (EXDBCenter *) sharedInstance;

@property (strong, nonatomic) EXDBHelper * dbHelper;

- (void)connectByAccount:(NSString *)account ;

@end
