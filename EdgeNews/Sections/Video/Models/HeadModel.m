//
//  Header.m
//  EdgeNews
//


#import "HeadModel.h"

@implementation HeadModel

- (void)dealloc
{
    [_sid release];
    [_title release];
    [_imgsrc release];
    [super dealloc];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

@end
