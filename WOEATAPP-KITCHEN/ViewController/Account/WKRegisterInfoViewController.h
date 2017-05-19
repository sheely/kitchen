//
//  WKRegisterInfoViewController.h
//  WOEATAPP-KITCHEN
//
//  Created by Huang Yirong on 16/10/17.
//  Copyright © 2016年 com.woeat-inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WKRegisterInfoViewController : UIViewController

@property (nonatomic, copy) NSString *accountName;
@property (nonatomic, copy) NSString *securityCode;
@property (nonatomic,copy)NSString *accessToken;
@property (nonatomic,copy)NSString *tokenType;
@property (nonatomic,copy)NSDate *expirationDate;
@property (nonatomic,copy)NSString *mobilNum;

@end
