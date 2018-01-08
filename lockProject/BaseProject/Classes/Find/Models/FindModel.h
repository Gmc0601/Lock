//
//  FindModel.h
//  BaseProject
//
//  Created by cc on 2018/1/3.
//  Copyright © 2018年 cc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FindModel : NSObject

@property (nonatomic , copy) NSString              * info_date;
@property (nonatomic , copy) NSString              * info_id;
@property (nonatomic , copy) NSString              * title;
@property (nonatomic , copy) NSString              * type;
@property (nonatomic , copy) NSString              * comment_count;
@property (nonatomic , copy) NSString              * img_url;

+(void) findListWithCallBack:(void(^)(NSString *error,NSArray *findArr)) callback;

@end
