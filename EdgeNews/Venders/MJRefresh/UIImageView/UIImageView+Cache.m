//
//  UIImageView+Cache.m
//  ImgaeCache
//
//  Created by 刘俊臣 on 15/10/5.
//  Copyright © 2015年 刘俊臣. All rights reserved.
//

#import "UIImageView+Cache.h"

@implementation UIImageView (Cache)
- (void)lo_setImageWithURL:(NSString *)imageURL placeHolder:(NSString *)contentImageName{
    self.image = [UIImage imageNamed:contentImageName];
    NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"LJCIMAGECACHES"];
    
    NSFileManager *manager = [NSFileManager defaultManager];
    
    if ([manager fileExistsAtPath:filePath]) {
        
    }
    else{
        
        [manager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *imageSandBoxName = [[imageURL componentsSeparatedByString:@"/"] lastObject];
    NSString *imagePath = [filePath stringByAppendingPathComponent:imageSandBoxName];
    if ([manager fileExistsAtPath:imagePath]) {
        self.image = [UIImage imageWithContentsOfFile:imagePath];
    }
    else{
        [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:imageURL]] queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse * response, NSData * data, NSError * connectionError) {
            if (data) {
                [data writeToFile:imagePath atomically:YES];
            }
            else{
                
            }            
            self.image = [UIImage imageWithContentsOfFile:imagePath];
        }];
    }
    
}
@end
