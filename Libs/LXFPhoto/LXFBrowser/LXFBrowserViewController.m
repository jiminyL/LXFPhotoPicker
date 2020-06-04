//
//  LXFBrowserViewController.m
//  KDSLife
//
//  Created by PChome on 2017/3/22.
//
//

#import "LXFBrowserViewController.h"
#import "LXFBrowserCollectionViewCell.h"

@interface LXFBrowserViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UILabel *indexLabel;

@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, strong) NSArray *photosArr;
@property (nonatomic, strong) NSArray *thumbArr;

@property (nonatomic, assign) BOOL isHideNaviBar;

@property (nonatomic, assign) NSInteger initIndex;


@end

@implementation LXFBrowserViewController

- (instancetype)initWithPhotosArr:(NSArray *)photosArr andThumbArr:(NSArray *)thumbArr andIndex:(NSInteger)index
{
    self = [super init];
    if (self) {
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        self.modalPresentationStyle = 0;
        if (photosArr) {
            self.photosArr = [NSArray arrayWithArray:photosArr];
        }
        if (thumbArr) {
            self.thumbArr = [NSArray arrayWithArray:thumbArr];
        }
        self.initIndex = index;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configCollectionView];
    [self configIndexLabel];
    
    __weak typeof(self) mself = self;
//    [RACObserve(self, initIndex) subscribeNext:^(id  _Nullable x) {
//        [mself.indexLabel setText:[NSString stringWithFormat:@"%ld/%ld", (long)mself.initIndex + 1, (long)mself.photosArr.count]];
//    }];
//    [RACObserve(self, currentIndex) subscribeNext:^(id  _Nullable x) {
//        [mself.indexLabel setText:[NSString stringWithFormat:@"%ld/%ld", (long)mself.currentIndex + 1, (long)mself.photosArr.count]];
//    }];
}

- (void)viewWillAppear:(BOOL)animated
{
//    [UIApplication sharedApplication].statusBarHidden = YES;
    
    if (self.photosArr.count > self.initIndex) {
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.initIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionRight animated:NO];
    }
}

- (void)configCollectionView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width , self.view.frame.size.height) collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor blackColor];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.pagingEnabled = YES;
    self.collectionView.scrollsToTop = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.contentOffset = CGPointMake(0, 0);
    self.collectionView.contentSize = CGSizeMake(self.view.frame.size.width * self.photosArr.count, self.view.frame.size.height);
        
    [self.view addSubview:_collectionView];
    [_collectionView registerClass:[LXFBrowserCollectionViewCell class] forCellWithReuseIdentifier:@"LXFBrowserCollectionViewCell"];
}

- (void)configIndexLabel
{
    self.indexLabel = [[UILabel alloc] init];
    NSString *str = [NSString stringWithFormat:@"%ld/%ld", (long)self.initIndex + 1, (long)self.photosArr.count];
    UIFont *font = [UIFont boldSystemFontOfSize:17.f];
    [self.indexLabel setFrame:CGRectMake(0.f, 0.f, self.view.frame.size.width, 40.f)];
    [self.indexLabel setBackgroundColor:[UIColor clearColor]];
    [self.indexLabel setTextColor:[UIColor whiteColor]];
    [self.indexLabel setFont:font];
    [self.indexLabel setTextAlignment:NSTextAlignmentCenter];
    [self.indexLabel setText:str];
    [self.view addSubview:self.indexLabel];
}

#pragma mark - currentMethod
- (void)back
{
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint offSet = scrollView.contentOffset;
    self.currentIndex = offSet.x / self.view.frame.size.width;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.photosArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LXFBrowserCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LXFBrowserCollectionViewCell" forIndexPath:indexPath];
    cell.masterViewController = self;
    
    __weak typeof(self) mself = self;
    cell.singleTapGestureBlock = ^(){
        [mself back];
    };

    id image = self.photosArr[indexPath.item];
    if ([image isKindOfClass:[UIImage class]]) {
        [cell setImage:image];
    }else if ([image isKindOfClass:[NSString class]]) {
        NSString *urlStr = self.photosArr[indexPath.item];
        NSString *thumbStr = self.thumbArr[indexPath.item];
        
        [cell setUrlStr:urlStr andThumbStr:thumbStr];
    }
    
    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
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
