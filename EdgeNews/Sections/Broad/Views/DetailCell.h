//
//  DetailCell.h
//  EdgeNews
//
//  Created by lanouhn on 15/12/3.
//  Copyright © 2015年 lanouhn. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PlayModel;

@interface DetailCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UILabel *titleLabel;
@property (retain, nonatomic) IBOutlet UILabel *ptimeLabel;
@property (retain, nonatomic) IBOutlet UILabel *sizeLabel;
@property (nonatomic, retain) PlayModel *model;

@end
