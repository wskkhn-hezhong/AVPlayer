//
//  HistoryViewController.m
//  EdgeNews
//
//  Created by lanouhn on 15/12/6.
//  Copyright © 2015年 lanouhn. All rights reserved.
//

#import "HistoryViewController.h"
#import "DBManager.h"
#import "PlayModel.h"
#import "HistoryViewCell.h"
#import "HistoryModel.h"
#import "UIImageView+WebCache.h"
#import "BtnSingleton.h"
#import "AudioPlayer.h"
#import "AudioStreamer.h"
#import "AFNetworking.h"

#define player [[BtnSingleton mainSingleton]player]



@interface HistoryViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) UITableView *tableView;

@property (nonatomic, retain) NSMutableArray *dataArray;

@property (nonatomic, retain) NSMutableArray *array;

@property (nonatomic, retain) NSIndexPath *indexPath;

@property (nonatomic,retain) NSTimer *timer;

@property (nonatomic, assign) NSInteger index;

@end

@implementation HistoryViewController
- (void)dealloc
{
    [_indexPath release];
    [_dataArray release];
    [_tableView release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.1608 green:0.5647 blue:0.9098 alpha:1.0];
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    self.dataArray  = [[DBManager defaultManager].selectModel mutableCopy];
    self.array = [NSMutableArray arrayWithCapacity:0];
    HistoryViewCell *cell = [self.tableView cellForRowAtIndexPath:self.indexPath];
    [cell.button addTarget:self action:@selector(play) forControlEvents:UIControlEventTouchUpInside];
    
    [self loadTableView];
    [self.tableView reloadData];
    [self backButton];
    [self clearAll];
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(displayTime) userInfo:nil repeats:YES];

}

- (NSTimer *)timer{
    if (!_timer) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.03 target:self selector:@selector(rotatePlayImageView) userInfo:nil repeats:YES];
    }
    return _timer;
    
}

- (void)loadTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 77;
    _tableView.separatorStyle = NO;
    [_tableView registerNib:[UINib nibWithNibName:@"HistoryViewCell" bundle:nil] forCellReuseIdentifier:@"FVC"];
    [self.view addSubview: self.tableView];
    [_tableView release];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HistoryViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FVC" forIndexPath:indexPath];
    HistoryModel *model = self.dataArray[indexPath.row];
    [cell.photoImage sd_setImageWithURL:[NSURL URLWithString:model.imgsrc] placeholderImage:[UIImage imageNamed:@"57"]];
    cell.photoImage.layer.cornerRadius = 35;
    cell.photoImage.clipsToBounds = YES;
    cell.timeLabel.hidden = YES;
    cell.alllabel.hidden = YES;
    
    cell.titleLabel.text = model.source;
    cell.detailLabel.text = model.title;
    if (indexPath.row == self.index) {
        cell.timeLabel.hidden = NO;
        cell.alllabel.hidden = NO;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.indexPath = indexPath;
    self.index = indexPath.row;
    PlayModel *model = self.dataArray[indexPath.row];
    [self getPlayCellData:model.docid];
    

    HistoryViewCell *cell = [self.tableView cellForRowAtIndexPath:self.indexPath];
    cell.timeLabel.hidden = NO;
    cell.alllabel.hidden = NO;
    [cell.button addTarget:self action:@selector(play) forControlEvents:UIControlEventTouchUpInside];

    }

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    HistoryViewCell *cell = [self.tableView cellForRowAtIndexPath:self.indexPath];
    cell.timeLabel.hidden = YES;
    cell.alllabel.hidden = YES;
}

- (void)play {
    HistoryViewCell *cell = [self.tableView cellForRowAtIndexPath:self.indexPath];
    if (![BtnSingleton mainSingleton].audioUrlStr) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"网络不佳" message:@"当前播放为空" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:otherAction];
        [self presentViewController:alert animated:YES completion:nil];
       
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [alert dismissViewControllerAnimated:YES completion:nil];
             });
        return;
    }
    
    if ([player isProcessing]) {
        [player.streamer pause];
        [self.timer invalidate];
        self.timer = nil;
        [cell.button setBackgroundImage:[UIImage imageNamed:@"pause1"] forState:UIControlStateNormal];
        
    } else {
        
        [self rotatePlayImageView];
        [player play];
        [self.timer fire];
        [cell.button setBackgroundImage:[UIImage imageNamed:@"play1"] forState:UIControlStateNormal];
        
        
    }
    
    
}


- (void)getPlayCellData:(NSString *)string {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json", nil];
    NSString *url = [NSString stringWithFormat:@"http://c.m.163.com/nc/article/%@/full.html", string];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = responseObject[string];
        NSArray *ar = dic[@"video"];
        NSDictionary *dic1 = ar[0];
        HistoryModel *model = [[HistoryModel alloc] init];
        model.url_mp4 = dic1[@"url_mp4"];
        
        [BtnSingleton mainSingleton].audioUrlStr = model.url_mp4;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if ([BtnSingleton mainSingleton].audioUrlStr) {
                //stop 直接调用这个方法, 换掉了上一次的播放网址, 也就是换掉了AVPlayer的avplaitem, 因为AVPlayeritem里面存储着播放网址以及其他的一些信息
                [player stop];
                //在直接调用play 让播放器播放
                [self play];
            }
        });
        
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}


- (void)displayTime {
    HistoryViewCell *cell = [self.tableView cellForRowAtIndexPath:self.indexPath];

    cell.timeLabel .text = [NSString stringWithFormat:@"%@", player.streamer.currentTime];
    cell.alllabel.text = [NSString stringWithFormat:@"%@", player.streamer.totalTime];
}

//图片转起来
- (void)rotatePlayImageView {
    HistoryViewCell *cell = [self.tableView cellForRowAtIndexPath:self.indexPath];

    cell.photoImage.transform = CGAffineTransformRotate(cell.photoImage.transform, 0.02);
}




- (void)backButton {
    UIBarButtonItem *lift= [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ba"] style:UIBarButtonItemStyleDone target:self action:@selector(clickMe)];
    self.navigationController.navigationBar.tintColor = [UIColor redColor];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor redColor];
    self.navigationItem.leftBarButtonItem = lift;
    [lift release];
}


- (void)clearAll{
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"清除记录" style:UIBarButtonItemStyleDone target:self action:@selector(clearAllArray)];
    self.navigationItem.rightBarButtonItem = right;
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor redColor];
    [right release];
}

- (void)clearAllArray {
    
    [[DBManager defaultManager] deleteObject];
    [self dismissViewControllerAnimated:YES completion:nil];
    
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
