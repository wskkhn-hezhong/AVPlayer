//
//  UIImageView+Cache.h
//  ImgaeCache
//
//  Created by 刘俊臣 on 15/10/5.
//  Copyright © 2015年 刘俊臣. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (Cache)
- (void)lo_setImageWithURL:(NSString *)imageURL placeHolder:(NSString *)contentImageName;
@end
