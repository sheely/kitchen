//
//  WKBusinessDayTime.h
//  WOEATAPP-KITCHEN
//
//  Created by 咸菜 on 2016/12/21.
//  Copyright © 2016年 com.woeat-inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WKBusinessDayTime : NSObject

/** 星期 */
@property (nonatomic,copy)NSString *weekday;
@property (nonatomic,copy)NSString *weekdayDisplay;

@property (nonatomic,assign)NSInteger firstTimeId;
@property (nonatomic,assign)NSInteger secondTimeId;


/** 上午营业开门时间 */
@property (nonatomic,assign)NSInteger firstBeginTime;
/** 上午营业关门时间 */
@property (nonatomic,assign)NSInteger firstEndTime;
/** 下午营业开门时间 */
@property (nonatomic,assign)NSInteger secondBeginTime;
/** 下午营业关门时间 */
@property (nonatomic,assign)NSInteger secondEndTime;

@end
