//
//  TitleListCell.m
//  EdgeNews
//
//  Created by lanouhn on 15/12/3.
//  Copyright © 2015年 lanouhn. All rights reserved.
//

#import "TitleListCell.h"
#import "UIImageView+WebCache.h"
#import "RadioModel.h"

@implementation TitleListCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_model release];
    [_photoImage release];
    [_titleLabel release];
    [_detailLabel release];
    [_playCountLabel release];
    [super dealloc];
}

- (void)setModel:(RadioModel *)model {
    self.photoImage.layer.cornerRadius = 40;
    self.photoImage.clipsToBounds = YES;
    [self.photoImage sd_setImageWithURL:[NSURL URLWithString:model.imgsrc] placeholderImage:[UIImage imageNamed:@"beijing"]];
    self.titleLabel.text = model.tname;
    self.detailLabel.text = model.title;
    NSString *str = [NSString stringWithFormat:@"%@", model.playCount];
    NSString *str1 = [str stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    int a = [str1 intValue];
    CGFloat sum = 0 ;
    if (a >= 10000) {
        sum = a / 10000.;
        self.playCountLabel.text = [NSString stringWithFormat:@"%.1f万", sum];
    }else {
        self.playCountLabel.text = [NSString stringWithFormat:@"%d", a];
    }
}

@end
