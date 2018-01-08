//
//  ConnectionAlter.m
//  BaseProject
//
//  Created by cc on 2018/1/3.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "ConnectionAlter.h"
#import <YYKit.h>
#import "JXCircleView.h"

@implementation ConnectionAlter

- (instancetype)initWithFrame:(CGRect)frame lock:(BOOL)lock {
    if (self == [super initWithFrame:frame]) {
        self.lock = lock;
        time = 60;
        [self addSubview:self.whitView];
        [self.whitView addSubview:self.moreView];
        [self.whitView addSubview:self.closebtn];
        [self.whitView addSubview:self.logoImage];
        [self.whitView addSubview:self.infolab];
    }
    return self;
}

- (void)pop {
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    [keyWindow addSubview:self];
    self.whitView.transform = CGAffineTransformMakeScale(0.2, 0.2);
    [UIView animateWithDuration:.35 animations:^{
        self.whitView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        
    }];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(animationAction) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
}
- (void)animationAction {
    time--;
    NSString *str;
    if (self.lock) {
        str = [NSString stringWithFormat:@"正在匹配智能锁...（%d）", time];
    }else {
        str = [NSString stringWithFormat:@"正在连接网关...（%d）", time];
    }
    self.infolab.text = str;
    JXCircleView *circleView1 = [[JXCircleView alloc]init];
    circleView1.frame = FRAME(0, 0, self.moreView.frame.size.width, self.moreView.frame.size.height);
    circleView1.backgroundColor = [UIColor clearColor];
    [circleView1.layer addAnimation:[self addGroupAnimation] forKey:@"groupAnimation2"];
    [self.moreView addSubview:circleView1];
    
    if (time == 0) {
        
    }
    
}


- (CAAnimationGroup *)addGroupAnimation{
    
    CABasicAnimation *animation1 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    
    animation1.fromValue = @1;
    animation1.toValue = @7;
    
    CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation2.fromValue = @1;
    animation2.toValue = @0;
    CAAnimationGroup *groupAnima = [CAAnimationGroup animation];
    groupAnima.animations = @[animation1,animation2];
    groupAnima.duration = 4;
    groupAnima.fillMode = kCAFillModeForwards;
    groupAnima.removedOnCompletion = NO;
    groupAnima.repeatCount = 1;
    
    groupAnima.delegate = self;
    return groupAnima;
}

- (void)dismiss {
     [self.timer invalidate];
    [UIView animateWithDuration:.35 animations:^{
        self.whitView.transform = CGAffineTransformMakeScale(0.2, 0.2);
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}

- (UIButton *)closebtn {
    if (!_closebtn) {
        _closebtn = [[UIButton alloc] initWithFrame:FRAME(15, 30, 30, 30)];
        _closebtn.backgroundColor = [UIColor clearColor];
        [_closebtn setImage:[UIImage imageNamed:@"icon_sc"] forState:UIControlStateNormal];
        [_closebtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closebtn;
}

- (UIImageView *)logoImage {
    if (!_logoImage) {
        _logoImage = [[UIImageView alloc] init];
        _logoImage.size = CGSizeMake(SizeWidth(110), SizeWidth(110));
        _logoImage.backgroundColor = [UIColor clearColor];
        if (self.lock) {
            _logoImage.image = [UIImage imageNamed:@"-s-tj_icon_zns_pre"];
        }else {
           _logoImage.image = [UIImage imageNamed:@"tjwg_icon_glwifi"];
        }
        
        _logoImage.centerX = self.centerX;
        _logoImage.centerY = self.centerX;
        
    }
    return _logoImage;
}

- (UIView *)moreView {
    if (!_moreView) {
        _moreView = [[UIView alloc] init];
        _moreView.size = CGSizeMake(SizeWidth(110), SizeWidth(110));
        _moreView.backgroundColor = [UIColor clearColor];
        _moreView.centerX = self.centerX;
        _moreView.centerY = self.centerX;
    }
    return _moreView;
}

- (UILabel *)infolab {
    if (!_infolab) {
        _infolab = [[UILabel alloc] initWithFrame:FRAME(15, self.logoImage.bottom + 30, kScreenW - 30, 15)];
        _infolab.textAlignment = NSTextAlignmentCenter;
        _infolab.text = @"";
        _infolab.font = [UIFont systemFontOfSize:15];
        _infolab.textColor = UIColorHex(0x648DDD);
    }
    return _infolab;
}

- (UIView *)whitView {
    if (!_whitView) {
        _whitView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
        _whitView.backgroundColor = [UIColor whiteColor];
    }
    return _whitView;
}

@end
