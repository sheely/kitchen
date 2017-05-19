//
//  WEOrderFilterViewOther.h
//  WOEATAPP-KITCHEN
//
//  Created by liubin on 17/2/6.
//  Copyright © 2017年 com.woeat-inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WEOrderFilterViewOtherDelegate <NSObject>

- (void)okButtonTapped:(UIButton *)button;
- (void)cancelButtonTapped:(UIButton *)button;
@end

@interface WEOrderFilterViewOther : UIView

@property(nonatomic, assign) int check1;
@property(nonatomic, assign) int check2;
@property(nonatomic, weak) id<WEOrderFilterViewOtherDelegate> filterDelegate;

- (float)getHeight;
@end
