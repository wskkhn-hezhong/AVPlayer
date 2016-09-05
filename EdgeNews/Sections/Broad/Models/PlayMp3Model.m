//
//  PlayMp3Model.m
//  EdgeNews
//
//  Created by lanouhn on 15/12/4.
//  Copyright © 2015年 lanouhn. All rights reserved.
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
