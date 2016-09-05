//
//  HistoryModel.m
//  EdgeNews
//
//  Created by lanouhn on 15/12/7.
//  Copyright © 2015年 lanouhn. All rights reserved.
//

#import "HistoryModel.h"

@implementation HistoryModel

- (void)dealloc
{
    [_cover release];
    [_url_mp4 release];
    [_docid release];
    [_title release];
    [_tname release];
    [_imgsrc release];
    [_source release];
    [super dealloc];
}

@end
