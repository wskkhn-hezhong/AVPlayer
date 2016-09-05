//
//  EdgeCollectionViewCell.h
//  EdgeNews
//
//  Created by lanouhn on 15/11/23.
//  Copyright (c) 2015年 lanouhn. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EdgeNewsViewController;

@interface EdgeCollectionViewCell : UICollectionViewCell

@property (nonatomic, retain) NSString *ename;

@property (nonatomic, retain) NSString  *tid;

@property (nonatomic, assign) EdgeNewsViewController *anyViewController;



@end