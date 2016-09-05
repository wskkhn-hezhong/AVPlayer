//
//  MostTableViewCell.m
//  EdgeNews
//
//  Created by lanouhn on 15/11/25.
//  Copyright (c) 2015年 lanouhn. All rights reserved.
//

#import "MostTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "Model.h"


@implementation MostTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_model release];
    [_bigImage release];
    [_titleLabel release];
    [_detailLabel release];
    [_smallLabel release];
    [super dealloc];
}

- (void)setModel:(Model *)model {
    if (_model != model) {
        _model = model;
    }
    
    self.titleLabel.text = model.title;
    self.detailLabel.text = model.digest;
    if (model.replyCount == nil) {
        self.smallLabel.text = @"0跟帖";
    }else {
        self.smallLabel.text = [NSString stringWithFormat:@"%@跟帖", model.replyCount];
    }
    [self.bigImage  sd_setImageWithURL:[NSURL URLWithString:model.imgsrc] placeholderImage:[UIImage imageNamed:@"aaa"]];
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.bigImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 100* WIDTH / 375, 75. / 667 * HEIGHT)];
        [self.contentView addSubview:_bigImage];
        [_bigImage release];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(120* WIDTH / 375, 6, WIDTH - 130, 26 * WIDTH / 375)];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:17 * WIDTH / 375];
        [self.contentView addSubview:_titleLabel];
        [_titleLabel release];
        
        self.detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(120 * WIDTH / 375, 30 * WIDTH / 375, 245 * WIDTH / 375, 36 * WIDTH / 375)];
        self.detailLabel.font = [UIFont systemFontOfSize:14 * WIDTH / 375];
        self.detailLabel.numberOfLines = 2;
        [self.contentView addSubview:_detailLabel];
        [_detailLabel release];
        
        self.smallLabel = [[UILabel alloc] initWithFrame:CGRectMake(300 * WIDTH / 375, 70 * WIDTH / 375, 60 * WIDTH / 375, 16 * WIDTH / 375)];
        self.smallLabel.textAlignment = NSTextAlignmentCenter;
        self.smallLabel.layer.cornerRadius = 5;
        self.smallLabel.layer.borderColor = [UIColor blackColor].CGColor;
        self.smallLabel.layer.borderWidth = 0.8;
        self.smallLabel.clipsToBounds =YES;
        self.smallLabel.font = [UIFont systemFontOfSize:11 * WIDTH / 375];
        [self.contentView addSubview:_smallLabel];
        [_smallLabel release];
        
    }
    
    
    return self;
}

@end
