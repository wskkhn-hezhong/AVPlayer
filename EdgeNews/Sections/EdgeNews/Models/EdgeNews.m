//
//  EdgeNews.m
//  EdgeNews
//

#import "EdgeNews.h"

@implementation EdgeNews

- (void)dealloc
{
    [_url release];
    [_title release];
    [_imgsrc release];
    [super dealloc];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"title"]) {
        self.title = value;
    }
}



@end
