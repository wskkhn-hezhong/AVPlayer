//
//  ScrollPhoto.m
//  EdgeNews
//
//  Created by lanouhn on 15/11/26.
//  Copyright (c) 2015年 lanouhn. All rights reserved.
//

#import "ScrollPhoto.h"

@implementation ScrollPhoto

- (void)dealloc
{
    [_note release];
    [_imgurl release];
    [super dealloc];
    
}


- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

@end
