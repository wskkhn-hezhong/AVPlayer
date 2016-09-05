//
//  RadioCollectionViewCell.m
//  EdgeNews
//
//  Created by lanouhn on 15/12/3.
//  Copyright © 2015年 lanouhn. All rights reserved.
//

#import "RadioCollectionViewCell.h"
#import "RadioModel.h"
#import "UIImageView+WebCache.h"

@implementation RadioCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)dealloc {
    [_photoImage release];
    [_titleLabel release];
    [_subLabel release];
    [_playCountLabel release];
    [super dealloc];
}


- (void)setModelToView:(RadioModel *)model {
    self.photoImage.layer.cornerRadius = 45;
    self.photoImage.clipsToBounds = YES;
    [self.photoImage sd_setImageWithURL:[NSURL URLWithString:model.imgsrc] placeholderImage:[UIImage imageNamed:@"beijing001"]];
    self.titleLabel.text = model.tname;
    self.subLabel.text = model.title;
    NSString *str = [NSString stringWithFormat:@"%@", model.playCount];
    NSString *str1 = [str stringByReplacingOccurrencesOfString:@"-" withString:@""];
   
    int a = [str1 intValue];
    int number = 0;
    if (a >= 10000) {
        number = a / 10000;
        self.playCountLabel.text = [NSString stringWithFormat:@"%d万", number];
    }else {
        self.playCountLabel.text = [NSString stringWithFormat:@"%d", a];
    }
    
}
@end
