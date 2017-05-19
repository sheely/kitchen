//
//  WKMenuModel.h
//  WOEATAPP-KITCHEN
//
//  Created by tamony on 2016/10/26.
//  Copyright © 2016年 com.woeat-inc. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface WKMenuModel : JSONModel

@property (nonatomic,copy)NSString *Name;

@property (nonatomic,copy)NSString *PortraitImageUrl;

@property (nonatomic,assign)float UnitPrice;

@property (nonatomic,copy)NSString *Id;


@property (nonatomic,copy)NSString *Description;

@property (nonatomic,copy)NSMutableArray *images;

@property (nonatomic,assign)NSInteger IsFeatured;

@property (nonatomic,assign)NSInteger IsActive;
@property (nonatomic,assign)NSInteger KitchenId;
@property (nonatomic,assign)NSInteger DailyAvailability;
@property (nonatomic,assign)NSInteger DisplayOrder;


@end
