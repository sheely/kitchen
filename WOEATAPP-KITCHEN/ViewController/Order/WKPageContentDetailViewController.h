//
//  WKPageContentDetailViewController.h
//  WOEATAPP-KITCHEN
//
//  Created by Huang Yirong on 16/12/25.
//  Copyright © 2016年 com.woeat-inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ToCookModel.h"

@interface WKPageContentDetailViewController : UIViewController
@property (nonatomic, copy) NSString *pageTitle;
@property (nonatomic, assign) NSInteger itemId;
@property (nonatomic, strong) ToCookModel * model;
@property (nonatomic, assign) NSInteger BusinessHourId;

@end
