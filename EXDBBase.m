//
//  EXDBBase.m
//  DBHelper
//
//  Created by zhengyj on 14-4-4.
//  Copyright (c) 2014年 zhengyj. All rights reserved.
//

#import "EXDBBase.h"
#import "FMResultSet.h"
#import "FMDatabase.h"
#import "EXDBHelper.h"
#import "EXDBBaseString.h"
#import "EXBaseModel.h"

@interface EXDBBase ()

- (BOOL)createTabelWithObjectName:(NSString *)name unique:(NSString*)statement,...;

@end

@implementation EXDBBase

@synthesize dbQueue = _dbQueue;

- (id)initWithDBQueue:(FMDatabaseQueue *)dbQueue
{
    self = [super init];
    if (self) {
        self.dbQueue = dbQueue;
        if (![self checkTable]) {
            //创建组表
            [self createTable];
        }
        
    }
    return self;
}

- (id)init
{
    //禁用 init
    NSAssert(NO, @"EXDBBase 必须调用 initWithDBQueue 初始化");
    //这里可以自己决定返回nil 还是 [self initSingleton]
    return nil;
}

///返回唯一标识符
-(NSString*)voUniqueKey {
    return nil;
}

///返回对应列名
-(NSString*)voClassName {
    NSString *string = [NSString stringWithFormat:@"%s 必须实现该类的 voClassName 方法 ",object_getClassName(self)];
    NSAssert(NO, string);
    
    return nil;
}
///返回对应表名
-(NSString*)tableName{
    NSString *string = [NSString stringWithFormat:@"%s 必须实现该类的 tableName 方法 ",object_getClassName(self)];
    NSAssert(NO, string);
    
    return nil;
}
///检查表是否存在
-(BOOL)checkTable{
    NSString *tableName = [self tableName];
    if (tableName) {
        __block BOOL flag = NO;
        [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
            FMResultSet *rs = [db executeQuery:@"select count(*) as 'count' from sqlite_master where type ='table' and name = ?", tableName];
            while ([rs next]) {
                NSInteger count = [rs intForColumn:@"count"];
                
                if (0 == count) {
                    flag = NO;
                }
                else {
                    flag = YES;
                }
                break;
            }
        }];
        return flag;
    }
    else{
        return NO;
    }
}

///创建对应表
-(BOOL)createTable{
    NSString *uniqueKey = [self voUniqueKey];
    NSString *tableName = [self tableName];
    if (tableName != nil) {
        if (![self checkTable]) {
            
            return [self createTabelWithObjectName:[self voClassName] unique:uniqueKey,nil];
        }
    }
    return NO;
}

#pragma mark - getter

- (FMDatabaseQueue *)dbQueue {
    
    if (_dbQueue == nil) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"数据库没有打开" delegate:nil cancelButtonTitle:@"cancel" otherButtonTitles: nil];
        [alertView show];
    }
    
    return _dbQueue;
}

#pragma mark - dbOperation

- (BOOL)createTabelWithObjectName:(NSString *)name unique:(NSString*)statement,... {
    
    va_list argList;
    va_start(argList,statement);
    va_end(argList);
    
    NSString *createSQL = [EXDBBaseString createStringWithClassName:name tableName:[self tableName] unique:statement uniques:argList];
    __block BOOL flag = NO;
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        flag = [db executeUpdate:createSQL];
    }];
    
    return flag;
}

- (BOOL)insertObject:(id) object {
    NSString *insertSQL = [EXDBBaseString insertStringWithClass:object VOTableName:[self tableName]];
    
    __block BOOL flag = NO;
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        flag = [db executeUpdate:insertSQL];
    }];
    
    return flag;
}

- (BOOL)replaceObject:(id)object {
    NSString *insertSQL = [EXDBBaseString replaceStringWithClass:object];
    NSLog(@"%@",insertSQL);
    __block BOOL flag = NO;
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        flag = [db executeUpdate:insertSQL];
    }];
    return flag;
}

- (BOOL)updateObject:(id)object value2Key:(NSDictionary *)dictionary {
    NSString *sql = [EXDBBaseString updateStringWithClass:object tableName:[self tableName] value2Key:dictionary];
    
    __block BOOL flag = NO;
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        flag = [db executeUpdate:sql];
    }];
    
    return flag;
}

- (NSArray *)getObjectWithObjectName:(NSString *)name value2KeyForAndCondition:(NSDictionary *)dictionary {
    
    NSString *sql = [EXDBBaseString getObjectStringWithTableName:[self tableName] value2KeyForAndCondition:dictionary];
    
    NSMutableArray *array = [NSMutableArray array];
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next])
        {
            id object = [NSClassFromString(name) alloc];
            if ([object respondsToSelector:@selector(initWithDataDic:)]) {
                id item = [object initWithDataDic:[rs resultDictionary]];
                [array addObject:item];
            }
            else {
                NSString *string = [NSString stringWithFormat:@"%@ 获取数据的对象模型必须实现 initWithDataDic 接口",name];
                NSAssert(NO, string);
            }
        }
    }];
    
    return array;
}

- (BOOL)deleteObjectName:(NSString *)objectName value2Key:(NSDictionary *)dictionary {
    NSString *sql = [EXDBBaseString deleteObjectStringWithTableName:[self tableName] value2Key:dictionary];
    
    __block BOOL flag = NO;
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        flag = [db executeUpdate:sql];
    }];
    return flag;
}

- (NSArray *)getObjectWithObjectName:(NSString *)name orderBy:(NSString *)orderCondition isDesc:(BOOL)isDesc limitCount:(int)count condition:(NSArray *)conditions {
    
    NSString *sql = [EXDBBaseString getObjectWithObjectName:name orderBy:orderCondition isDesc:isDesc limitCount:count condition:conditions];
    
    NSMutableArray *array = [NSMutableArray array];
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next])
        {
            id object = [NSClassFromString(name) alloc];
            
            if ([object respondsToSelector:@selector(initWithDataDic:)]) {
                id item = [object initWithDataDic:[rs resultDictionary]];
                [array addObject:item];
            }
        }
    }];
    
    return array;
}

@end
