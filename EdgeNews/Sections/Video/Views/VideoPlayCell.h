//
//  videoPlayCell.h
//  EdgeNews
//

#import <UIKit/UIKit.h>

@class VideoPlayCell, VideoModel;

@protocol VideoPlayCellDelegate <NSObject>

- (void)videoPlayCell:(VideoPlayCell *)videoCell;

@end

@interface VideoPlayCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UILabel *titleLabel;
@property (retain, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (retain, nonatomic) IBOutlet UIView *playView;
@property (retain, nonatomic) IBOutlet UILabel *lengthLabel;
@property (retain, nonatomic) IBOutlet UILabel *playcount;
@property (retain, nonatomic) IBOutlet UILabel *ptimeLabel;
@property (retain, nonatomic) IBOutlet UIImageView *photoImageView;
@property (retain, nonatomic) IBOutlet UIImageView *playImage;

@property (nonatomic,retain) UITapGestureRecognizer *gesture;
@property (nonatomic, assign) id<VideoPlayCellDelegate> delegate;



+ (instancetype)registerCell;

- (void)setModelToVideo:(VideoModel *)model;


@end
