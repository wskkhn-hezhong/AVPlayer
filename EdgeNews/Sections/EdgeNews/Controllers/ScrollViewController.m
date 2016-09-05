//
//  ScrollViewController.m
//  EdgeNews
//
#import "ScrollViewController.h"
#import "AFNetworking.h"
#import "photoSet.h"
#import "ScrollPhoto.h"
#import "UIImageView+WebCache.h"


@interface ScrollViewController ()<UIScrollViewDelegate>

@property (nonatomic, retain) NSMutableArray *dataSource;
@property (nonatomic, retain) NSMutableArray *array;
@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) UIImageView *sumImageview;
@property (nonatomic, retain) UILabel *label;
@property (nonatomic, retain) UILabel *count;
@property (nonatomic, retain) UITextView *textView;

@end

@implementation ScrollViewController


- (void)dealloc
{
    [_count release];
    [_label release];
    [_textView release];
    [_array release];
    [_dataSource release];
    [_scrollView release];
    [_sumImageview release];
    [_string release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.1608 green:0.5647 blue:0.9098 alpha:1.0];

    [self getPhotoView];
    [self backUp];
    
}


- (void)getPhotoView {
    NSArray *array = [self.string componentsSeparatedByString:@"|"];
    NSString *str1 = [array lastObject];
    NSString *str2 = [self.string substringWithRange:NSMakeRange(4, 4)];
    self.dataSource = [NSMutableArray arrayWithCapacity:0];
    self.array = [NSMutableArray arrayWithCapacity:0];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[NSString stringWithFormat:@"http://c.m.163.com/photo/api/set/%@/%@.json", str2, str1] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *array1 = responseObject[@"photos"];
        
        for (NSDictionary *dic in array1) {
            ScrollPhoto *photo = [[ScrollPhoto alloc] init];
            [photo setValuesForKeysWithDictionary:dic];
            [self.dataSource addObject:photo];
            [photo release];
        }
        photoSet *set = [[photoSet alloc] init];
        [set setValuesForKeysWithDictionary:responseObject];
        [self.array addObject:set];
        [set release];
        //将图片延时展示
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self showScrollView];
        });

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    
    
    
}

- (void)showScrollView {
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT -  220)];
    self.scrollView.contentSize = CGSizeMake(self.dataSource.count * WIDTH, 0);
    self.scrollView.delegate = self;
    
    //整页滚动
    self.scrollView.pagingEnabled = YES;
    [self.view addSubview:_scrollView];
    [_scrollView release];
//    NSLog(@"%ld", self.dataSource.count);
//    NSLog(@"%@", [self.array[0] imgsum]);
    
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
    self.navigationItem.title = self.label.text;

    _label.textColor = [UIColor whiteColor];
    //图片数字
    self.count = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_label.frame), HEIGHT - 160, 70, 30)];
    _count.text = [NSString stringWithFormat:@"1/%@", [self.array[0] imgsum]];
    _count.textColor = [UIColor whiteColor];
    [self.view addSubview:_count];
    [self.view addSubview:_label];
    [_label release];
    [_count release];
    
    //简介
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(10, HEIGHT - 130, WIDTH - 20, 200 - _label.frame.size.height - 60)];
    //文字
    _textView.text = [self.dataSource[0] note];
    //可以滑动
    _textView.scrollEnabled = YES;
    //不允许编辑
    _textView.editable = NO;
    //文字颜色
    _textView.backgroundColor = [UIColor blackColor];
    _textView.textColor = [UIColor whiteColor];
    //文字大小
   _textView.font = [UIFont systemFontOfSize:15];
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
    NSInteger index = (scrollView.contentOffset.x / WIDTH);
    self.textView.text = [self.dataSource[index] note];


    self.count.text = [NSString stringWithFormat:@"%ld/%@", (long)index + 1 , [self.array[0] imgsum]];
    
}



- (void)backUp {
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ba"] style:UIBarButtonItemStyleDone target:self action:@selector(clickMe)];
    self.navigationController.navigationBar.tintColor = [UIColor redColor];
    
    self.navigationItem.leftBarButtonItem = left;
    [left release];
}

- (void)clickMe {
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
