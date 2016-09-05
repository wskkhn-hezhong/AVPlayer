//
//  ThreeTableViewCell.h
//  EdgeNews
//
//  Created by lanouhn on 15/11/25.
//  Copyright (c) 2015年 lanouhn. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Model;

@interface ThreeTableViewCell : UITableViewCell
@property (retain, nonatomic)  UILabel *titleLabel;
@property (retain, nonatomic)  UILabel *smallLabel;
@property (retain, nonatomic)  UIImageView *photoView1;
@property (retain, nonatomic)  UIImageView *photoView2;
@property (retain, nonatomic)  UIImageView *photoView3;

@property (retain, nonatomic) Model *model;

@end
