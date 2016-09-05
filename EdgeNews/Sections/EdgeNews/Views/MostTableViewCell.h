//
//  MostTableViewCell.h
//  EdgeNews
//

#import <UIKit/UIKit.h>

@class Model;

@interface MostTableViewCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UIImageView *bigImage;
@property (retain, nonatomic) IBOutlet UILabel *titleLabel;
@property (retain, nonatomic) IBOutlet UILabel *detailLabel;
@property (retain, nonatomic) IBOutlet UILabel *smallLabel;
@property (nonatomic, retain) Model *model;


@end
