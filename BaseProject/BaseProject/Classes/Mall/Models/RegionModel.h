//
//  RegionModel.h
//  BaseProject
//
//  Created by LeoGeng on 26/12/2017.
//  Copyright © 2017 cc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>


@interface RegionModel : RLMObject
@property NSString * id;
@property NSString * fid;
@property NSString * name;

+(void) insertRegions:(NSArray *) arr;
+(BOOL) hasLoad;
+(NSMutableArray *) getRegions;
+(NSArray *) getProvinces;
+(NSString *) getRegionCode:(NSString *) name withFid:(NSString *) fid;
+(NSString *) getRegionName:(NSString *) code;
@end
