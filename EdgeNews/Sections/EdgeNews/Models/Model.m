//
//  Model.m
//  EdgeNews
//

#import "Model.h"

@implementation Model

- (void)dealloc
{
    [_url release];
    [_TAGS release];
    [_docid release];
    [_title release];
    [_digest release];
    [_imgsrc release];
    [_source release];
    [_boardid release];
    [_imageArray release];
    [_replyCount release];
    [_photosetID release];
    [super dealloc];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"imgextra"] ) {
        self.imageArray = [NSMutableArray arrayWithCapacity:0];
        self.imageArray = [NSMutableArray arrayWithArray:value];
    }
}

@end
