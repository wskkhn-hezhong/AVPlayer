//
//  VideoViewController.m
//  EdgeNews
//


#import "VideoViewController.h"
#import "AFNetworking.h"
#import "HeadModel.h"
#import "VideoModel.h"
#import "VideoPlayCell.h"
#import "NextViewController.h"
#import "VideoPlay.h"
#import "BtnSingleton.h"
#import "MBProgressHUD.h"
#import "MJRefresh.h"
#import <MediaPlayer/MediaPlayer.h>
#import "HeaderView.h"
#import "VideoPlayController.h"

@interface VideoViewController ()<UITableViewDelegate , UITableViewDataSource, VideoPlayCellDelegate, VideoPlayDelegate> {
    BOOL _ishidden;
    BOOL _isSmall;
}

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *dataArray;
@property (nonatomic, retain) NSMutableArray *headArray;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, retain) VideoPlayCell *playcell;
@property (nonatomic, retain) VideoPlay *play;
@property (nonatomic, retain) NSIndexPath *index;
@property (nonatomic, assign) CGRect currentFrame;//当前的
@property (nonatomic, assign) CGRect currentFrame2;//滚出的
@property (nonatomic, strong) MPMoviePlayerController *moviePlayer;
@property (nonatomic, retain) NSString *play_mp4;
@property (nonatomic, retain) NSString *otherTitle;
@property (nonatomic, retain) NSString *onlyID;

@end

@implementation VideoViewController

- (void)dealloc
{
    [_moviePlayer release];
    [_play_mp4 release];
    [_otherTitle release];
    [_onlyID release];
    [_playcell release];
    [_index release];
    [_play release];
    [_dataArray release];
    [_headArray release];
    [_tableView release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self tableView];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.1608 green:0.5647 blue:0.9098 alpha:1.0];

    self.navigationController.navigationBar.translucent = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor colorWithRed:0.9506 green:0.933 blue:0.9452 alpha:1.0];
//    HeaderView *view = [[HeaderView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, WIDTH / 4.)];
//    [view.button1 addTarget:self action:@selector(clickMe:) forControlEvents:UIControlEventTouchUpInside];
//    [view.button2 addTarget:self action:@selector(clickMe:) forControlEvents:UIControlEventTouchUpInside];
//    [view.button3 addTarget:self action:@selector(clickMe:) forControlEvents:UIControlEventTouchUpInside];
//    [view.button4 addTarget:self action:@selector(clickMe:) forControlEvents:UIControlEventTouchUpInside];
//    view.backgroundColor = [UIColor colorWithRed:0.9506 green:0.933 blue:0.9452 alpha:1.0];
//    self.tableView.tableHeaderView = view;
//    [view release];
    
    self.page = 0;
    [self netWork];
    
    //下拉刷新
    [self.tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(refreshTableViewHeader)];
    
    //上拉加载
    [self.tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(refreshTableViewFooter)];
    
    
    
    
}

- (void)refreshTableViewHeader {
    [self.dataArray removeAllObjects];
    self.page = 0;
    [self netWork];
    [self.tableView.header endRefreshing];
    
    
}

- (void)refreshTableViewFooter {
    self.page++;
    [self netWork];
    [self.tableView.footer endRefreshing];
}




- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        self.dataArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataArray;
}

- (NSMutableArray *)headArray {
    if (!_headArray) {
        self.headArray = [NSMutableArray arrayWithCapacity:0];
        
    }
    return _headArray;
}


- (UITableView *)tableView {
    if (!_tableView) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT ) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = NO;
        _tableView.backgroundColor = [UIColor colorWithRed:0.9506 green:0.933 blue:0.9452 alpha:1.0];
        [self.view addSubview:_tableView];
        [_tableView release];
    }
    return _tableView;
}

