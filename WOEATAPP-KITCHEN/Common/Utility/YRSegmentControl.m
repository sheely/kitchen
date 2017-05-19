//
//  YRSegmentControl.m
//  WOEATAPP-KITCHEN
//
//  Created by Huang Yirong on 16/10/20.
//  Copyright © 2016年 com.woeat-inc. All rights reserved.
//

#import "YRSegmentControl.h"

#define YR_Seg_Btn_Origin_Tag   1000

@interface YRSegmentControl()
{
    BOOL    bIsRedraw;
    UIView  *_bottomLineView;
}
@end

@implementation YRSegmentControl

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor  = [UIColor clearColor];
        _selectedIndex        = -1;
        _fontSize             = 14;
        _selectedColor        = [UIColor redColor];
        _unSelectedColor      = [UIColor blackColor];
        _selectedIndex        = -1;
        _bottomLineViewHeight = 3;
    }
    return self;
}

#pragma mark - UI
- (void)redraw {
    NSArray *subViews = self.subviews;
    
    if (subViews != nil && subViews.count != 0) {
        for(int i = 0;i < subViews.count;i++){
            [[subViews objectAtIndex:i] removeFromSuperview];
        }
    }
    
    if (_bottomLineView != nil) {
        [_bottomLineView removeFromSuperview];
        _bottomLineView = nil;
    }
    
    NSMutableArray *sizeArray = [[NSMutableArray alloc] initWithCapacity:_items.count];
    CGFloat totalWidth        = 0.0;
    
    for (int i = 0; i < _items.count; i++) {
        NSString *item = [_items objectAtIndex:i];
        
        UIFont *textFont;
        if (_fontName == nil || [_fontName isEqualToString:@""]) {
            textFont = [UIFont systemFontOfSize:_fontSize];
        }else {
            textFont = [UIFont fontWithName:_fontName size:_fontSize];
        }
        NSDictionary *attribute = [NSDictionary dictionaryWithObjectsAndKeys:textFont,NSFontAttributeName, nil];
        CGSize contentSize      = [item boundingRectWithSize:CGSizeMake(FLT_MAX, 1) options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil].size;
        
        [sizeArray addObject:[NSValue valueWithCGSize:contentSize]];
        totalWidth += contentSize.width;
    }
    
    CGFloat x              = 0.0;
    CGFloat separatorWidth = 0;
    
    for (int i = 0; i < _items.count; i++) {
        NSString *item = [_items objectAtIndex:i];
        CGFloat width  = (self.frame.size.width - totalWidth - separatorWidth) / _items.count + [[sizeArray objectAtIndex:i] CGSizeValue].width;
        UIButton *itemBtn;
        if (_segmentControlViewBlock != nil) {
            itemBtn = _segmentControlViewBlock(self,i,_items);
        }else {
            itemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            
            [itemBtn setTitle:item forState:UIControlStateNormal];
            [itemBtn setBackgroundImage:nil forState:UIControlStateNormal];
            [itemBtn setTitleColor:_unSelectedColor forState:UIControlStateNormal];
            [itemBtn setTitleColor:_selectedColor forState:UIControlStateSelected];
            
            if (_fontName == nil || [_fontName isEqualToString:@""]) {
                itemBtn.titleLabel.font = [UIFont systemFontOfSize:_fontSize];
            }else {
                itemBtn.titleLabel.font = [UIFont fontWithName:_fontName size:_fontSize];
            }
        }
        
        itemBtn.frame = CGRectMake(x, 0, width, self.frame.size.height);
        itemBtn.tag   = (i + YR_Seg_Btn_Origin_Tag);
        [itemBtn addTarget:self
                    action:@selector(onClick:)
          forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:itemBtn];
    
//        if (i==0) {
//            UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:itemBtn.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerTopLeft cornerRadii:CGSizeMake(3, 3)];
//            CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
//            maskLayer.frame = itemBtn.bounds;
//            maskLayer.path = maskPath.CGPath;
//            itemBtn.layer.mask = maskLayer;
//        }
        
        x += (width-1);
    }
}

