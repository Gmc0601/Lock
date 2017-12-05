//
//  AddDeviceNextViewController.h
//  BaseProject
//
//  Created by cc on 2017/12/5.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "CCBaseViewController.h"

typedef enum : NSUInteger {
    AddNetWork,
    AddLock,
} AddType;

@interface AddDeviceNextViewController : CCBaseViewController

@property (nonatomic, assign) AddType type;

@end
