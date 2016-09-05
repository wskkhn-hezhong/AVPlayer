//
//  photoSet.h
//  EdgeNews
//

#import <Foundation/Foundation.h>

@class ScrollPhoto;

@interface photoSet : NSObject

@property (nonatomic, retain) NSString *setname;
@property (nonatomic, retain) NSString *imgsum;

@property (nonatomic, retain) ScrollPhoto *photos;

@end
