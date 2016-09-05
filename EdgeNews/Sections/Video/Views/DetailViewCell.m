//
//  DetailViewCell.m
//  EdgeNews
//

#import "DetailViewCell.h"
#import "DetailModel.h"
#import "UIImageView+WebCache.h"

@implementation DetailViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_titleLabel release];
    [_timeLabel release];
    [_playImage release];
    [super dealloc];
}

- (void)setModelToCell:(DetailModel *)model {
    self.titleLabel.text = model.title;
    self.timeLabel.text = [NSString stringWithFormat:@"%.2d:%.2d", (model.length).intValue / 60, (model.length).intValue % 60];
}

@end
