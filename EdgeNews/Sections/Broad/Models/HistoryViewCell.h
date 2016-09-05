//
//  HistoryViewCell.h
//  EdgeNews
//


#import <UIKit/UIKit.h>


@interface HistoryViewCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UIImageView *photoImage;
@property (retain, nonatomic) IBOutlet UILabel *titleLabel;
@property (retain, nonatomic) IBOutlet UILabel *detailLabel;
@property (retain, nonatomic) IBOutlet UILabel *timeLabel;
@property (retain, nonatomic) IBOutlet UILabel *alllabel;
@property (retain, nonatomic) IBOutlet UIButton *button;


@end