#pragma mark - Properties
- (void)setSelectedIndex:(NSInteger)selectedIndex {
    if (_selectedIndex != selectedIndex || bIsRedraw == true) {
        bIsRedraw = false;
        NSArray *viewArray = self.subviews;
        for (int i = 0; i < viewArray.count; i++) {
            UIView *subview = [viewArray objectAtIndex:i];
            if ([subview isKindOfClass:[UIButton class]]) {
                UIButton *btn = (UIButton *)subview;
                if ((btn.tag - YR_Seg_Btn_Origin_Tag) == selectedIndex) {
                    btn.selected  = YES;
                    if (_bottomLineViewColor != nil) {
                        if (!_bottomLineView) {
                            _bottomLineView = [[UIView alloc] init];
                            _bottomLineView.backgroundColor = _bottomLineViewColor;
                            [self addSubview:_bottomLineView];
                        }
                        
                        [self bringSubviewToFront:btn];
                        
                        CGRect viewFrame       = btn.frame;
                        viewFrame.origin.y     = CGRectGetHeight(viewFrame) - _bottomLineViewHeight;
                        viewFrame.size.height  = _bottomLineViewHeight;
                        _bottomLineView.frame  = viewFrame;
                    }
                    
                    if (_selectedBackgroundImgName != nil && ![_selectedBackgroundImgName isEqualToString:@""]) {
                        [btn setBackgroundImage:[UIImage imageNamed:_selectedBackgroundImgName] forState:UIControlStateNormal];
                    }else {
                        [btn setBackgroundImage:nil forState:UIControlStateNormal];
                    }
                }
                else {
                    btn.selected  = NO;
                    if (_unSelectedBackgroundImgName != nil && ![_unSelectedBackgroundImgName isEqualToString:@""]) {
                        [btn setBackgroundImage:[UIImage imageNamed:_unSelectedBackgroundImgName] forState:UIControlStateNormal];
                    }else {
                        [btn setBackgroundImage:nil forState:UIControlStateNormal];
                    }
                }
            }
        }
        
        NSInteger fromIndex = _selectedIndex;
        _selectedIndex = selectedIndex;
        
        if (selectedIndex != -1) {
            if (_delegate && [_delegate respondsToSelector:@selector(onValueChangeFrom:to:)]) {
                [_delegate onValueChangeFrom:fromIndex to:selectedIndex];
            }
        }
    }
}

- (void)setItems:(NSArray *)items {
    _items = items;
    [self redraw];
}

- (void)setFontSize:(CGFloat)fontSize {
    _fontSize = fontSize;
    [self redraw];
    bIsRedraw = true;
    [self setSelectedIndex:_selectedIndex];
}

- (void)setUnSelectedColor:(UIColor *)unSelectedColor {
    _unSelectedColor = unSelectedColor;
    [self redraw];
    bIsRedraw = true;
    [self setSelectedIndex:_selectedIndex];
}

- (void)setSelectedColor:(UIColor *)selectedColor {
    _selectedColor = selectedColor;
    [self redraw];
    bIsRedraw = true;
    [self setSelectedIndex:_selectedIndex];
}

- (void)setSelectedBackgroundImgName:(NSString *)selectedBackgroundImgName {
    _selectedBackgroundImgName = selectedBackgroundImgName;
    [self redraw];
    bIsRedraw = true;
    [self setSelectedIndex:_selectedIndex];
}

- (void)setUnSelectedBackgroundImgName:(NSString *)unSelectedBackgroundImgName {
    _unSelectedBackgroundImgName = unSelectedBackgroundImgName;
    [self redraw];
    bIsRedraw = true;
    [self setSelectedIndex:_selectedIndex];
}

- (void)setBottomLineViewColor:(UIColor *)bottomLineViewColor {
    _bottomLineViewColor = bottomLineViewColor;
    [self redraw];
    bIsRedraw = YES;
    [self setSelectedIndex:_selectedIndex];
}

- (void)setBottomLineViewHeight:(float)bottomLineViewHeight {
    _bottomLineViewHeight = bottomLineViewHeight;
    [self redraw];
    bIsRedraw = YES;
    [self setSelectedIndex:_selectedIndex];
}

- (void)setSegmentControlViewBlock:(YRSegmentControlViewBlock)segmentControlViewBlock {
    _segmentControlViewBlock = segmentControlViewBlock;
    [self redraw];
    bIsRedraw = YES;
    [self setSelectedIndex:_selectedIndex];
}

#pragma mark - Event Response
- (void)onClick:(id)sender {
    UIButton *button = (UIButton *)sender;
    [self setSelectedIndex:(button.tag - YR_Seg_Btn_Origin_Tag)];
}


@end
