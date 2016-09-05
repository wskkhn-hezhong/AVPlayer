//
//  ScrollTableViewCell.h
//  EdgeNews
//

#import <UIKit/UIKit.h>
#import "SDCycleScrollView.h"



@class ScrollViewController;
@interface ScrollTableViewCell : UITableViewCell

@property (nonatomic, retain) SDCycleScrollView *cycleScrollView;

@property (nonatomic, retain) NSMutableArray *imageArray;

@property (nonatomic, retain) NSMutableArray *titleArray;

@property (nonatomic, retain) NSMutableArray *urlArray;

@property (nonatomic, assign) ScrollViewController *vc;


@end
