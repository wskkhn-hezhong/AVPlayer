//
//  HtmlViewController.m
//  EdgeNews
//
//  Created by lanouhn on 15/11/26.
//  Copyright (c) 2015年 lanouhn. All rights reserved.
//

#import "HtmlViewController.h"
#import "AFNetworking.h"
#import "ScrollPhoto.h"
#import "photoSet.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD.h"
#import "Model.h"
#import "EdgeNews.h"

@interface HtmlViewController ()<UIScrollViewDelegate>

@property (nonatomic, retain) NSMutableArray *dataSource;
@property (nonatomic, retain) NSMutableArray *array;
@property (nonatomic, retain) UIWebView *webView;
@property (nonatomic, assign) NSInteger number;
@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) UITextView *textView;
@property (nonatomic, retain) UILabel *count;
@property (nonatomic, retain) UIImageView *sumImageview;
@property (nonatomic, retain) UILabel *label;


@end

@implementation HtmlViewController

- (void)dealloc
{
    
    [_label release];
    [_array release];
    [_count release];
    [_webView release];
    [_scrollView release];
    [_sumImageview release];
    [_textView release];
    [_dataSource release];
    [_model release];
    [super dealloc];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.1608 green:0.5647 blue:0.9098 alpha:1.0];

    self.title = self.model.title;
    //返回按钮
    self.number = 1;
    if (self.model.photosetID) {
        [self photoViewShow];
    }else if (self.number == 1) {
        self.number = 1;
        self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT - 64)];
        [self panTheMostTableView];
        [self.view addSubview:_webView];
        [_webView release];
    }
    
    [self creatButton];
    
    
}

//大多数进入详情页的方法

- (void)panTheMostTableView {
    Model *model = self.model;
    //    NSLog(@"%@", model.docid);
    if (self.number == 1) {
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", nil];
        [manager GET:[NSString stringWithFormat:@"http://c.m.163.com/nc/article/%@/full.html", model.docid] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSArray *arr = responseObject[model.docid][@"img"];
            NSMutableArray *data = [NSMutableArray arrayWithCapacity:0];
            NSMutableArray *dataArr = [NSMutableArray arrayWithCapacity:0];
            NSMutableArray *tempArr = [NSMutableArray arrayWithCapacity:0];
            for (NSDictionary *dic  in arr) {
                //添加图片的url地址
                [data addObject:dic[@"src"]];
                for (NSString *str in dic) {
                    if ([str isEqualToString:@"picxel"]) {
                        [dataArr addObject:dic[@"picxel"]];
                        [tempArr addObject:dic[@"picxel"]];
                    }
                }
                if (tempArr.count == 0) {
                    [dataArr addObject:@"550*348"];
                }else {
                    [tempArr removeAllObjects];
                }
            }
            NSString *str = responseObject[model.docid][@"body"];
            NSMutableArray *arr1 = [NSMutableArray arrayWithCapacity:0];
            NSMutableArray *arr2 = [NSMutableArray arrayWithCapacity:0];
            for (NSInteger i = 0; i < dataArr.count; i ++) {
                NSString *str1 = dataArr[i];
                NSString *str2 = [str1 substringWithRange:NSMakeRange(0, 3)];
                NSString *str3 = [str1 substringFromIndex:4];
                [arr1 addObject:str2];
                [arr2 addObject:str3];
                
            }
            for (int i = 0; i < dataArr.count;i++) {
                str = [str stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"<!--IMG#%d-->", i] withString:[NSString stringWithFormat:@"<img src =\"%@\" width = %.2f; height = %.2f>", data[i], WIDTH - 15  , [arr2[i] floatValue] / [arr1[i] floatValue] * (WIDTH - 15)]];
            }
            //        NSLog(@"%@", str);
            [self.webView loadHTMLString:str baseURL:nil];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
    }
}

