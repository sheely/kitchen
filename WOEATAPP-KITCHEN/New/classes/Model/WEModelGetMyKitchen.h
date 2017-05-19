//
//  WEModelGetMyKitchen.h
//  woeat
//
//  Created by liubin on 17/1/30.
//

#import <Foundation/Foundation.h>
#import "JsonModel.h"

@protocol WEModelGetMyKitchenImages
@end

@interface WEModelGetMyKitchenImagesImage : JSONModel
@property(nonatomic, assign) int Height;
@property(nonatomic, strong) NSString<Optional> *Id;
@property(nonatomic, strong) NSString<Optional> *Filename;
@property(nonatomic, strong) NSString<Optional> *ContentType;
@property(nonatomic, strong) NSString<Optional> *Url;
@property(nonatomic, strong) NSString<Optional> *Width;
@property(nonatomic, assign) int Filesize;
@property(nonatomic, strong) NSString<Optional> *Alt;
@end

@interface WEModelGetMyKitchenKitchen : JSONModel
@property(nonatomic, strong) NSString<Optional> *TimeCreated;
@property(nonatomic, strong) NSString<Optional> *PortraitImageId;
@property(nonatomic, strong) NSString<Optional> *ChefGender;
@property(nonatomic, assign) int DisplayOrder;
@property(nonatomic, strong) NSString<Optional> *ChefMobileNumber;
@property(nonatomic, strong) NSString<Optional> *City;
@property(nonatomic, strong) NSString<Optional> *Name;
@property(nonatomic, strong) NSString<Optional> *Postcode;
@property(nonatomic, strong) NSString<Optional> *InspectionStatus;
@property(nonatomic, assign) double Longitude;
@property(nonatomic, strong) NSString<Optional> *LastInspectionTime;
@property(nonatomic, strong) NSString<Optional> *KitchenStory;
@property(nonatomic, strong) NSString<Optional> *ChefUsername;
@property(nonatomic, strong) NSString<Optional> *AddressId;
@property(nonatomic, strong) NSString<Optional> *State;
@property(nonatomic, strong) NSString<Optional> *AddressLine3;
@property(nonatomic, strong) NSString<Optional> *BroadcastMessage;
@property(nonatomic, strong) NSString<Optional> *Country;
@property(nonatomic, strong) NSString<Optional> *Id;
@property(nonatomic, strong) NSString<Optional> *AddressLine2;
@property(nonatomic, strong) NSString<Optional> *ThemeImageId;
@property(nonatomic, strong) NSString<Optional> *AddressLine1;
@property(nonatomic, assign) BOOL CanDeliver;
@property(nonatomic, assign) double Latitude;
@property(nonatomic, strong) NSString<Optional> *UserId;
@property(nonatomic, assign) BOOL CanPickup;
@property(nonatomic, assign) BOOL IsOpen;
@property(nonatomic, assign) int CustomerRating;
@property(nonatomic, assign) int InternalRating;
@property(nonatomic, strong) NSString<Optional> *InvitationCode;
@property(nonatomic, strong) NSString<Optional> *PortraitImageUrl;
@property(nonatomic, assign) BOOL KitchenImagesReviewed;
@end

@interface WEModelGetMyKitchenImages : JSONModel
@property(nonatomic, strong) NSString<Optional> *ResponseCode;
@property(nonatomic, strong) NSString<Optional> *ResponseMessage;
@property(nonatomic, strong) NSString<Optional> *ResponseDebugInfo;
@property(nonatomic, assign) BOOL IsSuccessful;
@property(nonatomic, strong) WEModelGetMyKitchenImagesImage<Optional> *Image;
@end

@interface WEModelGetMyKitchen : JSONModel
@property(nonatomic, strong) WEModelGetMyKitchenKitchen<Optional> *Kitchen;
@property(nonatomic, strong) NSString<Optional> *ResponseMessage;
@property(nonatomic, strong) NSArray<WEModelGetMyKitchenImages> *Images;
@property(nonatomic, strong) NSString<Optional> *ResponseDebugInfo;
@property(nonatomic, assign) BOOL IsSuccessful;
@property(nonatomic, strong) NSString<Optional> *ResponseCode;
@end

