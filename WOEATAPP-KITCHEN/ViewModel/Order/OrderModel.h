//
//  OrderModel.h
//  WOEATAPP-KITCHEN
//
//  Created by Huang Yirong on 16/10/22.
//  Copyright © 2016年 com.woeat-inc. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@class LineModel;


@interface OrderModel : JSONModel

@property (nonatomic, copy) NSString *ContactName;
@property (nonatomic, assign) NSInteger ContactNumber;
@property (nonatomic, assign) NSInteger Id;
@property (nonatomic, assign) NSInteger IsDispatched;
@property (nonatomic, assign) NSInteger IsCommented;
@property (nonatomic, assign) NSInteger IsFullyPaid;
@property (nonatomic, assign) NSInteger IsReadyForDispatch;
@property (nonatomic, assign) NSInteger IsReceived;
@property (nonatomic, assign) NSInteger IsRejected;
@property (nonatomic, assign) NSInteger IsSubmitted;
@property (nonatomic, assign) NSInteger KitchenId;
@property (nonatomic, assign) NSInteger IsAccepted;
@property (nonatomic, assign) NSInteger UserId;

@property (nonatomic, strong) NSArray<LineModel *> *Lines;//model 嵌套数组


@property (nonatomic, copy) NSString *DispatchMethod;
@property (nonatomic, copy) NSString *DispatchToCity;
@property (nonatomic, copy) NSString *DispatchToState;
@property (nonatomic, copy) NSString *DispatchToAddressLine1;
@property (nonatomic, copy) NSString *DispatchToAddressLine2;
@property (nonatomic, copy) NSString *DispatchToAddressLine3;

@property (nonatomic, copy) NSString *Message;
@property (nonatomic, copy) NSString *OrderStatus;
@property (nonatomic, copy) NSString *PayableValue;
@property (nonatomic, copy) NSString *RejectReason;
@property (nonatomic, copy) NSString *RequiredArrivalTime;
@property (nonatomic, copy) NSString *TimeAdminResponded;
@property (nonatomic, copy) NSString *TimeCreated;
@property (nonatomic, copy) NSString *TimeDispatched;
@property (nonatomic, copy) NSString *TimeKitchenResponded;
@property (nonatomic, copy) NSString *TimeReadyForDispatch;
@property (nonatomic, copy) NSString *TimeReceived;
@property (nonatomic, copy) NSString *TotalValue;

@end
