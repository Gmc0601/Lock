//
//  LockModel.m
//  BaseProject
//
//  Created by cc on 2018/1/3.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "LockModel.h"
#import <MJExtension.h>

@implementation LockModel

+(void) getlockCallBack:(void(^)(NSString *error,NSArray *findArr, NSArray *nameArr)) callback{
    
    [HttpRequest postPath:@"Lock/getlist" params:nil resultBlock:^(id responseObject, NSError *error) {
        NSDictionary *datadic = responseObject;
        
        if ([datadic[@"success"] intValue] == 1) {
            NSArray *infoArr = datadic[@"data"];
            NSMutableArray *models = [LockModel mj_objectArrayWithKeyValuesArray:infoArr];
            NSMutableArray *name = [NSMutableArray new];
            if (IsNULL(infoArr)) {
                 callback(nil,nil, nil);
            }else {
                for (NSDictionary *dic in infoArr) {
                    NSString *namestr = dic[@"lock_name"];
                    [name addObject:namestr];
                }
                callback(nil,models, name);
            }
            
           
        }else{
            callback(datadic[@"msg"],nil,nil);
        }
    }];
}

@end
