//
//  RadioModel.h
//  EdgeNews
//
//  Created by lanouhn on 15/12/3.
//  Copyright © 2015年 lanouhn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RadioModel : NSObject

@property (nonatomic,retain) NSString *docid;
@property (nonatomic, retain) NSString *title;//标题
@property (nonatomic, retain) NSString *imgsrc;//图片网址
@property (nonatomic, retain) NSString *tid;//需要拼接的id
@property (nonatomic, retain) NSString *source;//调到下一个界面的标题
@property (nonatomic, retain) NSString *tname;//名字
@property (nonatomic, retain) NSString *cid;
@property (nonatomic, retain) NSString *playCount;//播放次数


@end
