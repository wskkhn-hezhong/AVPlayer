//
//  VideoPlayController.m
//  EdgeNews
//


#import "VideoPlayController.h"
#import "DetailModel.h"
#import "DetailViewCell.h"
#import "AFNetworking.h"
#import "VideoPlay.h"


@interface VideoPlayController ()<UITableViewDelegate , UITableViewDataSource, VideoPlayDelegate>

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) VideoPlay *playView;
@property (nonatomic, retain) NSMutableArray *dataArray;
@property (nonatomic, assign) CGRect currentFrame;
@property (nonatomic, assign) NSInteger index;

@end

@implementation VideoPlayController

- (void)dealloc
{
    [_tableView release];
    [_titleLabel release];
    [_playView release];
    [_dataArray release];
    [_url release];
    [_mp4_url release];
    [_Maintitle release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.1608 green:0.5647 blue:0.9098 alpha:1.0];

    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = self.Maintitle;
    [self creatPlayView];
    [self tableView];
    
    [self getdata];

}


- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        self.dataArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataArray;
}

//创建播放器
- (void)creatPlayView {
    self.playView = [[VideoPlay alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT / 2.2)];
    self.playView.urlStr = self.mp4_url;
    [self.view addSubview:self.playView];
    self.playView.delegate = self;
    [self.playView release];
    
}





- (UITableView *)tableView {
    if (!_tableView) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, HEIGHT / 2.2, WIDTH  ,  HEIGHT - HEIGHT / 2.2) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 49;
        _tableView.separatorStyle = NO;
        [_tableView registerNib:[UINib nibWithNibName:@"DetailViewCell" bundle:nil] forCellReuseIdentifier:@"reuse"];
        [self.view addSubview: self.tableView];
        [_tableView release];
    }
    return _tableView;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- ( NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"相关视频";
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DetailViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuse" forIndexPath:indexPath];
    cell.layer.borderColor = [UIColor colorWithRed:0.9506 green:0.933 blue:0.9452 alpha:1.0].CGColor;
    cell.layer.borderWidth = 2;
    cell.layer.cornerRadius = 5;
    cell.clipsToBounds = YES;
    if (indexPath.row == self.index) {
        cell.playImage.hidden = NO;
    }
    cell.playImage.hidden = YES;
    [cell setModelToCell:self.dataArray[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DetailModel *model = [[DetailModel alloc] init];
    model = self.dataArray[indexPath.row];
    self.playView.urlStr = model.mp4_url;
    self.navigationItem.title = model.title;
    [model release];
    self.index = indexPath.row;
    DetailViewCell *cell = (DetailViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.playImage.hidden = NO;
  }


- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    DetailViewCell *cell = (DetailViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.playImage.hidden = YES;
}

#pragma mark - VideoPlayDelegate

//向左转全屏
- (void)turnLeft:(VideoPlay *)playerView {
    self.currentFrame = self.playView.frame;//记录当前的frame
    [UIView animateWithDuration:0.3 animations:^{
        playerView.transform = CGAffineTransformRotate(playerView.transform, M_PI_2);
        playerView.frame = [UIScreen mainScreen].bounds;
//        playerView.playerLayer.frame = playerView.layer.bounds;
//        playerView.playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;//设置自动按宽高比缩略播放
//        //灰色视图
//        playerView.bottom.frame = CGRectMake(0, WIDTH - 40, HEIGHT, 40);
//        //播放按钮
//        playerView.playButton.frame = CGRectMake(20, 5, 30, 30);
//        //进度条
//        playerView.videoProgress.frame = CGRectMake(CGRectGetMaxX( playerView.playButton.frame) + 10, 20, HEIGHT / 3 * 2, 1);
//        //状态条
//        playerView.slider.frame = CGRectMake(CGRectGetMaxX(playerView.playButton.frame) + 8  , 17, HEIGHT / 3 * 2 + 2, 7);
//        //时间条
//        playerView.timeLabel.frame = CGRectMake(CGRectGetMaxX(playerView.slider.frame) + 10, 10, 70, 20);
//        //全屏播放按钮
//        playerView.fullScreenButton.frame = CGRectMake(HEIGHT- 40, 5, 30, 30);
        [playerView.fullScreenButton setImage:[UIImage imageNamed:@"quitquanping"] forState:UIControlStateNormal];
        [[UIApplication sharedApplication].windows.firstObject addSubview:self.playView];

    } completion:^(BOOL finished) {
        
    }];
 
}
//左全屏转回小窗口播放
- (void)leftTurnBack:(VideoPlay *)playerView {
    [UIView animateWithDuration:0.3 animations:^{
        playerView.transform = CGAffineTransformRotate(playerView.transform, -M_PI_2);
        playerView.frame = self.currentFrame;
//        playerView.playerLayer.frame = playerView.layer.bounds;
        playerView.playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;//设置自动按宽高比缩略播放
//        //灰色视图
//        playerView.bottom.frame = CGRectMake(0, self.currentFrame.size.height - 40, self.currentFrame.size.width, 40);
//        //播放按钮
//        playerView.playButton.frame = CGRectMake(10, 5, 30, 30);
//        //进度条
//        playerView.videoProgress.frame = CGRectMake(CGRectGetMaxX( playerView.playButton.frame) + 10, 20, self.currentFrame.size.width / 3 * 2, 1);
//        //状态条
//        playerView.slider.frame = CGRectMake(CGRectGetMaxX(playerView.playButton.frame) + 8, 17, self.currentFrame.size.width / 3 * 2 + 2, 7);
//        //时间条
//        playerView.timeLabel.frame = CGRectMake(CGRectGetMaxX(playerView.slider.frame) - 60, 25, 60, 10);
//        //全屏播放按钮
//        playerView.fullScreenButton.frame = CGRectMake(self.currentFrame.size.width - 40, 5, 30, 30);
        [playerView.fullScreenButton setImage:[UIImage imageNamed:@"quanping"] forState:UIControlStateNormal];
    } completion:^(BOOL finished) {
    }];
}


- (void)getdata {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:self.url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        for (NSString *key in responseObject) {
            if ([key isEqualToString:@"secList"]) {
                NSMutableArray *data = responseObject[@"secList"];
                for (NSDictionary *dic in data) {
                    DetailModel *model = [[DetailModel alloc] init];
                    model.title = dic[@"title"];
                    model.mp4_url = dic[@"mp4_url"];
                    model.length = dic[@"length"];
                    [self.dataArray addObject:model];
                }
                [self.tableView reloadData];
            } else if ([key isEqualToString:@"recommend"]) {
                NSMutableArray *data1 = responseObject[@"recommend"];
                for (NSDictionary *dic1 in data1) {
                    DetailModel *model = [[DetailModel alloc] init];
                    model.cover = dic1[@"cover"];
                    model.title = dic1[@"title"];
                    model.mp4_url = dic1[@"mp4_url"];
                    model.length = dic1[@"length"];
                    [self.dataArray addObject:model];
                }
                [self.tableView reloadData];
            }
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        self.tableView.hidden = YES;
        UILabel *noVideoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 248, WIDTH, HEIGHT - 248)];
        noVideoLabel.text = @"暂时没有推荐视频";
        noVideoLabel.font = [UIFont systemFontOfSize:20];
        noVideoLabel.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:noVideoLabel];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"抱歉" message:@"网络连接失败,请检查您的网络是否连接" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }];
}


//切换到别的页面时, 暂停播放
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.playView.player replaceCurrentItemWithPlayerItem:nil];
    [self.playView removeFromSuperview];
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
