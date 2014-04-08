//
//  EXDBHelper.h
//  DBHelper
//
//  Created by zhengyj on 14-4-4.
//  Copyright (c) 2014年 zhengyj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabaseQueue.h"
#import "EXDBBase.h"

@class EXDBLib;

@interface EXDBHelper : NSObject

@property (strong, nonatomic)  FMDatabaseQueue * dbQueue;

- (void)openWithDBPath:(NSString *)dbPath;
- (void)close;

- (BOOL)replaceObject:(id)object;
- (BOOL)insertObject:(id)object;
- (BOOL)updateObject:(id)object condition:(NSDictionary *)condition;
- (BOOL)deleteObjectWithClassName:(NSString *)className condition:(NSDictionary *)condition;
- (NSArray *)getObjectWithClassName:(NSString *)className condition:(NSDictionary *)condition;
- (NSArray *)getObjectWithObjectName:(NSString *)className orderBy:(NSString *)orderCondition isDesc:(BOOL)isDesc limitCount:(int)count condition:(NSArray *)conditions;

- (void)addDBModuleWithClassName:(NSString *)className;

@end
