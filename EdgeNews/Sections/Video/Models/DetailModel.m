//
//  DetailModel.m
//  EdgeNews
//

#import "DetailModel.h"

@implementation DetailModel

- (void)dealloc
{
    [_cover release];
    [_title release];
    [_length release];
    [_mp4_url release];
    [super dealloc];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

@end
