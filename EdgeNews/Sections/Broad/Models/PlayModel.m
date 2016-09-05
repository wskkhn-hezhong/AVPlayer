//
//  PlayModel.m
//  EdgeNews
//
#import "PlayModel.h"

@implementation PlayModel

- (void)dealloc
{
    [_source release];
    [_imgsrc release];
    [_tname release];
    [_title release];
    [_docid release];
    [_tid release];
    [_size release];
    [_ptime release];
    [super dealloc];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

- (instancetype)initWithDocid:(NSString *)docid title:(NSString *)title imgsrc:(NSString *)imgsrc source:(NSString *)source

{
    self = [super init];
    if (self) {
        self.docid = docid;
        self.title = title;
        self.imgsrc = imgsrc;
        self.source = source;
    }
    return self;
}

@end
