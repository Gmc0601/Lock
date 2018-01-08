//
//  NetAlter.h
//  BaseProject
//
//  Created by cc on 2018/1/3.
//  Copyright © 2018年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NetModel : NSObject

@property (nonatomic,copy) NSString *gateway_id, *name;

@end

@interface NetAlter : UIView

@property (nonatomic, copy) void(^rightBlock)(NSIndexPath *);

//从外面传进来的数据数组
@property (nonatomic, strong) NSMutableArray *dataArray;

//弹出
- (void)pop;

//隐藏
- (void)dismiss;

@end
