//
//  CCButton.m
//  CarSticker
//
//  Created by cc on 2017/3/23.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "CCButton.h"
#import <YYKit.h>
#define C3  [UIColor colorWithRed:(((0x577dbc & 0xFF0000) >> 16))/255.0 green:(((0x577dbc &0xFF00) >>8))/255.0 blue:((0x577dbc &0xFF))/255.0 alpha:1.0]
@implementation CCButton

- (instancetype)init {
    if (self == [super init]) {
        [self createView];
    }
    return self;
}

- (void)setPic:(NSString *)picName title:(NSString *)title {
    self.pic.image = [UIImage imageNamed:picName];
    self.title.text = title;
}

- (void)setStr:(NSString *)str {
    if ([str intValue] == 0) {
        self.countLab.hidden = YES;
    }else {
        self.countLab.hidden = NO;
        self.countLab.text = str;
    }
}

- (void)createView {
    [self addSubview:self.pic];
    [self addSubview:self.countLab];
    [self addSubview:self.title];
    [self addSubview:self.btn];
}

- (UIImageView *)pic {
    if (!_pic) {
        _pic = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 40, 40)];
        _pic.backgroundColor = [UIColor clearColor];
    }
    return _pic;
}

- (UILabel *)title {
    if (!_title) {
        _title = [[UILabel alloc] initWithFrame:CGRectMake(0, 53, 70, 15)];
        _title.backgroundColor = [UIColor clearColor];
        _title.font = [UIFont systemFontOfSize:13];
        _title.textAlignment = NSTextAlignmentCenter;

    }
    return _title;
}

- (UIButton *)btn {
    if (!_btn) {
        _btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 90, 25)];
        _btn.backgroundColor = [UIColor clearColor];
        [_btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btn;
}

- (UILabel *)countLab {
    if (!_countLab) {
        _countLab = [[UILabel alloc] initWithFrame:FRAME(self.pic.right - 10, 5, 15, 15)];
        _countLab.backgroundColor = [UIColor redColor];
        _countLab.font = [UIFont systemFontOfSize:10];
        _countLab.textColor = [UIColor whiteColor];
        _countLab.textAlignment = NSTextAlignmentCenter;
        _countLab.layer.masksToBounds = YES;
        _countLab.hidden = YES;
        _countLab.layer.cornerRadius = 15/2;
    }
    return _countLab;
}

- (void)click:(id)sender {
    if (_cliclBlock) {
        _cliclBlock();
    }
}

@end
