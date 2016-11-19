//
// @author 刘智援 2016-11-19
// @简书地址:    http://www.jianshu.com/users/0714484ea84f/latest_articles
// @Github地址: https://github.com/lyoniOS
//

#import "ViewController.h"
#import "MXCycleCollectionView.h"
#import "MXCycleItem.h"

@interface ViewController ()<MXCycleCollectionViewDelegate>
@property (nonatomic,strong)NSMutableArray *cycleItems;
@property (nonatomic,strong)MXCycleCollectionView *cycleCollectionView;

@end

@implementation ViewController

#pragma mark - Life Cycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //视图出现重启定时器
    [self.cycleCollectionView resumeTimer];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //视图消失暂停定时器
    [self.cycleCollectionView pauseTimer];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //数据源
    MXCycleItem *i1 = [[MXCycleItem alloc] init];
    i1.pic = @"testImage";
    i1.link = @"http://www.baidu.com";
    
    MXCycleItem *i2 = [[MXCycleItem alloc] init];
    i2.pic = @"http://hbsnj.keliren.cn/tuku/a/20161104/581c05ccca265.jpg";
    i2.link = @"http://www.baidu.com";
    
    MXCycleItem *i3 = [[MXCycleItem alloc] init];
    i3.pic = @"testImage";
    i3.link = @"http://www.baidu.com";
    
    MXCycleItem *i4 = [[MXCycleItem alloc] init];
    i4.pic = @"http://hbsnj.keliren.cn/tuku/a/20161104/581c05ccca265.jpg";
    i4.link = @"http://www.baidu.com";
    
    [self.cycleItems addObject:i1];
    [self.cycleItems addObject:i2];
    [self.cycleItems addObject:i3];
    [self.cycleItems addObject:i4];
    
    self.cycleCollectionView.cycleItems = self.cycleItems;
    [self.view addSubview:self.cycleCollectionView];
}

#pragma mark - MXCycleCollectionViewDelegate
//选中轮播图代理方法
- (void)cycleCollectionView:(MXCycleCollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath atCycleItem:(MXCycleItem *)cycleItem
{
    NSLog(@"collectionView = %@",collectionView);
    NSLog(@"indexPath = %zd",indexPath.item);
    NSLog(@"cycleItem = %@",cycleItem);
}

#pragma mark - Getter and Setter

- (NSMutableArray *)cycleItems
{
    if (!_cycleItems) {
        _cycleItems = [NSMutableArray array];
    }
    return _cycleItems;
}

- (MXCycleCollectionView *)cycleCollectionView
{
    if (!_cycleCollectionView) {
        //第一种初始化方式
//        _cycleCollectionView = [[MXCycleCollectionView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.width * 0.3) timeInterval:4];
        
        //第二种初始化方式
//        _cycleCollectionView = [[MXCycleCollectionView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.width * 0.3)];
        
        //第三种初始化方式
        _cycleCollectionView = [[MXCycleCollectionView alloc]init];
        _cycleCollectionView.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.width * 0.3);
        _cycleCollectionView.mxDelegate = self;
    }
    return _cycleCollectionView;
}

@end
