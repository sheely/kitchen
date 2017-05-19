//
//  WETwoLineSegmentControl.m
//  WOEATAPP-KITCHEN
//
//  Created by liubin on 17/2/17.
//  Copyright © 2017年 com.woeat-inc. All rights reserved.
//

#import "WETwoLineSegmentControl.h"

#define TAG_LABEL_START 1000


@implementation WETwoLineSegmentControl

-(instancetype)initWithItems:(NSArray *)items
{
    self = [super initWithItems:items];
    NSMutableParagraphStyle* style;
    style = [[NSMutableParagraphStyle alloc] init];
    NSDictionary *attr = [NSDictionary dictionaryWithObjectsAndKeys:
                          [UIFont systemFontOfSize:15], NSFontAttributeName,
                          style, NSParagraphStyleAttributeName,
                          nil];
    [self setTitleTextAttributes:attr forState:UIControlStateNormal];
    self.tintColor = UICOLOR(139, 133, 101);
    self.selectedSegmentIndex = 0;
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [UIFont boldSystemFontOfSize:13], NSFontAttributeName,
                                self.tintColor, NSForegroundColorAttributeName,
                                nil];
    [self setTitleTextAttributes:attributes forState:UIControlStateNormal];
    NSDictionary *highlightedAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    [self setTitleTextAttributes:highlightedAttributes forState:UIControlStateSelected];
    
    [self setContentPositionAdjustment:UIOffsetMake(0, -7)
                        forSegmentType:UISegmentedControlSegmentAny
                            barMetrics:UIBarMetricsDefault];
    
    
    
    
    return self;
}

- (void)setBottomLineArray:(NSArray *)array superView:(UIView *)superView
{
    for(UIView *v in superView.subviews) {
        if ([v isKindOfClass:[UILabel class]] &&
             v.tag >= TAG_LABEL_START &&
             v.tag <= TAG_LABEL_START+4) {
                [v removeFromSuperview];
             }
    }
     
    float w = _totalWidth / array.count;
    for(int i=0; i<array.count; i++) {
        UILabel *label = [UILabel new];
        label.textColor = UICOLOR(245, 45, 33);
        label.font = [UIFont boldSystemFontOfSize:12];
        label.tag = TAG_LABEL_START+i;
        label.textAlignment = NSTextAlignmentCenter;
        [superView addSubview:label];
        [label makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.bottom).offset(-3);
            make.left.equalTo(self.left).offset(w*i);
            make.width.equalTo(w);
            make.height.equalTo(label.font.pointSize+1);
        }];
        label.text = array[i];
    }
    
}

//- (void)valueChanged
//{
//    for(UIView *v in self.subviews) {
//        if ([v isKindOfClass:[UILabel class]] &&
//            v.tag >= TAG_LABEL_START &&
//            v.tag <= TAG_LABEL_START+4) {
//            [self bringSubviewToFront:v];
//        }
//    }
//}
@end
