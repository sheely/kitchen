//
//  WEModelGetItem.h
//  woeat
//
//  Created by liubin on 17/1/30.
//

#import <Foundation/Foundation.h>
#import "JsonModel.h"

@interface WEModelGetItemItem : JSONModel
@property(nonatomic, strong) NSString<Optional> *Id;
@property(nonatomic, strong) NSString<Optional> *Name;
@property(nonatomic, strong) NSString<Optional> *TimeCreated;
@property(nonatomic, assign) int DisplayOrder;
@property(nonatomic, strong) NSString<Optional> *KitchenId;
@property(nonatomic, strong) NSString<Optional> *CuisineId;
@property(nonatomic, strong) NSString<Optional> *Description;
@property(nonatomic, assign) double UnitPrice;
@property(nonatomic, assign) int DailyAvailability;
@property(nonatomic, assign) int UserRating;
@property(nonatomic, assign) int InternalRating;
@property(nonatomic, assign) BOOL IsFeatured;
@property(nonatomic, assign) int TodayAvailability;
@property(nonatomic, assign) int TomorrowAvailability;
@property(nonatomic, assign) int SoldUnitsMonthToDate;
@property(nonatomic, assign) int SoldUnitsLifeLong;
@property(nonatomic, assign) int TotalPositiveVotes;
@property(nonatomic, assign) int TotalNeutralVotes;
@property(nonatomic, assign) int TotalNegativeVotes;
@property(nonatomic, assign) int TotalUserFavourites;
@property(nonatomic, assign) BOOL NeedPreorder;
@property(nonatomic, assign) BOOL CanPreorder;
@property(nonatomic, strong) NSString<Optional> *PortraitImageId;
@property(nonatomic, strong) NSString<Optional> *PortraitImageUrl;
@property(nonatomic, assign) BOOL IsActive;
@end

@interface WEModelGetItem : JSONModel
@property(nonatomic, strong) WEModelGetItemItem<Optional> *Item;
@property(nonatomic, strong) NSString<Optional> *ResponseCode;
@property(nonatomic, strong) NSString<Optional> *ResponseMessage;
@property(nonatomic, strong) NSString<Optional> *ResponseDebugInfo;
@property(nonatomic, assign) BOOL IsSuccessful;
@end

