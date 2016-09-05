//
//  MyViewController.m
//  EdgeNews
//
//  Created by lanouhn on 15/12/5.
//  Copyright © 2015年 lanouhn. All rights reserved.
//

#import "MyViewController.h"

@interface MyViewController ()
@property (nonatomic, retain)UILabel *label;
@property (nonatomic,  retain) UIImageView *imageView;
@end


@implementation MyViewController
- (void)dealloc
{
    [_label release];
    [_imageView release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.translucent = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.tintColor = [UIColor redColor];
    [self.view addSubview:self.imageView];
    [self.view addSubview:self.label];
}


- (UIImageView *)imageView {
    if (!_imageView) {
        self.imageView = [[UIImageView alloc ] initWithImage:[UIImage imageNamed:@"beijing1"]];
        _imageView.frame = CGRectMake(WIDTH * 0.5 - 50,HEIGHT * 0.5 - 150, 100, 100);
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.layer.cornerRadius = 21;
        _imageView.layer.masksToBounds = YES;

        [_imageView release];
    }
    return  _imageView;
}

- (UILabel *)label {
    if (!_label) {
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(30,HEIGHT * 0.5, WIDTH - 60, 100)];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.font = [UIFont systemFontOfSize:14];
        _label.textColor = [UIColor blackColor];
        _label.alpha = 0.7;
        _label.numberOfLines = 0;
        _label.text = @"本软件由wskkhn123开发,本程序为非盈利应用,发布资源均来源于互联网,版权归原作者所有,如有侵权或建议，请及时与我们联系。";

        [_label release];
    }
    return _label;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
