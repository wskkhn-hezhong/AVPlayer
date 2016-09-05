//
//  ScrollPhoto.m
//  EdgeNews
//

#import "ScrollPhoto.h"

@implementation ScrollPhoto

- (void)dealloc
{
    [_note release];
    [_imgurl release];
    [super dealloc];
    
}


- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

@end
