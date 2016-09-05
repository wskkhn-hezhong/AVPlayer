//
//  TitleListCell.h
//  EdgeNews
//

#import <UIKit/UIKit.h>

@class RadioModel;

@interface TitleListCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UIImageView *photoImage;
@property (retain, nonatomic) IBOutlet UILabel *titleLabel;
@property (retain, nonatomic) IBOutlet UILabel *detailLabel;
@property (retain, nonatomic) IBOutlet UILabel *playCountLabel;
@property (nonatomic, retain) RadioModel *model;


@end
