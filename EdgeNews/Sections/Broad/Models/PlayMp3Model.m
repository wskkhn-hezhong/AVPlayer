//
//  PlayMp3Model.m
//  EdgeNews
//

#import "PlayMp3Model.h"

@implementation PlayMp3Model


- (void)dealloc
{
    [_cover release];
    [_url_mp4 release];
    [super dealloc];
}


@end
