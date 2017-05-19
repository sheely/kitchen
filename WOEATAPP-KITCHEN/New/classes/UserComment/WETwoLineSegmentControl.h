//
//  WETwoLineSegmentControl.h
//  WOEATAPP-KITCHEN
//
//  Created by liubin on 17/2/17.
//  Copyright © 2017年 com.woeat-inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WETwoLineSegmentControl : UISegmentedControl

@property(nonatomic, assign) float totalWidth;

- (void)setBottomLineArray:(NSArray *)array superView:(UIView *)superView;
//- (void)valueChanged;
@end
