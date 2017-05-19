//
//  WENetUtil.m
//  woeat
//
//  Created by liubin on 16/10/24.
//  Copyright © 2016年 liubin. All rights reserved.
//

#import "WENetUtil.h"
#import "AFHTTPSessionManager.h"
#import "AFURLRequestSerialization.h"
#import "WEUserDataManager.h"
#import "WEGlobalData.h"
#import "AppDelegate.h"
#import "WEToken.h"
#import "WELocationManager.h"

#define kTimeOutInterval 30 // 请求超时的时间


#if TEST_LOCAL_NET
    #define BASE_URL     @"http://localhost:8080/woeatServer"
#else
    #define BASE_URL     @"https://api.woeatapp.com/v1"

#endif

#define SAVE_JSON_FILE 1


#define URL_SendSecurityCode                    BASE_URL@"/User/SendSecurityCodeConsumer"
#define URL_Login                               BASE_URL@"/User/Login"
//获取当前用户的余额
#define URL_GetMyBalance                         BASE_URL@"/User/GetMyBalance"
//更新用户头像
#define URL_UpdateUserImage                         BASE_URL@"/User/UpdateUserImage"
//更新用户信息
#define URL_UpdateUserDetails                         BASE_URL@"/User/UpdateUserDetails"
//获取当前用户的详情
#define URL_GetMyDetails                             BASE_URL@"/User/GetMyDetails"
//供家厨端调用。新家厨用户申请成为家厨时，填写详细信息，通过调用此接口完成家厨用户的注册
#define URL_RegisterKitchen                             BASE_URL@"/User/RegisterKitchen"

#define URL_GetListForConsumerHome               BASE_URL@"/Banner/GetListForConsumerHome"

#define URL_GetList                               BASE_URL@"/Kitchen/GetList"
#define URL_GetConsumerKitchen                        BASE_URL@"/Kitchen/GetConsumerKitchen"
#define URL_Get                                     BASE_URL@"/Kitchen/Get"
#define URL_Register                                BASE_URL@"/Kitchen/Register"
#define URL_WildSearch                                BASE_URL@"/Kitchen/WildSearch"
#define URL_GetMyKitchenSales                          BASE_URL@"/Kitchen/GetMyKitchenSales"
#define URL_GetMyKitchen                             BASE_URL@"/Kitchen/GetMyKitchen"
#define URL_SwitchOnOff                               BASE_URL@"/Kitchen/SwitchOnOff"
#define URL_Update                                   BASE_URL@"/Kitchen/Update"
#define URL_GetBusinessHours                         BASE_URL@"/Kitchen/GetBusinessHours"
#define URL_SetBusinessHours                         BASE_URL@"/Kitchen/SetBusinessHours"
#define URL_UploadKitchenImage                         BASE_URL@"/Kitchen/UploadKitchenImage"
#define URL_RemoveKitchenImage                         BASE_URL@"/Kitchen/RemoveKitchenImage"
#define URL_GetKitchenSalesByMonth                     BASE_URL@"/Kitchen/GetKitchenSalesByMonth"
#define URL_GetKitchenOrdersByMonth                    BASE_URL@"/Kitchen/GetKitchenOrdersByMonth"
#define URL_IsApproved                                 BASE_URL@"/Kitchen/IsApproved"
#define URL_UpdateDispatchMethod                      BASE_URL@"/Kitchen/UpdateDispatchMethod"
#define URL_UpdateKitchenStory                         BASE_URL@"/Kitchen/UpdateKitchenStory"
#define URL_LinkKitchenImages                         BASE_URL@"/Kitchen/LinkKitchenImages"
#define URL_ClearBusinessHours                         BASE_URL@"/Kitchen/ClearBusinessHours"


#define URL_GetListForConsumer                        BASE_URL@"/IntroSlider/GetListForConsumer"
#define URL_GetListForKitchen                        BASE_URL@"/IntroSlider/GetListForKitchen"

#define URL_UserFavouriteAddKitchen                   BASE_URL@"/UserUtility/AddKitchenToFavourite"
#define URL_UserFavouriteRemoveKitchen                BASE_URL@"/UserUtility/RemoveKitchenFromFavourite"
#define URL_AddDeliveryAddress                        BASE_URL@"/UserUtility/AddDeliveryAddress"
#define URL_DeleteDeliveryAddress                     BASE_URL@"/UserUtility/DeleteDeliveryAddress"
#define URL_GetMyDeliveryAddressList                  BASE_URL@"/UserUtility/GetMyDeliveryAddressList"


//#define URL_GetTagListForKitchen                      BASE_URL@"/Tag/GetTagListOfKitchen"
#define URL_GetTagListForOrderComment                   BASE_URL@"/Tag/GetTagListForOrderComment"


#define URL_ItemToday                                  BASE_URL@"/Item/GetTodayList"
#define URL_ItemTomorrow                               BASE_URL@"/Item/GetTomorrowList"
#define URL_GetConsumerItem                            BASE_URL@"/Item/GetConsumerItem"
#define URL_GetAllItemListByKitchenId                  BASE_URL@"/Item/GetAllItemListByKitchenId"
#define URL_AddItem                                    BASE_URL@"/Item/AddItem"
#define URL_UpdateItem                                 BASE_URL@"/Item/UpdateItem"
#define URL_DeleteItem                                 BASE_URL@"/Item/DeleteItem"
#define URL_Activate                                   BASE_URL@"/Item/Activate"
#define URL_Deactivate                                 BASE_URL@"/Item/Deactivate"
#define URL_GetAllMyItemList                           BASE_URL@"/Item/GetAllMyItemList"
#define URL_UploadItemImage                            BASE_URL@"/Item/UploadItemImage"
#define URL_GetItem                                    BASE_URL@"/Item/GetItem"
#define URL_RemoveItemImage                            BASE_URL@"/Item/RemoveItemImage"

#define URL_SubmitOrder                                BASE_URL@"/SalesOrderConsumer/SubmitOrder"
#define URL_AddCouponToOrder                          BASE_URL@"/SalesOrderConsumer/AddCouponToOrder"
#define URL_UpdateOrderForCheckout                     BASE_URL@"/SalesOrderConsumer/UpdateOrderForCheckout"
#define URL_CheckoutUsingBankCard                      BASE_URL@"/SalesOrderConsumer/CheckoutUsingBankCard"
#define URL_CheckoutUsingBalance                       BASE_URL@"/SalesOrderConsumer/CheckoutUsingBalance"

#define URL_GetMyOrderListInProgress                    BASE_URL@"/SalesOrderConsumer/GetMyOrderListInProgress"
#define URL_GetMyOrderListToComment                     BASE_URL@"/SalesOrderConsumer/GetMyOrderListToComment"
#define URL_GetMyOrderListCompleted                     BASE_URL@"/SalesOrderConsumer/GetMyOrderListCompleted"

//获取所有可用优惠券
#define URL_GetMyRedeemableCoupon                         BASE_URL@"/Coupon/GetMyRedeemableCoupon"
//获取所有优惠券,包括可用的和已用过的
#define URL_GetMyCouponList                                BASE_URL@"/Coupon/GetMyCouponList"
//添加优惠券。用户获得优惠券或获知优惠券代码后，调用此接口添加优惠券到自己个人名下
#define URL_ClaimCoupon                                    BASE_URL@"/Coupon/ClaimCoupon"
//根据指定CouponId来获取优惠券
#define URL_GetCouponById                                  BASE_URL@"/Coupon/GetCouponById"
//根据指定CouponCode来获取优惠券
#define URL_GetCoupon                                       BASE_URL@"/Coupon/GetCoupon"
//根据Id获取用户已添加的优惠券详情
#define URL_GetUserCoupon                                   BASE_URL@"/Coupon/GetUserCoupon"

//用户向自己的账户充值
#define URL_Recharge                                        BASE_URL@"/Transaction/Recharge"

//添加评论
#define URL_AddComment                                      BASE_URL@"/Comment/AddComment"
//根据指定条件来搜索评论记录
#define URL_GetCommentList                                      BASE_URL@"/Comment/GetCommentList"
//回复评论,仅测试用
#define URL_ReplyComment                                       BASE_URL@"/Comment/ReplyComment"
//根据指定条件来搜索评论记录
#define URL_GetCommentListOpen                                BASE_URL@"/Comment/GetCommentListOpen"
//厨房tag
#define URL_GetCommentTagListOfKitchen                        BASE_URL@"/Comment/GetCommentTagListOfKitchen"
#define URL_GeKitchenCommentListToReply                        BASE_URL@"/Comment/GeKitchenCommentListToReply"
#define URL_GeKitchenCommentListPositive                        BASE_URL@"/Comment/GeKitchenCommentListPositive"
#define URL_GeKitchenCommentListNeutral                        BASE_URL@"/Comment/GeKitchenCommentListNeutral"
#define URL_GeKitchenCommentListNegative                        BASE_URL@"/Comment/GeKitchenCommentListNegative"

#define URL_Upload                                            BASE_URL@"/Image/Upload"

#define URL_GetAddressFromLatLng                              BASE_URL@"/Address/GetAddressFromLatLng"

#define URL_GetOrder                                         BASE_URL@"/SalesOrderKitchen/GetOrder"
#define URL_AcceptOrder                                         BASE_URL@"/SalesOrderKitchen/AcceptOrder"
#define URL_RejectOrder                                         BASE_URL@"/SalesOrderKitchen/RejectOrder"
#define URL_SetReadyOrder                                          BASE_URL@"/SalesOrderKitchen/SetReadyOrder"
#define URL_DispatchOrder                                         BASE_URL@"/SalesOrderKitchen/DispatchOrder"
#define URL_ReceiveOrder                                         BASE_URL@"/SalesOrderKitchen/ReceiveOrder"
#define URL_CancelOrder                                         BASE_URL@"/SalesOrderKitchen/CancelOrder"
#define URL_GetOrderListToday                                         BASE_URL@"/SalesOrderKitchen/GetOrderListToday"
#define URL_GetOrderListTomorrow                                         BASE_URL@"/SalesOrderKitchen/GetOrderListTomorrow"
#define URL_GetItemToCookList                                          BASE_URL@"/SalesOrderKitchen/GetItemToCookList"
#define URL_GetItemToCookPerOrderList                            BASE_URL@"/SalesOrderKitchen/GetItemToCookPerOrderList"
#define URL_GetOrderListOtherDays                                         BASE_URL@"/SalesOrderKitchen/GetOrderListOtherDays"

#define URL_GetCashOutRequest                                    BASE_URL@"/TransactionCashOutRequest/GetCashOutRequest"
#define URL_GetCashOutRequestList                           BASE_URL@"/TransactionCashOutRequest/GetCashOutRequestList"
#define URL_AddCashOutRequest                               BASE_URL@"/TransactionCashOutRequest/AddCashOutRequest"



//#define CHECK_TOKEN_STRING(s) if (!s.length) {\
//    NSLog(@"token is nil");\
//    failure(nil, nil);\
//    return;\
//}

static void tmpBreak()
{
    NSLog(@"tmpBreak");
}

#define CHECK_TOKEN_STRING(s) if (!s.length) {\
    NSLog(@"token is nil");\
    tmpBreak();\
    failure(nil, nil);\
    return;\
}

@implementation WENetUtil

#pragma mark - 创建请求者
+(AFHTTPSessionManager *)sessionManager
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // 超时时间
    manager.requestSerializer.timeoutInterval = kTimeOutInterval;
    
    // 声明上传的是json格式的参数，需要你和后台约定好，不然会出现后台无法获取到你上传的参数问题
    //manager.requestSerializer = [AFHTTPRequestSerializer serializer]; // 上传普通格式
    manager.requestSerializer = [AFJSONRequestSerializer serializer]; // 上传JSON格式
    
    // 声明获取到的数据格式
    //manager.responseSerializer = [AFHTTPResponseSerializer serializer]; // AFN不会解析,数据是data，需要自己解析
    manager.responseSerializer = [AFJSONResponseSerializer serializer]; // AFN会JSON解析返回的数据
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", nil];
    // 个人建议还是自己解析的比较好，有时接口返回的数据不合格会报3840错误，大致是AFN无法解析返回来的数据
    return manager;
}

+ (NSString *)getTokenString
{
    return [WEToken getToken];
}

+ (NSString *)getServerErrorMsg:(NSError *)error
{
    NSString *msg = nil;
    NSData *data = [error.userInfo objectForKey:AFNetworkingOperationFailingURLResponseDataErrorKey];
    if ([data length]) {
        NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        msg = [dict objectForKey:@"Message"];
    }
    return msg;
}

+ (void)checkNeedReLogin:(NSError *)error
{
    id data = [error.userInfo objectForKey:AFNetworkingOperationFailingURLResponseErrorKey];
    if ([data isKindOfClass:[NSHTTPURLResponse class]]) {
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)data;
        NSLog(@"checkNeedReLogin statusCode=%d", response.statusCode);
        if (response.statusCode == 401) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"登录提示" message:@"您的登录已失效，请重新登录" delegate:self cancelButtonTitle:nil otherButtonTitles:@"重新登录", nil];
            [alertView show];
        }
    }
}

+ (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == alertView.firstOtherButtonIndex) {
        NSLog(@"重新登录");
        [WEToken clearToken];
        [WEGlobalData logOut];
        
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        //[delegate setRootToLoginController];
    }
}

+ (NSString *)getLatitudeString
{
    WELocationManager *location = [WELocationManager sharedInstance];
    double latitude = [location getCurrentLatitude];
    NSString *s = [NSString stringWithFormat:@"%f", latitude];
    return s;
}

+ (NSString *)getLongitudeString
{
    WELocationManager *location = [WELocationManager sharedInstance];
    double longitude = [location getCurrentLongitude];
    NSString *s = [NSString stringWithFormat:@"%f", longitude];
    return s;
}

+ (void)writeObject:(id)obj toJsonFile:(NSString *)path
{
#if SAVE_JSON_FILE
    NSString *dir = @"/tmp/json/";
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:obj
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"writeObject, Got an error: %@", error);
        return;
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        [jsonString writeToFile:[dir stringByAppendingString:path] atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }
#endif
}

+ (void)sendSecurityCodeWithPhoneNumber:(NSString *)phoneNumber
                                success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                failure:(void (^)(NSURLSessionDataTask *task, NSString *errorMsg))failure
{
    AFHTTPSessionManager *manager = [self sessionManager];
    NSDictionary *param = @{ @"MobileNumber" : phoneNumber,
                             };
    NSLog(@"%@",manager.requestSerializer.HTTPRequestHeaders);
    
    [manager POST:URL_SendSecurityCode parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self writeObject:responseObject toJsonFile:@"SendSecurityCode.json"];
        NSLog(@"sendSecurityCodeWithPhoneNumber success %@, %@",responseObject, task);
        success(task, responseObject);
             
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
        NSLog(@"sendSecurityCodeWithPhoneNumber fail %@, %@",error, task);
        NSString *msg = [self getServerErrorMsg:error];
        if (!msg) {
            msg = @"获取验证码失败";
        }
        failure(task, msg);
    }];
}


+ (void)userLoginWithPhoneNumber:(NSString *)phoneNumber
                   securityCode :(NSString *)securityCode
                         success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                         failure:(void (^)(NSURLSessionDataTask *task, NSString *errorMsg))failure
{
    AFHTTPSessionManager *manager = [self sessionManager];
    NSDictionary *param = @{ @"MobileNumber" : phoneNumber,
                             @"SecurityCode" : securityCode,
                             };
    NSLog(@"%@",manager.requestSerializer.HTTPRequestHeaders);
    
    [manager POST:URL_Login parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self writeObject:responseObject toJsonFile:@"Login.json"];
        NSLog(@"userLoginWithPhoneNumber success %@, %@",responseObject, task);
        success(task, responseObject);
        
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
        NSLog(@"userLoginWithPhoneNumber fail %@, %@",error, task);
        NSString *msg = [self getServerErrorMsg:error];
        if (!msg) {
            msg = @"登录失败";
        }
        failure(task, msg);
    }];
}


+ (void)getListForConsumerHomeSuccess:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                              failure:(void (^)(NSURLSessionDataTask *task, NSString *errorMsg))failure
{
    AFHTTPSessionManager *manager = [self sessionManager];
    NSDictionary *param = nil;

    
    NSString *s = [self getTokenString];
    CHECK_TOKEN_STRING(s);
    
    [manager.requestSerializer setValue:s forHTTPHeaderField:@"Authorization"];
    
    [manager GET:URL_GetListForConsumerHome parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self writeObject:responseObject toJsonFile:@"GetListForConsumerHome.json"];
        NSLog(@"getListForConsumerHome success %@, %@",responseObject, task);
        success(task, responseObject);
        
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
        NSLog(@"getListForConsumerHome fail %@, %@",error, task);
        NSString *msg = [self getServerErrorMsg:error];
        if (!msg) {
            msg = @"获取失败";
        }
        failure(task, msg);
        [self checkNeedReLogin:error];
    }];

}

