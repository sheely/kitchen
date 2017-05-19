//
//  YRToastView.h
//  WOEATAPP-KITCHEN
//
//  Created by huangyirong on 2016/11/4.
//  Copyright © 2016年 com.woeat-inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MBProgressHUD/MBProgressHUD.h>

typedef enum{
    YRToastTypeOnlyText=10,           //只显示文字
    YRToastTypeLoading,              //转菊花..
    YRToastTypeCircleLoading,        //加载圆圈
    YRToastTypeCustomAnimation,      //加载动画 
    YRToastTypeSuccess               //成功
    
}YRToastType;

@interface YRToastView : NSObject

@property (nonatomic,strong) MBProgressHUD  *hud;

+(instancetype)shareinstance;


+(void)hide;
+(void)show:(NSString *)message inView:(UIView *)view type:(YRToastType)type;
+(void)showMessage:(NSString *)msg inView:(UIView *)view;
+(void)showMessage:(NSString *)msg inView:(UIView *)view afterDelayTime:(NSInteger)delay;
+(MBProgressHUD *)showProgressCircle:(NSString *)msg inView:(UIView *)view;
+(void)showProgress:(NSString *)msg inView:(UIView *)view;
+(void)showSuccess:(NSString *)msg inview:(UIView *)view;
+(void)showMsgWithoutView:(NSString *)msg;
+(void)showCustomAnimation:(NSString *)msg withImgArry:(NSArray *)imgArry inview:(UIView *)view;

@end
