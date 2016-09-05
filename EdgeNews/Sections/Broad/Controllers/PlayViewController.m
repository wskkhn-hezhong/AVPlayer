//
//  PlayViewController.m
//  EdgeNews
//


#import "PlayViewController.h"
#import "AFNetworking.h"
#import "PlayModel.h"
#import "PlayMp3Model.h"
#import "UIImageView+WebCache.h"
#import "AudioPlayer.h"
#import "AudioStreamer.h"
#import "BtnSingleton.h"
#import "DetailCell.h"
#import "playMp3Model.h"
#import "MJRefresh.h"
#import "DBManager.h"
#import "MBProgressHUD.h"


#define player [[BtnSingleton mainSingleton]player]


@interface PlayViewController ()<UITableViewDelegate, UITableViewDataSource>
- (IBAction)play:(UIButton *)sender;
- (IBAction)last:(UIButton *)sender;
- (IBAction)next:(UIButton *)sender;
@property (retain, nonatomic) IBOutlet UISlider *slider;
@property (retain, nonatomic) IBOutlet UIButton *backButton;
@property (retain, nonatomic)  UITableView *tableView;
@property (retain, nonatomic) IBOutlet UILabel *titleLabel;
@property (retain, nonatomic) IBOutlet UIImageView *photoImage;
@property (retain, nonatomic) IBOutlet UILabel *allTimeLabel;
@property (retain, nonatomic) IBOutlet UILabel *beginTimeLabel;
@property (retain, nonatomic) IBOutlet UIButton *playButton;
@property (retain, nonatomic) AudioPlayer *play;
@property (nonatomic, retain) NSMutableArray *dataArray;
@property (nonatomic, retain) NSMutableArray *array;
@property (nonatomic, retain) NSString *url_mp3;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, retain) NSTimer *timer;
@property (nonatomic, assign) NSInteger page;

@end

@implementation PlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
      self.page = 0;
    [self netWorkWithTid:self.tid];
    // Do any additional setup after loading the view from its nib.
    [self addOther];
    [self addloading];
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(displayTime) userInfo:nil repeats:YES];
    [self getPlayCellData:self.docid];

}

- (void)addOther {
    [self.slider setThumbImage:[UIImage imageNamed:@"slider"] forState:UIControlStateNormal];
    self.slider.maximumValue = 1;
   [self.backButton addTarget:self action:@selector(backUp) forControlEvents:UIControlEventTouchUpInside];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 200, WIDTH, HEIGHT - 200) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"DetailCell" bundle:nil] forCellReuseIdentifier:@"detail"];
    self.tableView.rowHeight = 87;
    self.tableView.separatorStyle = NO;
    [self.view addSubview:self.tableView];
    [_tableView release];
    self.titleLabel.text = self.tname;
    self.photoImage.layer.cornerRadius = 50;
    self.photoImage.layer.masksToBounds = YES;
    self.photoImage.layer.borderColor = [UIColor blackColor].CGColor;
    self.photoImage.layer.borderWidth = 5;
    
}


- (void) addloading {
    [self.tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadFooterView)];
    
    [self.tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(loadheaderView)];
}

- (void)loadFooterView {
    self.page += 20;
    [self netWorkWithTid:self.tid];
    [self.tableView.footer endRefreshing];
}

- (void)loadheaderView {
    [self.dataArray removeAllObjects];
    [self.array removeAllObjects];
    self.page = 0;
    [self netWorkWithTid:self.tid];
    [self.tableView.header endRefreshing];
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        self.dataArray= [NSMutableArray arrayWithCapacity:0];
    }
    return _dataArray;
}

- (NSMutableArray *)array{
    if (!_array) {
        self.array = [NSMutableArray arrayWithCapacity:0];
        
    }
    return _array;
}

- (NSTimer *)timer {
    if (!_timer) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.03 target:self selector:@selector(rotatePlayImageView) userInfo:nil repeats:YES];
    }
    return _timer;
}


- (void)netWorkWithTid:(NSString *)tid  {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[NSString stringWithFormat:@"http://c.m.163.com/nc/article/list/%@/%ld-20.html", tid, self.page] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        for (NSDictionary *dic in responseObject[self.tid]) {
            PlayModel *model = [[PlayModel alloc] init];
            model.docid = dic[@"docid"];
            model.title = dic[@"title"];
            model.imgsrc = dic[@"imgsrc"];
            model.ptime = dic[@"ptime"];
            model.size = dic[@"size"];
            model.source = dic[@"source"];
            model.tname = dic[@"tname"];
            [self.dataArray addObject:model];
            [self.array addObject:dic[@"docid"]];
            [model release];
        }
        [self.tableView reloadData];


    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}


