//
// Created by denghua on 13-3-12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

//判断邮箱是否规则
#define IsValidEmail(email)\
[[NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"\\b([a-zA-Z0-9%_.+\\-]+)@([a-zA-Z0-9.\\-]+?\\.[a-zA-Z]{2,6})\\b"] evaluateWithObject:email]

@interface SGAValidatorUtil : NSObject

//检查密码是否达标　６位长.
+ (BOOL)checkPassword:(NSString *)text;

//检查用户名.
+ (BOOL)checkUsername:(NSString *)text;

//检查是否手机号码
+ (BOOL)isMobileNumber:(NSString *)mobileNum;

//检查设备号
+ (BOOL)checkDeviceId:(NSString *)text;


@end