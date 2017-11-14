//
//  LQCustomSegmentControl.m
//  LQEachOnlineManager
//
//  Created by 李勇 on 2017/8/7.
//  Copyright © 2017年 Lynn. All rights reserved.
//

#import "LQCustomSegmentControl.h"

static CGFloat animationDuring = 0.7;

@interface LQCustomSegmentControl()

@property (assign, nonatomic) CGFloat contentDefineWidth;
@property (copy, nonatomic) SegmentTapBlock tapBlock;
@property (assign, nonatomic) NSInteger currentIndex;
@property (strong, nonatomic) NSMutableArray <UILabel *>* contentArray;

@property (strong, nonatomic) UIView *indexView;
@property (strong, nonatomic) UILabel *currentLabel;

@end

@implementation LQCustomSegmentControl

/**
 *  @author liyong
 *
 *  初始化接口
 *
 *  @param frame             尺寸大小
 *  @param contentDataSource 内容数据源
 *  @param tapBlock          点击的block
 *
 *  @return
 */
- (id)initWithFrame:(CGRect)frame
  contentDataSource:(NSArray <NSString *> *)contentDataSource
           tapBlock:(SegmentTapBlock)tapBlock
{
    self = [super initWithFrame:frame];
    if ((self) && ([contentDataSource count] > 0))
    {
        self.tapBlock = tapBlock;
        [self buildViewWithContentDataSource:contentDataSource];
        
        return self;
    }else{
        return nil;
    }
}

- (void)setCornerRadius:(CGFloat)cornerRadius
{
    self.layer.cornerRadius = cornerRadius;
    self.indexView.layer.cornerRadius = cornerRadius;
}

- (void)setTextFont:(UIFont *)textFont
{
    [self.contentArray enumerateObjectsUsingBlock:^(UILabel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.font = textFont;
    }];
}

- (void)setSelectedSegmentIndex:(NSInteger)selectedSegmentIndex
{
    [self goToIndex:selectedSegmentIndex];
}

- (NSInteger)selectedSegmentIndex
{
    return self.currentIndex;
}

/**
 *  @author liyong
 *
 *  构建界面
 *
 *  @param contentDataSource
 */
- (void)buildViewWithContentDataSource:(NSArray <NSString *> *)contentDataSource
{
    //自我属性
    self.backgroundColor = UIColorFromRGB(0xdbdbdb);
    self.layer.masksToBounds = YES;
    
    self.contentDefineWidth = self.width / contentDataSource.count;
    CGFloat height = self.height;
    self.contentArray = [NSMutableArray arrayWithCapacity:0];
    //标签
    [contentDataSource enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(idx * self.contentDefineWidth, 0, self.contentDefineWidth, height)];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        if (idx == 0)
        {
            label.textColor = UIColorFromRGB(0Xffffff);
            self.currentLabel = label;
        }else{
            label.textColor = UIColorFromRGB(0x000000);
        }
        label.font = [UIFont customSystemFontOfSize:16.0];
        label.text = obj;
        [self addSubview:label];
        [self.contentArray addObject:label];
    }];
    
    //指示器
    self.indexView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.contentDefineWidth, height)];
//    self.indexView.center = CGPointMake(self.currentLabel.center.x, self.indexView.center.y);
    self.indexView.backgroundColor = UIColorFromRGB(0XFF9203);
    self.indexView.layer.masksToBounds = YES;
    [self addSubview:self.indexView];
    [self sendSubviewToBack:self.indexView];
    
    //点击手势
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                           action:@selector(tapClick:)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    tapGestureRecognizer.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:tapGestureRecognizer];
}

/**
 *  @author liyong
 *
 *  点击事件
 *
 *  @param tapGestureRecognizer
 */
- (void)tapClick:(UITapGestureRecognizer *)tapGestureRecognizer
{
    CGPoint locationPoint = [tapGestureRecognizer locationInView:self];
    NSInteger locationIndex = locationPoint.x / self.contentDefineWidth;
    [self goToIndex:locationIndex];
}

/**
 跳转指定序号

 @param locationIndex 
 */
- (void)goToIndex:(NSInteger)locationIndex
{
    if ((locationIndex != self.currentIndex) && (locationIndex < [self.contentArray count]))
    {
        if (self.tapBlock)
        {
            __weak typeof(self) weakSelf = self;
            self.tapBlock(locationIndex, ^{
                UILabel *goalLabel = [weakSelf.contentArray objectAtIndex:locationIndex];
                weakSelf.currentLabel.textColor = UIColorFromRGB(0x000000);
                goalLabel.textColor = UIColorFromRGB(0Xffffff);
                weakSelf.currentLabel = goalLabel;
                [UIView animateWithDuration:animationDuring
                                      delay:0
                     usingSpringWithDamping:0.4
                      initialSpringVelocity:0
                                    options:UIViewAnimationOptionCurveLinear
                                 animations:^{
                                     weakSelf.indexView.center = CGPointMake(goalLabel.center.x, weakSelf.indexView.center.y);
                                 } completion:^(BOOL finished) {
                                     
                                 }];
                weakSelf.currentIndex = locationIndex;
            });
        }
    }
}

@end
