//
//  WKKeyChain.h
//  WOEATAPP-KITCHEN
//
//  Created by Huang Yirong on 16/11/1.
//  Copyright © 2016年 com.woeat-inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WKUserInfo;

@interface WKKeyChain : NSObject

+ (void)save:(NSString *)service data:(id)data;

+ (id)load:(NSString *)service;

+ (void)delete:(NSString *)service;

+(void)saveUserInfo:(NSString *)service userInfo:(WKUserInfo *)userInfo;

+(WKUserInfo *)loadUserInfo:(NSString *)service;

+(void) deleteUserInfo:(NSString *)service;

@end
