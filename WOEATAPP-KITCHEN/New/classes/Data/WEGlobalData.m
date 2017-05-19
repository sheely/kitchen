//
//  WEGlobalData.m
//  woeat
//
//  Created by liubin on 16/12/20.
//  Copyright © 2016年 liubin. All rights reserved.
//

#import "WEGlobalData.h"
#import "WEKitchenCache.h"
#import "WEUserDataManager.h"
#import "WEAddressManager.h"

@implementation WEGlobalData

+ (instancetype)sharedInstance
{
    static WEGlobalData *instance = nil;
    if (instance == nil) {
        instance = [[self alloc] init];
    }
    return instance;
}


- (NSString *)getUserDir
{
    NSString *docsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    return [docsPath stringByAppendingPathComponent:_curUserName];
}


+ (void)logOut
{
    //shopping cart
    
    //address manager
    //[[WEAddressManager sharedInstance] save];
    
    //kitchen cache
    
    //user data
    [[WEUserDataManager sharedInstance] save];
    
    //profile image
    

}

+ (void)logIn
{
    //shopping cart
    //address manager
    [[WEAddressManager sharedInstance] reInit];
    
    //kitchen cache
    
    //user data
    [[WEUserDataManager sharedInstance] reInit];
    
    //profile image
    
    
}

+ (void)quitBackground
{
    //shopping cart
    
    //address manager
    //[[WEAddressManager sharedInstance] save];
    
    //kitchen cache
    [[WEKitchenCache sharedInstance] save];
    
    //user data
    [[WEUserDataManager sharedInstance] save];
    
    //profile image
}

@end