+ (void)GetListForKitchenSuccess:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                              failure:(void (^)(NSURLSessionDataTask *task, NSString *errorMsg))failure
{
    AFHTTPSessionManager *manager = [self sessionManager];
    NSDictionary *param = nil;
    
    
    NSString *s = [self getTokenString];
    CHECK_TOKEN_STRING(s);
    
    [manager.requestSerializer setValue:s forHTTPHeaderField:@"Authorization"];
    
    [manager GET:URL_GetListForKitchen parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self writeObject:responseObject toJsonFile:@"GetListForKitchen.json"];
        NSLog(@"GetListForKitchen success %@, %@",responseObject, task);
        success(task, responseObject);
        
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
        NSLog(@"GetListForKitchen fail %@, %@",error, task);
        NSString *msg = [self getServerErrorMsg:error];
        if (!msg) {
            msg = @"获取失败";
        }
        failure(task, msg);
        [self checkNeedReLogin:error];
    }];
    
}

//厨房列表
+ (void)getListWithSessionId:(NSString *)SessionId
                  PageNumber:(int)PageNumber
                        Mode:(NSString *)Mode
                    Latitude:(NSString *)Latitude
                   Longitude:(NSString *)Longitude
                     success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                     failure:(void (^)(NSURLSessionDataTask *task, NSString *errorMsg))failure
{
    AFHTTPSessionManager *manager = [self sessionManager];
    
    NSDictionary *param;
    if (SessionId.length) {
       param  = @{ @"SessionId" : SessionId,
            @"PageNumber" : @(PageNumber),
            @"Mode" : Mode,
            @"Latitude" : [self getLatitudeString],
            @"Longitude" : [self getLongitudeString],
            };
    } else {
        param  = @{ @"PageNumber" : @(PageNumber),
                   @"Mode" : Mode,
                   @"Latitude" : [self getLatitudeString],
                   @"Longitude" : [self getLongitudeString],
                   };
    }
    
    
    NSString *s = [self getTokenString];
    CHECK_TOKEN_STRING(s);
    
    [manager.requestSerializer setValue:s forHTTPHeaderField:@"Authorization"];
    
    NSLog(@"getList param %@", param);
    [manager POST:URL_GetList parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self writeObject:responseObject toJsonFile:@"GetList.json"];
        NSLog(@"getList success %@, %@",responseObject, task);
        success(task, responseObject);
        
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
        NSLog(@"getList fail %@, %@",error, task);
        NSString *msg = [self getServerErrorMsg:error];
        if (!msg) {
            msg = @"获取失败";
        }
        failure(task, msg);
        [self checkNeedReLogin:error];
    }];
    
}

//引导页
+ (void)getListForConsumerSuccess:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                              failure:(void (^)(NSURLSessionDataTask *task, NSString *errorMsg))failure
{
    AFHTTPSessionManager *manager = [self sessionManager];
    NSDictionary *param = nil;
    
    
    NSString *s = [self getTokenString];
    CHECK_TOKEN_STRING(s);
    
    [manager.requestSerializer setValue:s forHTTPHeaderField:@"Authorization"];
    
    [manager GET:URL_GetListForConsumer parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self writeObject:responseObject toJsonFile:@"GetListForConsumer.json"];
        NSLog(@"getListForConsumer success %@, %@",responseObject, task);
        success(task, responseObject);
        
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
        NSLog(@"getListForConsumer fail %@, %@",error, task);
        NSString *msg = [self getServerErrorMsg:error];
        if (!msg) {
            msg = @"获取失败";
        }
        failure(task, msg);
        [self checkNeedReLogin:error];
    }];
    
}


//厨房详情
+ (void)GetConsumerKitchenWithKitchenId:(NSString *)KitchenId
                    Latitude:(NSString *)Latitude
                   Longitude:(NSString *)Longitude
                     success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                     failure:(void (^)(NSURLSessionDataTask *task, NSString *errorMsg))failure
{
    AFHTTPSessionManager *manager = [self sessionManager];
    
    NSDictionary *param;
    param  = @{ @"KitchenId" : KitchenId,
                @"Latitude" : [self getLatitudeString],
                @"Longitude" : [self getLongitudeString],
                };
    
    NSString *s = [self getTokenString];
    CHECK_TOKEN_STRING(s);
    
    [manager.requestSerializer setValue:s forHTTPHeaderField:@"Authorization"];
    
    NSLog(@"GetConsumerKitchen param %@", param);
    [manager GET:URL_GetConsumerKitchen parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *jsonFile = [NSString stringWithFormat:@"GetConsumerKitchen_%@.json", KitchenId];
        [self writeObject:responseObject toJsonFile:jsonFile];
        NSLog(@"GetConsumerKitchen success %@, %@",responseObject, task);
        success(task, responseObject);
        
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
        NSLog(@"GetConsumerKitchen fail %@, %@",error, task);
        NSString *msg = [self getServerErrorMsg:error];
        if (!msg) {
            msg = @"获取失败";
        }
        failure(task, msg);
        [self checkNeedReLogin:error];
    }];
    
}

//收藏厨房
+ (void)UserFavouriteAddKitchenWithKitchenId:(NSString *)KitchenId
                                     success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                failure:(void (^)(NSURLSessionDataTask *task, NSString *errorMsg))failure
{
    AFHTTPSessionManager *manager = [self sessionManager];
    
    NSDictionary *param;
    param  = @{ @"KitchenId" : KitchenId,
                };
    
    NSString *s = [self getTokenString];
    CHECK_TOKEN_STRING(s);
    
    [manager.requestSerializer setValue:s forHTTPHeaderField:@"Authorization"];
    
    NSLog(@"UserFavouriteAddKitchen param %@", param);
    [manager GET:URL_UserFavouriteAddKitchen parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self writeObject:responseObject toJsonFile:@"UserFavouriteAddKitchen.json"];
        NSLog(@"UserFavouriteAddKitchen success %@, %@",responseObject, task);
        success(task, responseObject);
        
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
        NSLog(@"UserFavouriteAddKitchen fail %@, %@",error, task);
        NSString *msg = [self getServerErrorMsg:error];
        if (!msg) {
            msg = @"获取失败";
        }
        failure(task, msg);
        [self checkNeedReLogin:error];
    }];
    
}

//取消收藏厨房
+ (void)UserFavouriteRemoveKitchenWithKitchenId:(NSString *)KitchenId
                                     success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                     failure:(void (^)(NSURLSessionDataTask *task, NSString *errorMsg))failure
{
    AFHTTPSessionManager *manager = [self sessionManager];
    
    NSDictionary *param;
    param  = @{ @"KitchenId" : KitchenId,
                };
    
    NSString *s = [self getTokenString];
    CHECK_TOKEN_STRING(s);
    
    [manager.requestSerializer setValue:s forHTTPHeaderField:@"Authorization"];
    
    NSLog(@"UserFavouriteRemoveKitchenWithKitchenId param %@", param);
    [manager GET:URL_UserFavouriteRemoveKitchen parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self writeObject:responseObject toJsonFile:@"UserFavouriteRemoveKitchen.json"];
        NSLog(@"UserFavouriteRemoveKitchenWithKitchenId success %@, %@",responseObject, task);
        success(task, responseObject);
        
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
        NSLog(@"UserFavouriteAddKitchen fail %@, %@",error, task);
        NSString *msg = [self getServerErrorMsg:error];
        if (!msg) {
            msg = @"获取失败";
        }
        failure(task, msg);
        [self checkNeedReLogin:error];
    }];
    
}

//厨房 tag list
//+ (void)GetTagListForKitchenWithKitchenId:(NSString *)KitchenId
//                                        success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
//                                        failure:(void (^)(NSURLSessionDataTask *task, NSString *errorMsg))failure
//{
//    AFHTTPSessionManager *manager = [self sessionManager];
//    
//    NSDictionary *param;
//    param  = @{ @"KitchenId" : KitchenId,
//                };
//    
//    NSString *s = [self getTokenString];
//    CHECK_TOKEN_STRING(s);
//    
//    [manager.requestSerializer setValue:s forHTTPHeaderField:@"Authorization"];
//    
//    NSLog(@"GetTagListForKitchen param %@", param);
//    [manager GET:URL_GetTagListForKitchen parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
//        
//    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        [self writeObject:responseObject toJsonFile:@"GetTagListForKitchen.json"];
//        NSLog(@"GetTagListForKitchen success %@, %@",responseObject, [responseObject class]);
//        success(task, responseObject);
//        
//    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
//        NSLog(@"GetTagListForKitchen fail %@, %@",error, task);
//        NSString *msg = [self getServerErrorMsg:error];
//        if (!msg) {
//            msg = @"获取失败";
//        }
//        failure(task, msg);
//    }];
//    
//}

//返回用户评论订单时用到的标签列表
+ (void)GetTagListForOrderCommentWithSuccess:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                        failure:(void (^)(NSURLSessionDataTask *task, NSString *errorMsg))failure
{
    AFHTTPSessionManager *manager = [self sessionManager];

    NSDictionary *param = nil;
    NSString *s = [self getTokenString];
    CHECK_TOKEN_STRING(s);

    [manager.requestSerializer setValue:s forHTTPHeaderField:@"Authorization"];

    NSLog(@"GetTagListForOrderComment param %@", param);
    [manager GET:URL_GetTagListForOrderComment parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {

    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self writeObject:responseObject toJsonFile:@"GetTagListForOrderComment.json"];
        NSLog(@"GetTagListForOrderComment success %@, %@",responseObject, [responseObject class]);
        success(task, responseObject);

    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
        NSLog(@"GetTagListForOrderComment fail %@, %@",error, task);
        NSString *msg = [self getServerErrorMsg:error];
        if (!msg) {
            msg = @"获取失败";
        }
        failure(task, msg);
        [self checkNeedReLogin:error];
    }];

}

//今日菜品
+ (void)GetItemTodayWithKitchenId:(NSString *)KitchenId
                                  success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                  failure:(void (^)(NSURLSessionDataTask *task, NSString *errorMsg))failure
{
    AFHTTPSessionManager *manager = [self sessionManager];
    
    NSDictionary *param;
    param  = @{ @"KitchenId" : KitchenId,
                };
    
    NSString *s = [self getTokenString];
    CHECK_TOKEN_STRING(s);
    
    [manager.requestSerializer setValue:s forHTTPHeaderField:@"Authorization"];
    
    NSLog(@"GetItemToday param %@", param);
    [manager GET:URL_ItemToday parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *jsonFile = [NSString stringWithFormat:@"ItemToday_%@.json", KitchenId];
        [self writeObject:responseObject toJsonFile:jsonFile];

        NSLog(@"GetItemToday success %@, %@",responseObject, [responseObject class]);
        success(task, responseObject);
        
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
        NSLog(@"GetItemToday fail %@, %@",error, task);
        NSString *msg = [self getServerErrorMsg:error];
        if (!msg) {
            msg = @"获取失败";
        }
        failure(task, msg);
        [self checkNeedReLogin:error];
    }];
}

//预订明日
+ (void)GetItemTomorrowWithKitchenId:(NSString *)KitchenId
                          success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                          failure:(void (^)(NSURLSessionDataTask *task, NSString *errorMsg))failure
{
    AFHTTPSessionManager *manager = [self sessionManager];
    
    NSDictionary *param;
    param  = @{ @"KitchenId" : KitchenId,
                };
    
    NSString *s = [self getTokenString];
    CHECK_TOKEN_STRING(s);
    
    [manager.requestSerializer setValue:s forHTTPHeaderField:@"Authorization"];
    
    NSLog(@"GetItemTomorrow param %@", param);
    [manager GET:URL_ItemTomorrow parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *jsonFile = [NSString stringWithFormat:@"ItemTomorrow_%@.json", KitchenId];
        [self writeObject:responseObject toJsonFile:jsonFile];
        NSLog(@"GetItemTomorrow success %@, %@",responseObject, [responseObject class]);
        success(task, responseObject);
        
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
        NSLog(@"GetItemTomorrow fail %@, %@",error, task);
        NSString *msg = [self getServerErrorMsg:error];
        if (!msg) {
            msg = @"获取失败";
        }
        failure(task, msg);
        [self checkNeedReLogin:error];
    }];
}

//下订单
+ (void)SubmitOrderWithKitchenId:(NSString *)KitchenId
                         isToday:(BOOL)isToday
                     itemIdArray:(NSArray *)itemIdArray
                     unitPriceArray:(NSArray *)unitPriceArray
                     quantityArray:(NSArray *)quantityArray
                         success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                         failure:(void (^)(NSURLSessionDataTask *task, NSString *errorMsg))failure
{
    AFHTTPSessionManager *manager = [self sessionManager];
    
    NSMutableArray *ItemLineList = [[NSMutableArray alloc] initWithCapacity:itemIdArray.count];
    for(int i=0; i<itemIdArray.count; i++) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:3];
        [dict setObject:itemIdArray[i] forKey:@"ItemId"];
        [dict setObject:unitPriceArray[i] forKey:@"UnitPrice"];
        [dict setObject:quantityArray[i] forKey:@"Quantity"];
        [ItemLineList addObject:dict];
    }
    
    NSDate *date = [NSDate date];
    if (!isToday) {
        date = [NSDate dateWithTimeIntervalSinceNow:60*60*24];
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMdd";
    NSString *dateString = [formatter stringFromDate:date];

    NSDictionary *param;
    param  = @{ @"KitchenId" : KitchenId,
                @"OrderDate" : dateString,
                @"ItemLineList" : ItemLineList,
                };
    
    NSString *s = [self getTokenString];
    CHECK_TOKEN_STRING(s);
    
    [manager.requestSerializer setValue:s forHTTPHeaderField:@"Authorization"];
    
    NSLog(@"SubmitOrder param %@", param);
    [manager POST:URL_SubmitOrder parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *jsonFile = [NSString stringWithFormat:@"SubmitOrder_%@.json", KitchenId];
        [self writeObject:responseObject toJsonFile:jsonFile];
        NSLog(@"SubmitOrder success %@, %@",responseObject, [responseObject class]);
        success(task, responseObject);
        
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
        NSLog(@"SubmitOrder fail %@, %@",error, task);
        NSString *msg = [self getServerErrorMsg:error];
        if (!msg) {
            msg = @"获取失败";
        }
        failure(task, msg);
        [self checkNeedReLogin:error];
    }];
}



//获取所有可用优惠券
+ (void)GetMyRedeemableCouponWithSuccess:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                             failure:(void (^)(NSURLSessionDataTask *task, NSString *errorMsg))failure
{
    AFHTTPSessionManager *manager = [self sessionManager];
    
    NSDictionary *param = nil;
    
    NSString *s = [self getTokenString];
    CHECK_TOKEN_STRING(s);
    
    [manager.requestSerializer setValue:s forHTTPHeaderField:@"Authorization"];
    
    NSLog(@"GetMyRedeemableCoupon param %@", param);
    [manager GET:URL_GetMyRedeemableCoupon parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *jsonFile = [NSString stringWithFormat:@"GetMyRedeemableCoupon.json"];
        [self writeObject:responseObject toJsonFile:jsonFile];
        NSLog(@"GetMyRedeemableCoupon success %@, %@",responseObject, [responseObject class]);
        success(task, responseObject);
        
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
        NSLog(@"GetMyRedeemableCoupon fail %@, %@",error, task);
        NSString *msg = [self getServerErrorMsg:error];
        if (!msg) {
            msg = @"获取失败";
        }
        failure(task, msg);
        [self checkNeedReLogin:error];
    }];
}

//获取所有优惠券,包括可用的和已用过的
+ (void)GetMyCouponListWithSuccess:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                 failure:(void (^)(NSURLSessionDataTask *task, NSString *errorMsg))failure
{
    AFHTTPSessionManager *manager = [self sessionManager];
    
    NSDictionary *param = nil;
    
    NSString *s = [self getTokenString];
    CHECK_TOKEN_STRING(s);
    
    [manager.requestSerializer setValue:s forHTTPHeaderField:@"Authorization"];
    
    NSLog(@"GetMyCouponList param %@", param);
    [manager GET:URL_GetMyCouponList parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *jsonFile = [NSString stringWithFormat:@"GetMyCouponList"];
        [self writeObject:responseObject toJsonFile:jsonFile];
        NSLog(@"GetMyCouponList success %@, %@",responseObject, [responseObject class]);
        success(task, responseObject);
        
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
        NSLog(@"GetMyCouponList fail %@, %@",error, task);
        NSString *msg = [self getServerErrorMsg:error];
        if (!msg) {
            msg = @"获取失败";
        }
        failure(task, msg);
        [self checkNeedReLogin:error];
    }];
}

