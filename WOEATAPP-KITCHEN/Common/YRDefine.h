//
//  X1Define.h
//  X1
//
//  Created by zhangdan on 14-2-7.
//  Copyright (c) 2014年 sogou-inc.com. All rights reserved.
//

#define kYRAppErrorDomain           @"kYRAppErrorDomain"
#define kNoNetWorkingErrorCode      601

#define kAPPSecurityStoreKey @"woeatapp_kitchen_app_kc"
#define kTokenTypeKey @"woeatapp_kitchen_app_kc_tokenType"

#define kTokenKey @"woeatapp_kitchen_app_kc_accessToken"
#define kKitchenIdKey @"woeatapp_kitchen_app_kc_kitchenId"

#define kMobilNumberKey @"woeatapp_kitchen_app_kc_mobilNum"

#define CommonColor [UIColor colorWithHexString:@"3D3938" andAlpha:1.0]
#define CommonGoldColor [UIColor colorWithHexString:@"8B8468" andAlpha:1.0]
#define WK_Old_User  @"WK_Old_User"


#define COLOR(R, G, B, A)             [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]

#define WS(weakSelf) __weak typeof(&*self)weakSelf = self;

//#define navigationBarColor COLOR(255, 125, 107,1)

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define iOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >=7.0 ? YES : NO)

#define iPhone6plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242,2208), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ?\
CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? \
CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)

#define HelveticaNeueFONT(fontSize)       [UIFont fontWithName:@"HelveticaNeue" size:fontSize]

#define HelveticaNeueBoldFONT(fontSize)   [UIFont fontWithName:@"HelveticaNeue-Bold" size:fontSize]

#define STHeitiSCLightFONT(fontSize)      [UIFont fontWithName:@"STHeitiSC-Light" size:fontSize]
// 4.屏幕大小尺寸
#define screen_width [UIScreen mainScreen].bounds.size.width
#define screen_height [UIScreen mainScreen].bounds.size.height

#define navigationbar_height  CGRectGetMaxY(self.navigationController.navigationBar.frame)

//相对iphone6 屏幕比
#define KWidth_Scale    [UIScreen mainScreen].bounds.size.width/375.0f

#define TABBAR_H 44
#define StateBarHeight (([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)? 0 : 20)

/**
 *  Docment文件夹目录
 */
#define kDocumentPath NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject

/**
 *  cache文件夹目录
 */
#define kCachePath NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject

/**
 *  离线缓存文件路径
 */
#define kArchiverCachePath [kCachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/src.arch",[[NSBundle mainBundle] bundleIdentifier]]]
/**
 *  下载文件夹目录
 */
#define kDownloadPath [kDocumentPath stringByAppendingPathComponent: @"download"]
/**
 *  VideoModel归档文件夹目录
 */
#define kArchPath [kDocumentPath stringByAppendingPathComponent: @"arch"]

/**
 *  appkey
 */
#define APPKEY @"85eb6835b0a1034e"

/**
 *  appsec
 */
#define APPSEC @"2ad42749773c441109bdc0191257a664"

/**
 *  默认网络错误信息
 */
#define kerrorMessage @"网络连接出错_(:3 」∠)_"

/**
 * 判定字符串有效性
 */
#define CheckValidString(__OBJ)      ([(__OBJ) isKindOfClass:[NSString class]] && 0 < [(__OBJ) length])

/**
 * 判断操作系统版本号
 */
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define IS_IOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)
#define IS_IOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8)


#define commonColor [UIColor colorWithHexString:@"12b0c4" andAlpha:1.0] 





