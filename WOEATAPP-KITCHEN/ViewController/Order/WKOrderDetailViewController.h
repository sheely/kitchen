//
//  WKOrderDetailViewController.h
//  WOEATAPP-KITCHEN
//
//  Created by Huang Yirong on 16/12/26.
//  Copyright © 2016年 com.woeat-inc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OrderModel;
@interface WKOrderDetailViewController : WKBaseViewController
@property (nonatomic, assign) NSInteger orderType;
@property (nonatomic, strong)OrderModel *model;
@end