//添加优惠券。用户获得优惠券或获知优惠券代码后，调用此接口添加优惠券到自己个人名下
+ (void)ClaimCouponWithCouponCode:(NSString *)CouponCode
                             success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                             failure:(void (^)(NSURLSessionDataTask *task, NSString *errorMsg))failure
{
    AFHTTPSessionManager *manager = [self sessionManager];
    
    NSDictionary *param;
    param  = @{ @"CouponCode" : CouponCode,
                };
    
    NSString *s = [self getTokenString];
    CHECK_TOKEN_STRING(s);
    
    [manager.requestSerializer setValue:s forHTTPHeaderField:@"Authorization"];
    
    NSLog(@"ClaimCoupon param %@", param);
    [manager POST:URL_ClaimCoupon parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *jsonFile = [NSString stringWithFormat:@"ClaimCoupon.json"];
        [self writeObject:responseObject toJsonFile:jsonFile];
        NSLog(@"ClaimCoupon success %@, %@",responseObject, [responseObject class]);
        success(task, responseObject);
        
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
        NSLog(@"ClaimCoupon fail %@, %@",error, task);
        NSString *msg = [self getServerErrorMsg:error];
        if (!msg) {
            msg = @"获取失败";
        }
        failure(task, msg);
        [self checkNeedReLogin:error];
    }];
}

//添加优惠券。用户获得优惠券或获知优惠券代码后，调用此接口添加优惠券到自己个人名下
+ (void)GetCouponByIdWithCouponId:(NSString *)CouponId
                          success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                          failure:(void (^)(NSURLSessionDataTask *task, NSString *errorMsg))failure
{
    AFHTTPSessionManager *manager = [self sessionManager];
    
    NSDictionary *param;
    param  = @{ @"CouponId" : CouponId,
                };
    
    NSString *s = [self getTokenString];
    CHECK_TOKEN_STRING(s);
    
    [manager.requestSerializer setValue:s forHTTPHeaderField:@"Authorization"];
    
    NSLog(@"GetCouponById param %@", param);
    [manager GET:URL_GetCouponById parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *jsonFile = [NSString stringWithFormat:@"GetCouponById.json"];
        [self writeObject:responseObject toJsonFile:jsonFile];
        NSLog(@"GetCouponById success %@, %@",responseObject, [responseObject class]);
        success(task, responseObject);
        
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
        NSLog(@"GetCouponById fail %@, %@",error, task);
        NSString *msg = [self getServerErrorMsg:error];
        if (!msg) {
            msg = @"获取失败";
        }
        failure(task, msg);
        [self checkNeedReLogin:error];
    }];
}

//根据Id获取用户已添加的优惠券详情
+ (void)GetUserCouponWithCouponId:(NSString *)CouponId
                          success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                          failure:(void (^)(NSURLSessionDataTask *task, NSString *errorMsg))failure
{
    AFHTTPSessionManager *manager = [self sessionManager];
    
    NSDictionary *param;
    param  = @{ @"UserCouponId" : CouponId,
                };
    
    NSString *s = [self getTokenString];
    CHECK_TOKEN_STRING(s);
    
    [manager.requestSerializer setValue:s forHTTPHeaderField:@"Authorization"];
    
    NSLog(@"GetUserCoupon param %@", param);
    [manager POST:URL_GetUserCoupon parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *jsonFile = [NSString stringWithFormat:@"GetUserCoupon.json"];
        [self writeObject:responseObject toJsonFile:jsonFile];
        NSLog(@"GetUserCoupon success %@, %@",responseObject, [responseObject class]);
        success(task, responseObject);
        
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
        NSLog(@"GetUserCoupon fail %@, %@",error, task);
        NSString *msg = [self getServerErrorMsg:error];
        if (!msg) {
            msg = @"获取失败";
        }
        failure(task, msg);
        [self checkNeedReLogin:error];
    }];
}


//向指定的订单添加优惠券
+ (void)AddCouponToOrderWithCouponId:(NSString *)CouponId
                             OrderId:(NSString *)OrderId
                          success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                          failure:(void (^)(NSURLSessionDataTask *task, NSString *errorMsg))failure
{
    AFHTTPSessionManager *manager = [self sessionManager];
    
    NSDictionary *param;
    param  = @{ @"UserCouponId" : CouponId,
                @"OrderId" : OrderId,
                };
    
    NSString *s = [self getTokenString];
    CHECK_TOKEN_STRING(s);
    
    [manager.requestSerializer setValue:s forHTTPHeaderField:@"Authorization"];
    
    NSLog(@"AddCouponToOrder param %@", param);
    [manager POST:URL_AddCouponToOrder parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *jsonFile = [NSString stringWithFormat:@"AddCouponToOrder.json"];
        [self writeObject:responseObject toJsonFile:jsonFile];
        NSLog(@"AddCouponToOrder success %@, %@",responseObject, [responseObject class]);
        success(task, responseObject);
        
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
        NSLog(@"AddCouponToOrder fail %@, %@",error, task);
        NSString *msg = [self getServerErrorMsg:error];
        if (!msg) {
            msg = @"获取失败";
        }
        failure(task, msg);
        [self checkNeedReLogin:error];
    }];
}

//提交详细订单信息
+ (void)UpdateOrderForCheckoutWithOrderId:(NSString *)OrderId
                             DispatchMethod:(NSString *)DispatchMethod
                             RequiredArrivalTime:(NSString *)RequiredArrivalTime
                             Message:(NSString *)Message
                             UserCouponId:(NSString *)UserCouponId
                             DispatchToAddressLine1:(NSString *)DispatchToAddressLine1
                             DispatchToAddressLine2:(NSString *)DispatchToAddressLine2
                             DispatchToAddressLine3:(NSString *)DispatchToAddressLine3
                             DispatchToCity:(NSString *)DispatchToCity
                             DispatchToState:(NSString *)DispatchToState
                             DispatchToCountry:(NSString *)DispatchToCountry
                             DispatchToPostcode:(NSString *)DispatchToPostcode
                             DispatchToLatitude:(NSString *)DispatchToLatitude
                             DispatchToLongitude:(NSString *)DispatchToLongitude
                             DispatchToContactName:(NSString *)DispatchToContactName
                             DispatchToPhoneNumber:(NSString *)DispatchToPhoneNumber
                             success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                             failure:(void (^)(NSURLSessionDataTask *task, NSString *errorMsg))failure
{
    AFHTTPSessionManager *manager = [self sessionManager];
    
    NSDictionary *param;
    param  = @{ @"OrderId" : OrderId,
                @"DispatchMethod" : DispatchMethod,
                @"RequiredArrivalTime" : RequiredArrivalTime,
                @"Message" : Message,
                @"UserCouponId" : UserCouponId,
                @"DispatchToAddressLine1" : DispatchToAddressLine1,
                @"DispatchToAddressLine2" : DispatchToAddressLine2,
                @"DispatchToAddressLine3" : DispatchToAddressLine3,
                @"DispatchToCity" : DispatchToCity,
                @"DispatchToState" : DispatchToState,
                @"DispatchToCountry" : DispatchToCountry,
                @"DispatchToPostcode" : DispatchToPostcode,
                @"DispatchToLatitude" : [self getLatitudeString],
                @"DispatchToLongitude" : [self getLongitudeString],
                @"DispatchToContactName" : DispatchToContactName,
                @"DispatchToPhoneNumber" : DispatchToPhoneNumber,
                };
    
    NSString *s = [self getTokenString];
    CHECK_TOKEN_STRING(s);
    
    [manager.requestSerializer setValue:s forHTTPHeaderField:@"Authorization"];
    
    NSLog(@"UpdateOrderForCheckout param %@", param);
    [manager POST:URL_UpdateOrderForCheckout parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *jsonFile = [NSString stringWithFormat:@"UpdateOrderForCheckout.json"];
        [self writeObject:responseObject toJsonFile:jsonFile];
        NSLog(@"UpdateOrderForCheckout success %@, %@",responseObject, [responseObject class]);
        success(task, responseObject);
        
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
        NSLog(@"UpdateOrderForCheckout fail %@, %@",error, task);
        NSString *msg = [self getServerErrorMsg:error];
        if (!msg) {
            msg = @"获取失败";
        }
        failure(task, msg);
        [self checkNeedReLogin:error];
    }];
}


//获取当前用户的余额
+ (void)GetMyBalanceWithSuccess:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                           failure:(void (^)(NSURLSessionDataTask *task, NSString *errorMsg))failure
{
    AFHTTPSessionManager *manager = [self sessionManager];
    
    NSDictionary *param = nil;
    
    NSString *s = [self getTokenString];
    CHECK_TOKEN_STRING(s);
    
    [manager.requestSerializer setValue:s forHTTPHeaderField:@"Authorization"];
    
    NSLog(@"GetMyBalance param %@", param);
    [manager POST:URL_GetMyBalance parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *jsonFile = [NSString stringWithFormat:@"GetMyBalance.json"];
        [self writeObject:responseObject toJsonFile:jsonFile];
        NSLog(@"GetMyBalance success %@, %@",responseObject, [responseObject class]);
        success(task, responseObject);
        
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
        NSLog(@"GetMyBalance fail %@, %@",error, task);
        NSString *msg = [self getServerErrorMsg:error];
        if (!msg) {
            msg = @"获取失败";
        }
        failure(task, msg);
        [self checkNeedReLogin:error];
    }];
}


//提交详细订单信息
+ (void)CheckoutUsingBankCardWithOrderId:(NSString *)OrderId
                                CardType:(NSString *)CardType
                          CardHolderName:(NSString *)CardHolderName
                              CardNumber:(NSString *)CardNumber
                                ExpiryMM:(NSString *)ExpiryMM
                                ExpiryYY:(NSString *)ExpiryYY
                                  success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                  failure:(void (^)(NSURLSessionDataTask *task, NSString *errorMsg))failure
{
    AFHTTPSessionManager *manager = [self sessionManager];
    
    NSDictionary *param;
    param  = @{ @"OrderId" : OrderId,
                @"CardType" : CardType,
                @"CardHolderName" : CardHolderName,
                @"CardNumber" : CardNumber,
                @"ExpiryMM" : ExpiryMM,
                @"ExpiryYY" : ExpiryYY,
                };
    
    NSString *s = [self getTokenString];
    CHECK_TOKEN_STRING(s);
    
    [manager.requestSerializer setValue:s forHTTPHeaderField:@"Authorization"];
    
    NSLog(@"CheckoutUsingBankCard param %@", param);
    [manager POST:URL_CheckoutUsingBankCard parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *jsonFile = [NSString stringWithFormat:@"CheckoutUsingBankCard.json"];
        [self writeObject:responseObject toJsonFile:jsonFile];
        NSLog(@"CheckoutUsingBankCard success %@, %@",responseObject, [responseObject class]);
        success(task, responseObject);
        
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
        NSLog(@"CheckoutUsingBankCard fail %@, %@",error, task);
        NSString *msg = [self getServerErrorMsg:error];
        if (!msg) {
            msg = @"获取失败";
        }
        failure(task, msg);
        [self checkNeedReLogin:error];
    }];
}

//用户向自己的账户充值
+ (void)RechargeWithCardType:(NSString *)CardType
                          CardHolderName:(NSString *)CardHolderName
                              CardNumber:(NSString *)CardNumber
                                ExpiryMM:(NSString *)ExpiryMM
                                ExpiryYY:(NSString *)ExpiryYY
                                    CVN:(NSString *)CVN
                                    Value:(NSString *)Value
                                 success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                 failure:(void (^)(NSURLSessionDataTask *task, NSString *errorMsg))failure
{
    AFHTTPSessionManager *manager = [self sessionManager];
    
    NSDictionary *param;
    param  = @{ @"CardType" : CardType,
                @"CardHolderName" : CardHolderName,
                @"CardNumber" : CardNumber,
                @"ExpiryMM" : ExpiryMM,
                @"ExpiryYY" : ExpiryYY,
                @"CVN" : CVN,
                @"Value" : Value,
                };
    
    NSString *s = [self getTokenString];
    CHECK_TOKEN_STRING(s);
    
    [manager.requestSerializer setValue:s forHTTPHeaderField:@"Authorization"];
    
    NSLog(@"Recharge param %@", param);
    [manager POST:URL_Recharge parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *jsonFile = [NSString stringWithFormat:@"Recharge.json"];
        [self writeObject:responseObject toJsonFile:jsonFile];
        NSLog(@"Recharge success %@, %@",responseObject, [responseObject class]);
        success(task, responseObject);
        
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
        NSLog(@"Recharge fail %@, %@",error, task);
        NSString *msg = [self getServerErrorMsg:error];
        if (!msg) {
            msg = @"获取失败";
        }
        failure(task, msg);
        [self checkNeedReLogin:error];
    }];
}

//支付订单(使用用户充值)
+ (void)CheckoutUsingBalanceWithOrderId:(NSString *)OrderId
                             success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                             failure:(void (^)(NSURLSessionDataTask *task, NSString *errorMsg))failure
{
    AFHTTPSessionManager *manager = [self sessionManager];
    
    NSDictionary *param;
    param  = @{ @"OrderId" : OrderId,
                };
    
    NSString *s = [self getTokenString];
    CHECK_TOKEN_STRING(s);
    
    [manager.requestSerializer setValue:s forHTTPHeaderField:@"Authorization"];
    
    NSLog(@"CheckoutUsingBalance param %@", param);
    [manager POST:URL_CheckoutUsingBalance parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *jsonFile = [NSString stringWithFormat:@"CheckoutUsingBalance.json"];
        [self writeObject:responseObject toJsonFile:jsonFile];
        NSLog(@"CheckoutUsingBalance success %@, %@",responseObject, [responseObject class]);
        success(task, responseObject);
        
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
        NSLog(@"CheckoutUsingBalance fail %@, %@",error, task);
        NSString *msg = [self getServerErrorMsg:error];
        if (!msg) {
            msg = @"获取失败";
        }
        failure(task, msg);
        [self checkNeedReLogin:error];
    }];
}

//进行中的订单
+ (void)GetMyOrderListInProgressWithPageIndex:(int)PageIndex
                                     Pagesize:(int)Pagesize
                                success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                failure:(void (^)(NSURLSessionDataTask *task, NSString *errorMsg))failure
{
    AFHTTPSessionManager *manager = [self sessionManager];
    
    NSDictionary *param;
    param  = @{ @"PageIndex" : @(PageIndex),
                @"Pagesize" : @(Pagesize),
                };
    
    NSString *s = [self getTokenString];
    CHECK_TOKEN_STRING(s);
    
    [manager.requestSerializer setValue:s forHTTPHeaderField:@"Authorization"];
    
    NSLog(@"GetMyOrderListInProgress param %@", param);
    [manager POST:URL_GetMyOrderListInProgress parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *jsonFile = [NSString stringWithFormat:@"GetMyOrderListInProgress.json"];
        [self writeObject:responseObject toJsonFile:jsonFile];
        NSLog(@"GetMyOrderListInProgress success %@, %@",responseObject, [responseObject class]);
        success(task, responseObject);
        
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
        NSLog(@"GetMyOrderListInProgress fail %@, %@",error, task);
        NSString *msg = [self getServerErrorMsg:error];
        if (!msg) {
            msg = @"获取失败";
        }
        failure(task, msg);
        [self checkNeedReLogin:error];
    }];
}

//待评论的订单
+ (void)GetMyOrderListToCommentWithPageIndex:(int)PageIndex
                                     Pagesize:(int)Pagesize
                                      success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                      failure:(void (^)(NSURLSessionDataTask *task, NSString *errorMsg))failure
{
    AFHTTPSessionManager *manager = [self sessionManager];
    
    NSDictionary *param;
    param  = @{ @"PageIndex" : @(PageIndex),
                @"Pagesize" : @(Pagesize),
                };
    
    NSString *s = [self getTokenString];
    CHECK_TOKEN_STRING(s);
    
    [manager.requestSerializer setValue:s forHTTPHeaderField:@"Authorization"];
    
    NSLog(@"GetMyOrderListToComment param %@", param);
    [manager POST:URL_GetMyOrderListToComment parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *jsonFile = [NSString stringWithFormat:@"GetMyOrderListToComment.json"];
        [self writeObject:responseObject toJsonFile:jsonFile];
        NSLog(@"GetMyOrderListToComment success %@, %@",responseObject, [responseObject class]);
        success(task, responseObject);
        
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
        NSLog(@"GetMyOrderListToComment fail %@, %@",error, task);
        NSString *msg = [self getServerErrorMsg:error];
        if (!msg) {
            msg = @"获取失败";
        }
        failure(task, msg);
        [self checkNeedReLogin:error];
    }];
}

//已完成的订单
+ (void)GetMyOrderListCompletedWithPageIndex:(int)PageIndex
                                     Pagesize:(int)Pagesize
                                      success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                      failure:(void (^)(NSURLSessionDataTask *task, NSString *errorMsg))failure
{
    AFHTTPSessionManager *manager = [self sessionManager];
    
    NSDictionary *param;
    param  = @{ @"PageIndex" : @(PageIndex),
                @"Pagesize" : @(Pagesize),
                };
    
    NSString *s = [self getTokenString];
    CHECK_TOKEN_STRING(s);
    
    [manager.requestSerializer setValue:s forHTTPHeaderField:@"Authorization"];
    
    NSLog(@"GetMyOrderListCompleted param %@", param);
    [manager POST:URL_GetMyOrderListCompleted parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *jsonFile = [NSString stringWithFormat:@"GetMyOrderListCompleted.json"];
        [self writeObject:responseObject toJsonFile:jsonFile];
        NSLog(@"GetMyOrderListCompleted success %@, %@",responseObject, [responseObject class]);
        success(task, responseObject);
        
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
        NSLog(@"GetMyOrderListCompleted fail %@, %@",error, task);
        NSString *msg = [self getServerErrorMsg:error];
        if (!msg) {
            msg = @"获取失败";
        }
        failure(task, msg);
        [self checkNeedReLogin:error];
    }];
}

