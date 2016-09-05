//
//  BtnSingleton.h
//  EdgeNews
//
//

#import <Foundation/Foundation.h>
#import "AudioPlayer.h"

@class PlayViewController;

@interface BtnSingleton : NSObject

+ (BtnSingleton *)mainSingleton;

//存数据源
@property (nonatomic, retain) NSArray *data;
@property (nonatomic, retain) NSMutableArray *showData;
@property (nonatomic, retain) NSMutableArray *hideData;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSData *imageData;
@property (nonatomic, assign, getter=isLoadImage) BOOL loadVideo;
@property (nonatomic, assign) int mangeStatus;
@property (nonatomic, strong) AudioPlayer *player;
@property (nonatomic, retain) PlayViewController *playVC;
//播放链接
@property (nonatomic, retain) NSString *audioUrlStr;
@property (nonatomic, retain) NSMutableArray *historyDataSource;
@property (nonatomic, retain) NSMutableArray *collectionDataSource;



@end
