//
//  WKEvaluate.h
//  WOEATAPP-KITCHEN
//
//  Created by 咸菜 on 2016/12/11.
//  Copyright © 2016年 com.woeat-inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WKEvaluate : NSObject

@property (nonatomic,copy)NSString *evaluateId;

@property (nonatomic,copy)NSString *userName;

@property (nonatomic,copy)NSString *userAvatar;

@property (nonatomic,copy)NSString *userAvatarID;

@property (nonatomic,copy)NSString *replyMessage;

@property (nonatomic,copy)NSString *objectId;

@property (nonatomic,copy)NSString *objectType;

@property (nonatomic,copy)NSString *fromUserId;

/*评论好坏等级*/
@property (nonatomic,copy)NSString *type;

@property (nonatomic,copy)NSString *message;

@property (nonatomic,copy)NSString *createTime;

@end
