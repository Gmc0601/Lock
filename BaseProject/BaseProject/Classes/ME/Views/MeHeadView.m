//
//  MeHeadView.m
//  BaseProject
//
//  Created by cc on 2017/12/11.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "MeHeadView.h"
#import <YYKit.h>
#import "UIButton+YX.h"
#import "CCButton.h"
@implementation MeHeadView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self createView];
    }
    return self;
}

- (void)createView {
    [self addSubview:self.backView];
    [self.backView addSubview:self.headImg];
    [self.backView addSubview:self.nicknameLab];
    [self addSubview:self.messageBtn];
    [self addSubview:self.headBtn];
    [self addOrderBtn];
}

- (void)addOrderBtn {
    NSArray *titleArr = @[@"待付款", @"待发货", @"待收货", @"全部订单"];  NSArray *picArr = @[@"wd_icon_dfk", @"wd_icon_dfh", @"组3拷贝2", @"wd_icon_qbdd"];
    
    for (int i = 0; i < 4; i++) {
        CCButton *btn = [[CCButton alloc] init];
        btn.frame = FRAME(SizeWidth(20) + i * SizeWidth(90), self.backView.bottom + SizeHeight(10), SizeWidth(50), SizeHeight(60));
        btn.backgroundColor = [UIColor clearColor];

        [btn setPic:picArr[i] title:titleArr[i]];
        WeakSelf(weak);
        btn.cliclBlock = ^{
            [weak orderClick:i];
        };
        [self addSubview:btn];
    }
}

- (void)orderClick:(int)sender {
    
    NSLog(@"%d", sender);
    if (self.orderBlock) {
        self.orderBlock(sender);
    }
}

- (UIImageView *)backView {
    if (!_backView) {
        _backView = [[UIImageView alloc] initWithFrame:FRAME(0, 0, kScreenW, SizeHeight(230))];
        _backView.image = [UIImage imageNamed:@"wd_bg_tx"];
    }
    return _backView;
}

- (UIImageView *)headImg {
    if (!_headImg) {
        _headImg = [[UIImageView alloc] initWithFrame:FRAME(kScreenW/2 - SizeWidth(36), SizeHeight(80), SizeWidth(72), SizeWidth(72))];
        _headImg.backgroundColor = [UIColor clearColor];
        _headImg.layer.masksToBounds = YES;
        _headImg.layer.cornerRadius = SizeWidth(36);
        _headImg.image = [UIImage imageNamed:@"-s-xq_bg_tx"];
    }
    return _headImg;
}

- (UILabel *)nicknameLab {
    if (!_nicknameLab) {
        _nicknameLab = [[UILabel alloc] initWithFrame:FRAME(0, self.headImg.bottom + SizeHeight(10), kScreenW, SizeHeight(15))];
        _nicknameLab.backgroundColor = [UIColor clearColor];
        _nicknameLab.textColor = [UIColor whiteColor];
        _nicknameLab.font = ArialFont(12);
        _nicknameLab.text = @"CC";
        _nicknameLab.textAlignment = NSTextAlignmentCenter;
    }
    return _nicknameLab;
}

- (UIButton *)messageBtn {
    if (!_messageBtn) {
        _messageBtn = [[UIButton alloc] initWithFrame:FRAME(kScreenW - SizeWidth(15 + 25), SizeHeight(15), SizeWidth(25), SizeWidth(25))];
        _messageBtn.backgroundColor = [UIColor clearColor];
        [_messageBtn setImage:[UIImage imageNamed:@"nav_icon_xx_k"] forState:UIControlStateNormal];
        [_messageBtn addTarget:self action:@selector(messageClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _messageBtn;
}

- (UIButton *)headBtn {
    if (!_headBtn) {
        _headBtn = [[UIButton alloc] initWithFrame:FRAME(kScreenW/2 - SizeWidth(36), SizeHeight(80), SizeWidth(72), SizeWidth(100))];
        _headBtn.backgroundColor = [UIColor clearColor];
        [_headBtn addTarget:self action:@selector(headClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _headBtn;
}

- (void)headClick {
    if (self.headImgBlock) {
        self.headImgBlock();
    }
}

- (void)messageClick:(UIButton *)sender {
    NSLog(@"message");
}

@end
