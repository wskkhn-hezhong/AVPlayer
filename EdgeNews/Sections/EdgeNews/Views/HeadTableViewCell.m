//
//  HeadTableViewCell.m
//  EdgeNews
//

#import "HeadTableViewCell.h"
#import "EdgeNews.h"
#import "UIImageView+WebCache.h"
#import "UIView+Frame.h"

@implementation HeadTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc
{
    [_deLabel release];
    [_edgeNews release];
    [_allImage release];
    [super dealloc];
}

- (void)setEdgeNews:(EdgeNews *)edgeNews {
    if (_edgeNews != edgeNews) {
        _edgeNews = edgeNews;
    }
    
    self.deLabel.text = edgeNews.title;
    [self.allImage sd_setImageWithURL:[NSURL URLWithString:edgeNews.imgsrc] placeholderImage:[UIImage imageNamed:@"aaa"]];


}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.allImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,WIDTH, 190  * WIDTH / 375)];
        [self.contentView addSubview:_allImage];
        [_allImage release];
        
        self.deLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 190  * WIDTH / 375 - 26 * WIDTH / 375, WIDTH, 26)];
       
        self.deLabel.textColor = [UIColor whiteColor];
        self.deLabel.font = [UIFont boldSystemFontOfSize:17 * WIDTH / 375];
       
        [self.contentView addSubview:_deLabel];
        [_deLabel release];
    }
    return self;
}

@end
