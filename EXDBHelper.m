//
//  EXDBHelper.m
//  DBHelper
//
//  Created by zhengyj on 14-4-4.
//  Copyright (c) 2014年 zhengyj. All rights reserved.
//

#import "EXDBHelper.h"
#import "EXDBLib.h"
#import "EXDBLib.h"


@interface EXDBHelper ()

@property (strong, nonatomic) EXDBLib * dbModleData;
@property (strong, nonatomic) NSMutableDictionary * dbDictionay;

@property (strong, nonatomic) NSMutableArray * dbLibs;

@end

@implementation EXDBHelper

@synthesize dbQueue = _dbQueue;
@synthesize dbModleData = _dbModleData;
@synthesize dbDictionay = _dbDictionay;
@synthesize dbLibs = _dbLibs;

- (void)addDBModuleWithClassName:(NSString *)className {
     [self.dbModleData addDBBaseModule:className];
}

- (id)init
{
    self = [super init];
    if (self) {
        
        self.dbDictionay = [NSMutableDictionary dictionary];
        self.dbLibs = [NSMutableArray array];
    }
    return self;
}

- (void)openWithDBPath:(NSString *)dbPath {
    
    NSString *path = [self.dbDictionay valueForKey:dbPath];
    if (path != nil) {
        return;
    }
    else {
        self.dbQueue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
        self.dbModleData = nil;
        self.dbModleData = [[EXDBLib alloc] initWithDBQueue:self.dbQueue];
       
    }
}

- (void)openWithDBLib:(EXDBLib *)dbLib {
    
}

- (void)close {
    if (self.dbQueue) {
        [self.dbQueue close];
        self.dbQueue = nil;
    }
}

#pragma mark - 数据库 增删改除 操作

- (BOOL)insertObject:(id)object {
    EXDBBase *dbOperator = [self.dbModleData dbBaseWithObject:object];
    if (dbOperator == nil) {
        return NO;
    }
    BOOL flag = [dbOperator insertObject:object];
    return flag;
}

- (BOOL)replaceObject:(id)object {
    EXDBBase *dbOperator = [self.dbModleData dbBaseWithObject:object];
    if (dbOperator == nil) {
        return NO;
    }
    BOOL flag = [dbOperator replaceObject:object];
    return flag;
}

- (BOOL)updateObject:(id)object condition:(NSDictionary *)condition {
    EXDBBase * dbOperator = [self.dbModleData dbBaseWithObject:object];
    if (dbOperator == nil) {
        return NO;
    }
    return [dbOperator updateObject:object value2Key:condition];
}

- (NSArray *)getObjectWithClassName:(NSString *)className condition:(NSDictionary *)condition {
    EXDBBase * dbOperator = [self.dbModleData dbBaseWithClassName:className];
    if (dbOperator == nil) {
        return nil;
    }
    return [dbOperator getObjectWithObjectName:className value2KeyForAndCondition:condition];
}

- (BOOL)deleteObjectWithClassName:(NSString *)className condition:(NSDictionary *)condition {
    EXDBBase * dbOperator = [self.dbModleData dbBaseWithClassName:className];
    if (dbOperator == nil) {
        return NO;
    }
    return [dbOperator deleteObjectName:className value2Key:condition];
}

- (NSArray *)getObjectWithObjectName:(NSString *)className orderBy:(NSString *)orderCondition isDesc:(BOOL)isDesc limitCount:(int)count condition:(NSArray *)conditions {
    EXDBBase * dbOperator = [self.dbModleData dbBaseWithClassName:className];
    if (dbOperator == nil) {
        return nil;
    }
    return [dbOperator getObjectWithObjectName:className orderBy:orderCondition isDesc:isDesc limitCount:count condition:conditions];
}


- (FMDatabaseQueue *)dbQueueWithClassName:(NSString *)className {
    FMDatabaseQueue *dbQueue = nil;
    for (EXDBLib *dbLib in self.dbLibs) {
        for (EXDBBase *dbBase in dbLib.dbModles) {
            NSString *dbBaseClassName = [NSString stringWithFormat:@"%s",object_getClassName(dbBase)];
            if ([dbBaseClassName isEqualToString:className]) {
                dbQueue = dbLib.dbQueue;
                break;
            }
        }
    }
    return dbQueue;
}



@end