#pragma mark - 向左转全屏播放
//向左转全屏播放
- (void)turnLeft:(VideoPlay *)playerView {
    self.currentFrame = self.play.frame;//记录当前的frame
    [playerView removeFromSuperview];
    [UIView animateWithDuration:0.3 animations:^{
        //改变playerView的旋转角度
        playerView.transform = CGAffineTransformRotate(playerView.transform, M_PI_2);
        playerView.frame = [UIScreen mainScreen].bounds;
//        playerView.playerLayer.frame = playerView.layer.bounds;
        playerView.playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;//设置自动按宽高比缩略播放
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
//        playerView.fullScreenButton.frame = CGRectMake(HEIGHT - 40, 5, 30, 30);
        [playerView.fullScreenButton setImage:[UIImage imageNamed:@"quitquanping"] forState:UIControlStateNormal];
        [[UIApplication sharedApplication].delegate.window addSubview:playerView];//添加进全屏

    } completion:^(BOOL finished) {
        
        
    }];
}

#pragma mark - 左全屏转回小窗口播放

- (void)leftTurnBack:(VideoPlay *)playerView {
    //先移除全屏视图
    [playerView removeFromSuperview];
    
    [UIView animateWithDuration:0.3 animations:^{
        playerView.transform = CGAffineTransformRotate(playerView.transform, -M_PI_2);
        playerView.frame = self.currentFrame;
//        playerView.playerLayer.frame = playerView.layer.bounds;
        playerView.playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
        //灰色视图
//        playerView.bottom.frame = CGRectMake(0, self.currentFrame.size.height - 40, self.currentFrame.size.width, 40);
//        //播放按钮
//        playerView.playButton.frame = CGRectMake(10, 5, 30, 30);
//        //进度条
//        playerView.videoProgress.frame = CGRectMake(CGRectGetMaxX( playerView.playButton.frame) + 10, 20, self.currentFrame.size.width / 3 * 2, 1);
//        //状态条
//        playerView.slider.frame = CGRectMake(CGRectGetMaxX(playerView.playButton.frame) + 8  , 17, self.currentFrame.size.width / 3 * 2 + 2, 7);
//        //时间条
//        playerView.timeLabel.frame = CGRectMake(CGRectGetMaxX(playerView.slider.frame) - 60, 25, 60, 10);
//        //全屏播放按钮
//        playerView.fullScreenButton.frame = CGRectMake(self.currentFrame.size.width - 40, 5, 30, 30);
        [playerView.fullScreenButton setImage:[UIImage imageNamed:@"quanping"] forState:UIControlStateNormal];
       
       [self.playcell addSubview:self.play];
        
    } completion:^(BOOL finished) {
        
        
    }];
}

//播放失败
- (void)AVPlayerStatusFailed:(VideoPlay *)playerView {
    playerView.hidden = YES;
}



#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count ;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    VideoPlayCell *cell = [VideoPlayCell registerCell];
    cell.backgroundColor = [UIColor colorWithRed:0.9506 green:0.933 blue:0.9452 alpha:1.0];
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    [cell setModelToVideo:self.dataArray[indexPath.row]];
    cell.delegate = self;
    return cell;
    
    
}

- (void)clickMe:(UIButton *)button {
    NextViewController *nextVC = [[NextViewController alloc] init];
    
    UINavigationController *naVC = [[UINavigationController alloc] initWithRootViewController:nextVC];
    nextVC.head = self.headArray[button.tag - 1001];
    [self presentViewController:naVC animated:YES completion:nil];
    [naVC release];
    [nextVC release];
    
    
    
}

#pragma mark - VideoPlayCellDelegate

