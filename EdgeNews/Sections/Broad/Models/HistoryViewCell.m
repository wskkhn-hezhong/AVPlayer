//
//  HistoryViewCell.m
//  EdgeNews
//
//  Created by lanouhn on 15/12/6.
//  Copyright © 2015年 lanouhn. All rights reserved.
//

#import "HistoryViewCell.h"

@interface HistoryViewCell ()

@end

@implementation HistoryViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_photoImage release];
    [_titleLabel release];
    [_detailLabel release];
    [_timeLabel release];
    [_alllabel release];
    [_button release];
    [super dealloc];
}







@end
