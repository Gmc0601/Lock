//
//  LockhistoryViewController.h
//  BaseProject
//
//  Created by cc on 2018/1/3.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "CCBaseViewController.h"

@interface HistoryModel : NSObject

@end

@interface LockhistoryViewController : CCBaseViewController

@property (nonatomic,copy) NSString *lock_id;

@property (nonatomic, copy) NSString *textstr;

@end
