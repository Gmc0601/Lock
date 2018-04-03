//
//  AppDelegate+GTSdk.h
//  BaseProject
//
//  Created by cc on 2017/12/20.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "AppDelegate.h"
#import <GTSDK/GeTuiSdk.h>     // GetuiSdk头文件应用

// iOS10 及以上需导入 UserNotifications.framework
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
#import <UserNotifications/UserNotifications.h>
#endif
@interface AppDelegate (GTSdk)<UIApplicationDelegate, GeTuiSdkDelegate, UNUserNotificationCenterDelegate> 

- (void)initGTPushoptions:(NSDictionary *)launchOptions;

@end
