//
//
// 刘智援 2016-11-12
// 简书地址:http://www.jianshu.com/users/0714484ea84f/latest_articles
// Github地址:https://github.com/lyoniOS
//

#import "MXCycleCollectionView.h"
#import "MXCycleCollectionCell.h"
#import "NSTimer+Addition.h"

static NSInteger kTimeInterval = 4;
static NSInteger const kMaxSection = 20;
static NSString *const kCycleCollectionView = @"kCycleCollectionView";

@interface MXCycleCollectionView ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) UIPageControl *pageContol;
@property (nonatomic,weak  ) NSTimer *timer;
@end

@implementation MXCycleCollectionView

#pragma mark - Life Cycle

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame timeInterval:(NSInteger)timeInterval
{
    //设置定时器时间
    if (timeInterval != 0)
        kTimeInterval = timeInterval;

    return [self initWithFrame:frame];
}

- (void)setupUI
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(self.frame.size.width, self.frame.size.height);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.minimumLineSpacing = 0;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) collectionViewLayout:flowLayout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.pagingEnabled   = YES;
    self.collectionView.delegate        = self;
    self.collectionView.dataSource      = self;
    self.collectionView.showsHorizontalScrollIndicator  = NO;
    self.collectionView.showsVerticalScrollIndicator    = NO;
    [self.collectionView registerClass:[MXCycleCollectionCell class] forCellWithReuseIdentifier:kCycleCollectionView];
    [self addSubview:self.collectionView];
    
    //添加点
    self.pageContol = [[UIPageControl alloc] init];
    self.pageContol.currentPageIndicatorTintColor = [UIColor orangeColor];
    self.pageContol.pageIndicatorTintColor = [UIColor whiteColor];
    [self addSubview:self.pageContol];
    
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:kTimeInterval target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    self.timer = timer;
}

#pragma mark - UICollectionViewDataSource
//行数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.cycleItems.count;
}
//组数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return kMaxSection;
}
//行
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MXCycleCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCycleCollectionView forIndexPath:indexPath];
    [cell sizeToFit];
    cell.item = self.cycleItems[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.cycleItems.count == 0) return;

    if ([self.mxDelegate respondsToSelector:@selector(cycleCollectionView:didSelectItemAtIndexPath:atCycleItem:)]) {
        [self.mxDelegate cycleCollectionView:self didSelectItemAtIndexPath:indexPath atCycleItem:self.cycleItems[indexPath.item]];
    }
}

#pragma mark - UIScrollViewDelegate
//当用户即将开始拖拽的时候就调用
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self pauseTimer];
}
//当用户停止拖拽的时候就调用
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self resumeTimer];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int page = (int)(scrollView.contentOffset.x / scrollView.bounds.size.width + 0.5) % self.cycleItems.count;
    self.pageContol.currentPage = page;
}

#pragma mark - Event Response
//下一页
- (void)nextPage
{
    if (self.cycleItems.count == 0) return;
    
    //1.马上显示回最中间那组的数据
    NSIndexPath *currentIndexPathReset = [self resetIndexPath];

    //2.计算出下一个需要展示的位置
    NSInteger nextItem = currentIndexPathReset.item + 1;
    NSInteger nextSection = currentIndexPathReset.section;
    if (nextItem == self.cycleItems.count) {
        nextItem = 0;
        nextSection++;
    }
    NSIndexPath *nextIndexPath = [NSIndexPath indexPathForItem:nextItem inSection:nextSection];
    
    //3.通过动画滚动到下一个位置
    [self.collectionView scrollToItemAtIndexPath:nextIndexPath atScrollPosition:UICollectionViewScrollPositionRight animated:YES];
}

- (NSIndexPath *)resetIndexPath
{
    //当前正在展示的位置
    NSIndexPath *currentIndexPath = [[self.collectionView indexPathsForVisibleItems] lastObject];
    //马上显示回最中间那组的数据
    NSIndexPath *currentIndexPathReset = [NSIndexPath indexPathForItem:currentIndexPath.item inSection:kMaxSection/2];
    [self.collectionView scrollToItemAtIndexPath:currentIndexPathReset atScrollPosition:UICollectionViewScrollPositionRight animated:NO];
    return currentIndexPathReset;
}

#pragma mark - Layout

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.pageContol.frame = CGRectMake((self.frame.size.width-100)/2, self.frame.size.height-20, 100, 20);
}

#pragma mark - Private Method

//启动定时器
- (void)resumeTimer
{
    [self.timer resumeTimerAfterTimeInterval:kTimeInterval];
}

//停止定时器
- (void)pauseTimer
{
    [self.timer pauseTimer];
}

#pragma mark - Getter and Setter

- (void)setCycleItems:(NSArray<MXCycleItem *> *)cycleItems
{
    _cycleItems = cycleItems;
    
    if (cycleItems.count == 0) return;
    
    [self.collectionView reloadData];
    
    self.pageContol.numberOfPages = cycleItems.count;
    
    //默认显示最中间的那组
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:kMaxSection/2] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
}

@end
