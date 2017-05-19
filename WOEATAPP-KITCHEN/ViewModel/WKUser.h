//
//  WKUser.h
//  WOEATAPP-KITCHEN
//
//  Created by 咸菜 on 2017/1/5.
//  Copyright © 2017年 com.woeat-inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WKUser : NSObject

//id
@property (nonatomic, strong) NSString *userId;
//名
@property (nonatomic, strong) NSString *firstName;
//姓
@property (nonatomic, strong) NSString *familyName;
//头像
@property (nonatomic, strong) NSString *avatarIcon;
//性别
@property (nonatomic, strong) NSString *gender;

@end
