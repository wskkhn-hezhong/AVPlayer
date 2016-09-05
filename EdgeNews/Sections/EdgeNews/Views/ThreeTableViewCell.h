//
//  ThreeTableViewCell.h
//  EdgeNews
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
