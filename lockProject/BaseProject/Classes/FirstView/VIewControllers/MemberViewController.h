//
//  MemberViewController.h
//  BaseProject
//
//  Created by cc on 2018/1/3.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "CCBaseViewController.h"

@interface MemberModle :NSObject
@property (nonatomic, copy) NSString *un_user_id, *type, *remark;
@end

@interface MemberViewController : CCBaseViewController

@property (nonatomic, copy) NSString *lockId, *lockName;

@end