//添加评论
+ (void)AddCommentWithOrderId:(NSString *)OrderId
                                    Positive:(NSString *)Positive
                                    Message:(NSString *)Message
                                    TagList:(NSArray *)TagList
                                     success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                     failure:(void (^)(NSURLSessionDataTask *task, NSString *errorMsg))failure
{
    AFHTTPSessionManager *manager = [self sessionManager];
    
    NSDictionary *param;
    param  = @{ @"ObjectType" : @"SALES_ORDER",
                @"ObjectId" : OrderId,
                @"ParentCommentId" : @"0",
                @"Positive" : Positive,
                @"Message" : Message,
                @"TagList" : TagList,
                };
    
    NSString *s = [self getTokenString];
    CHECK_TOKEN_STRING(s);
    
    [manager.requestSerializer setValue:s forHTTPHeaderField:@"Authorization"];
    
    NSLog(@"AddComment param %@", param);
    [manager POST:URL_AddComment parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *jsonFile = [NSString stringWithFormat:@"AddComment.json"];
        [self writeObject:responseObject toJsonFile:jsonFile];
        NSLog(@"AddComment success %@, %@",responseObject, [responseObject class]);
        success(task, responseObject);
        
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
        NSLog(@"AddComment fail %@, %@",error, task);
        NSString *msg = [self getServerErrorMsg:error];
        if (!msg) {
            msg = @"获取失败";
        }
        failure(task, msg);
        [self checkNeedReLogin:error];
    }];
}

//根据指定条件来搜索评论记录 
+ (void)GetCommentListWithPageIndex:(int)PageIndex
                     Pagesize:(int)Pagesize
                      success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                      failure:(void (^)(NSURLSessionDataTask *task, NSString *errorMsg))failure
{
    AFHTTPSessionManager *manager = [self sessionManager];
    
    NSDictionary *param;
    param  = @{
               @"ModelFilter" : @{
                       @"ObjectType" : @"SALES_ORDER",
                       },
               @"PageFilter" : @{
                       @"PageIndex" : @(PageIndex),
                       @"Pagesize" : @(Pagesize)
                       }
               };
    
    NSString *s = [self getTokenString];
    CHECK_TOKEN_STRING(s);
    
    [manager.requestSerializer setValue:s forHTTPHeaderField:@"Authorization"];
    
    NSLog(@"GetCommentList param %@", param);
    [manager POST:URL_GetCommentList parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *jsonFile = [NSString stringWithFormat:@"GetCommentList.json"];
        [self writeObject:responseObject toJsonFile:jsonFile];
        NSLog(@"GetCommentList success %@, %@",responseObject, [responseObject class]);
        success(task, responseObject);
        
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
        NSLog(@"GetCommentList fail %@, %@",error, task);
        NSString *msg = [self getServerErrorMsg:error];
        if (!msg) {
            msg = @"获取失败";
        }
        failure(task, msg);
        [self checkNeedReLogin:error];
    }];
}

//回复评论,仅测试
+ (void)ReplyCommentWithParentCommentId:(NSString *)ParentCommentId
                           Message:(NSString *)Message
                            success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                            failure:(void (^)(NSURLSessionDataTask *task, NSString *errorMsg))failure
{
    AFHTTPSessionManager *manager = [self sessionManager];
    
    NSDictionary *param;
    param  = @{
               @"ParentCommentId" : ParentCommentId,
               @"Positive" : @"POSITIVE",
               @"Message" : Message
               };
    
    NSString *s = [self getTokenString];
    CHECK_TOKEN_STRING(s);
    
    [manager.requestSerializer setValue:s forHTTPHeaderField:@"Authorization"];
    
    NSLog(@"ReplyComment param %@", param);
    [manager POST:URL_ReplyComment parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *jsonFile = [NSString stringWithFormat:@"ReplyComment.json"];
        [self writeObject:responseObject toJsonFile:jsonFile];
        NSLog(@"ReplyComment success %@, %@",responseObject, [responseObject class]);
        success(task, responseObject);
        
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
        NSLog(@"ReplyComment fail %@, %@",error, task);
        NSString *msg = [self getServerErrorMsg:error];
        if (!msg) {
            msg = @"获取失败";
        }
        failure(task, msg);
        [self checkNeedReLogin:error];
    }];
}

//搜索厨房评论
+ (void)GetCommentListOpenWithPageIndex:(int)PageIndex
                           Pagesize:(int)Pagesize
                              kitchenId:(NSString *)kitchenId
                            success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                            failure:(void (^)(NSURLSessionDataTask *task, NSString *errorMsg))failure
{
    AFHTTPSessionManager *manager = [self sessionManager];
    
    NSDictionary *param;
    param  = @{
               @"ModelFilter" : @{
                       @"ObjectType" : @"SALES_ORDER",
                       @"KitchenId" : kitchenId
                       },
               @"PageFilter" : @{
                       @"PageIndex" : @(PageIndex),
                       @"Pagesize" : @(Pagesize)
                       }
               };
    
    NSString *s = [self getTokenString];
    CHECK_TOKEN_STRING(s);
    
    [manager.requestSerializer setValue:s forHTTPHeaderField:@"Authorization"];
    
    NSLog(@"GetCommentListOpen param %@", param);
    [manager POST:URL_GetCommentListOpen parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *jsonFile = [NSString stringWithFormat:@"GetCommentListOpen.json"];
        [self writeObject:responseObject toJsonFile:jsonFile];
        NSLog(@"GetCommentListOpen success %@, %@",responseObject, [responseObject class]);
        success(task, responseObject);
        
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
        NSLog(@"GetCommentListOpen fail %@, %@",error, task);
        NSString *msg = [self getServerErrorMsg:error];
        if (!msg) {
            msg = @"获取失败";
        }
        failure(task, msg);
        [self checkNeedReLogin:error];
    }];
}

//上传图片至服务器
+ (void)UploadWithImage:(UIImage *)image
                                success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                failure:(void (^)(NSURLSessionDataTask *task, NSString *errorMsg))failure
{
    AFHTTPSessionManager *manager = [self sessionManager];
    
    
    NSString *s = [self getTokenString];
    CHECK_TOKEN_STRING(s);
    
    [manager.requestSerializer setValue:s forHTTPHeaderField:@"Authorization"];
    
    [manager POST:URL_Upload parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> _Nonnull formData) {
        NSData *imageData =UIImageJPEGRepresentation(image,1);
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat =@"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
        [formData appendPartWithFileData:imageData
                        name:@"ImageFile"
                        fileName:fileName
                        mimeType:@"image/jpeg"];
        
     } progress:^(NSProgress *_Nonnull uploadProgress) {
         
     } success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
         NSString *jsonFile = [NSString stringWithFormat:@"Upload.json"];
         [self writeObject:responseObject toJsonFile:jsonFile];
         NSLog(@"Upload success %@, %@",responseObject, [responseObject class]);
         success(task, responseObject);
         
     } failure:^(NSURLSessionDataTask *_Nullable task, NSError * _Nonnull error) {
         NSLog(@"Upload fail %@, %@",error, task);
         NSString *msg = [self getServerErrorMsg:error];
         if (!msg) {
             msg = @"获取失败";
         }
         failure(task, msg);
        [self checkNeedReLogin:error];
     } ];
}

//更新用户头像
+ (void)UpdateUserImageWithImageId:(NSString *)ImageId
                                success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                failure:(void (^)(NSURLSessionDataTask *task, NSString *errorMsg))failure
{
    AFHTTPSessionManager *manager = [self sessionManager];
    
    NSDictionary *param;
    param  = @{
               @"ImageId" : ImageId
               };
    
    NSString *s = [self getTokenString];
    CHECK_TOKEN_STRING(s);
    
    [manager.requestSerializer setValue:s forHTTPHeaderField:@"Authorization"];
    
    NSLog(@"UpdateUserImage param %@", param);
    [manager POST:URL_UpdateUserImage parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *jsonFile = [NSString stringWithFormat:@"UpdateUserImage.json"];
        [self writeObject:responseObject toJsonFile:jsonFile];
        NSLog(@"UpdateUserImage success %@, %@",responseObject, [responseObject class]);
        success(task, responseObject);
        
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
        NSLog(@"UpdateUserImage fail %@, %@",error, task);
        NSString *msg = [self getServerErrorMsg:error];
        if (!msg) {
            msg = @"获取失败";
        }
        failure(task, msg);
        [self checkNeedReLogin:error];
    }];
}

//更新用户信息
+ (void)UpdateUserDetailsWithDisplayName:(NSString *)DisplayName
                                  isMale:(BOOL)isMale
                           success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                           failure:(void (^)(NSURLSessionDataTask *task, NSString *errorMsg))failure
{
    AFHTTPSessionManager *manager = [self sessionManager];
    
    NSString *gender;
    if (isMale) {
        gender = @"M";
    } else {
        gender = @"F";
    }
    NSDictionary *param;
    param  = @{
               @"DisplayName" : DisplayName,
               @"Gender" : gender
               };
    
    NSString *s = [self getTokenString];
    CHECK_TOKEN_STRING(s);
    
    [manager.requestSerializer setValue:s forHTTPHeaderField:@"Authorization"];
    
    NSLog(@"UpdateUserDetails param %@", param);
    [manager POST:URL_UpdateUserDetails parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *jsonFile = [NSString stringWithFormat:@"UpdateUserDetails.json"];
        [self writeObject:responseObject toJsonFile:jsonFile];
        NSLog(@"UpdateUserDetails success %@, %@",responseObject, [responseObject class]);
        success(task, responseObject);
        
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
        NSLog(@"UpdateUserDetails fail %@, %@",error, task);
        NSString *msg = [self getServerErrorMsg:error];
        if (!msg) {
            msg = @"获取失败";
        }
        failure(task, msg);
        [self checkNeedReLogin:error];
    }];
}


//获取当前用户的详情
+ (void)GetMyDetailsSuccess:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                 failure:(void (^)(NSURLSessionDataTask *task, NSString *errorMsg))failure
{
    AFHTTPSessionManager *manager = [self sessionManager];
    
    NSDictionary *param = nil;
    NSString *s = [self getTokenString];
    CHECK_TOKEN_STRING(s);
    
    [manager.requestSerializer setValue:s forHTTPHeaderField:@"Authorization"];
    
    NSLog(@"GetMyDetails param %@", param);
    [manager POST:URL_GetMyDetails parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *jsonFile = [NSString stringWithFormat:@"GetMyDetails.json"];
        [self writeObject:responseObject toJsonFile:jsonFile];
        NSLog(@"GetMyDetails success %@, %@",responseObject, [responseObject class]);
        success(task, responseObject);
        
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
        NSLog(@"GetMyDetails fail %@, %@",error, task);
        NSString *msg = [self getServerErrorMsg:error];
        if (!msg) {
            msg = @"获取失败";
        }
        failure(task, msg);
        [self checkNeedReLogin:error];
    }];
}


//注册厨房信息
+ (void)RegisterWithName:(NSString *)Name
                           ChefUsername:(NSString *)ChefUsername
                      isMale:(BOOL)isMale
                   AddressLine1:(NSString *)AddressLine1
                           City:(NSString *)City
                            State:(NSString *)State
                          Postcode:(NSString *)Postcode
                       Longitude:(NSString *)Longitude
                        Latitude:(NSString *)Latitude
                                  success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                  failure:(void (^)(NSURLSessionDataTask *task, NSString *errorMsg))failure
{
    AFHTTPSessionManager *manager = [self sessionManager];
    NSString *gender;
    if (isMale) {
        gender = @"M";
    } else {
        gender = @"F";
    }
    
    NSDictionary *param;
    param  = @{ @"Name" : Name,
                @"ChefUsername" : ChefUsername,
                @"ChefGender" : gender,
                @"AddressLine1" : AddressLine1,
                @"AddressLine2" : @"",
                @"AddressLine3" : @"",
                @"City" : City,
                @"State" : State,
                @"Country" : @"US",
                @"Postcode" : Postcode,
                @"Latitude" : [self getLatitudeString],
                @"Longitude" : [self getLongitudeString],
                @"PortraitImageId" : @(0),
                @"ThemeImageId" : @(0),
                @"KitchenStory" : @"",
                @"BroadcastMessage" : @"",
                @"CanPickup" : @(YES),
                @"CanDeliver" : @(NO),
                @"InvitationCode" : @"",
                };
    
    NSString *s = [self getTokenString];
    if (!s.length) {
        s = [WEGlobalData sharedInstance].registerToken;
    }
    
    [manager.requestSerializer setValue:s forHTTPHeaderField:@"Authorization"];
    
    NSLog(@"Register param %@", param);
    [manager POST:URL_Register parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *jsonFile = [NSString stringWithFormat:@"Register.json"];
        [self writeObject:responseObject toJsonFile:jsonFile];
        NSLog(@"Register success %@, %@",responseObject, [responseObject class]);
        success(task, responseObject);
        
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
        NSLog(@"Register fail %@, %@",error, task);
        NSString *msg = [self getServerErrorMsg:error];
        if (!msg) {
            msg = @"获取失败";
        }
        failure(task, msg);
        [self checkNeedReLogin:error];
    }];
}

//为当前用户添加新的送餐地址
+ (void)AddDeliveryAddressWithContactName:(NSString *)ContactName
            PhoneNumber:(NSString *)PhoneNumber
            DisplayOrder:(int)DisplayOrder
            AddressLine1:(NSString *)AddressLine1
                    City:(NSString *)City
                   State:(NSString *)State
                Postcode:(NSString *)Postcode
               Longitude:(NSString *)Longitude
                Latitude:(NSString *)Latitude
                 success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                 failure:(void (^)(NSURLSessionDataTask *task, NSString *errorMsg))failure
{
    AFHTTPSessionManager *manager = [self sessionManager];
    
    NSDictionary *param;
    param  = @{ @"Name" : @"",
                @"DisplayOrder" : @(DisplayOrder),
                @"AddressLine1" : AddressLine1,
                @"AddressLine2" : @"",
                @"AddressLine3" : @"",
                @"City" : City,
                @"State" : State,
                @"Country" : @"US",
                @"Postcode" : Postcode,
                @"Latitude" : [self getLatitudeString],
                @"Longitude" : [self getLongitudeString],
                @"ContactName" : ContactName,
                @"PhoneNumber" : PhoneNumber,
                };
    
    NSString *s = [self getTokenString];
    CHECK_TOKEN_STRING(s);
    
    [manager.requestSerializer setValue:s forHTTPHeaderField:@"Authorization"];
    
    NSLog(@"AddDeliveryAddress param %@", param);
    [manager POST:URL_AddDeliveryAddress parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *jsonFile = [NSString stringWithFormat:@"AddDeliveryAddress.json"];
        [self writeObject:responseObject toJsonFile:jsonFile];
        NSLog(@"AddDeliveryAddress success %@, %@",responseObject, [responseObject class]);
        success(task, responseObject);
        
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
        NSLog(@"AddDeliveryAddress fail %@, %@",error, task);
        NSString *msg = [self getServerErrorMsg:error];
        if (!msg) {
            msg = @"获取失败";
        }
        failure(task, msg);
        [self checkNeedReLogin:error];
    }];
}

//移除送餐地址
+ (void)DeleteDeliveryAddressWithAddressId:(NSString *)AddressId
                          success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                          failure:(void (^)(NSURLSessionDataTask *task, NSString *errorMsg))failure
{
    AFHTTPSessionManager *manager = [self sessionManager];
    
    NSDictionary *param;
    param  = @{ @"AddressId" : AddressId,
                };
    
    NSString *s = [self getTokenString];
    CHECK_TOKEN_STRING(s);
    
    [manager.requestSerializer setValue:s forHTTPHeaderField:@"Authorization"];
    
    NSLog(@"DeleteDeliveryAddress param %@", param);
    [manager POST:URL_DeleteDeliveryAddress parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *jsonFile = [NSString stringWithFormat:@"DeleteDeliveryAddress.json"];
        [self writeObject:responseObject toJsonFile:jsonFile];
        NSLog(@"DeleteDeliveryAddress success %@, %@",responseObject, [responseObject class]);
        success(task, responseObject);
        
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
        NSLog(@"DeleteDeliveryAddress fail %@, %@",error, task);
        NSString *msg = [self getServerErrorMsg:error];
        if (!msg) {
            msg = @"获取失败";
        }
        failure(task, msg);
        [self checkNeedReLogin:error];
    }];
}

