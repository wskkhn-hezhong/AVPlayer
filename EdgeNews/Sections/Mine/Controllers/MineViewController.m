//
//  MineViewController.m
//  EdgeNews
//

#import "MineViewController.h"
#import "BtnSingleton.h"
#import "UIImageView+WebCache.h"
#import "MyViewController.h"
#import "HistoryViewController.h"


@interface MineViewController ()<UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) UIButton *button1;
@property (nonatomic,retain) UILabel *contentLabel;

@end

@implementation MineViewController
- (void)dealloc
{
    [_button1 release];
    [_contentLabel release];
    [_tableView release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.1608 green:0.5647 blue:0.9098 alpha:1.0];

    self.navigationController.navigationBar.translucent = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    // Do any additional setup after loading the view.
    [self loadTableView];
}


- (UILabel *)contentLabel{
    if (!_contentLabel) {
        self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
        _contentLabel.textColor =[UIColor lightGrayColor];
        _contentLabel.adjustsFontSizeToFitWidth = YES;
        [_contentLabel release];
    }
    return _contentLabel;
}

- (void)loadTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0, WIDTH, HEIGHT - 113) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 57;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 180)];
    imageView.image = [UIImage imageNamed:@"beijing1"];
    imageView.userInteractionEnabled = YES;
    self.tableView.tableHeaderView = imageView;
    self.tableView.tableFooterView = [[UIView new] autorelease];
    self.button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    _button1.frame = CGRectMake(WIDTH  / 2 - 40, 50, 80, 80);
    _button1.layer.cornerRadius = 40;
    _button1.clipsToBounds = YES;
    [_button1 setImage:[UIImage imageNamed:@"beijing001"] forState:UIControlStateNormal];
    [_button1 addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_tableView];
    [_tableView release];

    [imageView addSubview:_button1];
    [imageView release];

    
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
        return 2;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    if (indexPath.section == 0 && indexPath.row == 0) {
        cell.imageView.image = [UIImage imageNamed:@"beijing"];
        cell.textLabel.text = @"清除缓存";
        cell.accessoryView = self.contentLabel;
    }
    
    
    if (indexPath.section == 1 && indexPath.row == 0) {
        cell.imageView.image = [UIImage imageNamed:@"beijing"];
        cell.textLabel.text = @"非Wifi状态下播放视频";
        UISwitch *loadSweth = [[UISwitch alloc] init];
        [loadSweth addTarget:self action:@selector(handleLoadImgButton:) forControlEvents:UIControlEventValueChanged];
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"loadVideo"]) {
            [loadSweth setOn:YES];
        }
        loadSweth.onTintColor = [UIColor greenColor];
        cell.accessoryView = loadSweth;
        [loadSweth release];
    }
    //夜间模式
    if (indexPath.section == 1 && indexPath.row == 1) {
        cell.imageView.image = [UIImage imageNamed:@"57"];
        cell.textLabel.text = @"夜间模式";
        UISwitch *nightButton = [[UISwitch alloc] init];
        [nightButton addTarget:self action:@selector(clickNightButton:) forControlEvents:UIControlEventValueChanged];
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"night"]) {
            [nightButton setOn:YES];
        }
        nightButton.onTintColor = [UIColor redColor];
        cell.accessoryView = nightButton;
        [nightButton release];
    }
    
    if (indexPath.section == 2 && indexPath.row == 0) {
        cell.imageView.image = [UIImage imageNamed:@"57"];
        cell.textLabel.text = @"联系我们";
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width / 7 * 3, 38)];
        label.text = @"QQ:757201604";
        label.textAlignment = NSTextAlignmentRight;
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = [UIColor lightGrayColor];
        cell.accessoryView = label;
        [label release];
    }
    
    if (indexPath.section == 2 && indexPath.row == 1) {
        cell.imageView.image = [UIImage imageNamed:@"57"];
        cell.textLabel.text = @"关于我们";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.imageView.layer.cornerRadius = 27.5;
    cell.imageView.clipsToBounds = YES;
    cell.layer.borderColor = [UIColor colorWithRed:0.9506 green:0.933 blue:0.9452 alpha:1.0].CGColor;
    cell.layer.borderWidth = 2;
    cell.layer.cornerRadius = 5;
    cell.clipsToBounds = YES;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 0 ) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"清除缓存" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertView.alertViewStyle = UIAlertViewStyleDefault;
        alertView.delegate = self;
        [alertView show];
        [self.view addSubview:alertView];
        [alertView release];
    }
