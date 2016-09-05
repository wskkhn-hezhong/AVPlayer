//
//  Model.h
//  EdgeNews
//
//  Created by lanouhn on 15/11/25.
//  Copyright (c) 2015年 lanouhn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Model : NSObject

@property (nonatomic, retain) NSString *title;//标题
@property (nonatomic, retain) NSString *digest;//简介
@property (nonatomic, retain) NSString *replyCount;//跟帖数
@property (nonatomic, retain) NSString *docid;//详情页id
@property (nonatomic, retain) NSString *imgsrc;//照片网址
@property (nonatomic, retain) NSString *url; //画报点击进入详情界面的网址
@property (nonatomic, retain) NSMutableArray *imageArray; //图片数组
@property (nonatomic, retain) NSString *source;
@property (nonatomic, retain) NSString *TAGS;
@property (nonatomic, retain) NSString *boardid;
@property (nonatomic, retain) NSString *photosetID;

@end
