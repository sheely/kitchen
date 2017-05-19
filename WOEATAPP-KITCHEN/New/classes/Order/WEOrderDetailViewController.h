//
//  WEOrderDetailViewController.h
//  WOEATAPP-KITCHEN
//
//  Created by liubin on 17/2/7.
//  Copyright © 2017年 com.woeat-inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WEOrderDetailViewController : UIViewController

@property(nonatomic, strong) NSString *orderId;
@property(nonatomic, weak) UIViewController *parentController;
@end
