//
//  LockHistory.m
//  BaseProject
//
//  Created by cc on 2018/1/4.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "LockHistory.h"
#import <MJExtension.h>

@implementation LockHistory

+ (void)getlockHistory:(NSDictionary *)dic CallBack:(void (^)(NSString *, NSArray *, NSArray *))callback {
    [HttpRequest postPath:@"Lock/loglist" params:dic resultBlock:^(id responseObject, NSError *error) {
        if([error isEqual:[NSNull null]] || error == nil){
            NSLog(@"success");
        }
        NSLog(@"%@", responseObject);
        NSDictionary *datadic = responseObject;
        if ([datadic[@"success"] intValue] == 1) {
            
            NSArray *data = datadic[@"data"];
            
            if (IsNULL(data)) {
                callback(@"nodare", nil, nil);
            }else {
                NSMutableArray *dataArr = [LockHistory mj_objectArrayWithKeyValuesArray:data];
                
                NSMutableArray *dateArr = [NSMutableArray new];
                
                for (int i = 0; i < dataArr.count; i++) {
                    LockHistory *model =  [[LockHistory alloc] init];
                    model = dataArr[i];
                    NSString *str = [NSString stringWithFormat:@"%@", model.date];
                    NSLog(@"%@", str);
                    [dateArr addObject:model.date];

                    NSInteger index= [dateArr indexOfObject:model.date inRange:NSMakeRange(0, [dateArr count] - 1)];

                    if(index!= NSNotFound)

                    {

                        [dateArr removeObjectAtIndex:index];

                    }

                }
                
                
                NSMutableArray *finalArr =[NSMutableArray new];
                
                for (int i = 0; i < dateArr.count; i++) {
                    NSMutableArray *arr = [NSMutableArray new];
                    NSString *str = dateArr[i];
                    for (LockHistory *dic in dataArr) {
                        if ([str isEqualToString:dic.date]) {
                            [arr addObject:dic];
                        }
                    }
                    [finalArr addObject:arr];
                }
                
                callback(nil, finalArr, dateArr);
            }
            
        }else {
            NSString *str = datadic[@"msg"];
            [ConfigModel mbProgressHUD:str andView:nil];
        }
    }];
}

@end
