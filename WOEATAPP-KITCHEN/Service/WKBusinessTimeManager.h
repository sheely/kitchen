//
//  WKBusinessTimeManager.h
//  WOEATAPP-KITCHEN
//
//  Created by Huang Yirong on 16/12/27.
//  Copyright © 2016年 com.woeat-inc. All rights reserved.
//

#import <Foundation/Foundation.h>

//@class WKBusinessDayTime;
@interface WKBusinessTimeManager : NSObject

+ (WKBusinessTimeManager *)sharedManager;
- (void)fetchBussinessTime;
- (NSMutableArray *)getBussinessTime;

@end
