//
//  DetailCell.h
//  EdgeNews
//

#import <UIKit/UIKit.h>

@class PlayModel;

@interface DetailCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UILabel *titleLabel;
@property (retain, nonatomic) IBOutlet UILabel *ptimeLabel;
@property (retain, nonatomic) IBOutlet UILabel *sizeLabel;
@property (nonatomic, retain) PlayModel *model;

@end
