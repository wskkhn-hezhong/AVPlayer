//
//  HeadTableViewCell.h
//  EdgeNews
//
//  Created by lanouhn on 15/11/25.
//  Copyright (c) 2015年 lanouhn. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EdgeNews;

@interface HeadTableViewCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UIImageView *allImage;
@property (retain, nonatomic) IBOutlet UILabel *deLabel;

@property (nonatomic, retain) EdgeNews *edgeNews;

@end
