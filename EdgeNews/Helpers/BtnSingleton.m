//
//  BtnSingleton.m
//  EdgeNews
//
//

#import "BtnSingleton.h"
#import "PlayViewController.h"

@implementation BtnSingleton

- (void)dealloc
{
    [_data release];
    [_showData release];
    [_hideData release];
    [_title release];
    [_imageData release];
    [_player release];
    [_playVC release];
    [_audioUrlStr release];
    [_historyDataSource release];
    [_collectionDataSource release];
    [super dealloc];
}

+ (BtnSingleton *)mainSingleton {
    static BtnSingleton *singleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [[BtnSingleton alloc] init];
        singleton.data = [NSArray array];
        singleton.showData = [NSMutableArray arrayWithCapacity:0];
        singleton.hideData = [NSMutableArray arrayWithCapacity:0];
        
        
        singleton.player = [[AudioPlayer alloc] init];
        singleton.playVC = [[PlayViewController alloc] init];
        singleton.historyDataSource = [NSMutableArray arrayWithCapacity:0];
        singleton.collectionDataSource = [NSMutableArray arrayWithCapacity:0];
    });
    return singleton;
}

- (void)setAudioUrlStr:(NSString *)audioUrlStr {
    _audioUrlStr = audioUrlStr;
    self.player.url = [NSURL URLWithString:audioUrlStr];
}



@end
