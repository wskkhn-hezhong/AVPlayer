//
//  DBManager.m
//  FMDBDemo
//
//  Created by 刘俊臣 on 15/12/4.
//  Copyright © 2015年 河南蓝鸥科技. All rights reserved.
//

#import "DBManager.h"
#import "FMDB.h"
#import "PlayModel.h"
//FMDB框架下载地址：https://github.com/ccgus/fmdb


@interface DBManager ()
//FMDB 中对数据库操作的类， 可以保证多线程数据安全， 推荐使用
@property (nonatomic, retain)FMDatabaseQueue *opeQueue;



@property (nonatomic, retain)NSString *sandBoxPath;
@end


@implementation DBManager

- (void)dealloc
{
    [_opeQueue release];
    [_playCellArr release];
    [_sandBoxPath release];
    [super dealloc];
}


//SQLite_Name_Bundle 为工程中 SQLite 文件的名字， 根据需求进行修改
//工程中 SQLite 文件是使用工具 SQLiteManager 创建的， 表内结构是创建时确定好的
//SQLiteManager 网盘下载地址: http://pan.baidu.com/s/1hq6TtAk
#define SQLite_Name_Bundle @"mydatabase"

#pragma mark 以下全是初始化操作单元，代码内基本上不用进行修改
//单例初始化数据库请求类
+ (DBManager *)defaultManager{
    static DBManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[DBManager alloc] init];
    });
    return manager;
}
//重写 init 方法
- (id)init{
    if (self = [super init]) {
        //SQLite 文件在沙盒内的路径
        self.sandBoxPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"MyDB.sqlite"];
        
        [self checkSQLiteWithPath:_sandBoxPath];
    }
    return self;
}
//判断文件夹路径下，sqlite 文件是否存在
- (void)checkSQLiteWithPath:(NSString *)path{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //如果存在
    if ([fileManager fileExistsAtPath:path]) {
        //暂时不做任何处理
    }
    //如果不存在
    else{
        //将工程中的 SQLite 文件拷贝进沙盒里面， 用来存储数据

        //1. 工程中 SQLite 文件的路径
        NSString *bundlePath = [[NSBundle mainBundle] pathForResource:SQLite_Name_Bundle ofType:@"sqlite"];
        if (bundlePath.length==0) {
//            NSLog(@"工程中的 SQLite 文件不存在， 请重新引入");
            abort();
        }
//        BOOL b =
        [fileManager copyItemAtPath:bundlePath toPath:path error:nil];
//        b?NSLog(@"拷贝成功"):NSLog(@"拷贝失败");
    }
    //初始化opeQueue
    //操作沙盒中的数据库文件
    self.opeQueue = [FMDatabaseQueue databaseQueueWithPath:path];
}


#pragma mark 以下为数据库的增删该查方法， 具体实现依照自己的实际需求
- (void)insertObjectWithModel:(PlayModel *)model{
    
    NSArray *tempArr = [self selectModel];
    for (PlayModel *mo in tempArr) {
        if ([mo.docid isEqualToString:model.docid]) {
            return;
        }
    }
    [self.opeQueue inDatabase:^(FMDatabase *db) {
        [db open];
//        BOOL b =
        [db executeUpdate:@"insert into PlayHistory(docid, title, source,  imgsrc) values (?, ?, ?, ?)", model.docid, model.title, model.source,  model.imgsrc];
//        b?NSLog(@"插入数据成功"):NSLog(@"插入数据失败");
        [db close];
    }];
}

- (void)deleteObject{
    [self.opeQueue inDatabase:^(FMDatabase *db) {
        [db open];
//        BOOmoviePlayerL b =
        [db executeUpdate:@"delete from PlayHistory" ];
//        b?NSLog(@"删除数据成功"):NSLog(@"删除数据失败");
        [db close];
    }];
}

//- (void)updateObjectWithGender:(BOOL)gender withName:(NSString *)name{
//    [self.opeQueue inDatabase:^(FMDatabase *db) {
//        [db open];
//        BOOL b = [db executeUpdate:@"update PersonTable set name=? where gender=?", @(gender), name];
//        b?NSLog(@"修改数据成功"):NSLog(@"修改数据失败");
//        [db close];
//    }];
//}

- (NSArray *)selectModel{
    self.playCellArr =[NSMutableArray arrayWithCapacity:0];
    [self.opeQueue inDatabase:^(FMDatabase *db) {
        [db open];
        FMResultSet *result = [db executeQuery:@"select * from PlayHistory"];
        while ([result next]) {
            NSString *docid = [result stringForColumn:@"docid"];
            NSString *title = [result stringForColumn:@"title"];
            NSString *source = [result stringForColumn:@"source"];
            NSString *imgsrc = [result stringForColumn:@"imgsrc"];
            
            //将读取到的数据封装成 Name 对象 存储到 数组中
            PlayModel *cellModel = [[PlayModel alloc] initWithDocid:docid title:title imgsrc:imgsrc source:source ];
            [self.playCellArr addObject:cellModel];

        }
        [db close];
    }];
    return _playCellArr;
}


- (void)removeSQLite{
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager removeItemAtPath:self.sandBoxPath error:nil]) {
//        NSLog(@"删除数据库成功");
    }
    else{
//        NSLog(@"删除数据库失败");
    }
}










@end
