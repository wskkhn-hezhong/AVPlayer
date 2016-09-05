//
//  UIView+Frame.m
//  Player
//
//  Created by 刘俊臣 on 15/11/23.
//  Copyright © 2015年 河南蓝鸥科技. All rights reserved.
//

#import "UIView+Frame.h"

@implementation UIView (Frame)
- (float)x{
    return self.frame.origin.x;
}
- (float)y{
    return self.frame.origin.y;
}
- (float)width{
    return self.frame.size.width;
}
- (float)height{
    return self.frame.size.height;
}
- (void)setX:(float)x{
    CGRect rect = self.frame;
    rect.origin.x = x;
    self.frame = rect;
}
- (void)setY:(float)y{
    CGRect rect = self.frame;
    rect.origin.y = y;
    self.frame = rect;
}
- (void)setWidth:(float)width{
    CGRect rect = self.frame;
    rect.size.width = width;
    self.frame = rect;
}
- (void)setHeight:(float)height{
    CGRect rect = self.frame;
    rect.size.height = height;
    self.frame = rect;
}
@end
