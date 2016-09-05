//
//  photoSet.h
//  EdgeNews
//
//  Created by lanouhn on 15/11/26.
//  Copyright (c) 2015年 lanouhn. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ScrollPhoto;

@interface photoSet : NSObject

@property (nonatomic, retain) NSString *setname;
@property (nonatomic, retain) NSString *imgsum;

@property (nonatomic, retain) ScrollPhoto *photos;

@end
