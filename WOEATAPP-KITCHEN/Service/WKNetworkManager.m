//
//  WKNetworkManager.m
//  WOEATAPP-KITCHEN
//
//  Created by Huang Yirong on 16/10/27.
//  Copyright © 2016年 com.woeat-inc. All rights reserved.
//

#import "WKNetworkManager.h"
#import "WEToken.h"

NSString *const kWKNetBasedUrl = @"https://api.woeatapp.com/";

@implementation WKNetworkManager

+ (WKNetworkManager *)sharedManager
{
    static WKNetworkManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] initWithBaseURL:[NSURL URLWithString:kWKNetBasedUrl]];
        dispatch_queue_t queue = dispatch_queue_create("cn.woeat.network.response",  DISPATCH_QUEUE_SERIAL);
        sharedManager.completionQueue = queue;
        NSMutableSet *set = [NSMutableSet setWithSet:sharedManager.responseSerializer.acceptableContentTypes];
        [set addObject:@"text/html"];
        [set addObject:@"text/json"];
        [set addObject:@"application/json"];
        [set addObject:@"text/plain"];
        sharedManager.responseSerializer.acceptableContentTypes = set;
        
    });
    return sharedManager;
}

/*
 通过 token 访问受限的 API,需要在request中带上header
 */
+ (WKNetworkManager *)sharedAuthManager
{
    static WKNetworkManager *sharedAuthManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedAuthManager = [[self alloc] initWithBaseURL:[NSURL URLWithString:kWKNetBasedUrl]];
        dispatch_queue_t queue = dispatch_queue_create("cn.woeat.network.response",  DISPATCH_QUEUE_SERIAL);
        sharedAuthManager.completionQueue = queue;
        NSMutableSet *set = [NSMutableSet setWithSet:sharedAuthManager.responseSerializer.acceptableContentTypes];
        [set addObject:@"text/html"];
        [set addObject:@"text/json"];
        [set addObject:@"application/json"];
        [set addObject:@"text/plain"];
        sharedAuthManager.responseSerializer.acceptableContentTypes = set;
 
    });
    
//    WKUserInfo *account = [WKKeyChain loadUserInfo:kAPPSecurityStoreKey];
//    NSString *accessToken = account.accessToken;
//    NSString *tokenType = account.tokenType;
//    NSString *authorization = [NSString stringWithFormat:@"%@ %@",tokenType,accessToken];
    NSString *authorization = [WEToken getToken];
    if (authorization.length > 0) {
        [sharedAuthManager.requestSerializer setValue:authorization forHTTPHeaderField:@"authorization"];
    }
    
    return sharedAuthManager;
}

- (NSURLSessionDataTask *)GET:(NSString *)URLString
          responseInMainQueue:(BOOL)isMain
                   parameters:(id)parameters
                      success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                      failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:parameters];
    void (^successOperate)(NSURLSessionDataTask *task, id responseObject) = success;
    void (^failureOperate)(NSURLSessionDataTask *task, NSError *error) = failure;
    if (isMain) {
        successOperate = ^(NSURLSessionDataTask *task, id responseObject) {
            dispatch_async(dispatch_get_main_queue(), ^(){
                success(task,responseObject);
                NSLog(@"%@ paramsDic:%@",URLString,responseObject);
            });
        };
        failureOperate = ^(NSURLSessionDataTask *task, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^(){
                failureOperate(task,error);
                NSLog(@"%@ paramsDic:%@",URLString,error);
            });
        };
    }
    return [self GET:URLString parameters:param success:successOperate failure:failureOperate];
}

- (NSURLSessionDataTask *)POST:(NSString *)URLString
           responseInMainQueue:(BOOL)isMain
                    parameters:(id)parameters
                       success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:parameters];
    void (^successOperate)(NSURLSessionDataTask *task, id responseObject) = success;
    void (^failureOperate)(NSURLSessionDataTask *task, NSError *error) = failure;
    if (isMain) {
        successOperate = ^(NSURLSessionDataTask *task, id responseObject) {
            dispatch_async(dispatch_get_main_queue(), ^(){
                success(task,responseObject);
                NSLog(@"%@ paramsDic:%@",URLString,responseObject);
            });
        };
        failureOperate = ^(NSURLSessionDataTask *task, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^(){
                failureOperate(task,error);
                NSLog(@"%@ paramsDic:%@",URLString,error);
            });
        };
    }
    return [self POST:URLString parameters:param success:successOperate failure:failureOperate];
}


@end
