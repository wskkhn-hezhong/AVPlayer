//
//  FirstViewController.m
//  EdgeNews
//
//  Created by lanouhn on 15/12/5.
//  Copyright © 2015年 lanouhn. All rights reserved.
//

#import "FirstViewController.h"
#import "TabViewController.h"

@interface FirstViewController ()<UIScrollViewDelegate>

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadWelcomeView];
}

- (void)loadWelcomeView {
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.contentSize = CGSizeMake(WIDTH * 3, HEIGHT);
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    scrollView.delegate = self;
    [self.view addSubview:scrollView];
    [scrollView release];
    
    for (int i = 0; i < 3; i++) {
        UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH * i, 0, WIDTH, HEIGHT)];
        imageview.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d", i + 1]];
        [scrollView addSubview:imageview];
        [imageview release];
        if (i == 2) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH / 2 - 75 , HEIGHT - 150, 150, 40 * WIDTH / 375)];
            label.text = @"点击体验";
            label.textColor = [UIColor whiteColor];
            label.textAlignment = NSTextAlignmentCenter;
            label.adjustsFontSizeToFitWidth = YES;
                       label.font = [UIFont fontWithName:@"Zapfino" size:28 * WIDTH / 375];
            [imageview addSubview:label];
            [label release];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
            imageview.userInteractionEnabled = YES;
            [imageview addGestureRecognizer:tap];
            [tap release];
        }
    }
    UIPageControl *pageControl =[[UIPageControl alloc] initWithFrame:CGRectMake(WIDTH - 50, HEIGHT - 50, 30, 20)];
    pageControl.numberOfPages = 3;
    pageControl.tag = 500;
    pageControl.currentPageIndicatorTintColor = [UIColor orangeColor];
    pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    [self.view addSubview:pageControl];
    [pageControl release];
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    UIPageControl *page = (UIPageControl *)[self.view viewWithTag:500];
    page.currentPage = scrollView.contentOffset.x / WIDTH;
    
}

- (void)handleTap:(UITapGestureRecognizer *)tap {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    TabViewController *tabVC = [storyboard instantiateViewControllerWithIdentifier:@"TabViewController"];
    [self presentViewController:tabVC animated:YES completion:nil];
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