- (void)videoPlayCell:(VideoPlayCell *)videoCell {
    self.playcell = videoCell;
    self.index = [self.tableView indexPathForCell:videoCell];
    self.play_mp4 = [self.dataArray[self.index.row] mp4_url];
    
    if (_isSmall) {
        [self.play removeFromSuperview];
        self.play.urlStr = self.play_mp4;
        self.play.frame = CGRectMake(8, 79, WIDTH - 15, HEIGHT / 2 - 111 );
//        self.play.playerLayer.frame = self.play.layer.bounds;
        self.play.playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;//设置自动按宽高比缩略播放
//        //灰色视图
//        self.play.bottom.frame  = CGRectMake(0, self.play.frame.size.height - 40, self.play.frame.size.width, 40);
//        //播放按钮
//        self.play.playButton.frame = CGRectMake(10, 5, 30, 30);
//        //进度条
//        self.play.videoProgress.frame = CGRectMake(CGRectGetMaxX(self.play.playButton.frame) + 10, 20, self.play.frame.size.width / 3 * 2 , 1);
//        //状态条
//        self.play.slider.frame = CGRectMake(CGRectGetMaxX(self.play.playButton.frame) + 8, 17, self.play.frame.size.width / 3 * 2 + 2, 7);
//        //时间条
//        self.play.timeLabel.frame = CGRectMake(CGRectGetMaxX(self.play.playButton.frame) - 60, 25, 60, 10);
//        //全屏按钮
//        self.play.fullScreenButton.frame = CGRectMake(self.play.frame.size.width - 40, 5, 30, 30);
        self.play.bottom.hidden = YES;
        [self.play.fullScreenButton setImage:[UIImage imageNamed:@"quanping"] forState:UIControlStateNormal];
        
        [self.playcell addSubview:self.play];
    }else {
        if ([BtnSingleton mainSingleton].mangeStatus == 1 && ![BtnSingleton mainSingleton].loadVideo) {
            UIAlertView *aliertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络已断开, 将要使用运营商网络, 继续观看会产生超额的流量费!!" delegate:self cancelButtonTitle:@"取消观看" otherButtonTitles:@"继续观看", nil];
            [aliertView show];
            [aliertView release];
        }else {
            if (!_play) {
                //初始化
                self.play = [[VideoPlay alloc] initWithFrame:CGRectMake(8, 79, WIDTH - 16, HEIGHT / 2 - 111 )];
            }
            self.play.urlStr = self.play_mp4;
            [self.playcell addSubview:self.play];
            self.play.delegate = self;
            [self.play release];
        }
    }
    
    
}



#pragma mark - UITableViewDelegate

//点击cell触发

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //关闭当前播放器
    [self.play.player replaceCurrentItemWithPlayerItem:nil];
    //将播放器从当前视图移除
    [self.play removeFromSuperview];
    
    self.playcell = (VideoPlayCell *)[tableView cellForRowAtIndexPath:indexPath];
    self.index = indexPath;
    self.otherTitle = [self.dataArray[indexPath.row] title];
    self.play_mp4 = [self.dataArray[indexPath.row] mp4_url];
    self.onlyID = [self.dataArray[indexPath.row] vid];
    
    //Push到下一个界面
    VideoPlayController *videoPlay = [[VideoPlayController alloc] init];
    videoPlay.Maintitle = self.otherTitle;
    videoPlay.mp4_url = self.play_mp4;
    videoPlay.url = [NSString stringWithFormat:@"http://c.m.163.com/nc/video/detail/%@.html",self.onlyID];
    [self.navigationController pushViewController:videoPlay animated:YES];
    [videoPlay release];

}

