//
//  WKKeyChain.m
//  WOEATAPP-KITCHEN
//
//  Created by Huang Yirong on 16/11/1.
//  Copyright © 2016年 com.woeat-inc. All rights reserved.
//

#import "WKKeyChain.h"
#import "WKUserInfo.h"

@implementation WKKeyChain

+ (NSMutableDictionary *)getKeychainQuery:(NSString *)service
{
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            (id) CFBridgingRelease(kSecClassGenericPassword), (id) CFBridgingRelease(kSecClass),
            service, (id) CFBridgingRelease(kSecAttrService),
            service, (id) CFBridgingRelease(kSecAttrAccount),
            (id) CFBridgingRelease(kSecAttrAccessibleAfterFirstUnlock), (id) CFBridgingRelease(kSecAttrAccessible),
            nil];
}

+ (void)save:(NSString *)service data:(id)data
{
    //Get search dictionary
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    //Delete old item before add new item
    SecItemDelete((__bridge CFDictionaryRef) keychainQuery);
    //Add new object to search dictionary(Attention:the data format)
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(id) CFBridgingRelease(kSecValueData)];
    //Add item to keychain with the search dictionary
    SecItemAdd((__bridge CFDictionaryRef) keychainQuery, NULL);
}

+ (id)load:(NSString *)service
{
    id ret = nil;
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    //Configure the search setting
    //Since in our simple case we are expecting only a single attribute to be returned (the password) we can set the attribute kSecReturnData to kCFBooleanTrue
    [keychainQuery setObject:(id) kCFBooleanTrue forKey:(id) CFBridgingRelease(kSecReturnData)];
    [keychainQuery setObject:(id) CFBridgingRelease(kSecMatchLimitOne) forKey:(id) CFBridgingRelease(kSecMatchLimit)];
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((__bridge CFDictionaryRef) keychainQuery,
                            (CFTypeRef *) &keyData) == noErr) {
        @try {
            ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge
                                                              NSData *) keyData];
        } @catch (NSException *e) {
            NSLog(@"Unarchive of %@ failed: %@", service, e);
        } @finally {
        }
    }
    if (keyData)
        CFRelease(keyData);
    return ret;
}

+ (void)delete:(NSString *)service
{
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    SecItemDelete((__bridge CFDictionaryRef) keychainQuery);
}


+(void)saveUserInfo:(NSString *)service userInfo:(WKUserInfo *)userInfo{
    
    [WKKeyChain save:[NSString stringWithFormat:@"%@_userId",service] data:userInfo.userId];
    [WKKeyChain save:[NSString stringWithFormat:@"%@_nickName",service] data:userInfo.nickName];
    [WKKeyChain save:[NSString stringWithFormat:@"%@_gender",service] data:userInfo.gender];
    [WKKeyChain save:[NSString stringWithFormat:@"%@_avatar",service] data:userInfo.avatar];
    [WKKeyChain save:[NSString stringWithFormat:@"%@_accessToken",service] data:userInfo.accessToken];
    [WKKeyChain save:[NSString stringWithFormat:@"%@_tokenType",service] data:userInfo.tokenType];
    [WKKeyChain save:[NSString stringWithFormat:@"%@_mobilNum",service] data:userInfo.mobilNum];
    [WKKeyChain save:[NSString stringWithFormat:@"%@_securityCode",service] data:userInfo.securityCode];
    [WKKeyChain save:[NSString stringWithFormat:@"%@_KitchenId",service] data:@(userInfo.KitchenId)];
    
    [WKKeyChain save:[NSString stringWithFormat:@"%@_PortraitImageUrl",service] data:userInfo.PortraitImageUrl];
    [WKKeyChain save:[NSString stringWithFormat:@"%@_State",service] data:userInfo.State];
    [WKKeyChain save:[NSString stringWithFormat:@"%@_City",service] data:userInfo.City];
    [WKKeyChain save:[NSString stringWithFormat:@"%@_InspectionStatus",service] data:userInfo.InspectionStatus];
    [WKKeyChain save:[NSString stringWithFormat:@"%@_AddressLine1",service] data:userInfo.AddressLine1];
}


