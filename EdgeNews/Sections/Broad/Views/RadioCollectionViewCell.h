//
//  RadioCollectionViewCell.h
//  EdgeNews
//
//  Created by lanouhn on 15/12/3.
//  Copyright © 2015年 lanouhn. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RadioModel;

@interface RadioCollectionViewCell : UICollectionViewCell
@property (retain, nonatomic) IBOutlet UIImageView *photoImage;
@property (retain, nonatomic) IBOutlet UILabel *titleLabel;
@property (retain, nonatomic) IBOutlet UILabel *subLabel;
@property (retain, nonatomic) IBOutlet UILabel *playCountLabel;


- (void)setModelToView:(RadioModel *)model;

@end
