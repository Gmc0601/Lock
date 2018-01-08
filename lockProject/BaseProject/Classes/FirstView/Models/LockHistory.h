//
//  LockHistory.h
//  BaseProject
//
//  Created by cc on 2018/1/4.
//  Copyright © 2018年 cc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LockHistory : NSObject

@property (nonatomic, copy) NSString *unlock_id, *unlock_user_id, *date, *time, *content, *user;

+(void) getlockHistory:(NSDictionary *)dic CallBack:(void(^)(NSString *error,NSArray *findArr, NSArray *dateArr)) callback;

@end
