//
//  EdgeNewsViewController.m
//  EdgeNews
//

#import "EdgeNewsViewController.h"
#import "AFNetworking.h"
#import "EdgeCollectionViewCell.h"
#import "LeftViewController.h"


static NSString *identifier = @"cell";

@interface EdgeNewsViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, retain) NSMutableArray *dataArray;
@property (nonatomic, retain) NSMutableArray *needArray;
@property (nonatomic, retain) NSMutableArray *dataSource;
@property (nonatomic, retain) UICollectionView *collectionView;
@property (nonatomic, retain) UIScrollView *scrollView;

@end

@implementation EdgeNewsViewController

- (void)dealloc
{
    [_scrollView release];
    [_collectionView release];
    [_dataSource release];
    [_dataArray release];
    [_needArray release];
    [super dealloc];}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    self.needArray = [NSMutableArray arrayWithCapacity:0];
    self.dataSource = [NSMutableArray arrayWithCapacity:0];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.1608 green:0.5647 blue:0.9098 alpha:1.0];
    self.tabBarController.tabBar.tintColor = [UIColor colorWithRed:0.0 green:0.2 blue:0.8 alpha:1.0];
    [self netWork];
    
    [self loadCollectionView];

    [self showLeftButton];
   }

- (void)getScrollView {
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, WIDTH , 40)];
    //   self.scrollView.backgroundColor = [UIColor cyanColor];
    self.scrollView.contentSize = CGSizeMake(WIDTH / 5 * self.needArray.count, 40);
    self.scrollView.showsHorizontalScrollIndicator = NO;
    //    scrollView.layer.borderWidth = 1;
    //    scrollView.layer.borderColor = [UIColor blackColor].CGColor;
    
    [self.view addSubview:_scrollView];
    [_scrollView release];
    for (NSInteger i = 0; i < self.needArray.count; i++) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(WIDTH / 5 * i + 5 , 5, WIDTH / 6, 30);
        button.tag = 100 + i;
        button.tintColor = [UIColor blackColor];
        
        NSString *str = self.needArray[i];
        [button setTitle:str forState:UIControlStateNormal];
        [button addTarget:self action:@selector(heightButton:) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:button];
    }
    
    [UIView animateWithDuration:0.1 animations:^{
        UIButton *button = (UIButton *)[self.view viewWithTag:100];
        
        button.tintColor = [UIColor colorWithRed:0.0 green:0.2 blue:0.8 alpha:1.0];
        button.transform = CGAffineTransformScale(button.transform, 1.3, 1.3);
    } completion:^(BOOL finished) {
        
    }];
    
    
}

- (void)heightButton:(UIButton *)button {
    
    NSInteger number = button.tag - 100;
    [self.collectionView setContentOffset:CGPointMake(WIDTH * number, 0) animated:NO];
    
    for (NSInteger i = 0; i < self.needArray.count; i++) {
        UIButton *ontherButton = (UIButton *)[self.view viewWithTag:100 + i];
        ontherButton.tintColor = [UIColor blackColor];
        UIButton *buttonMe = [UIButton buttonWithType:UIButtonTypeSystem];
        buttonMe.frame =  CGRectMake(0, 0, WIDTH / 6, 30);
        ontherButton.transform = buttonMe.transform;
        
        
    }
    [UIView animateWithDuration:0.1 animations:^{
        button.tintColor = [UIColor colorWithRed:0.0 green:0.2 blue:0.8 alpha:1.0];
        
        button.transform = CGAffineTransformScale(button.transform, 1.3, 1.3);
        
    } completion:^(BOOL finished) {
        
    }];
    
}

- (void)netWork {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //异步get, 自动解析json数据
    NSString *string = [NSString stringWithFormat:@"http://c.3g.163.com/nc/topicset/ios/subscribe/manage/listspecial.html"];
    [manager GET:string parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //NSLog(@"responseObject: %@", responseObject);
        
        NSArray *array = responseObject[@"tList"];
        NSArray *array1 = @[array[2],array[1], array[7], array[4], array[5], array[11], array[16], array[32], array[25],array[18], array[26], array[8], array[34], array[17]];
        
        
        
        /*array[2]: 头条, array[8]: 娱乐, array[5]: 历史, array[6]: 军事, array[12]: 体育, array[17] : 科技, array[37]: 时尚, array[26]: 游戏, array[19]: 数码, array[27]: 旅游, array[9]: 影视; array[35]: 暴雪游戏, array[18]: 手机*/
        for (NSDictionary *dic in array1) {
            [self.dataSource addObject:dic[@"tid"]];
            [self.needArray addObject:dic[@"tname"]];
            [self.dataArray addObject:dic[@"ename"]];
        }
        
        [self getScrollView];
        [self loadCollectionView];
        [self.collectionView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"没有网络, 请检查你的网络" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:otherAction];
        [self presentViewController:alert animated:YES completion:nil];
        
    }];
    
    
}

- (void)loadCollectionView {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(WIDTH, HEIGHT - 104);
    flowLayout.minimumLineSpacing  = 0;
    //滚动方向
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 104, WIDTH, HEIGHT - 104) collectionViewLayout:flowLayout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.pagingEnabled = YES;
    
    //设置代理 和 数据
    
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    
    //注册cell
    [self.collectionView registerClass:[EdgeCollectionViewCell class] forCellWithReuseIdentifier:identifier];
    [self.view addSubview:_collectionView];
    [_collectionView release];
    
    
    
}

#pragma mark - UICollectionViewDataSource


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.needArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    EdgeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
        cell.tid = self.dataSource[indexPath.item];
        cell.ename = self.dataArray[indexPath.item];
        cell.anyViewController = self;
      
    return cell;
    
}
//collectionView滚动, scrollView的button跟着动;

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    NSInteger number = self.collectionView.contentOffset.x / WIDTH;
    if (number < self.needArray.count - 4 )
    {
        [self.scrollView setContentOffset:CGPointMake(WIDTH / 5 * number, 0) animated:YES];
    }
    
    for (NSInteger i = 0; i < self.needArray.count; i++) {
        UIButton *allButton = (UIButton *)[self.view viewWithTag:100 + i];
        allButton.tintColor = [UIColor blackColor];
        UIButton *buttonMe = [UIButton buttonWithType:UIButtonTypeSystem];
        buttonMe.frame = CGRectMake(0, 0, WIDTH / 6, 30);
        allButton.transform = buttonMe.transform;
        
    }
    
    [UIView animateWithDuration:0.1 animations:^{
        UIButton *button = (UIButton *)[self.view viewWithTag:100 + number];
        button.tintColor = [UIColor colorWithRed:0.0 green:0.2 blue:0.8 alpha:1.0];
        button.transform = CGAffineTransformScale(button.transform, 1.3, 1.3);
    }];
    
    
    
}

- (void)showLeftButton {
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"24"] style:UIBarButtonItemStyleDone target:self action:@selector(toLeft)];
    self.navigationItem.rightBarButtonItem = left;
    
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor colorWithRed:0.3098 green:0.9569 blue:0.9725 alpha:1.0];
    [left release];
}

- (void)toLeft {
    LeftViewController *left = [[LeftViewController alloc] init];
    UINavigationController *naVC = [[UINavigationController alloc] initWithRootViewController:left];
    [self.navigationController presentViewController:naVC animated:YES completion:nil];
    [left release];
    [naVC release];
    
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
