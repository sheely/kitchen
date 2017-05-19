//
//  WKUserInfo.h
//  WOEATAPP-KITCHEN
//
//  Created by Huang Yirong on 16/11/1.
//  Copyright © 2016年 com.woeat-inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WKUserInfo : NSObject

/** Access Token凭证 */
@property (nonatomic,copy)NSString *accessToken;

/** Access Token类型 */
@property (nonatomic,copy)NSString *tokenType;

/** Access Token的失效期 */
@property (nonatomic,copy)NSDate *expirationDate;

/** 用户 userId */
@property (nonatomic,copy)NSString *userId;

/** 用户昵称 */
@property (nonatomic,copy)NSString *nickName;

/** 用户性别 */
@property (nonatomic,copy)NSString *gender;

/** 用户头像 */
@property (nonatomic,copy)NSString *avatar;

/** 用户手机号 */
@property (nonatomic,copy)NSString *mobilNum;

/** 用户验证码 */
@property (nonatomic,copy)NSString *securityCode;

@property (nonatomic,copy)NSString *displayName;
@property (nonatomic,copy)NSString *birthDay;
@property (nonatomic,copy)NSString *userName;
@property (nonatomic,copy)NSString *firstName;
@property (nonatomic,copy)NSString *lastName;

@property (nonatomic,assign)NSInteger KitchenId;
@property (nonatomic,copy)NSString *PortraitImageUrl;
@property (nonatomic,copy)NSString *State;
@property (nonatomic,copy)NSString *City;
@property (nonatomic,copy)NSString *InspectionStatus;
@property (nonatomic,copy)NSString *AddressLine1;
@property (nonatomic,copy)NSString *AddressId;



@end
