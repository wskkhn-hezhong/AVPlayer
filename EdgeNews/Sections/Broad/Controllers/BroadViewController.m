//
//  BroadViewController.m
//  EdgeNews
//

//

#import "BroadViewController.h"
#import "RadioCollectionViewCell.h"
#import "HeadOneViewCell.h"
#import "AFNetworking.h"
#import "TitleModel.h"
#import "RadioModel.h"
#import "PlayViewController.h"
#import "DetailViewController.h"

@interface BroadViewController ()<UICollectionViewDelegate , UICollectionViewDataSource>

@property (nonatomic, retain) UICollectionView *collectionView;
@property (nonatomic, retain) NSMutableArray *dataArray;
@property (nonatomic, retain) NSMutableArray *nameArray;
@property (nonatomic, retain) RadioCollectionViewCell *cell;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, assign) NSInteger index;

@end

@implementation BroadViewController
- (void)dealloc
{
    [_cell release];
    [_dataArray release];
    [_tableView release];
    [_collectionView release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.translucent = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.1608 green:0.5647 blue:0.9098 alpha:1.0];

    [self creatCollectionView];
    
    [self netWork];
    
}


- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        self.dataArray = [NSMutableArray arrayWithCapacity:0];
        
    }
    return _dataArray;
}

- (NSMutableArray *)nameArray {
    if (!_nameArray) {
        self.nameArray = [NSMutableArray arrayWithCapacity:0];
        
    }
    return _nameArray;
}










- (void)creatCollectionView {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    //设置item的大小
    flowLayout.itemSize = CGSizeMake((WIDTH - 40) / 3, 190);
    flowLayout.sectionInset = UIEdgeInsetsMake(5, 10, 5, 10);
    flowLayout.minimumInteritemSpacing = 0;
    //
    flowLayout.headerReferenceSize = CGSizeMake(320, 35);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT- 115) collectionViewLayout:flowLayout];
    _collectionView.backgroundColor = [UIColor colorWithRed:0.9506 green:0.933 blue:0.9452 alpha:1.0];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerNib:[UINib nibWithNibName:@"RadioCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"collection"];
    [_collectionView registerNib:[UINib nibWithNibName:@"HeadOneViewCell" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"head"];
    [self.view addSubview:self.collectionView];
    [flowLayout release];
    [_collectionView release];
    
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 3;
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.nameArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    self.cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collection" forIndexPath:indexPath];
    NSInteger num = (indexPath.section) * 3 + indexPath.item;
    
    [_cell setModelToView:self.dataArray[num]];
    _cell.layer.borderColor = [UIColor colorWithRed:0.9506 green:0.933 blue:0.9452 alpha:1.0].CGColor;
    _cell.layer.borderWidth = 1;
    _cell.layer.cornerRadius = 5;
    _cell.clipsToBounds = YES;
    return _cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    HeadOneViewCell *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"head" forIndexPath:indexPath];
    header.layer.borderColor = [UIColor colorWithRed:0.9506 green:0.933 blue:0.9452 alpha:1.0].CGColor;
    header.layer.borderWidth = 2;
    header.clipsToBounds = YES;
    header.layer.cornerRadius = 5;
    header.titleLabel.text = [self.nameArray[indexPath.section] cname];
    
    header.section = indexPath.section;
    [header.joinButton addTarget:self action:@selector(joinToNext:) forControlEvents:UIControlEventTouchUpInside];
    return header;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    PlayViewController *playVC = [[PlayViewController alloc] init];
    NSInteger number = (indexPath.section) * 3 + (indexPath.item);
    playVC.tid = [self.dataArray[number] tid];
    playVC.tname = [self.dataArray[number] source];
    playVC.docid = [self.dataArray[number] docid];
    playVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:playVC animated:YES completion:nil];
}

//点击区头进入下一页

- (void)joinToNext:(UIButton *)sender{
    HeadOneViewCell *head =  (HeadOneViewCell *)sender.superview.superview;
   
    
    DetailViewController *detailVC = [[DetailViewController alloc] init];
    detailVC.name = [self.nameArray[head.section] cname];
    detailVC.cid = [self.nameArray[head.section] cid];
    [self.navigationController pushViewController:detailVC animated:YES];
}











- (void)netWork {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:@"http://c.m.163.com/nc/topicset/ios/radio/index.html" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"JSON: %@", responseObject);
        
        for (NSDictionary *dic  in responseObject[@"cList"]) {
            TitleModel *model = [[TitleModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [self.nameArray addObject:model];
            
            for (NSDictionary *dic1 in model.modelArray) {
                RadioModel *radioModel = [[RadioModel alloc] init];
                radioModel.playCount = dic1[@"playCount"];
                radioModel.tid = dic1[@"tid"];
                NSDictionary *dic2 = dic1[@"radio"];
                radioModel.docid = dic2[@"docid"];
                radioModel.title = dic2[@"title"];
                radioModel.cid = dic2[@"cid"];
                radioModel.tname = dic2[@"tname"];
                radioModel.imgsrc = dic2[@"imgsrc"];
                radioModel.source = dic2[@"source"];
                [self.dataArray addObject:radioModel];
                
                
            }

        }
        [self.collectionView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"Error: %@", error);
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
