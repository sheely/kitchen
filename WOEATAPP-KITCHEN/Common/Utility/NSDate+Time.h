//
//  NSDate+Time.h
//  WOEATAPP-KITCHEN
//
//  Created by Huang Yirong on 16/12/27.
//  Copyright © 2016年 com.woeat-inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Time)
+ (NSString*)weekdayStringFromDate:(NSDate*)inputDate;
+ (NSDate *)dateTomorrow;
+ (NSString *)stringWithDate:(NSDate *)date;
@end
