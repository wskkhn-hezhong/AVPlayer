//
//  ScrollTableViewCell.m
//  EdgeNews
//
//  Created by lanouhn on 15/11/25.
//  Copyright (c) 2015年 lanouhn. All rights reserved.
//

#import "ScrollTableViewCell.h"
#import "EdgeNews.h"
#import "UIView+Frame.h"
#import "ScrollViewController.h"
#import "Model.h"


@interface ScrollTableViewCell ()<SDCycleScrollViewDelegate>
@end

@implementation ScrollTableViewCell

- (void)dealloc
{
    [_urlArray release];
    [_imageArray release];
    [_titleArray release];
    [_cycleScrollView release];
    [super dealloc];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (NSMutableArray *)urlArray {
    if (!_urlArray) {
        self.urlArray = [NSMutableArray arrayWithCapacity:0];
        
    }
    return _urlArray;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.cycleScrollView];
    }
    return self;
}

- (SDCycleScrollView *)cycleScrollView {
    
    if (!_cycleScrollView) {
        self.cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0,WIDTH , 190  * WIDTH / 375) imageURLStringsGroup:nil];
        _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
       _cycleScrollView.dotColor = [UIColor whiteColor];
        _cycleScrollView.delegate = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _cycleScrollView.imageURLStringsGroup = self.imageArray;
            _cycleScrollView.titlesGroup = self.titleArray;
        });
        
    }
    return _cycleScrollView;
}


#pragma mark - SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    ScrollViewController *html = [[ScrollViewController alloc] init];
    UINavigationController *naVC = [[UINavigationController alloc] initWithRootViewController:html];
    html.string = self.urlArray[index];
    [self.vc presentViewController:naVC animated:YES completion:nil];
    [html release];
    [naVC release];
}


@end