+ (WKUserInfo *)loadUserInfo:(NSString *)service
{
    
    WKUserInfo *account= [WKUserInfo new];
    
    NSString *userId = [WKKeyChain load:[NSString stringWithFormat:@"%@_userId",service]];
    NSString *nickName = [WKKeyChain load:[NSString stringWithFormat:@"%@_nickName",service]];
    NSString *gender = [WKKeyChain load:[NSString stringWithFormat:@"%@_gender",service]];
    NSString *avatar = [WKKeyChain load:[NSString stringWithFormat:@"%@_avatar",service]];
    NSString *accessToken = [WKKeyChain load:[NSString stringWithFormat:@"%@_accessToken",service]];
    NSString *tokenType = [WKKeyChain load:[NSString stringWithFormat:@"%@_tokenType",service]];
    NSString *mobilNum = [WKKeyChain load:[NSString stringWithFormat:@"%@_mobilNum",service]];
    NSString *securityCode = [WKKeyChain load:[NSString stringWithFormat:@"%@_securityCode",service]];
    NSInteger KitchenId = [[WKKeyChain load:[NSString stringWithFormat:@"%@_KitchenId",service]] integerValue];
    
    NSString *PortraitImageUrl = [WKKeyChain load:[NSString stringWithFormat:@"%@_PortraitImageUrl",service]];
    NSString *State = [WKKeyChain load:[NSString stringWithFormat:@"%@_State",service]];
    NSString *City = [WKKeyChain load:[NSString stringWithFormat:@"%@_City",service]];
    NSString *InspectionStatus = [WKKeyChain load:[NSString stringWithFormat:@"%@_InspectionStatus",service]];
    NSString *AddressLine1 = [WKKeyChain load:[NSString stringWithFormat:@"%@_AddressLine1",service]];
    
    account.userId= userId;
    account.nickName= nickName;
    account.gender=gender;
    account.avatar= avatar;
    account.accessToken= accessToken;
    account.tokenType = tokenType;
    account.securityCode = securityCode;
    account.mobilNum = mobilNum;
    account.KitchenId = KitchenId;
    
    account.PortraitImageUrl= PortraitImageUrl;
    account.State = State;
    account.City = City;
    account.InspectionStatus = InspectionStatus;
    account.AddressLine1 = AddressLine1;
    return account;
    
}

+(void) deleteUserInfo:(NSString *)service{
    
    [WKKeyChain delete:[NSString stringWithFormat:@"%@_KitchenId",service]];
    [WKKeyChain delete:[NSString stringWithFormat:@"%@_userId",service]];
    [WKKeyChain delete:[NSString stringWithFormat:@"%@_expirationDate",service]];
    [WKKeyChain delete:[NSString stringWithFormat:@"%@_nickName",service]];
    [WKKeyChain delete:[NSString stringWithFormat:@"%@_gender",service]];
    [WKKeyChain delete:[NSString stringWithFormat:@"%@_avatar",service]];
    [WKKeyChain delete:[NSString stringWithFormat:@"%@_accessToken",service]];
    [WKKeyChain delete:[NSString stringWithFormat:@"%@_tokenTpye",service]];
    [WKKeyChain delete:[NSString stringWithFormat:@"%@_mobilNum",service]];
    [WKKeyChain delete:[NSString stringWithFormat:@"%@_securityCode",service]];

    [WKKeyChain delete:[NSString stringWithFormat:@"%@_PortraitImageUrl",service]];
    [WKKeyChain delete:[NSString stringWithFormat:@"%@_State",service]];
    [WKKeyChain delete:[NSString stringWithFormat:@"%@_City",service]];
    [WKKeyChain delete:[NSString stringWithFormat:@"%@_InspectionStatus",service]];
    [WKKeyChain delete:[NSString stringWithFormat:@"%@_AddressLine1",service]];
    
}


@end
