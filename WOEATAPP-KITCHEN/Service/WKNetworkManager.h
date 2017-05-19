//
//  WKNetworkManager.h
//  WOEATAPP-KITCHEN
//
//  Created by Huang Yirong on 16/10/27.
//  Copyright © 2016年 com.woeat-inc. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

@interface WKNetworkManager : AFHTTPSessionManager

+ (WKNetworkManager *)sharedManager;
+ (WKNetworkManager *)sharedAuthManager;
- (NSURLSessionDataTask *)GET:(NSString *)URLString
          responseInMainQueue:(BOOL)isMain
                   parameters:(id)parameters
                      success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                      failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

- (NSURLSessionDataTask *)POST:(NSString *)URLString
           responseInMainQueue:(BOOL)isMain
                    parameters:(id)parameters
                       success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

@end
