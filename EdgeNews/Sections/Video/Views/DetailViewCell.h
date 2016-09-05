//
//  DetailViewCell.h
//  EdgeNews
//

#import <UIKit/UIKit.h>



@class DetailModel;
@interface DetailViewCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UILabel *titleLabel;
@property (retain, nonatomic) IBOutlet UILabel *timeLabel;
@property (retain, nonatomic) IBOutlet UIImageView *playImage;

- (void)setModelToCell:(DetailModel *)model;



@end