//获取当前用户的送餐地址列表 
+ (void)GetMyDeliveryAddressListWithSuccess:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                   failure:(void (^)(NSURLSessionDataTask *task, NSString *errorMsg))failure
{
    AFHTTPSessionManager *manager = [self sessionManager];
    
    NSDictionary *param;
    param  = nil;
    
    NSString *s = [self getTokenString];
    CHECK_TOKEN_STRING(s);
    
    [manager.requestSerializer setValue:s forHTTPHeaderField:@"Authorization"];
    
    NSLog(@"GetMyDeliveryAddressList param %@", param);
    [manager GET:URL_GetMyDeliveryAddressList parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *jsonFile = [NSString stringWithFormat:@"GetMyDeliveryAddressList.json"];
        [self writeObject:responseObject toJsonFile:jsonFile];
        NSLog(@"GetMyDeliveryAddressList success %@, %@",responseObject, [responseObject class]);
        success(task, responseObject);
        
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
        NSLog(@"GetMyDeliveryAddressList fail %@, %@",error, task);
        NSString *msg = [self getServerErrorMsg:error];
        if (!msg) {
            msg = @"获取失败";
        }
        failure(task, msg);
        [self checkNeedReLogin:error];
    }];
}

//根据关键字搜索厨房和菜品
+ (void)WildSearchWithKeywords:(NSString *)Keywords
                      PageIndex:(int)PageIndex
                         Longitude:(NSString *)Longitude
                          Latitude:(NSString *)Latitude
                           success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                           failure:(void (^)(NSURLSessionDataTask *task, NSString *errorMsg))failure
{
    AFHTTPSessionManager *manager = [self sessionManager];
    
    NSDictionary *param;
    param  = @{ @"Keywords" : Keywords,
                @"PageIndex" : @(PageIndex),
                @"Latitude" : [self getLatitudeString],
                @"Longitude" : [self getLongitudeString],
                };
    
    NSString *s = [self getTokenString];
    CHECK_TOKEN_STRING(s);
    
    [manager.requestSerializer setValue:s forHTTPHeaderField:@"Authorization"];
    
    NSLog(@"WildSearch param %@", param);
    [manager POST:URL_WildSearch parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *jsonFile = [NSString stringWithFormat:@"WildSearch.json"];
        [self writeObject:responseObject toJsonFile:jsonFile];
        NSLog(@"WildSearch success %@, %@",responseObject, [responseObject class]);
        success(task, responseObject);
        
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
        NSLog(@"WildSearch fail %@, %@",error, task);
        NSString *msg = [self getServerErrorMsg:error];
        if (!msg) {
            msg = @"获取失败";
        }
        failure(task, msg);
        [self checkNeedReLogin:error];
    }];
}

//根据经纬度获取地址信息
+ (void)GetAddressFromLatLngWitLat:(NSString *)Lat
                      Lng:(NSString *)Lng
                       success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                       failure:(void (^)(NSURLSessionDataTask *task, NSString *errorMsg))failure
{
    AFHTTPSessionManager *manager = [self sessionManager];
    
    NSDictionary *param;
    param  = @{ @"Lat" : Lat,
                @"Lng" : Lng,
                };
    
    NSString *s = [self getTokenString];
    CHECK_TOKEN_STRING(s);
    
    [manager.requestSerializer setValue:s forHTTPHeaderField:@"Authorization"];
    
    NSLog(@"GetAddressFromLatLng param %@", param);
    [manager POST:URL_GetAddressFromLatLng parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *jsonFile = [NSString stringWithFormat:@"GetAddressFromLatLng.json"];
        [self writeObject:responseObject toJsonFile:jsonFile];
        NSLog(@"GetAddressFromLatLng success %@, %@",responseObject, [responseObject class]);
        success(task, responseObject);
        
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
        NSLog(@"GetAddressFromLatLng fail %@, %@",error, task);
        NSString *msg = [self getServerErrorMsg:error];
        if (!msg) {
            msg = @"获取失败";
        }
        failure(task, msg);
        [self checkNeedReLogin:error];
    }];
}

//根据指定ItemId来获取专门针对饭友端返回的菜品信息
+ (void)GetConsumerItemWithItemId:(NSString *)ItemId
                           success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                           failure:(void (^)(NSURLSessionDataTask *task, NSString *errorMsg))failure
{
    AFHTTPSessionManager *manager = [self sessionManager];
    
    NSDictionary *param;
    param  = @{ @"ItemId" : ItemId,
                };
    
    NSString *s = [self getTokenString];
    CHECK_TOKEN_STRING(s);
    
    [manager.requestSerializer setValue:s forHTTPHeaderField:@"Authorization"];
    
    NSLog(@"GetConsumerItem param %@", param);
    [manager GET:URL_GetConsumerItem parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *jsonFile = [NSString stringWithFormat:@"GetConsumerItem.json"];
        [self writeObject:responseObject toJsonFile:jsonFile];
        NSLog(@"GetConsumerItem success %@, %@",responseObject, [responseObject class]);
        success(task, responseObject);
        
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
        NSLog(@"GetConsumerItem fail %@, %@",error, task);
        NSString *msg = [self getServerErrorMsg:error];
        if (!msg) {
            msg = @"获取失败";
        }
        failure(task, msg);
        [self checkNeedReLogin:error];
    }];
}

//获取当前家厨用户的菜品列表
+ (void)GetAllItemListByKitchenIdWithKitchenId:(NSString *)KitchenId
                          success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                          failure:(void (^)(NSURLSessionDataTask *task, NSString *errorMsg))failure
{
    AFHTTPSessionManager *manager = [self sessionManager];
    
    NSDictionary *param;
    param  = @{ @"KitchenId" : KitchenId,
                };
    
    NSString *s = [self getTokenString];
    CHECK_TOKEN_STRING(s);
    
    [manager.requestSerializer setValue:s forHTTPHeaderField:@"Authorization"];
    
    NSLog(@"GetAllItemListByKitchenId param %@", param);
    [manager GET:URL_GetAllItemListByKitchenId parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *jsonFile = [NSString stringWithFormat:@"GetAllItemListByKitchenId.json"];
        [self writeObject:responseObject toJsonFile:jsonFile];
        NSLog(@"GetAllItemListByKitchenId success %@, %@",responseObject, [responseObject class]);
        success(task, responseObject);
        
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
        NSLog(@"GetAllItemListByKitchenId fail %@, %@",error, task);
        NSString *msg = [self getServerErrorMsg:error];
        if (!msg) {
            msg = @"获取失败";
        }
        failure(task, msg);
        [self checkNeedReLogin:error];
    }];
}

//厨房tag
+ (void)GetCommentTagListOfKitchenWithKitchenId:(NSString *)KitchenId
                                       success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                       failure:(void (^)(NSURLSessionDataTask *task, NSString *errorMsg))failure
{
    AFHTTPSessionManager *manager = [self sessionManager];
    
    NSDictionary *param;
    param  = @{ @"KitchenId" : KitchenId,
                };
    
    NSString *s = [self getTokenString];
    CHECK_TOKEN_STRING(s);
    
    [manager.requestSerializer setValue:s forHTTPHeaderField:@"Authorization"];
    
    NSLog(@"GetCommentTagListOfKitchen param %@", param);
    [manager GET:URL_GetCommentTagListOfKitchen parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *jsonFile = [NSString stringWithFormat:@"GetCommentTagListOfKitchen.json"];
        [self writeObject:responseObject toJsonFile:jsonFile];
        NSLog(@"GetCommentTagListOfKitchen success %@, %@",responseObject, [responseObject class]);
        success(task, responseObject);
        
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
        NSLog(@"GetCommentTagListOfKitchen fail %@, %@",error, task);
        NSString *msg = [self getServerErrorMsg:error];
        if (!msg) {
            msg = @"获取失败";
        }
        failure(task, msg);
        [self checkNeedReLogin:error];
    }];
}

//供家厨端调用。新家厨用户申请成为家厨时，填写详细信息，通过调用此接口完成家厨用户的注册
+ (void)RegisterKitchenWithMobileNumber:(NSString *)MobileNumber
            FirstName:(NSString *)FirstName
                  LastName:(NSString *)LastName
            isMale:(BOOL)isMale
                AddressLine1:(NSString *)AddressLine1
                    City:(NSString *)City
                   State:(NSString *)State
                Postcode:(NSString *)Postcode
               Longitude:(NSString *)Longitude
                Latitude:(NSString *)Latitude
                 success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                 failure:(void (^)(NSURLSessionDataTask *task, NSString *errorMsg))failure
{
    AFHTTPSessionManager *manager = [self sessionManager];
    NSString *Gender;
    if (isMale) {
        Gender = @"M";
    } else {
        Gender = @"F";
    }
    
    NSDictionary *param;
    param  = @{ @"MobileNumber" : MobileNumber,
                @"FirstName" : FirstName,
                @"LastName" : LastName,
                @"Gender" : Gender,
                @"AddressLine1" : AddressLine1,
                @"City" : City,
                @"State" : State,
                @"Country" : @"US",
                @"Postcode" : Postcode,
                @"Latitude" : [self getLatitudeString],
                @"Longitude" : [self getLongitudeString]
                };
    
//    NSString *s = [self getTokenString];
//    CHECK_TOKEN_STRING(s);
    NSString *s = [WEGlobalData sharedInstance].registerToken;
    
    [manager.requestSerializer setValue:s forHTTPHeaderField:@"Authorization"];
    
    NSLog(@"RegisterKitchen param %@", param);
    [manager POST:URL_RegisterKitchen parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *jsonFile = [NSString stringWithFormat:@"RegisterKitchen.json"];
        [self writeObject:responseObject toJsonFile:jsonFile];
        NSLog(@"RegisterKitchen success %@, %@",responseObject, [responseObject class]);
        success(task, responseObject);
        
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
        NSLog(@"RegisterKitchen fail %@, %@",error, task);
        NSString *msg = [self getServerErrorMsg:error];
        if (!msg) {
            msg = @"获取失败";
        }
        failure(task, msg);
        [self checkNeedReLogin:error];
    }];
}


+ (void)GetMyKitchenSalesWithSuccess:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                        failure:(void (^)(NSURLSessionDataTask *task, NSString *errorMsg))failure
{
    AFHTTPSessionManager *manager = [self sessionManager];
    
    NSDictionary *param;
    param  = nil;
    
    NSString *s = [self getTokenString];
    CHECK_TOKEN_STRING(s);
    
    [manager.requestSerializer setValue:s forHTTPHeaderField:@"Authorization"];
    
    NSLog(@"GetMyKitchenSales param %@", param);
    [manager GET:URL_GetMyKitchenSales parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *jsonFile = [NSString stringWithFormat:@"GetMyKitchenSales.json"];
        [self writeObject:responseObject toJsonFile:jsonFile];
        NSLog(@"GetMyKitchenSales success %@, %@",responseObject, [responseObject class]);
        success(task, responseObject);
        
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
        NSLog(@"GetMyKitchenSales fail %@, %@",error, task);
        NSString *msg = [self getServerErrorMsg:error];
        if (!msg) {
            msg = @"获取失败";
        }
        failure(task, msg);
        [self checkNeedReLogin:error];
    }];
}

//添加菜品
+ (void)AddItemWithName:(NSString *)Name
                              DisplayOrder:(int)DisplayOrder
                               Description:(NSString *)Description
                                 UnitPrice:(NSString *)UnitPrice
                           DailyAvailability:(int)DailyAvailability
                                   IsFeatured:(BOOL)IsFeatured
                                   CanPreorder:(BOOL)CanPreorder
                                   NeedPreorder:(BOOL)NeedPreorder
                                   IsActive:(BOOL)IsActive
                                    ImageIds:(NSArray *)ImageIds
                                success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                failure:(void (^)(NSURLSessionDataTask *task, NSString *errorMsg))failure
{
    AFHTTPSessionManager *manager = [self sessionManager];
    
    NSDictionary *param;
    param  = @{ @"Name" : Name,
                @"DisplayOrder" : @(DisplayOrder),
                @"Description" : Description,
                @"UnitPrice" : UnitPrice,
                @"DailyAvailability" : @(DailyAvailability),
                @"IsFeatured" : @(IsFeatured),
                @"CanPreorder" : @(CanPreorder),
                @"NeedPreorder" : @(NeedPreorder),
                @"IsActive" : @(IsActive),
                //@"ImageIds" : ImageIds,
                };
    
    NSString *s = [self getTokenString];
    CHECK_TOKEN_STRING(s);
    
    [manager.requestSerializer setValue:s forHTTPHeaderField:@"Authorization"];
    
    NSLog(@"AddItem param %@", param);
    [manager POST:URL_AddItem parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *jsonFile = [NSString stringWithFormat:@"AddItem.json"];
        [self writeObject:responseObject toJsonFile:jsonFile];
        NSLog(@"AddItem success %@, %@",responseObject, [responseObject class]);
        success(task, responseObject);
        
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
        NSLog(@"AddItem fail %@, %@",error, task);
        NSString *msg = [self getServerErrorMsg:error];
        if (!msg) {
            msg = @"获取失败";
        }
        failure(task, msg);
        [self checkNeedReLogin:error];
    }];
}

//更新菜品
+ (void)UpdateItemWithId:(NSString *)Id
            KitchenId:(NSString *)KitchenId
            Name:(NSString *)Name
           DisplayOrder:(int)DisplayOrder
            Description:(NSString *)Description
              UnitPrice:(NSString *)UnitPrice
      DailyAvailability:(int)DailyAvailability
             IsFeatured:(BOOL)IsFeatured
            CanPreorder:(BOOL)CanPreorder
           NeedPreorder:(BOOL)NeedPreorder
               IsActive:(BOOL)IsActive
               ImageIds:(NSArray *)ImageIds
                success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                failure:(void (^)(NSURLSessionDataTask *task, NSString *errorMsg))failure
{
    AFHTTPSessionManager *manager = [self sessionManager];
    
    NSDictionary *param;
    param  = @{ @"Id" : Id,
                @"KitchenId" : KitchenId,
                @"Name" : Name,
                @"DisplayOrder" : @(DisplayOrder),
                @"Description" : Description,
                @"UnitPrice" : UnitPrice,
                @"DailyAvailability" : @(DailyAvailability),
                @"IsFeatured" : @(IsFeatured),
                @"CanPreorder" : @(CanPreorder),
                @"NeedPreorder" : @(NeedPreorder),
                @"IsActive" : @(IsActive),
                //@"ImageIds" : ImageIds,
                };
    
    NSString *s = [self getTokenString];
    CHECK_TOKEN_STRING(s);
    
    [manager.requestSerializer setValue:s forHTTPHeaderField:@"Authorization"];
    
    NSLog(@"UpdateItem param %@", param);
    [manager POST:URL_UpdateItem parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *jsonFile = [NSString stringWithFormat:@"UpdateItem.json"];
        [self writeObject:responseObject toJsonFile:jsonFile];
        NSLog(@"UpdateItem success %@, %@",responseObject, [responseObject class]);
        success(task, responseObject);
        
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
        NSLog(@"UpdateItem fail %@, %@",error, task);
        NSString *msg = [self getServerErrorMsg:error];
        if (!msg) {
            msg = @"获取失败";
        }
        failure(task, msg);
        [self checkNeedReLogin:error];
    }];
}

//删除菜品
+ (void)DeleteItemWithItemId:(NSString *)ItemId
                                success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                failure:(void (^)(NSURLSessionDataTask *task, NSString *errorMsg))failure
{
    AFHTTPSessionManager *manager = [self sessionManager];
    NSString *TAG = @"DeleteItem";
    
    NSDictionary *param;
    param  = @{ @"ItemId" : ItemId,
                };
    
    NSString *s = [self getTokenString];
    CHECK_TOKEN_STRING(s);
    
    [manager.requestSerializer setValue:s forHTTPHeaderField:@"Authorization"];
    
    NSLog(@"%@ param %@", TAG, param);
    [manager POST:URL_DeleteItem parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *jsonFile = [NSString stringWithFormat:@"%@.json", TAG];
        [self writeObject:responseObject toJsonFile:jsonFile];
        NSLog(@"%@ success %@, %@", TAG, responseObject, [responseObject class]);
        success(task, responseObject);
        
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
        NSLog(@"%@ fail %@, %@", TAG, error, task);
        NSString *msg = [self getServerErrorMsg:error];
        if (!msg) {
            msg = @"获取失败";
        }
        failure(task, msg);
        [self checkNeedReLogin:error];
    }];
}

//上架菜品
+ (void)ActivateWithItemId:(NSString *)ItemId
                     success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                     failure:(void (^)(NSURLSessionDataTask *task, NSString *errorMsg))failure
{
    AFHTTPSessionManager *manager = [self sessionManager];
    NSString *TAG = @"Activate";
    
    NSDictionary *param;
    param  = @{ @"ItemId" : ItemId,
                };
    
    NSString *s = [self getTokenString];
    CHECK_TOKEN_STRING(s);
    
    [manager.requestSerializer setValue:s forHTTPHeaderField:@"Authorization"];
    
    NSLog(@"%@ param %@", TAG, param);
    [manager POST:URL_Activate parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *jsonFile = [NSString stringWithFormat:@"%@.json", TAG];
        [self writeObject:responseObject toJsonFile:jsonFile];
        NSLog(@"%@ success %@, %@", TAG, responseObject, [responseObject class]);
        success(task, responseObject);
        
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
        NSLog(@"%@ fail %@, %@", TAG, error, task);
        NSString *msg = [self getServerErrorMsg:error];
        if (!msg) {
            msg = @"获取失败";
        }
        failure(task, msg);
        [self checkNeedReLogin:error];
    }];
}

