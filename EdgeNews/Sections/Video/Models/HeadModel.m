//
//  Header.m
//  EdgeNews
//
//  Created by lanouhn on 15/11/28.
//  Copyright (c) 2015年 lanouhn. All rights reserved.
//

#import "HeadModel.h"

@implementation HeadModel

- (void)dealloc
{
    [_sid release];
    [_title release];
    [_imgsrc release];
    [super dealloc];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

@end