//    if (indexPath.section == 0 && indexPath.row == 1) {
//        HistoryViewController *historyVC = [[HistoryViewController alloc] init];
//        UINavigationController *naVC =[[UINavigationController alloc] initWithRootViewController:historyVC];
//        naVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
//        [self presentViewController:naVC animated:YES completion:nil];
//        [historyVC release];
//        [naVC release];
//    
//    }
    if (indexPath.section == 2 && indexPath.row == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"敬请你给我们发来意见" message:@"我们的公众邮箱是wskkhn123@126.com" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [alertView dismissWithClickedButtonIndex:0 animated:YES];
        });
        [alertView release];
    }
    if (indexPath.section == 2 && indexPath.row == 1) {
        MyViewController *myVC = [[MyViewController alloc] init];
        [self.navigationController pushViewController:myVC animated:YES];
        [myVC release];
    }
}

- (void)handleLoadImgButton:(UISwitch *)sender {
    if ([sender isOn]) {
        [BtnSingleton mainSingleton].loadVideo = YES;
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"loadVideo"];
        
    }else {
        [BtnSingleton mainSingleton].loadVideo = NO;
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"loadVideo"];
    }
}

- (void)clickNightButton:(UISwitch *)sender {
    if ([sender isOn]) {
        self.view.window.alpha = 0.6;
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"night"];
    }else {
        self.view.window.alpha = 1;
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"night"];
    }
}

- (void)clickButton:(UIButton *)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相机选择",@"拍照", nil];
    [actionSheet showInView:self.view];
    [actionSheet release];
}
#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            //相机选择
            [self readImageFromAlbum];
            break;
            
            case 1:
            //拍照
            [self readImageFromCamera];
            break;
        default:
            break;
    }
}
//从相册读取图片
- (void)readImageFromAlbum {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;//从相册选取照片
    imagePicker.delegate = self;//制动代理
    imagePicker.allowsEditing = YES;//允许用户编辑
    
    [self presentViewController:imagePicker animated:YES completion:nil];//显示相册
    [imagePicker release];
}

//拍照
- (void)readImageFromCamera {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.allowsEditing = YES;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        imagePicker.delegate = self;
        [self presentViewController:imagePicker animated:YES completion:nil];
        [imagePicker release];
    }else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"警告" message:@"未检测到摄像头" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:otherAction];
        [self presentViewController:alert animated:YES completion:nil];

        
    }
}

//图片编辑完成之后触发, 显示图片在button上
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary<NSString *,id> *)editingInfo{
    [self.button1 setImage:image forState:UIControlStateNormal];
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (NSString *)_getCatch {
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    return path;
}

//路径文件

- (CGFloat)_folderSizeAtPath:(NSString *)folderPath {
    NSFileManager *manager = [NSFileManager defaultManager];
    folderPath = [self _getCatch];
    if (![manager fileExistsAtPath:folderPath]) {
        return 0;
    }
    NSEnumerator *childfilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString *fileName = nil;
    long long folderSize = 0;
    while ((fileName = [childfilesEnumerator nextObject]) != nil) {
        NSString *fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        float singleFireSize = 0.0;
        if ([manager fileExistsAtPath:fileAbsolutePath]) {
            singleFireSize = [[manager attributesOfItemAtPath:fileAbsolutePath error:nil] fileSize];
            
        }
        folderSize += singleFireSize;
    }
    return folderSize;
}
//清除指定文件夹
- (void)_clearCache:(NSString *)floderPath {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //遍历文件夹
    if ([fileManager fileExistsAtPath:floderPath]) {
        NSArray *childerFiles = [fileManager subpathsAtPath:floderPath];
        for (NSString *fileName in childerFiles) {
            NSString *absoultePath = [floderPath stringByAppendingPathComponent:fileName];
            [fileManager removeItemAtPath:absoultePath error:nil];
        }
    }
    [[SDImageCache sharedImageCache] cleanDisk];
}
//视图将要出现时
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    NSString *path = [self _getCatch];
    CGFloat cacheSize = [self _folderSizeAtPath:path] / 1024.0 / 1024.0;
    self.contentLabel.text = [NSString stringWithFormat:@"%0.1lfMB", cacheSize];
    self.tabBarController.tabBar.hidden = NO;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        return;
    } else {
        NSString *cachePath = [self _getCatch];
        [self _clearCache:cachePath];
        self.contentLabel.text = @"0.0MB";
    }
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