//下架菜品
+ (void)DeactivateWithItemId:(NSString *)ItemId
                   success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                   failure:(void (^)(NSURLSessionDataTask *task, NSString *errorMsg))failure
{
    AFHTTPSessionManager *manager = [self sessionManager];
    NSString *TAG = @"Deactivate";
    
    NSDictionary *param;
    param  = @{ @"ItemId" : ItemId,
                };
    
    NSString *s = [self getTokenString];
    CHECK_TOKEN_STRING(s);
    
    [manager.requestSerializer setValue:s forHTTPHeaderField:@"Authorization"];
    
    NSLog(@"%@ param %@", TAG, param);
    [manager POST:URL_Deactivate parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *jsonFile = [NSString stringWithFormat:@"%@.json", TAG];
        [self writeObject:responseObject toJsonFile:jsonFile];
        NSLog(@"%@ success %@, %@", TAG, responseObject, [responseObject class]);
        success(task, responseObject);
        
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
        NSLog(@"%@ fail %@, %@", TAG, error, task);
        NSString *msg = [self getServerErrorMsg:error];
        if (!msg) {
            msg = @"获取失败";
        }
        failure(task, msg);
        [self checkNeedReLogin:error];
    }];
}

//获取当前家厨用户的菜品列表
+ (void)GetAllMyItemListWithSuccess:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                     failure:(void (^)(NSURLSessionDataTask *task, NSString *errorMsg))failure
{
    AFHTTPSessionManager *manager = [self sessionManager];
    NSString *TAG = @"GetAllMyItemList";
    
    NSDictionary *param;
    param  = nil;
    
    NSString *s = [self getTokenString];
    CHECK_TOKEN_STRING(s);
    
    [manager.requestSerializer setValue:s forHTTPHeaderField:@"Authorization"];
    
    NSLog(@"%@ param %@", TAG, param);
    [manager POST:URL_GetAllMyItemList parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *jsonFile = [NSString stringWithFormat:@"%@.json", TAG];
        [self writeObject:responseObject toJsonFile:jsonFile];
        NSLog(@"%@ success %@, %@", TAG, responseObject, [responseObject class]);
        success(task, responseObject);
        
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
        NSLog(@"%@ fail %@, %@", TAG, error, task);
        NSString *msg = [self getServerErrorMsg:error];
        if (!msg) {
            msg = @"获取失败";
        }
        failure(task, msg);
        [self checkNeedReLogin:error];
    }];
}

//上传菜品图片至服务器
+ (void)UploadItemImageWithImage:(UIImage *)image
                          ItemId:(NSString *)ItemId
                success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                failure:(void (^)(NSURLSessionDataTask *task, NSString *errorMsg))failure
{
    AFHTTPSessionManager *manager = [self sessionManager];
    
    
    NSString *s = [self getTokenString];
    CHECK_TOKEN_STRING(s);
    
    NSDictionary *param;
    param  = @{ @"ItemId" : ItemId,
                };
    
    [manager.requestSerializer setValue:s forHTTPHeaderField:@"Authorization"];
    
    [manager POST:URL_UploadItemImage parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData> _Nonnull formData) {
        NSData *imageData =UIImageJPEGRepresentation(image,1);
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat =@"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
        [formData appendPartWithFileData:imageData
                                    name:@"ImageFile"
                                fileName:fileName
                                mimeType:@"image/jpeg"];
        
    } progress:^(NSProgress *_Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
        NSString *jsonFile = [NSString stringWithFormat:@"UploadItemImage.json"];
        [self writeObject:responseObject toJsonFile:jsonFile];
        NSLog(@"UploadItemImage success %@, %@",responseObject, [responseObject class]);
        success(task, responseObject);
        
    } failure:^(NSURLSessionDataTask *_Nullable task, NSError * _Nonnull error) {
        NSLog(@"UploadItemImage fail %@, %@",error, task);
        NSString *msg = [self getServerErrorMsg:error];
        if (!msg) {
            msg = @"获取失败";
        }
        failure(task, msg);
        [self checkNeedReLogin:error];
    } ];
}

//获取指定Id的厨房信息
+ (void)GetWithKitchenId:(NSString *)KitchenId
                   success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                   failure:(void (^)(NSURLSessionDataTask *task, NSString *errorMsg))failure
{
    AFHTTPSessionManager *manager = [self sessionManager];
    NSString *TAG = @"Get";
    
    NSDictionary *param;
    param  = @{ @"KitchenId" : KitchenId,
                };
    
    NSString *s = [self getTokenString];
    CHECK_TOKEN_STRING(s);
    
    [manager.requestSerializer setValue:s forHTTPHeaderField:@"Authorization"];
    
    NSLog(@"%@ param %@", TAG, param);
    [manager POST:URL_Get parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *jsonFile = [NSString stringWithFormat:@"%@.json", TAG];
        [self writeObject:responseObject toJsonFile:jsonFile];
        NSLog(@"%@ success %@, %@", TAG, responseObject, [responseObject class]);
        success(task, responseObject);
        
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
        NSLog(@"%@ fail %@, %@", TAG, error, task);
        NSString *msg = [self getServerErrorMsg:error];
        if (!msg) {
            msg = @"获取失败";
        }
        failure(task, msg);
        [self checkNeedReLogin:error];
    }];
}

//返回当前家厨用户的厨房信息，仅供家厨端调用。如家厨还未注册，则返回Id为0的家厨json数据，其他属性均为默认值
+ (void)GetMyKitchenWithSuccess:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                 failure:(void (^)(NSURLSessionDataTask *task, NSString *errorMsg))failure
{
    AFHTTPSessionManager *manager = [self sessionManager];
    NSString *TAG = @"GetMyKitchen";
    
    NSDictionary *param;
    param  = nil;
    
    NSString *s = [self getTokenString];
    CHECK_TOKEN_STRING(s);
    
    [manager.requestSerializer setValue:s forHTTPHeaderField:@"Authorization"];
    
    NSLog(@"%@ param %@", TAG, param);
    [manager GET:URL_GetMyKitchen parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *jsonFile = [NSString stringWithFormat:@"%@.json", TAG];
        [self writeObject:responseObject toJsonFile:jsonFile];
        NSLog(@"%@ success %@, %@", TAG, responseObject, [responseObject class]);
        success(task, responseObject);
        
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
        NSLog(@"%@ fail %@, %@", TAG, error, task);
        NSString *msg = [self getServerErrorMsg:error];
        if (!msg) {
            msg = @"获取失败";
        }
        failure(task, msg);
        [self checkNeedReLogin:error];
    }];
}

+ (void)SwitchOnOffWithSuccess:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                        failure:(void (^)(NSURLSessionDataTask *task, NSString *errorMsg))failure
{
    AFHTTPSessionManager *manager = [self sessionManager];
    NSString *TAG = @"SwitchOnOff";
    
    NSDictionary *param;
    param  = nil;
    
    NSString *s = [self getTokenString];
    CHECK_TOKEN_STRING(s);
    
    [manager.requestSerializer setValue:s forHTTPHeaderField:@"Authorization"];
    
    NSLog(@"%@ param %@", TAG, param);
    [manager POST:URL_SwitchOnOff parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *jsonFile = [NSString stringWithFormat:@"%@.json", TAG];
        [self writeObject:responseObject toJsonFile:jsonFile];
        NSLog(@"%@ success %@, %@", TAG, responseObject, [responseObject class]);
        success(task, responseObject);
        
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
        NSLog(@"%@ fail %@, %@", TAG, error, task);
        NSString *msg = [self getServerErrorMsg:error];
        if (!msg) {
            msg = @"获取失败";
        }
        failure(task, msg);
        [self checkNeedReLogin:error];
    }];
}

//更新厨房信息
+ (void)UpdateWithId:(NSString *)Id
             Name:(NSString *)Name
            AddressLine1:(NSString *)AddressLine1
                    City:(NSString *)City
                   State:(NSString *)State
                Postcode:(NSString *)Postcode
               PortraitImageId:(NSString *)PortraitImageId
                ThemeImageId:(NSString *)ThemeImageId
                KitchenStory:(NSString *)KitchenStory
                BroadcastMessage:(NSString *)BroadcastMessage
                CanPickup:(BOOL)CanPickup
                CanDeliver:(BOOL)CanDeliver
                 success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                 failure:(void (^)(NSURLSessionDataTask *task, NSString *errorMsg))failure
{
    AFHTTPSessionManager *manager = [self sessionManager];
    
    NSDictionary *param;
    param  = @{ @"Id" : Id,
                @"Name" : Name,
                @"AddressLine1" : AddressLine1,
                @"AddressLine2" : @"",
                @"AddressLine3" : @"",
                @"City" : City,
                @"State" : State,
                @"Country" : @"US",
                @"Postcode" : Postcode,
                @"Latitude" : [self getLatitudeString],
                @"Longitude" : [self getLongitudeString],
                @"PortraitImageId" : @(0),
                @"ThemeImageId" : @(0),
                @"KitchenStory" : KitchenStory,
                @"BroadcastMessage" : BroadcastMessage,
                @"CanPickup" : @(CanPickup),
                @"CanDeliver" : @(CanDeliver),
                @"InvitationCode" : @"",
                };
    
    NSString *s = [self getTokenString];
    CHECK_TOKEN_STRING(s);
    NSString *TAG = @"Update";
    
    [manager.requestSerializer setValue:s forHTTPHeaderField:@"Authorization"];
    
    NSLog(@"%@ param %@", TAG, param);
    [manager POST:URL_Update parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *jsonFile = [NSString stringWithFormat:@"%@.json", TAG];
        [self writeObject:responseObject toJsonFile:jsonFile];
        NSLog(@"%@ success %@, %@", TAG, responseObject, [responseObject class]);
        success(task, responseObject);
        
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
        NSLog(@"%@ fail %@, %@", TAG, error, task);
        NSString *msg = [self getServerErrorMsg:error];
        if (!msg) {
            msg = @"获取失败";
        }
        failure(task, msg);
        [self checkNeedReLogin:error];
    }];
}

//获取厨房营业时间，供家厨端和饭友端调用
+ (void)GetBusinessHoursWithKitchenId:(NSString *)KitchenId
                 success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                 failure:(void (^)(NSURLSessionDataTask *task, NSString *errorMsg))failure
{
    AFHTTPSessionManager *manager = [self sessionManager];
    NSString *TAG = @"GetBusinessHours";
    
    NSDictionary *param;
    param  = @{ @"KitchenId" : KitchenId,
                };
    
    NSString *s = [self getTokenString];
    CHECK_TOKEN_STRING(s);
    
    [manager.requestSerializer setValue:s forHTTPHeaderField:@"Authorization"];
    
    NSLog(@"%@ param %@", TAG, param);
    [manager GET:URL_GetBusinessHours parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *jsonFile = [NSString stringWithFormat:@"%@.json", TAG];
        [self writeObject:responseObject toJsonFile:jsonFile];
        NSLog(@"%@ success %@, %@", TAG, responseObject, [responseObject class]);
        success(task, responseObject);
        
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
        NSLog(@"%@ fail %@, %@", TAG, error, task);
        NSString *msg = [self getServerErrorMsg:error];
        if (!msg) {
            msg = @"获取失败";
        }
        failure(task, msg);
        [self checkNeedReLogin:error];
    }];
}

//设置厨房营业时间，供家厨端调用
+ (void)SetBusinessHoursWithKitchenId:(NSString *)KitchenId
                     BusinessHourList:(NSString *)BusinessHourList
                              success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                              failure:(void (^)(NSURLSessionDataTask *task, NSString *errorMsg))failure
{
    AFHTTPSessionManager *manager = [self sessionManager];
    NSString *TAG = @"SetBusinessHours";
    
    NSDictionary *param;
    param  = @{ @"KitchenId" : KitchenId,
                @"BusinessHourList" : BusinessHourList
                };
    
    NSString *s = [self getTokenString];
    CHECK_TOKEN_STRING(s);
    
    [manager.requestSerializer setValue:s forHTTPHeaderField:@"Authorization"];
    
    NSLog(@"%@ param %@", TAG, param);
    [manager POST:URL_SetBusinessHours parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *jsonFile = [NSString stringWithFormat:@"%@.json", TAG];
        [self writeObject:responseObject toJsonFile:jsonFile];
        NSLog(@"%@ success %@, %@", TAG, responseObject, [responseObject class]);
        success(task, responseObject);
        
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
        NSLog(@"%@ fail %@, %@", TAG, error, task);
        NSString *msg = [self getServerErrorMsg:error];
        if (!msg) {
            msg = @"获取失败";
        }
        failure(task, msg);
        [self checkNeedReLogin:error];
    }];
}

//上传家厨图片至服务器
+ (void)UploadKitchenImageWithImage:(UIImage *)image
                          KitchenId:(NSString *)KitchenId
                         success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                         failure:(void (^)(NSURLSessionDataTask *task, NSString *errorMsg))failure
{
    AFHTTPSessionManager *manager = [self sessionManager];
    
    
    NSString *s = [self getTokenString];
    CHECK_TOKEN_STRING(s);
    
    NSDictionary *param;
    param  = @{ @"KitchenId" : KitchenId,
                };
    
    [manager.requestSerializer setValue:s forHTTPHeaderField:@"Authorization"];
    
    [manager POST:URL_UploadKitchenImage parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData> _Nonnull formData) {
        NSData *imageData =UIImageJPEGRepresentation(image,1);
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat =@"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
        [formData appendPartWithFileData:imageData
                                    name:@"ImageFile"
                                fileName:fileName
                                mimeType:@"image/jpeg"];
        
    } progress:^(NSProgress *_Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
        NSString *jsonFile = [NSString stringWithFormat:@"UploadKitchenImage.json"];
        [self writeObject:responseObject toJsonFile:jsonFile];
        NSLog(@"UploadKitchenImage success %@, %@",responseObject, [responseObject class]);
        success(task, responseObject);
        
    } failure:^(NSURLSessionDataTask *_Nullable task, NSError * _Nonnull error) {
        NSLog(@"UploadKitchenImage fail %@, %@",error, task);
        NSString *msg = [self getServerErrorMsg:error];
        if (!msg) {
            msg = @"获取失败";
        }
        failure(task, msg);
        [self checkNeedReLogin:error];
    } ];
}


//删除家厨图片
+ (void)RemoveKitchenImageWithKitchenId:(NSString *)KitchenId
                     ImageId:(NSString *)ImageId
                              success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                              failure:(void (^)(NSURLSessionDataTask *task, NSString *errorMsg))failure
{
    AFHTTPSessionManager *manager = [self sessionManager];
    NSString *TAG = @"RemoveKitchenImage";
    
    NSDictionary *param;
    param  = @{ @"KitchenId" : KitchenId,
                @"ImageId" : ImageId
                };
    
    NSString *s = [self getTokenString];
    CHECK_TOKEN_STRING(s);
    
    [manager.requestSerializer setValue:s forHTTPHeaderField:@"Authorization"];
    
    NSLog(@"%@ param %@", TAG, param);
    [manager POST:URL_RemoveKitchenImage parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *jsonFile = [NSString stringWithFormat:@"%@.json", TAG];
        [self writeObject:responseObject toJsonFile:jsonFile];
        NSLog(@"%@ success %@, %@", TAG, responseObject, [responseObject class]);
        success(task, responseObject);
        
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
        NSLog(@"%@ fail %@, %@", TAG, error, task);
        NSString *msg = [self getServerErrorMsg:error];
        if (!msg) {
            msg = @"获取失败";
        }
        failure(task, msg);
        [self checkNeedReLogin:error];
    }];
}

+ (void)GetKitchenSalesByMonthWithSuccess:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                       failure:(void (^)(NSURLSessionDataTask *task, NSString *errorMsg))failure
{
    AFHTTPSessionManager *manager = [self sessionManager];
    NSString *TAG = @"GetKitchenSalesByMonth";
    
    NSDictionary *param;
    param  = nil;
    
    NSString *s = [self getTokenString];
    CHECK_TOKEN_STRING(s);
    
    [manager.requestSerializer setValue:s forHTTPHeaderField:@"Authorization"];
    
    NSLog(@"%@ param %@", TAG, param);
    [manager GET:URL_GetKitchenSalesByMonth parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *jsonFile = [NSString stringWithFormat:@"%@.json", TAG];
        [self writeObject:responseObject toJsonFile:jsonFile];
        NSLog(@"%@ success %@, %@", TAG, responseObject, [responseObject class]);
        success(task, responseObject);
        
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
        NSLog(@"%@ fail %@, %@", TAG, error, task);
        NSString *msg = [self getServerErrorMsg:error];
        if (!msg) {
            msg = @"获取失败";
        }
        failure(task, msg);
        [self checkNeedReLogin:error];
    }];
}

