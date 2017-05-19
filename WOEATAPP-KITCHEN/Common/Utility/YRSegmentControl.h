//
//  YRSegmentControl.h
//  WOEATAPP-KITCHEN
//
//  Created by Huang Yirong on 16/10/20.
//  Copyright © 2016年 com.woeat-inc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YRSegmentControl;

typedef UIButton * (^YRSegmentControlViewBlock) (YRSegmentControl *segmentControl,NSInteger btnIndex,NSArray *itemArray);

@protocol YRSegmentControlDelegate <NSObject>

- (void)onValueChangeFrom:(NSInteger)fromIndex to:(NSInteger)toIndex;

@end

@interface YRSegmentControl : UIControl
@property (nonatomic, assign) id<YRSegmentControlDelegate > delegate;

/**
 *@description 自定义每一项视图
 */
@property (nonatomic, copy  ) YRSegmentControlViewBlock segmentControlViewBlock;

/**
 *@description 每一项的内容
 */
@property (nonatomic, strong) NSArray                   *items;

/**
 *@description 当前选中下标
 */
@property (nonatomic, assign) NSInteger                 selectedIndex;

/**
 *@description 选中文字颜色
 */
@property (nonatomic, strong) UIColor                   *selectedColor;

/**
 *@description 未选中文字颜色
 */
@property (nonatomic, retain) UIColor                   *unSelectedColor;

/**
 *@description 文本字体大小
 */
@property (nonatomic, assign) CGFloat                   fontSize;

/**
 *@description 文本字体类型名
 */
@property (nonatomic, strong) NSString                  *fontName;

/**
 *@description 选中时的背景图片名
 */
@property (nonatomic, strong) NSString                  *selectedBackgroundImgName;

/**
 *@description 未选中时的背景图片名
 */
@property (nonatomic, strong) NSString                  *unSelectedBackgroundImgName;

/**
 *@description 底下线条颜色
 */
@property (nonatomic, strong) UIColor                   *bottomLineViewColor;

/**
 *@description 底下线条高度，默认3
 */
@property (nonatomic,assign ) float                     bottomLineViewHeight;

@end
