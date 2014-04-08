//
//  EXDBModleData.m
//  DBHelper
//
//  Created by zhengyj on 14-4-4.
//  Copyright (c) 2014年 zhengyj. All rights reserved.
//

#import "EXDBLib.h"
#import "EXUserModle.h"
#import "EXCarDB.h"
#import <objc/runtime.h>

@interface EXDBLib ()
- (BOOL)addDBModle:(EXDBBase *)dbBase;
@end

@implementation EXDBLib

@synthesize dbPath = _dbPath;
@synthesize dbQueue = _dbQueue;
@synthesize dbModles = _dbModles;

- (void)addDBBaseModule:(NSString *)DBModuleClassName {
    Class class = NSClassFromString(DBModuleClassName);
    if(class == nil) {
        NSString *string = [NSString stringWithFormat:@"没有 %@ 该类" ,DBModuleClassName];
        NSAssert(NO, string);
    }

    EXDBBase *dbBase = [[class alloc] initWithDBQueue:self.dbQueue];
    [self addDBModle:dbBase];
}

- (id)init
{
    self = [super init];
    if (self) {
        //初始化代码
        self.dbModles = [NSMutableArray array];
        
    }
    return self;
}

- (id)initWithDBQueue:(FMDatabaseQueue *)dbQueue
{
    self = [super init];
    if (self) {
        //初始化代码
        self.dbModles = [NSMutableArray array];
        self.dbQueue = dbQueue;
        
    }
    return self;
}

- (BOOL)addDBModle:(EXDBBase *)dbBase {
    if (dbBase == nil || ![dbBase isKindOfClass:[EXDBBase class]]) {
        return NO;
    }
    [self.dbModles addObject:dbBase];
    return YES;
}

- (EXDBBase *)dbBaseWithObject:(id)object {
    EXDBBase *dbObject = nil;
    NSString *objectClassName = [NSString stringWithUTF8String:object_getClassName(object)];
    for (EXDBBase *dbBase in self.dbModles) {
        if ([[dbBase voClassName] isEqualToString:objectClassName]) {
            dbObject = dbBase;
            break;
        }
    }
    if (dbObject == nil) {
        NSString *string = [NSString stringWithFormat:@"%s 没有注册 %@ 该类",__PRETTY_FUNCTION__,objectClassName];
        NSAssert(NO, string);
    }
    
    return dbObject;
}

- (EXDBBase *)dbBaseWithClassName:(NSString *)className {
    EXDBBase *dbObject = nil;
    for (EXDBBase *dbBase in self.dbModles) {
        if ([[dbBase voClassName] isEqualToString:className]) {
            dbObject = dbBase;
            break;
        }
    }
    if (dbObject == nil) {
        NSString *string = [NSString stringWithFormat:@"%s 没有注册 %@ 该类",__PRETTY_FUNCTION__,className];
        NSAssert(NO, string);
    }
    
    return dbObject;
}




@end