+ (void)GetKitchenOrdersByMonthWithYear:(int)Year
                                Month:(int)Month
                                success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                failure:(void (^)(NSURLSessionDataTask *task, NSString *errorMsg))failure
{
    AFHTTPSessionManager *manager = [self sessionManager];
    NSString *TAG = @"GetKitchenOrdersByMonth";
    
    NSDictionary *param;
    param  = @{ @"Year" : @(Year),
                @"Month" : @(Month)
                };
    
    NSString *s = [self getTokenString];
    CHECK_TOKEN_STRING(s);
    
    [manager.requestSerializer setValue:s forHTTPHeaderField:@"Authorization"];
    
    NSLog(@"%@ param %@", TAG, param);
    [manager GET:URL_GetKitchenOrdersByMonth parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *jsonFile = [NSString stringWithFormat:@"%@.json", TAG];
        [self writeObject:responseObject toJsonFile:jsonFile];
        NSLog(@"%@ success %@, %@", TAG, responseObject, [responseObject class]);
        success(task, responseObject);
        
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
        NSLog(@"%@ fail %@, %@", TAG, error, task);
        NSString *msg = [self getServerErrorMsg:error];
        if (!msg) {
            msg = @"获取失败";
        }
        failure(task, msg);
        [self checkNeedReLogin:error];
    }];
}

+ (void)GetOrderWithOrderId:(NSString *)OrderId
                                success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                failure:(void (^)(NSURLSessionDataTask *task, NSString *errorMsg))failure
{
    AFHTTPSessionManager *manager = [self sessionManager];
    NSString *TAG = @"GetOrder";
    
    NSDictionary *param;
    param  = @{ @"OrderId" : OrderId,
                };
    
    NSString *s = [self getTokenString];
    CHECK_TOKEN_STRING(s);
    
    [manager.requestSerializer setValue:s forHTTPHeaderField:@"Authorization"];
    
    NSLog(@"%@ param %@", TAG, param);
    [manager GET:URL_GetOrder parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *jsonFile = [NSString stringWithFormat:@"%@.json", TAG];
        [self writeObject:responseObject toJsonFile:jsonFile];
        NSLog(@"%@ success %@, %@", TAG, responseObject, [responseObject class]);
        success(task, responseObject);
        
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
        NSLog(@"%@ fail %@, %@", TAG, error, task);
        NSString *msg = [self getServerErrorMsg:error];
        if (!msg) {
            msg = @"获取失败";
        }
        failure(task, msg);
        [self checkNeedReLogin:error];
    }];
}

+ (void)AcceptOrderWithOrderId:(NSString *)OrderId
                    success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                    failure:(void (^)(NSURLSessionDataTask *task, NSString *errorMsg))failure
{
    AFHTTPSessionManager *manager = [self sessionManager];
    NSString *TAG = @"AcceptOrder";
    
    NSDictionary *param;
    param  = @{ @"OrderId" : OrderId,
                };
    
    NSString *s = [self getTokenString];
    CHECK_TOKEN_STRING(s);
    
    [manager.requestSerializer setValue:s forHTTPHeaderField:@"Authorization"];
    
    NSLog(@"%@ param %@", TAG, param);
    [manager GET:URL_AcceptOrder parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *jsonFile = [NSString stringWithFormat:@"%@.json", TAG];
        [self writeObject:responseObject toJsonFile:jsonFile];
        NSLog(@"%@ success %@, %@", TAG, responseObject, [responseObject class]);
        success(task, responseObject);
        
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
        NSLog(@"%@ fail %@, %@", TAG, error, task);
        NSString *msg = [self getServerErrorMsg:error];
        if (!msg) {
            msg = @"获取失败";
        }
        failure(task, msg);
        [self checkNeedReLogin:error];
    }];
}

+ (void)RejectOrderWithOrderId:(NSString *)OrderId
                       success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                       failure:(void (^)(NSURLSessionDataTask *task, NSString *errorMsg))failure
{
    AFHTTPSessionManager *manager = [self sessionManager];
    NSString *TAG = @"RejectOrder";
    
    NSDictionary *param;
    param  = @{ @"OrderId" : OrderId,
                };
    
    NSString *s = [self getTokenString];
    CHECK_TOKEN_STRING(s);
    
    [manager.requestSerializer setValue:s forHTTPHeaderField:@"Authorization"];
    
    NSLog(@"%@ param %@", TAG, param);
    [manager GET:URL_RejectOrder parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *jsonFile = [NSString stringWithFormat:@"%@.json", TAG];
        [self writeObject:responseObject toJsonFile:jsonFile];
        NSLog(@"%@ success %@, %@", TAG, responseObject, [responseObject class]);
        success(task, responseObject);
        
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
        NSLog(@"%@ fail %@, %@", TAG, error, task);
        NSString *msg = [self getServerErrorMsg:error];
        if (!msg) {
            msg = @"获取失败";
        }
        failure(task, msg);
        [self checkNeedReLogin:error];
    }];
}

+ (void)SetReadyOrderWithOrderId:(NSString *)OrderId
                       success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                       failure:(void (^)(NSURLSessionDataTask *task, NSString *errorMsg))failure
{
    AFHTTPSessionManager *manager = [self sessionManager];
    NSString *TAG = @"SetReadyOrder";
    
    NSDictionary *param;
    param  = @{ @"OrderId" : OrderId,
                };
    
    NSString *s = [self getTokenString];
    CHECK_TOKEN_STRING(s);
    
    [manager.requestSerializer setValue:s forHTTPHeaderField:@"Authorization"];
    
    NSLog(@"%@ param %@", TAG, param);
    [manager GET:URL_SetReadyOrder parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *jsonFile = [NSString stringWithFormat:@"%@.json", TAG];
        [self writeObject:responseObject toJsonFile:jsonFile];
        NSLog(@"%@ success %@, %@", TAG, responseObject, [responseObject class]);
        success(task, responseObject);
        
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
        NSLog(@"%@ fail %@, %@", TAG, error, task);
        NSString *msg = [self getServerErrorMsg:error];
        if (!msg) {
            msg = @"获取失败";
        }
        failure(task, msg);
        [self checkNeedReLogin:error];
    }];
}

+ (void)DispatchOrderWithOrderId:(NSString *)OrderId
                         success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                         failure:(void (^)(NSURLSessionDataTask *task, NSString *errorMsg))failure
{
    AFHTTPSessionManager *manager = [self sessionManager];
    NSString *TAG = @"DispatchOrder";
    
    NSDictionary *param;
    param  = @{ @"OrderId" : OrderId,
                };
    
    NSString *s = [self getTokenString];
    CHECK_TOKEN_STRING(s);
    
    [manager.requestSerializer setValue:s forHTTPHeaderField:@"Authorization"];
    
    NSLog(@"%@ param %@", TAG, param);
    [manager GET:URL_DispatchOrder parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *jsonFile = [NSString stringWithFormat:@"%@.json", TAG];
        [self writeObject:responseObject toJsonFile:jsonFile];
        NSLog(@"%@ success %@, %@", TAG, responseObject, [responseObject class]);
        success(task, responseObject);
        
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
        NSLog(@"%@ fail %@, %@", TAG, error, task);
        NSString *msg = [self getServerErrorMsg:error];
        if (!msg) {
            msg = @"获取失败";
        }
        failure(task, msg);
        [self checkNeedReLogin:error];
    }];
}

+ (void)ReceiveOrderWithOrderId:(NSString *)OrderId
                         success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                         failure:(void (^)(NSURLSessionDataTask *task, NSString *errorMsg))failure
{
    AFHTTPSessionManager *manager = [self sessionManager];
    NSString *TAG = @"ReceiveOrder";
    
    NSDictionary *param;
    param  = @{ @"OrderId" : OrderId,
                };
    
    NSString *s = [self getTokenString];
    CHECK_TOKEN_STRING(s);
    
    [manager.requestSerializer setValue:s forHTTPHeaderField:@"Authorization"];
    
    NSLog(@"%@ param %@", TAG, param);
    [manager GET:URL_ReceiveOrder parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *jsonFile = [NSString stringWithFormat:@"%@.json", TAG];
        [self writeObject:responseObject toJsonFile:jsonFile];
        NSLog(@"%@ success %@, %@", TAG, responseObject, [responseObject class]);
        success(task, responseObject);
        
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
        NSLog(@"%@ fail %@, %@", TAG, error, task);
        NSString *msg = [self getServerErrorMsg:error];
        if (!msg) {
            msg = @"获取失败";
        }
        failure(task, msg);
        [self checkNeedReLogin:error];
    }];
}

+ (void)CancelOrderWithOrderId:(NSString *)OrderId
                        success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                        failure:(void (^)(NSURLSessionDataTask *task, NSString *errorMsg))failure
{
    AFHTTPSessionManager *manager = [self sessionManager];
    NSString *TAG = @"CancelOrder";
    
    NSDictionary *param;
    param  = @{ @"OrderId" : OrderId,
                };
    
    NSString *s = [self getTokenString];
    CHECK_TOKEN_STRING(s);
    
    [manager.requestSerializer setValue:s forHTTPHeaderField:@"Authorization"];
    
    NSLog(@"%@ param %@", TAG, param);
    [manager GET:URL_CancelOrder parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *jsonFile = [NSString stringWithFormat:@"%@.json", TAG];
        [self writeObject:responseObject toJsonFile:jsonFile];
        NSLog(@"%@ success %@, %@", TAG, responseObject, [responseObject class]);
        success(task, responseObject);
        
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
        NSLog(@"%@ fail %@, %@", TAG, error, task);
        NSString *msg = [self getServerErrorMsg:error];
        if (!msg) {
            msg = @"获取失败";
        }
        failure(task, msg);
        [self checkNeedReLogin:error];
    }];
}

+ (void)GetOrderListTodayWithOrderStatus:(NSString *)OrderStatus
                        DispatchMethod:(NSString *)DispatchMethod
                        OrderBy:(NSString *)OrderBy
                        OrderDir:(NSString *)OrderDir
                       success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                       failure:(void (^)(NSURLSessionDataTask *task, NSString *errorMsg))failure
{
    AFHTTPSessionManager *manager = [self sessionManager];
    NSString *TAG = @"GetOrderListToday";
    
    NSDictionary *param;
    param  = @{ @"OrderStatus" : OrderStatus,
                @"DispatchMethod" : DispatchMethod,
                @"OrderBy" : OrderBy,
                @"OrderDir" : OrderDir,
                };
    
    NSString *s = [self getTokenString];
    CHECK_TOKEN_STRING(s);
    
    [manager.requestSerializer setValue:s forHTTPHeaderField:@"Authorization"];
    
    NSLog(@"%@ param %@", TAG, param);
    [manager POST:URL_GetOrderListToday parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *jsonFile = [NSString stringWithFormat:@"%@.json", TAG];
        [self writeObject:responseObject toJsonFile:jsonFile];
        NSLog(@"%@ success %@, %@", TAG, responseObject, [responseObject class]);
        success(task, responseObject);
        
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
        NSLog(@"%@ fail %@, %@", TAG, error, task);
        NSString *msg = [self getServerErrorMsg:error];
        if (!msg) {
            msg = @"获取失败";
        }
        failure(task, msg);
        [self checkNeedReLogin:error];
    }];
}

+ (void)GetOrderListOtherDaysWithOrderStatus:(NSString *)OrderStatus
                          DispatchMethod:(NSString *)DispatchMethod
                                 OrderBy:(NSString *)OrderBy
                                OrderDir:(NSString *)OrderDir
                                 success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                 failure:(void (^)(NSURLSessionDataTask *task, NSString *errorMsg))failure
{
    AFHTTPSessionManager *manager = [self sessionManager];
    NSString *TAG = @"GetOrderListOtherDays";
    
    NSDictionary *param;
    param  = @{ @"OrderStatus" : OrderStatus,
                @"DispatchMethod" : DispatchMethod,
                @"OrderBy" : OrderBy,
                @"OrderDir" : OrderDir,
                };
    
    NSString *s = [self getTokenString];
    CHECK_TOKEN_STRING(s);
    
    [manager.requestSerializer setValue:s forHTTPHeaderField:@"Authorization"];
    
    NSLog(@"%@ param %@", TAG, param);
    [manager POST:URL_GetOrderListOtherDays parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *jsonFile = [NSString stringWithFormat:@"%@.json", TAG];
        [self writeObject:responseObject toJsonFile:jsonFile];
        NSLog(@"%@ success %@, %@", TAG, responseObject, [responseObject class]);
        success(task, responseObject);
        
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
        NSLog(@"%@ fail %@, %@", TAG, error, task);
        NSString *msg = [self getServerErrorMsg:error];
        if (!msg) {
            msg = @"获取失败";
        }
        failure(task, msg);
        [self checkNeedReLogin:error];
    }];
}

+ (void)GetOrderListTomorrowWithOrderStatus:(NSString *)OrderStatus
                          DispatchMethod:(NSString *)DispatchMethod
                                 OrderBy:(NSString *)OrderBy
                                OrderDir:(NSString *)OrderDir
                                 success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                 failure:(void (^)(NSURLSessionDataTask *task, NSString *errorMsg))failure
{
    AFHTTPSessionManager *manager = [self sessionManager];
    NSString *TAG = @"GetOrderListTomorrow";
    
    NSDictionary *param;
    param  = @{ @"OrderStatus" : OrderStatus,
                @"DispatchMethod" : DispatchMethod,
                @"OrderBy" : OrderBy,
                @"OrderDir" : OrderDir,
                };
    
    NSString *s = [self getTokenString];
    CHECK_TOKEN_STRING(s);
    
    [manager.requestSerializer setValue:s forHTTPHeaderField:@"Authorization"];
    
    NSLog(@"%@ param %@", TAG, param);
    [manager POST:URL_GetOrderListTomorrow parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *jsonFile = [NSString stringWithFormat:@"%@.json", TAG];
        [self writeObject:responseObject toJsonFile:jsonFile];
        NSLog(@"%@ success %@, %@", TAG, responseObject, [responseObject class]);
        success(task, responseObject);
        
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
        NSLog(@"%@ fail %@, %@", TAG, error, task);
        NSString *msg = [self getServerErrorMsg:error];
        if (!msg) {
            msg = @"获取失败";
        }
        failure(task, msg);
        [self checkNeedReLogin:error];
    }];
}

+ (void)GetItemToCookListWithDate:(NSString *)Date
                                    success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                    failure:(void (^)(NSURLSessionDataTask *task, NSString *errorMsg))failure
{
    AFHTTPSessionManager *manager = [self sessionManager];
    NSString *TAG = @"GetItemToCookList";
    
    NSDictionary *param;
    param  = @{ @"Date" : Date,
                };
    
    NSString *s = [self getTokenString];
    CHECK_TOKEN_STRING(s);
    
    [manager.requestSerializer setValue:s forHTTPHeaderField:@"Authorization"];
    
    NSLog(@"%@ param %@", TAG, param);
    [manager POST:URL_GetItemToCookList parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *jsonFile = [NSString stringWithFormat:@"%@.json", TAG];
        [self writeObject:responseObject toJsonFile:jsonFile];
        NSLog(@"%@ success %@, %@", TAG, responseObject, [responseObject class]);
        success(task, responseObject);
        
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
        NSLog(@"%@ fail %@, %@", TAG, error, task);
        NSString *msg = [self getServerErrorMsg:error];
        if (!msg) {
            msg = @"获取失败";
        }
        failure(task, msg);
        [self checkNeedReLogin:error];
    }];
}

+ (void)GetItemToCookPerOrderListWithItemId:(NSString *)ItemId
                                       Date:(NSString *)Date
                                    success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                    failure:(void (^)(NSURLSessionDataTask *task, NSString *errorMsg))failure
{
    AFHTTPSessionManager *manager = [self sessionManager];
    NSString *TAG = @"GetItemToCookPerOrderList";
    
    NSDictionary *param;
    param  = @{ @"ItemId" : ItemId,
                @"Date" : Date,
                };
    
    NSString *s = [self getTokenString];
    CHECK_TOKEN_STRING(s);
    
    [manager.requestSerializer setValue:s forHTTPHeaderField:@"Authorization"];
    
    NSLog(@"%@ param %@", TAG, param);
    [manager POST:URL_GetItemToCookPerOrderList parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *jsonFile = [NSString stringWithFormat:@"%@.json", TAG];
        [self writeObject:responseObject toJsonFile:jsonFile];
        NSLog(@"%@ success %@, %@", TAG, responseObject, [responseObject class]);
        success(task, responseObject);
        
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
        NSLog(@"%@ fail %@, %@", TAG, error, task);
        NSString *msg = [self getServerErrorMsg:error];
        if (!msg) {
            msg = @"获取失败";
        }
        failure(task, msg);
        [self checkNeedReLogin:error];
    }];
}

