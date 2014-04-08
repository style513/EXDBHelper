//
//  EXDBModleData.h
//  DBHelper
//
//  Created by zhengyj on 14-4-4.
//  Copyright (c) 2014年 zhengyj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EXDBBase.h"
#import "FMDatabaseQueue.h"
@interface EXDBLib : NSObject

@property (strong, nonatomic) NSMutableArray * dbModles;


- (EXDBBase *)dbBaseWithObject:(id)object;
- (EXDBBase *)dbBaseWithClassName:(NSString *)className;


@property (weak, nonatomic)  FMDatabaseQueue * dbQueue;
@property (strong, nonatomic) NSString * dbPath;

- (id)initWithDBQueue:(FMDatabaseQueue *)dbQueue;
- (void)addDBBaseModule:(NSString *)DBModuleClassName ;


@end
