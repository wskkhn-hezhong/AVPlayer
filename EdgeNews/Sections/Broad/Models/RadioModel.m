//
//  RadioModel.m
//  EdgeNews
//
//  Created by lanouhn on 15/12/3.
//  Copyright © 2015年 lanouhn. All rights reserved.
//

#import "RadioModel.h"

@implementation RadioModel


- (void)dealloc
{
    [_cid release];
    [_tid release];
    [_docid release];
    [_title release];
    [_tname release];
    [_imgsrc release];
    [_source release];
    [_playCount release];
    [super dealloc];
}




@end;

