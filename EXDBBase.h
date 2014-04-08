//
//  EXDBBase.h
//  DBHelper
//
//  Created by zhengyj on 14-4-4.
//  Copyright (c) 2014年 zhengyj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabaseQueue.h"

@interface EXDBBase : NSObject 

@property (weak, nonatomic) FMDatabaseQueue * dbQueue;

///返回唯一标识符
-(NSString*)voUniqueKey;
///返回对应列名
-(NSString*)voClassName;
///返回对应表名
-(NSString*)tableName;
///检查表是否存在
-(BOOL)checkTable;
///创建对应表
-(BOOL)createTable;

- (BOOL)insertObject:(id)object;
- (BOOL)replaceObject:(id)object;
- (BOOL)updateObject:(id)object value2Key:(NSDictionary *)dictionary;
- (NSArray *)getObjectWithObjectName:(NSString *)name value2KeyForAndCondition:(NSDictionary *)dictionary;
- (BOOL)deleteObjectName:(NSString *)objectName value2Key:(NSDictionary *)dictionary;
- (NSArray *)getObjectWithObjectName:(NSString *)name orderBy:(NSString *)orderCondition isDesc:(BOOL)isDesc limitCount:(int)count condition:(NSArray *)conditions;

- (id)initWithDBQueue:(FMDatabaseQueue *)dbQueue;


@end
