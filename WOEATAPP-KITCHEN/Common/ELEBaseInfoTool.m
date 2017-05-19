//
//  ELEBaseInfoTool.m
//  WOEATAPP-KITCHEN
//
//  Created by huangyirong on 2016/12/21.
//  Copyright © 2016年 com.woeat-inc. All rights reserved.
//

#import "ELEBaseInfoTool.h"

static NSMutableArray *CountryArray = nil;
static NSMutableArray *StateArray = nil;
static NSMutableArray *CityArray = nil;
static NSMutableDictionary *poiDict = nil;
static NSMutableDictionary *stateDict = nil;

@implementation ELEBaseInfoTool
+(void)buildCountryArray{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"country" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSError *error;
    id result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (!result || ![result isKindOfClass:[NSArray class]]) {
        return ;
    }
    CountryArray = [[NSMutableArray alloc]init];
    for (NSDictionary *dic in result){
        [CountryArray addObject:dic[@"Name"]];
    }
}

+(void)buildStateArray{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSString *path = [[NSBundle mainBundle] pathForResource:@"state" ofType:@"json"];
        NSData *data = [NSData dataWithContentsOfFile:path];
        NSError *error;
        stateDict = [NSMutableDictionary new];
        id result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        if (!result || ![result isKindOfClass:[NSArray class]]) {
            return ;
        }
        for (NSDictionary *dic in result){
            NSString *code = [NSString stringWithFormat:@"%@",dic[@"Code"]];
            [stateDict setObject:code forKey:dic[@"Name"]];
        }
    });
 
}

+(void)buildCityArray{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"city" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSError *error;
    id result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (!result || ![result isKindOfClass:[NSDictionary class]]) {
        return ;
    }
}

+(void)buildPoi{
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString *path =  [[NSBundle mainBundle] pathForResource:@"StateCities" ofType:@"plist"];
        NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
        NSArray *allKeys = [dict allKeys];
        StateArray = [[NSMutableArray alloc]initWithArray:allKeys];
        if (StateArray.count > 41) {
            [self moveObjectFromIndex:40 toIndex:0 array:StateArray];
        }
        poiDict = [NSMutableDictionary new];
        for (NSString *key in allKeys) {
            NSArray *cities = [dict objectForKey:key];
            [poiDict setObject:cities forKey:key];
        }
    });
}

+ (void)moveObjectFromIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex array:(NSMutableArray*)array
{
    if(toIndex != fromIndex && fromIndex < [array count] && toIndex< [array count]) {
        id obj = [array objectAtIndex:fromIndex];
        [array removeObjectAtIndex:fromIndex];
        if (toIndex >= [array count]) {
            [array addObject:obj];
        } else {
            [array insertObject:obj atIndex:toIndex];
        }
    }
}


+(NSArray *)stateArray{
    return StateArray;
 
}

+(NSDictionary*)poiDict{
    return poiDict;
}


+(NSDictionary*)stateDict{
    return stateDict;
}

+(NSArray *)Country{
    return CountryArray;
}
//
//+(NSArray *)State{
//    
//}
//
//+(NSArray *)City{
//    
//}
@end
