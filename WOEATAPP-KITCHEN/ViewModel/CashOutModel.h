//
//  CashOutModel.h
//  WOEATAPP-KITCHEN
//
//  Created by huangyirong on 2017/1/20.
//  Copyright © 2017年 com.woeat-inc. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface CashOutModel : JSONModel
@property (nonatomic, copy) NSString *Name;
@property (nonatomic, copy) NSString *UserMobileNumber;
@property (nonatomic, copy) NSString *TimeCreated;
@property (nonatomic, copy) NSString *UserDisplayName;
@property (nonatomic, copy) NSString *TimeProcessed;

@property (nonatomic, assign) NSInteger ContactNumber;
@property (nonatomic, assign) NSInteger Id;
@property (nonatomic, assign) NSInteger TransactionId;
@property (nonatomic, assign) NSInteger CashoutValue;
@property (nonatomic, assign) NSInteger HasSufficientBalance;

@property (nonatomic, assign) NSInteger UserBalance;
@property (nonatomic, assign) NSInteger DisplayOrder;
@property (nonatomic, assign) NSInteger UserId;
@end
