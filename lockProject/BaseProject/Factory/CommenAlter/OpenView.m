//
//  OpenView.m
//  BaseProject
//
//  Created by cc on 2018/1/3.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "OpenView.h"
#import <YYKit.h>

@implementation OpenView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self addSubview:self.backView];
//        [self.backView addSubview:self.leftBtn];
//        [self.backView addSubview:self.rightBtn];
        [self.backView addSubview:self.openBtn];
    }
    return self;
}

- (CCButton *)leftBtn {
    if (!_leftBtn ) {
        _leftBtn = [[CCButton alloc] init];
        _leftBtn.frame = FRAME(SizeWidth(75), 64 + SizeHeight(20), SizeWidth(63), SizeHeight(90));
        _leftBtn.backgroundColor = [UIColor clearColor];
        [_leftBtn setPic:@"sy_icon_ksjl_k-1" title:@"开锁记录"];
        WeakSelf(weak);
        _leftBtn.cliclBlock = ^{
            //  开锁记录
//            LockModel *model = [[LockModel alloc] init];
//            model = self.dateArr[num];
//            LockhistoryViewController *vc = [[LockhistoryViewController alloc] init];
//            vc.lock_id = model.lock_id;
//            [weak.navigationController pushViewController:vc animated:YES];
        };
    }
    return _leftBtn;
}
- (CCButton *)rightBtn {
    if (!_rightBtn ) {
        _rightBtn = [[CCButton alloc] init];
        _rightBtn.frame = FRAME(SizeWidth(234), 64+ SizeHeight(20), SizeWidth(63), SizeHeight(90));
        _rightBtn.backgroundColor = [UIColor clearColor];
        [_rightBtn setPic:@"sy_icon_cygl_k-1" title:@"成员管理"];
//        _rightBtn.title.textColor =
        WeakSelf(weak);
        _rightBtn.cliclBlock = ^{
            //  开锁记录
//            LockModel *model = [[LockModel alloc] init];
//            model = self.dateArr[num];
//            MemberViewController *vc = [[MemberViewController alloc] init];
//            vc.lockId = model.lock_id;
//            vc.lockName = model.lock_name;
//            [weak.navigationController pushViewController:vc animated:YES];
        };
    }
    return _rightBtn;
}
- (UIButton *)openBtn {
    if (!_openBtn) {
        _openBtn = [[UIButton alloc] init];
        UIImage *image = [UIImage imageNamed:@"组6"];
        _openBtn.size = image.size;
        _openBtn.centerX = self.centerX;
        _openBtn.centerY = self.centerY + 20;
        [_openBtn setImage:image forState:UIControlStateNormal];
//        [_openBtn addTarget:self action:@selector(openlock) forControlEvents:UIControlEventTouchUpInside];
    }
    return _openBtn;
}

- (UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc] initWithFrame:FRAME(0, 0, kScreenW, kScreenH)];
        _backView.backgroundColor = UIColorFromHex(0x4A566D);
    }
    return _backView;
}

- (void)pop {
    
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    [keyWindow addSubview:self];
    
    self.backView.transform = CGAffineTransformMakeScale(0.2, 0.2);
    [UIView animateWithDuration:.35 animations:^{
        self.backView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(dismiss) userInfo:nil repeats:NO];
    }];
}

- (void)dismiss {
    
    [UIView animateWithDuration:.35 animations:^{
        self.backView.transform = CGAffineTransformMakeScale(0.2, 0.2);
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}

@end
