//
//  WEGlobalData.h
//  woeat
//
//  Created by liubin on 16/12/20.
//  Copyright © 2016年 liubin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WEModelGetMyKitchen.h"

@interface WEGlobalData : NSObject

@property(nonatomic, strong) NSString *selectedCouponId;
@property(nonatomic, strong) NSString *selectedCouponDesc;
@property(nonatomic, strong) NSArray *orderCommentArray;
@property(nonatomic, strong) NSString *curUserName;
@property(nonatomic, strong) NSString *registerToken;
@property(nonatomic, strong) WEModelGetMyKitchen *cacheMyKitchen;
@property(nonatomic, assign) float myBalance;

+ (instancetype)sharedInstance;
- (NSString *)getUserDir;


+ (void)logOut;
+ (void)logIn;
+ (void)quitBackground;
@end
