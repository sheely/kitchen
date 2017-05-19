//
//  WKKitchenSale.h
//  WOEATAPP-KITCHEN
//
//  Created by 咸菜 on 2017/1/7.
//  Copyright © 2017年 com.woeat-inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WKKitchenSale : NSObject

//要做的菜
@property (nonatomic, assign) NSInteger todayCookCount;
//今日订单
@property (nonatomic, assign) NSInteger todayOrderCount;
//明日订单
@property (nonatomic, assign) NSInteger tomorrowOrderCount;
//钱箱总额
@property (nonatomic, assign) CGFloat totalMoney;
//今日营业额
@property (nonatomic, assign) CGFloat todaySales;

@end
