//
//  HeadOneViewCell.m
//  EdgeNews
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