+ (void)IsApprovedWithsuccess:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                            failure:(void (^)(NSURLSessionDataTask *task, NSString *errorMsg))failure
{
    AFHTTPSessionManager *manager = [self sessionManager];
    NSString *TAG = @"IsApproved";
    
    NSDictionary *param;
    param  = nil;
    
    NSString *s = [self getTokenString];
    if (!s.length) {
        s = [WEGlobalData sharedInstance].registerToken;
    }
    CHECK_TOKEN_STRING(s);
    
    
    [manager.requestSerializer setValue:s forHTTPHeaderField:@"Authorization"];
    
    NSLog(@"%@ param %@", TAG, param);
    [manager GET:URL_IsApproved parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *jsonFile = [NSString stringWithFormat:@"%@.json", TAG];
        [self writeObject:responseObject toJsonFile:jsonFile];
        NSLog(@"%@ success %@, %@", TAG, responseObject, [responseObject class]);
        success(task, responseObject);
        
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
        NSLog(@"%@ fail %@, %@", TAG, error, task);
        NSString *msg = [self getServerErrorMsg:error];
        if (!msg) {
            msg = @"获取失败";
        }
        failure(task, msg);
        [self checkNeedReLogin:error];
    }];
}

+ (void)GetCashOutRequestWithCashOutRequestId:(NSString *)CashOutRequestId
                                            success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                            failure:(void (^)(NSURLSessionDataTask *task, NSString *errorMsg))failure
{
    AFHTTPSessionManager *manager = [self sessionManager];
    NSString *TAG = @"GetCashOutRequest";
    
    NSDictionary *param;
    param  = @{ @"CashOutRequestId" : CashOutRequestId,
                };
    
    NSString *s = [self getTokenString];
    CHECK_TOKEN_STRING(s);
    
    [manager.requestSerializer setValue:s forHTTPHeaderField:@"Authorization"];
    
    NSLog(@"%@ param %@", TAG, param);
    [manager GET:URL_GetCashOutRequest parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *jsonFile = [NSString stringWithFormat:@"%@.json", TAG];
        [self writeObject:responseObject toJsonFile:jsonFile];
        NSLog(@"%@ success %@, %@", TAG, responseObject, [responseObject class]);
        success(task, responseObject);
        
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
        NSLog(@"%@ fail %@, %@", TAG, error, task);
        NSString *msg = [self getServerErrorMsg:error];
        if (!msg) {
            msg = @"获取失败";
        }
        failure(task, msg);
        [self checkNeedReLogin:error];
    }];
}

+ (void)GetCashOutRequestListWithSuccess:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                      failure:(void (^)(NSURLSessionDataTask *task, NSString *errorMsg))failure
{
    AFHTTPSessionManager *manager = [self sessionManager];
    NSString *TAG = @"GetCashOutRequestList";
    
    NSDictionary *param;
    param  = nil;
    
    NSString *s = [self getTokenString];
    CHECK_TOKEN_STRING(s);
    
    [manager.requestSerializer setValue:s forHTTPHeaderField:@"Authorization"];
    
    NSLog(@"%@ param %@", TAG, param);
    [manager GET:URL_GetCashOutRequestList parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *jsonFile = [NSString stringWithFormat:@"%@.json", TAG];
        [self writeObject:responseObject toJsonFile:jsonFile];
        NSLog(@"%@ success %@, %@", TAG, responseObject, [responseObject class]);
        success(task, responseObject);
        
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
        NSLog(@"%@ fail %@, %@", TAG, error, task);
        NSString *msg = [self getServerErrorMsg:error];
        if (!msg) {
            msg = @"获取失败";
        }
        failure(task, msg);
        [self checkNeedReLogin:error];
    }];
}

+ (void)AddCashOutRequestWithCashoutValue:(NSString *)CashoutValue
                                      success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                      failure:(void (^)(NSURLSessionDataTask *task, NSString *errorMsg))failure
{
    AFHTTPSessionManager *manager = [self sessionManager];
    NSString *TAG = @"AddCashOutRequest";
    
    NSDictionary *param;
    param  = @{ @"CashoutValue" : CashoutValue,
                };
    
    NSString *s = [self getTokenString];
    CHECK_TOKEN_STRING(s);
    
    [manager.requestSerializer setValue:s forHTTPHeaderField:@"Authorization"];
    
    NSLog(@"%@ param %@", TAG, param);
    [manager POST:URL_AddCashOutRequest parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *jsonFile = [NSString stringWithFormat:@"%@.json", TAG];
        [self writeObject:responseObject toJsonFile:jsonFile];
        NSLog(@"%@ success %@, %@", TAG, responseObject, [responseObject class]);
        success(task, responseObject);
        
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
        NSLog(@"%@ fail %@, %@", TAG, error, task);
        NSString *msg = [self getServerErrorMsg:error];
        if (!msg) {
            msg = @"获取失败";
        }
        failure(task, msg);
        [self checkNeedReLogin:error];
    }];
}

+ (void)UpdateDispatchMethodWithCanPickup:(BOOL)CanPickup
                                CanDeliver:(BOOL)CanDeliver
                                  success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                  failure:(void (^)(NSURLSessionDataTask *task, NSString *errorMsg))failure
{
    AFHTTPSessionManager *manager = [self sessionManager];
    NSString *TAG = @"UpdateDispatchMethod";
    
    NSDictionary *param;
    param  = @{ @"CanPickup" : @(CanPickup),
                @"CanDeliver" : @(CanDeliver),
                };
    
    NSString *s = [self getTokenString];
    CHECK_TOKEN_STRING(s);
    
    [manager.requestSerializer setValue:s forHTTPHeaderField:@"Authorization"];
    
    NSLog(@"%@ param %@", TAG, param);
    [manager POST:URL_UpdateDispatchMethod parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *jsonFile = [NSString stringWithFormat:@"%@.json", TAG];
        [self writeObject:responseObject toJsonFile:jsonFile];
        NSLog(@"%@ success %@, %@", TAG, responseObject, [responseObject class]);
        success(task, responseObject);
        
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
        NSLog(@"%@ fail %@, %@", TAG, error, task);
        NSString *msg = [self getServerErrorMsg:error];
        if (!msg) {
            msg = @"获取失败";
        }
        failure(task, msg);
        [self checkNeedReLogin:error];
    }];
}

+ (void)UpdateKitchenStoryWithKitchenStory:(NSString *)KitchenStory
                                  success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                  failure:(void (^)(NSURLSessionDataTask *task, NSString *errorMsg))failure
{
    AFHTTPSessionManager *manager = [self sessionManager];
    NSString *TAG = @"UpdateKitchenStory";
    
    NSDictionary *param;
    param  = @{ @"KitchenStory" : KitchenStory,
                };
    
    NSString *s = [self getTokenString];
    CHECK_TOKEN_STRING(s);
    
    [manager.requestSerializer setValue:s forHTTPHeaderField:@"Authorization"];
    
    NSLog(@"%@ param %@", TAG, param);
    [manager POST:URL_UpdateKitchenStory parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *jsonFile = [NSString stringWithFormat:@"%@.json", TAG];
        [self writeObject:responseObject toJsonFile:jsonFile];
        NSLog(@"%@ success %@, %@", TAG, responseObject, [responseObject class]);
        success(task, responseObject);
        
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
        NSLog(@"%@ fail %@, %@", TAG, error, task);
        NSString *msg = [self getServerErrorMsg:error];
        if (!msg) {
            msg = @"获取失败";
        }
        failure(task, msg);
        [self checkNeedReLogin:error];
    }];
}

+ (void)GetItemWithItemId:(NSString *)ItemId
                                   success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                   failure:(void (^)(NSURLSessionDataTask *task, NSString *errorMsg))failure
{
    AFHTTPSessionManager *manager = [self sessionManager];
    NSString *TAG = @"GetItem";
    
    NSDictionary *param;
    param  = @{ @"ItemId" : ItemId,
                };
    
    NSString *s = [self getTokenString];
    CHECK_TOKEN_STRING(s);
    
    [manager.requestSerializer setValue:s forHTTPHeaderField:@"Authorization"];
    
    NSLog(@"%@ param %@", TAG, param);
    [manager GET:URL_GetItem parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *jsonFile = [NSString stringWithFormat:@"%@.json", TAG];
        [self writeObject:responseObject toJsonFile:jsonFile];
        NSLog(@"%@ success %@, %@", TAG, responseObject, [responseObject class]);
        success(task, responseObject);
        
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
        NSLog(@"%@ fail %@, %@", TAG, error, task);
        NSString *msg = [self getServerErrorMsg:error];
        if (!msg) {
            msg = @"获取失败";
        }
        failure(task, msg);
        [self checkNeedReLogin:error];
    }];
}

+ (void)RemoveItemImageWithItemId:(NSString *)ItemId
                  success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                  failure:(void (^)(NSURLSessionDataTask *task, NSString *errorMsg))failure
{
    AFHTTPSessionManager *manager = [self sessionManager];
    NSString *TAG = @"RemoveItemImage";
    
    NSDictionary *param;
    param  = @{ @"ItemId" : ItemId,
                };
    
    NSString *s = [self getTokenString];
    CHECK_TOKEN_STRING(s);
    
    [manager.requestSerializer setValue:s forHTTPHeaderField:@"Authorization"];
    
    NSLog(@"%@ param %@", TAG, param);
    [manager GET:URL_RemoveItemImage parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *jsonFile = [NSString stringWithFormat:@"%@.json", TAG];
        [self writeObject:responseObject toJsonFile:jsonFile];
        NSLog(@"%@ success %@, %@", TAG, responseObject, [responseObject class]);
        success(task, responseObject);
        
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
        NSLog(@"%@ fail %@, %@", TAG, error, task);
        NSString *msg = [self getServerErrorMsg:error];
        if (!msg) {
            msg = @"获取失败";
        }
        failure(task, msg);
        [self checkNeedReLogin:error];
    }];
}

+ (void)LinkKitchenImagesWithImageIdList:(NSArray *)ImageIdList
                          success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                          failure:(void (^)(NSURLSessionDataTask *task, NSString *errorMsg))failure
{
    AFHTTPSessionManager *manager = [self sessionManager];
    NSString *TAG = @"LinkKitchenImages";
    
    NSDictionary *param;
    param  = @{ @"ImageIdList" : ImageIdList,
                };
    
    NSString *s = [self getTokenString];
    CHECK_TOKEN_STRING(s);
    
    [manager.requestSerializer setValue:s forHTTPHeaderField:@"Authorization"];
    
    NSLog(@"%@ param %@", TAG, param);
    [manager POST:URL_LinkKitchenImages parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *jsonFile = [NSString stringWithFormat:@"%@.json", TAG];
        [self writeObject:responseObject toJsonFile:jsonFile];
        NSLog(@"%@ success %@, %@", TAG, responseObject, [responseObject class]);
        success(task, responseObject);
        
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
        NSLog(@"%@ fail %@, %@", TAG, error, task);
        NSString *msg = [self getServerErrorMsg:error];
        if (!msg) {
            msg = @"获取失败";
        }
        failure(task, msg);
        [self checkNeedReLogin:error];
    }];
}

+ (void)GeKitchenCommentListToReplyWithPageIndex:(int)PageIndex
                    Pagesize:(int)Pagesize
                  success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                  failure:(void (^)(NSURLSessionDataTask *task, NSString *errorMsg))failure
{
    AFHTTPSessionManager *manager = [self sessionManager];
    NSString *TAG = @"GeKitchenCommentListToReply";
    
    NSDictionary *param;
    param  = @{ @"PageIndex" : @(PageIndex),
                @"Pagesize" : @(Pagesize)
                };
    
    NSString *s = [self getTokenString];
    CHECK_TOKEN_STRING(s);
    
    [manager.requestSerializer setValue:s forHTTPHeaderField:@"Authorization"];
    
    NSLog(@"%@ param %@", TAG, param);
    [manager POST:URL_GeKitchenCommentListToReply parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *jsonFile = [NSString stringWithFormat:@"%@.json", TAG];
        [self writeObject:responseObject toJsonFile:jsonFile];
        NSLog(@"%@ success %@, %@", TAG, responseObject, [responseObject class]);
        success(task, responseObject);
        
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
        NSLog(@"%@ fail %@, %@", TAG, error, task);
        NSString *msg = [self getServerErrorMsg:error];
        if (!msg) {
            msg = @"获取失败";
        }
        failure(task, msg);
        [self checkNeedReLogin:error];
    }];
}

+ (void)GeKitchenCommentListPositiveWithPageIndex:(int)PageIndex
                                        Pagesize:(int)Pagesize
                                         success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                         failure:(void (^)(NSURLSessionDataTask *task, NSString *errorMsg))failure
{
    AFHTTPSessionManager *manager = [self sessionManager];
    NSString *TAG = @"GeKitchenCommentListPositive";
    
    NSDictionary *param;
    param  = @{ @"PageIndex" : @(PageIndex),
                @"Pagesize" : @(Pagesize)
                };
    
    NSString *s = [self getTokenString];
    CHECK_TOKEN_STRING(s);
    
    [manager.requestSerializer setValue:s forHTTPHeaderField:@"Authorization"];
    
    NSLog(@"%@ param %@", TAG, param);
    [manager POST:URL_GeKitchenCommentListPositive parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *jsonFile = [NSString stringWithFormat:@"%@.json", TAG];
        [self writeObject:responseObject toJsonFile:jsonFile];
        NSLog(@"%@ success %@, %@", TAG, responseObject, [responseObject class]);
        success(task, responseObject);
        
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
        NSLog(@"%@ fail %@, %@", TAG, error, task);
        NSString *msg = [self getServerErrorMsg:error];
        if (!msg) {
            msg = @"获取失败";
        }
        failure(task, msg);
        [self checkNeedReLogin:error];
    }];
}

+ (void)GeKitchenCommentListNeutralWithPageIndex:(int)PageIndex
                                         Pagesize:(int)Pagesize
                                          success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                          failure:(void (^)(NSURLSessionDataTask *task, NSString *errorMsg))failure
{
    AFHTTPSessionManager *manager = [self sessionManager];
    NSString *TAG = @"GeKitchenCommentListNeutral";
    
    NSDictionary *param;
    param  = @{ @"PageIndex" : @(PageIndex),
                @"Pagesize" : @(Pagesize)
                };
    
    NSString *s = [self getTokenString];
    CHECK_TOKEN_STRING(s);
    
    [manager.requestSerializer setValue:s forHTTPHeaderField:@"Authorization"];
    
    NSLog(@"%@ param %@", TAG, param);
    [manager POST:URL_GeKitchenCommentListNeutral parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *jsonFile = [NSString stringWithFormat:@"%@.json", TAG];
        [self writeObject:responseObject toJsonFile:jsonFile];
        NSLog(@"%@ success %@, %@", TAG, responseObject, [responseObject class]);
        success(task, responseObject);
        
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
        NSLog(@"%@ fail %@, %@", TAG, error, task);
        NSString *msg = [self getServerErrorMsg:error];
        if (!msg) {
            msg = @"获取失败";
        }
        failure(task, msg);
        [self checkNeedReLogin:error];
    }];
}

+ (void)GeKitchenCommentListNegativeWithPageIndex:(int)PageIndex
                                        Pagesize:(int)Pagesize
                                         success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                         failure:(void (^)(NSURLSessionDataTask *task, NSString *errorMsg))failure
{
    AFHTTPSessionManager *manager = [self sessionManager];
    NSString *TAG = @"GeKitchenCommentListNegative";
    
    NSDictionary *param;
    param  = @{ @"PageIndex" : @(PageIndex),
                @"Pagesize" : @(Pagesize)
                };
    
    NSString *s = [self getTokenString];
    CHECK_TOKEN_STRING(s);
    
    [manager.requestSerializer setValue:s forHTTPHeaderField:@"Authorization"];
    
    NSLog(@"%@ param %@", TAG, param);
    [manager POST:URL_GeKitchenCommentListNegative parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *jsonFile = [NSString stringWithFormat:@"%@.json", TAG];
        [self writeObject:responseObject toJsonFile:jsonFile];
        NSLog(@"%@ success %@, %@", TAG, responseObject, [responseObject class]);
        success(task, responseObject);
        
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
        NSLog(@"%@ fail %@, %@", TAG, error, task);
        NSString *msg = [self getServerErrorMsg:error];
        if (!msg) {
            msg = @"获取失败";
        }
        failure(task, msg);
        [self checkNeedReLogin:error];
    }];
}

+ (void)ClearBusinessHoursWithSuccess:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                          failure:(void (^)(NSURLSessionDataTask *task, NSString *errorMsg))failure
{
    AFHTTPSessionManager *manager = [self sessionManager];
    NSString *TAG = @"ClearBusinessHours";
    
    NSDictionary *param = nil;
    NSString *s = [self getTokenString];
    CHECK_TOKEN_STRING(s);
    
    [manager.requestSerializer setValue:s forHTTPHeaderField:@"Authorization"];
    
    NSLog(@"%@ param %@", TAG, param);
    [manager POST:URL_ClearBusinessHours parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *jsonFile = [NSString stringWithFormat:@"%@.json", TAG];
        [self writeObject:responseObject toJsonFile:jsonFile];
        NSLog(@"%@ success %@, %@", TAG, responseObject, [responseObject class]);
        success(task, responseObject);
        
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
        NSLog(@"%@ fail %@, %@", TAG, error, task);
        NSString *msg = [self getServerErrorMsg:error];
        if (!msg) {
            msg = @"获取失败";
        }
        failure(task, msg);
        [self checkNeedReLogin:error];
    }];
}
@end
