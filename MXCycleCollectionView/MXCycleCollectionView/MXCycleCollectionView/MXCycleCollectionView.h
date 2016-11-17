//
//
// 刘智援 2016-11-12
// 简书地址:    http://www.jianshu.com/users/0714484ea84f/latest_articles
// Github地址: https://github.com/lyoniOS
//

#import <UIKit/UIKit.h>
#import "MXCycleItem.h"

@class MXCycleCollectionView;
@protocol MXCycleCollectionViewDelegate <NSObject>

@optional;
/**
 点击轮播图代理方法 刘智援 2016-11-12
 
 @param collectionView 轮播图视图
 @param indexPath      轮播图索引
 @param cycleItem      轮播图模型
 */
- (void)cycleCollectionView:(MXCycleCollectionView *)collectionView
   didSelectItemAtIndexPath:(NSIndexPath *)indexPath
                atCycleItem:(MXCycleItem *)cycleItem;

@end

@interface MXCycleCollectionView : UIView

@property (nonatomic,assign)id<MXCycleCollectionViewDelegate>mxDelegate;
/**轮播图模型数组*/
@property (nonatomic,strong)NSArray <MXCycleItem *>*cycleItems;

/**
 初始化实例方法  刘智援 2016-11-12

 @param frame        设置尺寸
 @param timeInterval 定时器定时滚动时间

 @return MXCycleCollectionView
 */
- (id)initWithFrame:(CGRect)frame timeInterval:(NSInteger)timeInterval;


//请在控制器出现时调用以下方法
//恢复定时器
- (void)resumeTimer;
//请在控制器即将消失时调用以下方法
//停止定时器
- (void)pauseTimer;


@end
