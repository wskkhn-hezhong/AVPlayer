//
//  HeaderView.m
//  EdgeNews
//
//  Created by lanouhn on 15/12/1.
//  Copyright (c) 2015年 lanouhn. All rights reserved.
//

#import "HeaderView.h"
#import "AFNetworking.h"

@implementation HeaderView

- (void)dealloc
{
    [_label1 release];
    [_label2 release];
    [_label3 release];
    [_label4 release];
    [_nameArray release];
    [_imageArray release];
    [_button1 release];
    [_button2 release];
    [_button3 release];
    [_button4 release];
    [super dealloc];
}



- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self netWork];
        self.backgroundColor = [UIColor grayColor];
        [self addSubview:self.button1];
        [self addSubview:self.button2];
        [self addSubview:self.button3];
        [self addSubview:self.button4];
        [self addSubview:self.label4];
        [self addSubview:self.label3];
        [self addSubview:self.label2];
        [self addSubview:self.label1];

    }
    return self;
}

- (NSMutableArray *)imageArray {
    if (!_imageArray) {
        self.imageArray = [NSMutableArray arrayWithCapacity:0];
        
    }
    return _imageArray;
}

- (NSMutableArray *)nameArray {
    if (!_nameArray ) {
        self.nameArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _nameArray;
}


- (void)netWork {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:@"http://c.m.163.com/nc/video/home/0-10.html" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        for (NSDictionary *dic in responseObject[@"videoSidList"]) {
            NSString *str1 = dic[@"title"];
            [self.nameArray addObject:str1];
            NSString *str2 = dic[@"imgsrc"];
            [self.imageArray addObject:str2];
        }
        
        _label1.text = self.nameArray[0];
        _label2.text = self.nameArray[1];
        _label3.text = self.nameArray[2];
        _label4.text = self.nameArray[3];
        
        [_button1 setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.imageArray[0]]]] forState:UIControlStateNormal];
        
        [_button2 setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.imageArray[1]]]] forState:UIControlStateNormal];
        
        [_button3 setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.imageArray[2]]]] forState:UIControlStateNormal];
        
        [_button4 setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.imageArray[3]]]] forState:UIControlStateNormal];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}



- (UIButton *)button1 {
    if (!_button1) {
        self.button1 = [UIButton buttonWithType:UIButtonTypeCustom];
        _button1.frame = CGRectMake(20, 2, WIDTH / 4.- 40, WIDTH / 4. - 40);
        _button1.backgroundColor = [UIColor colorWithRed:0.9506 green:0.933 blue:0.9452 alpha:1.0];
        _button1.tag = 1001;
//        [_button1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        _button1.titleEdgeInsets = UIEdgeInsetsMake(60, -80, 0, 0);
//        _button1.imageEdgeInsets = UIEdgeInsetsMake(5, 20, 35, 20);
    }
    return _button1;
}
- (UIButton *)button2 {
    if (!_button2) {
        self.button2 = [UIButton buttonWithType:UIButtonTypeCustom];
        _button2.frame = CGRectMake(WIDTH / 4. + 20, 2, WIDTH / 4. - 40, WIDTH / 4. - 40);
        [_button2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _button2.tag = 1002;
        
//        _button2.backgroundColor = [UIColor colorWithRed:0.9506 green:0.933 blue:0.9452 alpha:1.0];
////        _button2.titleEdgeInsets = UIEdgeInsetsMake(60, -80, 0, 0);
//        _button2.imageEdgeInsets = UIEdgeInsetsMake(5, 20, 35, 20);
    }
    return _button2;
}
- (UIButton *)button3 {
    if (!_button3) {
        self.button3 = [UIButton buttonWithType:UIButtonTypeCustom];
        _button3.frame = CGRectMake(WIDTH / 4. * 2  + 20, 2, WIDTH / 4. - 40, WIDTH / 4.- 40);
        [_button3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _button3.tag = 1003;
//        _button3.backgroundColor = [UIColor colorWithRed:0.9506 green:0.933 blue:0.9452 alpha:1.0];
//        _button3.titleEdgeInsets = UIEdgeInsetsMake(60, -80, 0, 0);
//        _button3.imageEdgeInsets = UIEdgeInsetsMake(5, 20, 35, 20);
    }
    return _button3;
}
- (UIButton *)button4 {
    if (!_button4) {
        self.button4 = [UIButton buttonWithType:UIButtonTypeCustom];
        _button4.frame = CGRectMake(WIDTH / 4. * 3 + 20, 2, WIDTH / 4. - 40, WIDTH / 4. - 40);
        [_button4 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _button4.tag = 1004;
//        _button4.backgroundColor = [UIColor colorWithRed:0.9506 green:0.933 blue:0.9452 alpha:1.0];
//        [_button4 setTitle:@"精品 " forState:UIControlStateNormal];
//        [_button4 setImage:[UIImage imageNamed:@"jingpin"] forState:UIControlStateNormal];
//        _button4.titleEdgeInsets = UIEdgeInsetsMake(60, -80, 0, 0);
//        _button4.imageEdgeInsets = UIEdgeInsetsMake(5, 20, 35, 20);
    }
    return _button4;
}

- (UILabel *)label1{
    if (!_label1) {
        self.label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, WIDTH / 4 - 40, WIDTH / 4, 40)];
        _label1.textAlignment = NSTextAlignmentCenter;
        _label1.font = [UIFont systemFontOfSize:17];
        [_label1 release];
    }
    return _label1;
}
- (UILabel *)label2{
    if (!_label2) {
        self.label2 = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH / 4., WIDTH / 4 - 40, WIDTH / 4 - 1, 40)];
        _label2.textAlignment = NSTextAlignmentCenter;
        _label2.font = [UIFont systemFontOfSize:17];

        [_label2 release];

    }
    return _label2;
}

- (UILabel *)label3{
    if (!_label3) {
        self.label3 = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH / 4. * 2, WIDTH / 4 - 40, WIDTH / 4 - 1, 40)];
        _label3.textAlignment = NSTextAlignmentCenter;
        _label3.font = [UIFont systemFontOfSize:17];

        [_label3 release];

    }
    return _label3;
}

- (UILabel *)label4{
    if (!_label4) {
        self.label4 = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH / 4. * 3, WIDTH / 4 - 40, WIDTH / 4 -1, 40)];
        _label4.textAlignment = NSTextAlignmentCenter;
        _label4.font = [UIFont systemFontOfSize:17];

        [_label4 release];

    }
    return _label4;
}


@end
