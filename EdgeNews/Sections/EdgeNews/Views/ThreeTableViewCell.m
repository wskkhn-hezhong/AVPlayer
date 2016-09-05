//
//  ThreeTableViewCell.m
//  EdgeNews
//
//  Created by lanouhn on 15/11/25.
//  Copyright (c) 2015年 lanouhn. All rights reserved.
//

#import "ThreeTableViewCell.h"
#import "Model.h"
#import "UIImageView+WebCache.h"

@implementation ThreeTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_model release];
    [_titleLabel release];
    [_smallLabel release];
    [_photoView1 release];
    [_photoView2 release];
    [_photoView3 release];
    [super dealloc];
}

- (void)setModel:(Model *)model {
    if (_model != model) {
        _model = model;
    }
    
    self.titleLabel.text = model.title;
    self.smallLabel.text = [NSString stringWithFormat:@"%@跟帖", model.replyCount];
    [self.photoView1 sd_setImageWithURL:[NSURL URLWithString:model.imgsrc] placeholderImage:[UIImage imageNamed:@"aaa"]];
    [self.photoView2 sd_setImageWithURL:[NSURL URLWithString:[model.imageArray firstObject][@"imgsrc"]] placeholderImage:[UIImage imageNamed:@"aaa"]];
    [self.photoView3 sd_setImageWithURL:[NSURL URLWithString:[model.imageArray lastObject][@"imgsrc"]] placeholderImage:[UIImage imageNamed:@"aaa"]];
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, WIDTH - 85 * WIDTH / 375, 26 * WIDTH / 375)];
        _titleLabel.font = [UIFont boldSystemFontOfSize:17 * WIDTH / 375];
        [self.contentView addSubview:_titleLabel];
        [_titleLabel release];
        
        self.smallLabel = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH - 70 * WIDTH / 375, 9 * WIDTH / 375, 60 * WIDTH / 375, 16 * WIDTH / 375)];
        _smallLabel.font = [UIFont systemFontOfSize:11 * WIDTH / 375];
        _smallLabel.textAlignment = NSTextAlignmentCenter;
        _smallLabel.layer.cornerRadius = 5;
        _smallLabel.layer.borderColor = [UIColor blackColor].CGColor;
        _smallLabel.layer.borderWidth = 0.8;
        _smallLabel.clipsToBounds =YES;
        [self.contentView addSubview:_smallLabel];
        [_smallLabel release];
        
        self.photoView1 = [[UIImageView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.titleLabel.bounds) + 10, (WIDTH - 40) / 3. , 76 * WIDTH / 375)];
        [self.contentView addSubview:_photoView1];
        [_photoView1 release];
        
        self.photoView2 = [[UIImageView alloc] initWithFrame:CGRectMake((WIDTH / 2.) - ((WIDTH - 40 ) / 6.),CGRectGetMaxY(self.titleLabel.bounds) + 10 , CGRectGetMaxX(self.photoView1.bounds), 76 * WIDTH / 375)];
        [self.contentView addSubview:_photoView2];
        [_photoView2 release];
        
        self.photoView3 = [[UIImageView alloc] initWithFrame:CGRectMake( WIDTH - 10 - CGRectGetMaxX(self.photoView1.bounds),CGRectGetMaxY(self.titleLabel.bounds) + 10, CGRectGetMaxX(self.photoView1.bounds), 76 * WIDTH / 375)];
        [self.contentView addSubview:_photoView3];
        [_photoView3 release];
        
        
    }
    return self;
    
}

@end