//右下角小屏播放
- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath {
    if (self.index.row == indexPath.row) {
        _isSmall = YES;
        self.currentFrame2 = self.play.frame;
        [self.play removeFromSuperview];
        self.play.frame = CGRectMake(WIDTH / 2, HEIGHT / 4. * 3 , WIDTH / 2 - 10, HEIGHT / 4 - 60);
//        self.play.playerLayer.frame = self.play.layer.bounds;
        self.play.playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
//        //灰色视图
//        self.play.bottom.frame  = CGRectMake(0, self.play.frame.size.height - 40, self.play.frame.size.width, 40);
//        //播放按钮
//        self.play.playButton.frame = CGRectMake(10, 5, 30, 30);
//        //进度条
//        self.play.videoProgress.frame = CGRectMake(CGRectGetMaxX(self.play.playButton.frame) + 10, 20, self.play.frame.size.width / 3 * 2 , 1);
//        //状态条
//        self.play.slider.frame = CGRectMake(CGRectGetMaxX(self.play.playButton.frame) + 8, 17, self.play.frame.size.width / 3 * 2 + 2, 7);
//        //时间条
//        self.play.timeLabel.frame = CGRectMake(CGRectGetMaxX(self.play.playButton.frame) - 60, 25, 60, 10);
        //全屏按钮
//        self.play.fullScreenButton.frame = CGRectMake(self.play.frame.size.width - 40, 5, 30, 30);
        self.play.bottom.hidden = YES;
        [[UIApplication sharedApplication].delegate.window addSubview:self.play];
    }
}

//通过self.index来判断点击的哪个cell 然后通过cell将要出现这个方法, 来判断将要出现的cell是不是点击的那个cell 通过self.index 来判断 如果相等的话 就把小屏播放界面先从父视图中移除, 然后在按照原先视频播放器的frame来添加到刚才点击的那个cell上 实现继续播放的功能. (方法里的这个cell 通过cell的下标来判断是否是点击的那个cell 如果是 方法里的这个cell 就是点击的那个cell 直接把播放视频界面添加到这个cell就可以了)

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.index.row == indexPath.row) {
        _isSmall = NO;
        [self.play removeFromSuperview];
        self.play.frame = self.currentFrame2;
        self.play.playerLayer.frame = self.play.layer.bounds;
        self.play.playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
      //  灰色视图
//        self.play.bottom.frame = CGRectMake(0, self.currentFrame2.size.height - 40, self.currentFrame2.size.width, 40);
//        //播放按钮
//        self.play.playButton.frame = CGRectMake(10, 5, 30, 30);
//        //进度条
//        self.play.videoProgress.frame = CGRectMake(CGRectGetMaxX(self.play.playButton.frame) + 10, 20, self.currentFrame2.size.width / 3 * 2, 1);
//        //状态条
//        self.play.slider.frame = CGRectMake(CGRectGetMaxX(self.play.playButton.frame) + 8, 17, self.currentFrame2.size.width / 3 * 2 + 2, 7);
//        //时间条
//        self.play.timeLabel.frame = CGRectMake(self.currentFrame2.size.width - 40, 5, 30, 30);
//        //全屏播放按钮
//        self.play.fullScreenButton.frame = CGRectMake(self.currentFrame2.size.width - 40, 5, 30, 30);
        [self.play.fullScreenButton setImage:[UIImage imageNamed:@"quanping"] forState:UIControlStateNormal];
        self.play.bottom.hidden = NO;
        [cell addSubview:self.play];
    }
}



//切换到别的页面. 暂停播放
- (void)viewWillDisappear:(BOOL)animated {
    [self.play.player replaceCurrentItemWithPlayerItem:nil];
    [self.play removeFromSuperview];
    self.index = nil;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return (HEIGHT - 16 )/ 2;
}


#pragma mark - netWorking

- (void)netWork {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[NSString stringWithFormat:@"http://c.m.163.com/nc/video/home/%ld0-10.html", (long)self.page] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"JSON: %@", responseObject);
        
        for (NSDictionary *dic in responseObject[@"videoSidList"]) {
            HeadModel *head = [[HeadModel alloc] init];
            [head setValuesForKeysWithDictionary:dic];
            [self.headArray addObject:head];
            [head release];
        }
            for (NSDictionary *dic1 in responseObject[@"videoList"]) {
            VideoModel *video = [[VideoModel alloc] init];
            [video setValuesForKeysWithDictionary:dic1];
            [self.dataArray addObject:video];
            [video release];
        }

        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.tableView reloadData];

        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
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
