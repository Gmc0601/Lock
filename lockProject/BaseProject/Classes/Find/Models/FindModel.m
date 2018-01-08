//
//  FindModel.m
//  BaseProject
//
//  Created by cc on 2018/1/3.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "FindModel.h"
#import <MJExtension.h>
@implementation FindModel

+(void) findListWithCallBack:(void(^)(NSString *error,NSArray *findArr)) callback{
    
    [HttpRequest getPath:@"Info/getlist" params:nil resultBlock:^(id responseObject, NSError *error) {
        NSDictionary *datadic = responseObject;
        
        if ([datadic[@"success"] intValue] == 1) {
            NSArray *infoArr = datadic[@"data"];
            NSMutableArray *models = [FindModel mj_objectArrayWithKeyValuesArray:infoArr];
            
            
            callback(nil,models);
        }else{
            callback(datadic[@"msg"],nil);
        }
    }];
}


@end
