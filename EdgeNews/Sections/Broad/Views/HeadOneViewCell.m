//
//  HeadOneViewCell.m
//  EdgeNews
//
//  Created by lanouhn on 15/12/3.
//  Copyright © 2015年 lanouhn. All rights reserved.
//

#import "HeadOneViewCell.h"

@implementation HeadOneViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)dealloc {
    [_titleLabel release];
    [_joinButton release];
    [super dealloc];
}
@end
