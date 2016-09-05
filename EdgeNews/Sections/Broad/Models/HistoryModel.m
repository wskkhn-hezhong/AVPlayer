//
//  HistoryModel.m
//  EdgeNews
//

#import "HistoryModel.h"

@implementation HistoryModel

- (void)dealloc
{
    [_cover release];
    [_url_mp4 release];
    [_docid release];
    [_title release];
    [_tname release];
    [_imgsrc release];
    [_source release];
    [super dealloc];
}

@end
