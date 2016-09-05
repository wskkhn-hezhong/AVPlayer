//
//  LeftViewController.m
//  EdgeNews
//
//  Created by lanouhn on 15/11/27.
//  Copyright (c) 2015年 lanouhn. All rights reserved.
//

#import "LeftViewController.h"
#import "AFNetworking.h"
#import "Model.h"
#import "EdgeNews.h"
#import "MBProgressHUD.h"
#import "MJRefresh.h"
#import "MostTableViewCell.h"
#import "HeadTableViewCell.h"
#import "ThreeTableViewCell.h"
#import "SVPullToRefresh.h"
#import "HtmlViewController.h"

@interface LeftViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, assign) NSInteger page;
@property (nonatomic, retain) NSMutableArray *dataArray;
@property (nonatomic, retain) UITableView *tableView;

@end

@implementation LeftViewController
- (void)dealloc
{
    [_tableView release];
    [_dataArray release];
    [super dealloc];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.1608 green:0.5647 blue:0.9098 alpha:1.0];

    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"24小时新闻";
    [self backNews];
    [self netWork];
    [self tableView];
    self.page = 0;
    
    //下拉刷新
    [self.tableView addPullToRefreshWithActionHandler:^{
        self.page = 0;
        [self netWork];
    }];
//    //上拉加载
//    [self.tableView addInfiniteScrollingWithActionHandler:^{
//        self.page += 2;
//        [self netWork];
//        NSLog(@"生了");
//    }];
    
    //自动刷新
    [self.tableView triggerPullToRefresh];
    
    
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        self.dataArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataArray;
}


- (void)netWork {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager GET:[NSString stringWithFormat:@"http://c.m.163.com/nc/article/list/T1429173683626/0-20.html"] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"JSON: %@", responseObject);
        if (self.page == 0) {
            [self.dataArray removeAllObjects];
        }
        
        for (NSDictionary *dic in responseObject[@"T1429173683626"] ) {
            if (!dic[@"TAG"]) {
                Model *model = [[Model alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [self.dataArray addObject:model];
                [model release];
            }
        }
        [self.tableView reloadData];
        if (self.page == 0) {
            [self.tableView.pullToRefreshView stopAnimating];
        
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}


- (UITableView *)tableView {
    if (!_tableView) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT - 64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[MostTableViewCell class] forCellReuseIdentifier:@"myCell"];
        [_tableView registerClass:[HeadTableViewCell class] forCellReuseIdentifier:@"head"];
        [_tableView registerClass:[ThreeTableViewCell class] forCellReuseIdentifier:@"three"];
        [self.view addSubview: _tableView];
        [_tableView release];
    }
    return _tableView;
}

#pragma  mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        HeadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"head" forIndexPath:indexPath];
        cell.edgeNews = self.dataArray[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else {
        if ([self.dataArray[indexPath.row] imageArray].count ) {
            ThreeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"three" forIndexPath:indexPath];
            cell.model = self.dataArray[indexPath.row];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
    MostTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCell" forIndexPath:indexPath];
    cell.model = self.dataArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        return HEIGHT / 3.5;
    }else {
        if ([self.dataArray[indexPath.row] imageArray].count) {
            return 132. / 667 * HEIGHT;
        }
    }
    return 99. / 667 * HEIGHT;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HtmlViewController *html = [[HtmlViewController alloc] init];
    UINavigationController *naVC = [[UINavigationController alloc] initWithRootViewController:html];
    
    html.model = self.dataArray[indexPath.row];
    [self.navigationController presentViewController:naVC animated:YES completion:nil];
    [html release];
    [naVC release];
    
    
    
    
}

- (void)backNews {
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ba"] style:UIBarButtonItemStylePlain target:self action:@selector(nextPage)];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0];
    self.navigationItem.leftBarButtonItem = leftButton;
    [leftButton release];
}

- (void)nextPage {
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
