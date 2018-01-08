//
//  RegionModel.m
//  BaseProject
//
//  Created by LeoGeng on 26/12/2017.
//  Copyright © 2017 cc. All rights reserved.
//

#import "RegionModel.h"
#import "PlaceModel.h"

@implementation RegionModel
+(void) insertRegions:(NSArray *) arr{
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];

    for (RegionModel *model in arr) {
        [realm addObject:model];
    }
    
    [realm commitWriteTransaction];
}

+(BOOL) hasLoad{
    RLMResults<RegionModel *> *privences = [RegionModel objectsWhere:@"fid = '0'"];
    return  privences.count > 0;
}

+(NSArray *) getProvinces{
    RLMResults<RegionModel *> *privences = [RegionModel objectsWhere:@"fid = '0'"];
    NSMutableArray *provinceArray = [NSMutableArray new];
    for (RegionModel *model in privences) {
        [provinceArray addObject:model.name];
    }
    
    return  provinceArray;
}

+(NSMutableArray *) getRegions{
    RLMResults<RegionModel *> *privences = [RegionModel objectsWhere:@"fid = '0'"];
    NSMutableArray *provinceArray = [NSMutableArray new];
    for (int i = 0; i < privences.count; i ++) {
        RegionModel *priovinde = privences[i];
        PlaceModel *placeModel = [[PlaceModel alloc] init];
        placeModel.provinceName = priovinde.name;
        NSString *strStatement = [NSString stringWithFormat:@"fid = '%@'",priovinde.id];
        RLMResults<RegionModel *> *cities = [RegionModel objectsWhere:strStatement];
        for (RegionModel *city in cities) {
            NSString *strStatement = [NSString stringWithFormat:@"fid = '%@'",city.id];
            RLMResults<RegionModel *> *countries = [RegionModel objectsWhere:strStatement];
            [placeModel.cityArray addObject:city.name];
            NSMutableArray *countryNames = [NSMutableArray new];
            for (RegionModel *model in countries) {
                [countryNames addObject:model.name];
            }
            [placeModel.districtArray addObject:countryNames];
        }
       
        [provinceArray addObject:placeModel];
    }
    
    return provinceArray;
}

+(NSString *) getRegionCode:(NSString *) name withFid:(NSString *) fid{
    NSString *strStatement = [NSString stringWithFormat:@"fid = '%@' AND name='%@' ",fid,name];

    RLMResults<RegionModel *> *privences = [RegionModel objectsWhere:strStatement];
    if (privences.firstObject == nil) {
        return  @"";
    }
    
    return ((RegionModel *)privences.firstObject).id;
}

+(NSString *) getRegionName:(NSString *) code{
    NSString *strStatement = [NSString stringWithFormat:@"id = '%@' ",code];
    
    RLMResults<RegionModel *> *privences = [RegionModel objectsWhere:strStatement];
    if (privences.firstObject == nil) {
        return  @"";
    }
    
    return ((RegionModel *)privences.firstObject).name;
}
@end
