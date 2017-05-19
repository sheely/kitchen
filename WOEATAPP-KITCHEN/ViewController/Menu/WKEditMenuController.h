//
//  WKEditMenuController.h
//  WOEATAPP-KITCHEN
//
//  Created by tamony on 2016/10/27.
//  Copyright © 2016年 com.woeat-inc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WKMenuModel;
@interface WKEditMenuController : WKBaseViewController
@property (nonatomic, strong)NSArray *images;
@property (nonatomic, strong)WKMenuModel* model;
@property (nonatomic ,assign)NSInteger itemId;
@property (nonatomic, assign) BOOL isAddItem;
@end
