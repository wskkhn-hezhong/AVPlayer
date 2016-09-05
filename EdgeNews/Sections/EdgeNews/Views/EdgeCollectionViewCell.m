//
//  EdgeCollectionViewCell.m
//  EdgeNews
//
//  Created by lanouhn on 15/11/23.
//  Copyright (c) 2015年 lanouhn. All rights reserved.
//

#import "EdgeCollectionViewCell.h"
#import "EdgeNewsViewController.h"
#import "MBProgressHUD.h"
#import "AFNetworking.h"
#import "MJRefresh.h"
#import "MostTableViewCell.h"
#import "HeadTableViewCell.h"
#import "ThreeTableViewCell.h"
#import "ScrollTableViewCell.h"
#import "Model.h"
#import "EdgeNews.h"
#import "HtmlViewController.h"


@interface EdgeCollectionViewCell ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) UITableView *tabelView;
@property (nonatomic, retain) NSMutableArray *dataArray;
@property (nonatomic, retain) NSMutableArray *imageArray;
@property (nonatomic, retain) NSMutableArray *titleArray;
@property (nonatomic, retain) NSMutableArray *urlArray;
@property (nonatomic, assign) NSInteger page;

@end

@implementation EdgeCollectionViewCell

- (void)dealloc
{
    [_dataArray release];
    [_tabelView release];
    [_imageArray release];
    [_titleArray release];
    [_tid release];
    [_ename release];
    [super dealloc];
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        self.dataArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataArray;
}

- (NSMutableArray *)titleArray {
    if (!_titleArray) {
        self.titleArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _titleArray;
}

- (NSMutableArray *)imageArray {
    if (!_imageArray) {
        self.imageArray = [NSMutableArray arrayWithCapacity:0];
    }
    
    return _imageArray;
}

- (NSMutableArray *)urlArray {
    if (!_urlArray) {
        self.urlArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _urlArray;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.page = 0;
        [self refreshAllTabelView];
        
    }
    return self;
}

- (void)refreshAllTabelView {
    
    [self.tabelView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadTableView)];
    [self.tabelView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(refreshtableView)];
    
}
//上拉加载
- (void)loadTableView {
    self.page += 2;
    NSString *string = [NSString stringWithFormat:@"http://c.3g.163.com/nc/article/list/%@/%ld0-20.html", self.tid, self.page];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    if (![self.tid isEqualToString:@"T1348647853363"]) {
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", nil];
    }
    [manager GET:string parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableArray *array = responseObject[self.tid];
        
        for (NSDictionary *dic in array) {
            if (!dic[@"TAG"]) {
            Model *model = [[Model alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [self.dataArray addObject:model];
            [model release];
            }
        }
        [self.tabelView reloadData];
        [self.tabelView.footer endRefreshing];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"加载失败, 请您检查网络再加载" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }];
    
    
}
//下拉刷新
- (void)refreshtableView {
    [self.dataArray  removeAllObjects];
    
    NSString *string = [NSString stringWithFormat:@"http://c.3g.163.com/nc/article/list/%@/0-20.html", self.tid];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    if (![self.tid isEqualToString:@"T1348647853363"]) {
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", nil];
    }
    
    [manager GET:string parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:self animated:YES];
        
        NSArray *array = responseObject[self.tid];
        
        for (NSDictionary *dic in array[0][@"ads"]) {
            EdgeNews *edge = [[EdgeNews alloc] init];
            [edge setValuesForKeysWithDictionary:dic];
            [self.imageArray addObject:edge.imgsrc];
            [self.titleArray addObject:edge.title];
            [self.urlArray addObject:edge.url];
            [edge release];
        }
        for (NSDictionary *dic1 in array) {
            if (!dic1[@"TAG"]) {
            Model *modelOne = [[Model alloc] init];
            [modelOne setValuesForKeysWithDictionary:dic1];
            [self.dataArray addObject:modelOne];
            [modelOne release];
            }
        }
        [self.tabelView reloadData];
        [self.tabelView.header endRefreshing];
       
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"刷新失败, 请您检查网络再加载" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }];
    
}

