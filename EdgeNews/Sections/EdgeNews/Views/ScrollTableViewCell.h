//
//  ScrollTableViewCell.h
//  EdgeNews
//
//  Created by lanouhn on 15/11/25.
//  Copyright (c) 2015年 lanouhn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDCycleScrollView.h"



@class ScrollViewController;
@interface ScrollTableViewCell : UITableViewCell

@property (nonatomic, retain) SDCycleScrollView *cycleScrollView;

@property (nonatomic, retain) NSMutableArray *imageArray;

@property (nonatomic, retain) NSMutableArray *titleArray;

@property (nonatomic, retain) NSMutableArray *urlArray;

@property (nonatomic, assign) ScrollViewController *vc;


@end
