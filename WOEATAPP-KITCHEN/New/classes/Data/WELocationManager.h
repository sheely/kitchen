//
//  WELocationManager.h
//  woeat
//
//  Created by liubin on 17/1/13.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WELocationManager : NSObject

+ (instancetype)sharedInstance;
- (double)getCurrentLatitude;
- (double)getCurrentLongitude;

@end
