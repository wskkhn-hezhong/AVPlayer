//
//  HistoryModel.h
//  EdgeNews
//

#import <Foundation/Foundation.h>

@interface HistoryModel : NSObject

@property (nonatomic, retain) NSString *docid;
@property (nonatomic, retain) NSString *title;//标题
@property (nonatomic, retain) NSString *imgsrc;//图片网址
@property (nonatomic,retain) NSString *tname;
@property (nonatomic,retain) NSString *source;
@property (nonatomic, retain) NSString *url_mp4;//播放网址

@property (nonatomic, retain) NSString *cover;//图片

@end
