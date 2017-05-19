//
//  ELEBaseInfoTool.h
//  WOEATAPP-KITCHEN
//
//  Created by huangyirong on 2016/12/21.
//  Copyright © 2016年 com.woeat-inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ELEBaseInfoTool : NSObject

+(void)buildCountryArray;
+(void)buildStateArray;
+(void)buildCityArray;
+(void)buildPoi;

+(NSArray *)stateArray;
+(NSDictionary*)poiDict;
+(NSDictionary*)stateDict;

+(NSArray *)Country;
+(NSArray *)State;
+(NSArray *)City;



@end
