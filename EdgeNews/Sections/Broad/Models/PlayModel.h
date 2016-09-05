//
//  PlayModel.h
//  EdgeNews
//
//  Created by lanouhn on 15/12/3.
//  Copyright © 2015年 lanouhn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlayModel : NSObject


@property (nonatomic, retain) NSString *docid;
@property (nonatomic, retain) NSString *title;//标题
@property (nonatomic, retain) NSString *imgsrc;//图片网址
@property (nonatomic,retain) NSString *ptime;
@property (nonatomic,retain) NSString *size;
@property (nonatomic,retain) NSString *tname;
@property (nonatomic,retain) NSString *source;
@property (nonatomic,retain) NSString *tid;


- (instancetype)initWithDocid:(NSString *)docid title:(NSString *)title imgsrc:(NSString *)imgsrc  source:(NSString *)source ;

@end
