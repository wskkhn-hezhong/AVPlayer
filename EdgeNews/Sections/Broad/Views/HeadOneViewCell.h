//
//  HeadOneViewCell.h
//  EdgeNews
//
#import <UIKit/UIKit.h>

@interface HeadOneViewCell : UICollectionViewCell
@property (retain, nonatomic) IBOutlet UILabel *titleLabel;
@property (retain, nonatomic) IBOutlet UIButton *joinButton;
@property (nonatomic, assign) NSInteger section;

@end
