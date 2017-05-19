//
//  WEOrderFilterView.h
//  WOEATAPP-KITCHEN
//
//  Created by liubin on 17/2/5.
//  Copyright © 2017年 com.woeat-inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol WEOrderFilterViewDelegate <NSObject>

- (void)okButtonTapped:(UIButton *)button;
- (void)cancelButtonTapped:(UIButton *)button;
@end

@interface WEOrderFilterView : UIView

@property(nonatomic, assign) int check1;
@property(nonatomic, assign) int check2;
@property(nonatomic, assign) int check3;
@property(nonatomic, weak) id<WEOrderFilterViewDelegate> filterDelegate;

- (float)getHeight;
@end
