//
//  DetailCell.m
//  EdgeNews
//

#import "DetailCell.h"
#import "PlayModel.h"

@implementation DetailCell

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
    [_ptimeLabel release];
    [_sizeLabel release];
    [super dealloc];
}

- (void)setModel:(PlayModel *)model {
    self.titleLabel.text = model.title;
    self.sizeLabel.text = model.size;
    
    NSString *str12 = [model.ptime substringWithRange:NSMakeRange(0, 10)];
    self.ptimeLabel.text = str12;
}


@end
