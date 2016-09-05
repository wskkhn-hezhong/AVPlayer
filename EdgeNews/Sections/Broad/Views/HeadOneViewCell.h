//
//  HeadOneViewCell.h
//  EdgeNews
//
//  Created by lanouhn on 15/12/3.
//  Copyright © 2015年 lanouhn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeadOneViewCell : UICollectionViewCell
@property (retain, nonatomic) IBOutlet UILabel *titleLabel;
@property (retain, nonatomic) IBOutlet UIButton *joinButton;
@property (nonatomic, assign) NSInteger section;

@end
