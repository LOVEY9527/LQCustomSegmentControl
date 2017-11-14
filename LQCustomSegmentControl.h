//
//  LQCustomSegmentControl.h
//  LQEachOnlineManager
//
//  Created by 李勇 on 2017/8/7.
//  Copyright © 2017年 Lynn. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SegmentTapBlock)(NSInteger tapIndex, void(^completeBlock)());

@interface LQCustomSegmentControl : UIView

@property (assign, nonatomic) NSInteger selectedSegmentIndex;
//圆角
@property (assign, nonatomic) CGFloat cornerRadius;
//字体
@property (strong, nonatomic) UIFont *textFont;


/**
 *  @author liyong
 *
 *  初始化接口
 *
 *  @param frame             尺寸大小
 *  @param contentDataSource 内容数据源
 *  @param tapBlock          点击的block
 *
 *  @return 初始化的对象
 */
- (instancetype)initWithFrame:(CGRect)frame
            contentDataSource:(NSArray <NSString *> *)contentDataSource
                     tapBlock:(SegmentTapBlock)tapBlock;

@end