//切换页面
- (void)setTid:(NSString *)tid {
    if (_tid != tid) {
        _tid = tid;
    }
    [self.dataArray removeAllObjects];
    [self.imageArray  removeAllObjects];
    
    NSString *str = [NSString stringWithFormat:@"http://c.3g.163.com/nc/article/list/%@/0-20.html", _tid];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    if (![tid isEqualToString:@"T1348647853363"]) {
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", nil];
    }
    [manager GET:str parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *array = responseObject[self.tid];
        
        for (NSDictionary *dic in responseObject[self.tid][0][@"ads"]) {
            EdgeNews *edge = [[EdgeNews alloc] init];
            [edge setValuesForKeysWithDictionary:dic];
            [self.imageArray addObject:edge.imgsrc];
            [self.titleArray addObject:edge.title];
            [self.urlArray addObject:edge.url];

            [edge release];
        }
        
        for (NSDictionary *dic1 in array) {
            if (!dic1[@"TAG"]){

            Model *model1 = [[Model alloc] init];
            [model1 setValuesForKeysWithDictionary:dic1];
            [self.dataArray addObject:model1];
            
            [model1 release];
            }
        }
        [self.tabelView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"不好意思, 没有网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }];
}

//懒加载
- (UITableView *)tabelView {
    if (!_tabelView) {
        self.tabelView = [[UITableView alloc] initWithFrame:self.bounds];
        self.tabelView.delegate = self;
        self.tabelView.dataSource = self;
        self.tabelView.separatorStyle = NO;
        //注册cell
        
        [self.tabelView registerClass:[MostTableViewCell class] forCellReuseIdentifier:@"most"];
        
        [self.tabelView registerClass:[ThreeTableViewCell class] forCellReuseIdentifier:@"three"];
        [self.tabelView registerClass:[HeadTableViewCell class] forCellReuseIdentifier:@"head"];
                
        [self.tabelView registerClass:[ScrollTableViewCell class] forCellReuseIdentifier:@"scroll"];
        
        [self.contentView addSubview:self.tabelView];
        [self.tabelView release];
}
    return _tabelView;
}
#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
    }
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0 && self.imageArray.count > 0 && [self.ename isEqualToString:@"iosnews"]) {
        ScrollTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"scroll" forIndexPath:indexPath];
        cell.imageArray = [NSMutableArray arrayWithArray:self.imageArray];
        cell.titleArray = [NSMutableArray arrayWithArray:self.titleArray];
        cell.urlArray = [NSMutableArray arrayWithArray:self.urlArray];
        //cell的样式
        cell.vc = self.anyViewController;
        cell.selectionStyle = UITableViewCellSeparatorStyleNone;
        return cell;
    }else {
        if (indexPath.section == 0 && indexPath.row == 0) {
            HeadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"head" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSeparatorStyleNone;
            cell.edgeNews = self.dataArray[indexPath.row];
            return cell;
        }else {
            
            if ([self.dataArray[indexPath.row] imageArray].count != 0) {
                ThreeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"three" forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSeparatorStyleNone;
                cell.model = self.dataArray[indexPath.row];
                return cell;
            }
        }
        MostTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"most" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = self.dataArray[indexPath.row];
        return cell;
    }
    
}

//定义cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0 && self.imageArray.count > 0) {
        return 190  * WIDTH / 375;
    } else if (indexPath.section == 0 && indexPath.row == 0) {
        return 190  * WIDTH / 375;
    }else {
        if ([self.dataArray[indexPath.row] imageArray].count != 0) {
            return 132.  * WIDTH / 375 ;
        }
    }
    return 105. / 667 * HEIGHT ;
}

//点击进入下一页

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HtmlViewController *html = [[HtmlViewController alloc] init];
    
    UINavigationController *naVC = [[UINavigationController alloc] initWithRootViewController:html];
    html.model = self.dataArray[indexPath.row];
    [self.anyViewController presentViewController:naVC animated:YES completion:nil];
    [html release];
    [naVC release];
}




@end