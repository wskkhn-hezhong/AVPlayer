//
//  VideoModel.h
//  EdgeNews
//

#import <Foundation/Foundation.h>

@interface VideoModel : NSObject

@property (nonatomic, retain) NSString *replyCount;//评论数
@property (nonatomic, retain) NSString *title;//标题
@property (nonatomic, retain) NSString *cover;//图片
@property (nonatomic, retain) NSString *playCount;//播放数
@property (nonatomic, retain) NSString *des;//简介
@property (nonatomic, retain) NSString *vid;//id
@property (nonatomic, retain) NSString *length;//时长
@property (nonatomic, retain) NSString *mp4_url;//视频地址
@property (nonatomic, retain) NSString *ptime;//更新时间


@end
