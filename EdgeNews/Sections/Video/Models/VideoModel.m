//
//  VideoModel.m
//  EdgeNews
//

#import "VideoModel.h"

@implementation VideoModel

- (void)dealloc
{
    [_des release];
    [_vid release];
    [_cover release];
    [_ptime release];
    [_title release];
    [_length release];
    [_mp4_url release];
    [_playCount release];
    [_replyCount release];
    [super dealloc];
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"description"]) {
        self.des = value;
    }
}

@end
