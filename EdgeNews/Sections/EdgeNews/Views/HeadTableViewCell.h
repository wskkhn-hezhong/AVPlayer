//
//  HeadTableViewCell.h
//  EdgeNews
//
#import <UIKit/UIKit.h>

@class EdgeNews;

@interface HeadTableViewCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UIImageView *allImage;
@property (retain, nonatomic) IBOutlet UILabel *deLabel;

@property (nonatomic, retain) EdgeNews *edgeNews;

@end
