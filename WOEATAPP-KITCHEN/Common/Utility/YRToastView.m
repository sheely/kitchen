//
//  YRToastView.m
//  WOEATAPP-KITCHEN
//
//  Created by huangyirong on 2016/11/4.
//  Copyright © 2016年 com.woeat-inc. All rights reserved.
//

#import "YRToastView.h"

@implementation YRToastView

+(instancetype)shareinstance{
    static YRToastView *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[YRToastView alloc] init];
    });
    return instance;
    
}

+(void)hide{
    if ([YRToastView shareinstance].hud != nil) {
        [[YRToastView shareinstance].hud hide:YES];
    }
}


+(void)show:(NSString *)message inView:(UIView *)view type:(YRToastType)type{
    [self show:message inView:view type:type customImgView:nil];
}


+(void)showMessage:(NSString *)msg inView:(UIView *)view{
    [self show:msg inView:view type:YRToastTypeOnlyText];
    [[YRToastView shareinstance].hud hide:YES afterDelay:1.0];
}

+(void)showMessage:(NSString *)msg inView:(UIView *)view afterDelayTime:(NSInteger)delay{
    [self show:msg inView:view type:YRToastTypeOnlyText];
    [[YRToastView shareinstance].hud hide:YES afterDelay:delay];
}

+(void)showSuccess:(NSString *)msg inview:(UIView *)view{
    [self show:msg inView:view type:YRToastTypeSuccess];
    [[YRToastView shareinstance].hud hide:YES afterDelay:1.0];
}


+(void)showProgress:(NSString *)msg inView:(UIView *)view{
    [self show:msg inView:view type:YRToastTypeLoading];
}

+(MBProgressHUD *)showProgressCircle:(NSString *)msg inView:(UIView *)view{
    if (view == nil) view = (UIView*)[UIApplication sharedApplication].delegate.window;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.labelText = msg;
    return hud;
}


+(void)showMsgWithoutView:(NSString *)msg{
    UIWindow *view = [[UIApplication sharedApplication].windows lastObject];
    [self show:msg inView:view type:YRToastTypeOnlyText];
    [[YRToastView shareinstance].hud hide:YES afterDelay:1.0];
}

+(void)showCustomAnimation:(NSString *)msg withImgArry:(NSArray *)imgArry inview:(UIView *)view{
    
    UIImageView *showImageView = [[UIImageView alloc] init];
    
    showImageView.animationImages = imgArry;
    [showImageView setAnimationRepeatCount:0];
    [showImageView setAnimationDuration:(imgArry.count + 1) * 0.075];
    [showImageView startAnimating];
    
    [self show:msg inView:view type:YRToastTypeCustomAnimation customImgView:showImageView];
        [[YRToastView shareinstance].hud hide:YES afterDelay:8.0];
    
    
}


+(void)show:(NSString *)msg inView:(UIView *)view type:(YRToastType)type customImgView:(UIImageView *)customImgView{
    if ([YRToastView shareinstance].hud != nil) {
        [[YRToastView shareinstance].hud hide:YES];
        [YRToastView shareinstance].hud = nil;
    }
    if ([UIScreen mainScreen].bounds.size.height == 480) {
        [view endEditing:YES];
    }
    
    [YRToastView shareinstance].hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    //是否显示透明背景
    //[YRToastView shareinstance].hud.dimBackground = YES;
    //调两个颜色
    [YRToastView shareinstance].hud.color = [UIColor blackColor];
    [YRToastView shareinstance].hud.labelColor = [UIColor whiteColor];
    [[YRToastView shareinstance].hud setMargin:10];
    [[YRToastView shareinstance].hud setRemoveFromSuperViewOnHide:YES];
    [YRToastView shareinstance].hud.detailsLabelText = msg;
    [YRToastView shareinstance].hud.detailsLabelFont = [UIFont systemFontOfSize:14];
    switch ((NSInteger)type) {
        case YRToastTypeOnlyText:
            [YRToastView shareinstance].hud.mode = MBProgressHUDModeText;
            break;
        case YRToastTypeLoading:
            [YRToastView shareinstance].hud.mode = MBProgressHUDModeIndeterminate;
            break;
        case YRToastTypeSuccess:
            [YRToastView shareinstance].hud.mode = MBProgressHUDModeCustomView;
            [YRToastView shareinstance].hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"success"]];
            break;
        default:
            break;
    }
}





@end
