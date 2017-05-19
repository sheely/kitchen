//
//  AppDelegate.h
//  WOEATAPP-KITCHEN
//
//  Created by huangyirong on 2016/10/13.
//  Copyright © 2016年 com.woeat-inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;


- (void)selectRootController;
- (void)setRootToHomeController:(UIViewController *)originController;
- (void)setRootToApprovedController;
- (void)setRootToLoginController;
@end