- (void)getPlayCellData:(NSString *)string {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json", nil];
    NSString *url = [NSString stringWithFormat:@"http://c.m.163.com/nc/article/%@/full.html", string];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = responseObject[string];
        NSArray *ar = dic[@"video"];
        NSDictionary *dic1 = ar[0];
        PlayMp3Model *model = [[PlayMp3Model alloc] init];
        model.url_mp4 = dic1[@"url_mp4"];
        model.cover = dic1[@"cover"];
        //给图片赋值
        [self.photoImage sd_setImageWithURL:[NSURL URLWithString:model.cover] placeholderImage:[UIImage imageNamed:@"beijing001"]];
        
      
        [BtnSingleton mainSingleton].audioUrlStr = model.url_mp4;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if ([BtnSingleton mainSingleton].audioUrlStr) {
                //stop 直接调用这个方法, 换掉了上一次的播放网址, 也就是换掉了AVPlayer的avplaitem, 因为AVPlayeritem里面存储着播放网址以及其他的一些信息
                [player stop];
                //在直接调用play 让播放器播放
                [self play:nil];
            }
        });
        
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}


#pragma  mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"detail" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.dataArray[indexPath.row];
    cell.titleLabel.textColor = [UIColor blackColor];
    cell.layer.borderColor = [UIColor colorWithRed:0.9506 green:0.933 blue:0.9452 alpha:1.0].CGColor;
    cell.layer.borderWidth = 2;
    cell.layer.cornerRadius = 5;
    cell.clipsToBounds = YES;
    if (indexPath.row == self.index) {
        cell.titleLabel.textColor = [UIColor redColor];
    }
        return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.index = indexPath.row;
    self.docid = [self.dataArray[indexPath.row] docid];
//    DetailCell *cell = (DetailCell *)[tableView cellForRowAtIndexPath:indexPath];
//    cell.titleLabel.textColor = [UIColor redColor];

    [self getPlayCellData:self.docid];
    
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    DetailCell *cell = (DetailCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.titleLabel.textColor = [UIColor blackColor];
//    [self getPlayCellData:self.docid];
}



- (void)progressMusic:(UISlider *)sender {
    [player.streamer seekToTime:self.slider.value * player.streamer.duration];
    
}


- (void)displayTime {
    self.beginTimeLabel.text = [NSString stringWithFormat:@"%@", player.streamer.currentTime];
    self.allTimeLabel.text = [NSString stringWithFormat:@"%@", player.streamer.totalTime];
    self.slider.value = player.streamer.progress / player.streamer.duration;
//    NSLog(@ "%lf", self.slider.value);
    if (self.slider.value >= 0.998) {
        [self next:nil];
    }
}

//图片转起来
- (void)rotatePlayImageView {
    self.photoImage.transform = CGAffineTransformRotate(self.photoImage.transform, 0.02);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backUp {
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
}


- (void)dealloc {
    [_array release];
    [_dataArray release];
    [_url_mp3 release];
    [_play release];
    [_timer release];
    [_tid release];
    [_docid release];
    [_tname release];
    [_slider release];
    [_backButton release];
    [_tableView release];
    [_titleLabel release];
    [_photoImage release];
    [_allTimeLabel release];
    [_beginTimeLabel release];
    [_playButton release];
    [super dealloc];
}

//播放
- (IBAction)play:(UIButton *)sender {
    if (![BtnSingleton mainSingleton].audioUrlStr) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"网络不佳" message:@"当前播放为空" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        [alert show];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [alert dismissWithClickedButtonIndex:0 animated:YES];
            [alert release];
        });
        return;
    }
    
    if ([player isProcessing]) {
        [player.streamer pause];
        [self.timer invalidate];
        self.timer = nil;
        [_playButton setBackgroundImage:[UIImage imageNamed:@"pause1"] forState:UIControlStateNormal];
        
    } else {
        
        [self rotatePlayImageView];
        [player play];
        [self.timer fire];
        [_playButton setBackgroundImage:[UIImage imageNamed:@"play1"] forState:UIControlStateNormal];
        
        [_slider addTarget:self action:@selector(progressMusic:) forControlEvents:UIControlEventValueChanged];
        
    }
    if (self.dataArray.count != 0) {
        [[DBManager defaultManager] insertObjectWithModel:self.dataArray[self.index]];

    }
    
}

//上一曲
- (IBAction)last:(UIButton *)sender {
    self.index--;
    if (self.index == -1) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"已经是第一曲了" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:otherAction];
        [self presentViewController:alert animated:YES completion:nil];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [alert dismissViewControllerAnimated:YES completion:nil];
        });
        self.index = 0;
        
    }else {
        [player stop];
        self.docid = self.array[self.index];
        [self getPlayCellData:self.docid];
    }
    
    
    
}
//下一曲
- (IBAction)next:(UIButton *)sender {
    if (self.array.count != 0) {
        self.index++;
        if (self.index == self.array.count) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil  message:@"已经是最后一曲了" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alert addAction:otherAction];
            [self presentViewController:alert animated:YES completion:nil];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [alert dismissViewControllerAnimated:YES completion:nil];
            });
            self.index--;
        }else{
            [player stop];
            self.docid = self.array[self.index];
            [self getPlayCellData:self.docid];
        }
    }
    
    
    
}
@end
