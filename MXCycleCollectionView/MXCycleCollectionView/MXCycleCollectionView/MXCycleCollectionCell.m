//
// @author 刘智援 2016-11-19
// @简书地址:    http://www.jianshu.com/users/0714484ea84f/latest_articles
// @Github地址: https://github.com/lyoniOS
//

#import "MXCycleCollectionCell.h"
#import "SDWebImage/UIImageView+WebCache.h"
@interface MXCycleCollectionCell ()
@property (nonatomic,strong) UIImageView *iconView;

@end

@implementation MXCycleCollectionCell

#pragma mark - Life Cycle

- (instancetype)init
{
    if (self = [super init]) {
        [self setupUI];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    [self addSubview:self.iconView];
}

#pragma mark - Layout

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.iconView.frame = self.bounds;
}

#pragma mark - Getter and Setter

- (void)setItem:(MXCycleItem *)item
{
    _item = item;
    
    if ([item.pic hasPrefix:@"http://"] || [item.pic hasPrefix:@"https://"]) {
        
        [self.iconView sd_setImageWithURL:[NSURL URLWithString:item.pic] placeholderImage:nil];
        
    }else {
        
        self.iconView.image = [UIImage imageNamed:item.pic];
    }
}

- (UIImageView *)iconView
{
    if (!_iconView) {
        _iconView = [[UIImageView alloc]init];
    }
    return _iconView;
}

@end
