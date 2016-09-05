//
//  RadioCollectionViewCell.h
//  EdgeNews
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
