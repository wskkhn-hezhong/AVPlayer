//
//  TitleModel.m
//  EdgeNews
//

#import "TitleModel.h"

@implementation TitleModel

- (void)dealloc
{
    [_cid release];
    [_cname release];
    [_modelArray release];
    [super dealloc];
    
}




- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"tList"]) {
        self.modelArray = [NSMutableArray arrayWithCapacity:0];
        self.modelArray = value;
    }
}
@end
