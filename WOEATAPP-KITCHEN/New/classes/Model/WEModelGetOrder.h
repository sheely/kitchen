//
//  WEModelGetOrder.h
//  woeat
//
//  Created by liubin on 17/1/30.
//

#import <Foundation/Foundation.h>
#import "JsonModel.h"

@protocol WEModelGetOrderOrderLines
@end

@interface WEModelGetOrderOrderLines : JSONModel
@property(nonatomic, strong) NSString<Optional> *ItemId;
@property(nonatomic, strong) NSString<Optional> *Id;
@property(nonatomic, strong) NSString<Optional> *SalesOrderId;
@property(nonatomic, strong) NSString<Optional> *UserCouponId;
@property(nonatomic, strong) NSString<Optional> *Reference;
@property(nonatomic, assign) double UnitPrice;
@property(nonatomic, assign) int Quantity;
@property(nonatomic, strong) NSString<Optional> *Name;
@property(nonatomic, assign) int DisplayOrder;
@property(nonatomic, strong) NSString<Optional> *LineType;
@property(nonatomic, assign) double LineTotalValue;
@end

@interface WEModelGetOrderOrder : JSONModel
@property(nonatomic, strong) NSString<Optional> *DispatchToAddressLine3;
@property(nonatomic, assign) BOOL IsDispatched;
@property(nonatomic, strong) NSString<Optional> *DispatchToCountry;
@property(nonatomic, assign) double DispatchToLatitude;
@property(nonatomic, assign) BOOL IsSubmitted;
@property(nonatomic, strong) NSString<Optional> *TimeCancelled;
@property(nonatomic, strong) NSString<Optional> *KitchenMobileNumber;
@property(nonatomic, strong) NSString<Optional> *DispatchMethod;
@property(nonatomic, assign) BOOL IsAccepted;
@property(nonatomic, assign) BOOL IsCommented;
@property(nonatomic, strong) NSString<Optional> *UserMobileNumber;
@property(nonatomic, assign) BOOL IsRejected;
@property(nonatomic, strong) NSString<Optional> *DispatchToAddressId;
@property(nonatomic, assign) double TotalValue;
@property(nonatomic, assign) BOOL IsReadyForDispatch;
@property(nonatomic, strong) NSString<Optional> *TimeReceived;
@property(nonatomic, assign) double DispatchToLongitude;
@property(nonatomic, strong) NSString<Optional> *DispatchToAddressLine2;
@property(nonatomic, strong) NSString<Optional> *RequiredArrivalTime;
@property(nonatomic, strong) NSString<Optional> *ContactName;
@property(nonatomic, strong) NSString<Optional> *UserDisplayName;
@property(nonatomic, strong) NSString<Optional> *DispatchToPostcode;
@property(nonatomic, strong) NSString<Optional> *KitchenId;
@property(nonatomic, strong) NSString<Optional> *TimeKitchenResponded;
@property(nonatomic, assign) BOOL IsPartiallyPaid;
@property(nonatomic, strong) NSString<Optional> *DispatchToAddressLine1;
@property(nonatomic, strong) NSString<Optional> *TimeCreated;
@property(nonatomic, strong) NSString<Optional> *TimeAdminResponded;
@property(nonatomic, strong) NSString<Optional> *TimeReadyForDispatch;
@property(nonatomic, strong) NSString<Optional> *OrderStatus;
@property(nonatomic, assign) BOOL IsCancelled;
@property(nonatomic, strong) NSArray<WEModelGetOrderOrderLines> *Lines;
@property(nonatomic, assign) double PayableValue;
@property(nonatomic, assign) int DiscountValue;
@property(nonatomic, strong) NSString<Optional> *KitchenName;
@property(nonatomic, strong) NSString<Optional> *DispatchToCity;
@property(nonatomic, strong) NSString<Optional> *ContactNumber;
@property(nonatomic, strong) NSString<Optional> *UserId;
@property(nonatomic, strong) NSString<Optional> *RejectReason;
@property(nonatomic, strong) NSString<Optional> *Id;
@property(nonatomic, strong) NSString<Optional> *Message;
@property(nonatomic, strong) NSString<Optional> *DispatchToState;
@property(nonatomic, strong) NSString<Optional> *TimeDispatched;
@property(nonatomic, assign) BOOL IsReceived;
@property(nonatomic, assign) BOOL IsFullyPaid;
@end

@interface WEModelGetOrder : JSONModel
@property(nonatomic, strong) NSString<Optional> *ResponseMessage;
@property(nonatomic, strong) NSString<Optional> *ResponseDebugInfo;
@property(nonatomic, assign) BOOL IsSuccessful;
@property(nonatomic, strong) WEModelGetOrderOrder<Optional> *Order;
@property(nonatomic, strong) NSString<Optional> *ResponseCode;
@end

