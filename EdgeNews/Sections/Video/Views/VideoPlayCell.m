//
//  videoPlayCell.m
//  EdgeNews
//
//  Created by lanouhn on 15/12/1.
//  Copyright © 2015年 lanouhn. All rights reserved.
//

#import "VideoPlayCell.h"
#import "VideoModel.h"
#import "UIImageView+WebCache.h"

@implementation VideoPlayCell

+ (instancetype)registerCell {
    VideoPlayCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"VideoPlayCell" owner:self options:nil] firstObject];
    return cell;
}

- (void)awakeFromNib {
    self.gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickPhoto:)];
    self.photoImageView.userInteractionEnabled = YES;
    [self.photoImageView addGestureRecognizer:_gesture];
    [_gesture release];
}

- (void)clickPhoto:(UITapGestureRecognizer *)gesture {
    if (self.delegate && [self.delegate respondsToSelector:@selector(videoPlayCell:)]) {
        [self.delegate videoPlayCell:self];
    }
}


- (void)setModelToVideo:(VideoModel *)model {
    self.titleLabel .text = model.title;
    self.descriptionLabel.text = model.des;
    self.descriptionLabel.font = [UIFont systemFontOfSize:13 *WIDTH / 375];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:16 * WIDTH / 375];
    self.lengthLabel.text = [NSString stringWithFormat:@"%.2d:%.2d", (model.length).intValue / 60, (model.length).intValue % 60];
    self.playcount.text = [NSString stringWithFormat:@"%d", (model.playCount).intValue];
    self.ptimeLabel.text = model.ptime;
    [self.photoImageView sd_setImageWithURL:[NSURL URLWithString:model.cover]];
   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_titleLabel release];
    [_descriptionLabel release];
    [_playView release];
    [_lengthLabel release];
    [_playcount release];
    [_ptimeLabel release];
    [_photoImageView release];
    [_playImage release];
    [super dealloc];
}
@end
