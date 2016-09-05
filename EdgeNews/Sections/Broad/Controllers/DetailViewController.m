//
//  DetailViewController.m
//  EdgeNews
//
//  Created by lanouhn on 15/12/3.
//  Copyright © 2015年 lanouhn. All rights reserved.
//

#import "DetailViewController.h"
#import "AFNetworking.h"
#import "RadioModel.h"
#import "TitleListCell.h"
#import "PlayViewController.h"
#import "MJRefresh.h"

@interface DetailViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, retain) NSMutableArray *dataArray;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, assign) NSInteger page;

@end

@implementation DetailViewController

- (void)dealloc
{
    [_dataArray release];
    [_tableView release];
    [_cid release];
    [_name release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets =NO;
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.title = self.name;
   [self netWork];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.1608 green:0.5647 blue:0.9098 alpha:1.0];

   [self creatTableView];
    self.page = 0;
    [self refresh];
    
    
    
    
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        self.dataArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataArray;
}

- (void)refresh{
    [self.tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(refreshTableViewFoot)];
    [self.tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(refreshTableViewHead)];
}

- (void)refreshTableViewFoot {
    self.page += 20;
    [self netWork];
    [self.tableView.footer endRefreshing];
}

- (void)refreshTableViewHead {
    [self.dataArray removeAllObjects];
    self.page = 0;
    [self.tableView.header endRefreshing];
}


- (void)creatTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 115) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource= self;
    _tableView.separatorStyle = NO;
    _tableView.rowHeight = 100;
    [_tableView registerNib:[UINib nibWithNibName:@"TitleListCell" bundle:nil] forCellReuseIdentifier:@"title"];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 375, 40)];
    label.text = @"没有更多内容了";
    label.textAlignment = NSTextAlignmentCenter;
    _tableView.tableFooterView = label;
    [label release];
    
    [self.view addSubview:self.tableView];
    [_tableView release];
    
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TitleListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"title" forIndexPath:indexPath];
    cell.layer.borderColor = [UIColor colorWithRed:0.9506 green:0.933 blue:0.9452 alpha:1.0].CGColor;
    cell.layer.borderWidth = 2;
    cell.layer.cornerRadius = 5;
    cell.clipsToBounds = YES;
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PlayViewController *playVC = [[PlayViewController alloc] init];
    playVC.tid = [self.dataArray[indexPath.row] tid];
    playVC.tname = [self.dataArray[indexPath.row] tname];
    playVC.docid = [self.dataArray[indexPath.row] docid];
    playVC.modalTransitionStyle =  UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:playVC animated:YES completion:nil];
    [playVC release];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)netWork {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[NSString stringWithFormat:@"http://c.m.163.com/nc/topicset/ios/radio/%@/%ld-20.html", self.cid, self.page] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        for (NSDictionary *dic in responseObject[@"tList"]) {
            RadioModel *model =[[RadioModel alloc] init];
            model.playCount = dic[@"playCount"];
            model.tid = dic[@"tid"];
            NSDictionary *dic1 = dic[@"radio"];
            model.docid = dic1[@"docid"];
            model.title = dic1[@"title"];
            model.cid = dic1[@"cid"];
            model.tname = dic1[@"tname"];
            model.imgsrc = dic1[@"imgsrc"];
            [self.dataArray addObject:model];
            [model release];
                }
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"Error: %@", error);
    }];
}


@end
