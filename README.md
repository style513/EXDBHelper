///连接数据库

    [[EXDBCenter sharedInstance] connectByAccount:@"test001"];
    
///所有的 model 对应这 EXBaseModule ,每一张表对应一个 类(该类继承与 EXDBBase)   ,没增加一张表的类就要在 EXDBCenter 中注册该表的类
    [self.dbHelper addDBModuleWithClassName:@"EXUserLib"]; 
    
///增


        
        EXUserModel *userModel2 = [[EXUserModel alloc] init];
        userModel2.name = [NSString stringWithFormat:@"name:%d",i];
        userModel2.age = [NSNumber numberWithInt:i ];
        userModel2.sex = @"man";
        
        [[EXDBCenter sharedInstance].dbHelper insertObject:userModel2];