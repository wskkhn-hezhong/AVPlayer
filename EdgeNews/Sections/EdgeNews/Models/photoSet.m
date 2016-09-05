//
//  photoSet.m
//  EdgeNews
//
//  Created by lanouhn on 15/11/26.
//  Copyright (c) 2015年 lanouhn. All rights reserved.
//

#import "photoSet.h"
#import "ScrollPhoto.h"

@implementation photoSet

- (void)dealloc
{
    [_imgsum release];
    [_photos release];
    [_setname release];
    [super dealloc];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

@end
