//
//  DBManager.h
//  FMDBDemo
//
//  Created by 刘俊臣 on 15/12/4.
//  Copyright © 2015年 河南蓝鸥科技. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PlayModel;
@interface DBManager : NSObject
@property (nonatomic, retain) NSMutableArray *playCellArr;

//单例初始化方法
+ (DBManager *)defaultManager;

//插入 Person 数据
- (void)insertObjectWithModel:(PlayModel *)model;

//按照年龄删除数据
- (void)deleteObject;

////按照性别更新所有人的名字
//- (void)updateObjectWithGender:(BOOL)gender withName:(NSString *)name;

//根据年龄检索出来所有这个年龄的人
- (NSArray *)selectModel;

//删除数据库
- (void)removeSQLite;
@end
