//
//  EXDBCenter.m
//  DBHelper
//
//  Created by zhengyj on 14-4-8.
//  Copyright (c) 2014年 zhengyj. All rights reserved.
//

#import "EXDBCenter.h"

@implementation EXDBCenter

@synthesize dbHelper = _dbHelper;

- (id) init {
    //禁用 init
    NSAssert(NO, @"Cannot create instance of Singleton");
    //这里可以自己决定返回nil 还是 [self initSingleton]
    return nil;
}

- (id) initSingleton {
    self = [super init];
    if (self) {
        //初始化代码
        self.dbHelper = [[EXDBHelper alloc] init];    }
    return self;
}

+ (EXDBCenter *) sharedInstance {
    
    static EXDBCenter *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] initSingleton];
    });
    return instance;
}


- (void)connectByAccount:(NSString *)account {
    [self.dbHelper close];
    
    NSString* cachesDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *accountPath = [NSString stringWithFormat:@"%@.sqlite3",account];
    NSString *dbPath = [cachesDirectory stringByAppendingPathComponent:accountPath];
    NSLog(@"%@",dbPath);
    [self.dbHelper openWithDBPath:dbPath];
    
    [self.dbHelper addDBModuleWithClassName:@"EXUserModle"];
    [self.dbHelper addDBModuleWithClassName:@"EXCarDB"];
    [self.dbHelper addDBModuleWithClassName:@"EXUserLib"];
}



@end