- (void)photoViewShow {
    Model *model = self.model;
    NSString *str1 = model.photosetID;
    NSArray *ary = [str1 componentsSeparatedByString:@"|"];
    NSString *str2 = [str1 substringWithRange:NSMakeRange(4, 4)];
    NSString *str3 = [ary lastObject];
    self.dataSource = [NSMutableArray arrayWithCapacity:0];
    self.array = [NSMutableArray arrayWithCapacity:0];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //数据解析
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[NSString stringWithFormat:@"http://c.m.163.com/photo/api/set/%@/%@.json", str2,str3] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSArray *array1 = responseObject[@"photos"];
        
        for (NSDictionary *dic in array1) {
            ScrollPhoto *photo = [[ScrollPhoto alloc] init];
            [photo setValuesForKeysWithDictionary:dic];
            [self.dataSource addObject:photo];
        }
        photoSet *set = [[photoSet alloc] init];
        [set setValuesForKeysWithDictionary:responseObject];
        [self.array addObject:set];
        //将图片延时展示
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self showScrollView];
        });
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}


//三张图片的cell 的展示

- (void)showScrollView {
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT -  220)];
    self.scrollView.contentSize = CGSizeMake(self.dataSource.count * WIDTH, 0);
    self.scrollView.delegate = self;
    
    //整页滚动
    self.scrollView.pagingEnabled = YES;
    [self.view addSubview:_scrollView];
    [_scrollView release];
    
    
    for (int i = 0; i < self.dataSource.count; i++) {
        self.sumImageview = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH * i, 0, WIDTH, self.scrollView.frame.size.height )];
        _sumImageview.contentMode = UIViewContentModeScaleAspectFit;
        _sumImageview.userInteractionEnabled = YES;
        _sumImageview.tag = 100 + i;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click:)];
        [self.sumImageview addGestureRecognizer:tap];
        NSURL *url = [NSURL URLWithString:[self.dataSource[i] imgurl]];
        [self.sumImageview sd_setImageWithURL:url];
        [self.scrollView addSubview:_sumImageview];
        [_sumImageview release];
    }
    
    //简单的介绍
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(10, HEIGHT - 160, WIDTH - 80, 30)];
    _label.text = [self.array[0] setname];
    _label.textColor = [UIColor whiteColor];
    //图片数字
    self.count = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_label.frame), HEIGHT - 160, 70, 30)];
    _count.textColor = [UIColor whiteColor];
    _count.text = [NSString stringWithFormat:@"1/%@", [self.array[0] imgsum]];
    [self.view addSubview:_count];
    [self.view addSubview:_label];
    [_label release];
    [_count release];
    
    //简介
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(10, HEIGHT - 130, WIDTH - 20, 200 - _label.frame.size.height - 60)];
    //文字
    _textView.backgroundColor = [UIColor blackColor];
    self.textView.text = [self.dataSource[0] note];
    //可以滑动
    self.textView.scrollEnabled = YES;
    //不乐意编辑
    self.textView.editable = NO;
    //文字颜色
    self.textView.textColor = [UIColor grayColor];
    //文字大小
    self.textView.font = [UIFont systemFontOfSize:15];
    //添加视图
    [self.view addSubview:_textView];
    //释放
    [_textView release];
    
    
}

//图片轻怕手势, 添加动画使其文字隐藏
- (void)click:(UITapGestureRecognizer *)tap {
    [UIView animateWithDuration:1 animations:^{
        if (self.navigationController.navigationBar.alpha == 1.0 && self.label.alpha == 1.0 && self.textView.alpha == 1.0 && self.count.alpha == 1.0) {
            self.navigationController.navigationBar.alpha = 0.0;
            self.textView.alpha = 0.0;
            self.label.alpha = 0.0;
            self.count.alpha = 0.0;
        }else {
            self.navigationController.navigationBar.alpha = 1.0;
            self.textView.alpha = 1.0;
            self.label.alpha = 1.0;
            self.count.alpha = 1.0;
            
        }
    }];
    
    
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger index = scrollView.contentOffset.x / WIDTH;
    self.textView.text = [self.dataSource[index] note];
    self.count.text = [NSString stringWithFormat:@"%ld/%@", index + 1, [self.array[0] imgsum]];
    
}

//返回主界面
- (void)creatButton {
    UIBarButtonItem *left =[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ba"] style:UIBarButtonItemStylePlain target:self action:@selector(backToEdgeNewsViewController)];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0];
    
    self.navigationItem.leftBarButtonItem = left;
    
}
- (void)backToEdgeNewsViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
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
