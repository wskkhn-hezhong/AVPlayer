//
//  photoSet.m
//  EdgeNews
//

#import "photoSet.h"
#import "ScrollPhoto.h"

@implementation photoSet

- (void)dealloc
{
    [_imgsum release];
    [_photos release];
    [_setname release];
    [super dealloc];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

@end
