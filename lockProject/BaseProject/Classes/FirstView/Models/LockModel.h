//
//  LockModel.h
//  BaseProject
//
//  Created by cc on 2018/1/3.
//  Copyright © 2018年 cc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LockModel : NSObject

@property (nonatomic , copy) NSString              * lock_id;
@property (nonatomic , copy) NSString              * lock_no;
@property (nonatomic , copy) NSString              * lock_name;
@property (nonatomic , copy) NSString              * create_time;
@property (nonatomic , copy) NSString              * gateway_name;
@property (nonatomic , copy) NSString              * gateway_id;

+(void) getlockCallBack:(void(^)(NSString *error,NSArray *findArr, NSArray *nameArr)) callback;

@end
