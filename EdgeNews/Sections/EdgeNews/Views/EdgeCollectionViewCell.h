//
//  EdgeCollectionViewCell.h
//  EdgeNews
//

#import <UIKit/UIKit.h>

@class EdgeNewsViewController;

@interface EdgeCollectionViewCell : UICollectionViewCell

@property (nonatomic, retain) NSString *ename;

@property (nonatomic, retain) NSString  *tid;

@property (nonatomic, assign) EdgeNewsViewController *anyViewController;



@end