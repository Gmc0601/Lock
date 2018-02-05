//
//  CCButton.h
//  CarSticker
//
//  Created by cc on 2017/3/23.
//  Copyright © 2017年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CCButton : UIView

@property (nonatomic, retain) UIImageView *pic;

@property (nonatomic, retain) UILabel *title;

@property (nonatomic, retain) UILabel *countLab;

@property (nonatomic, retain) UIButton *btn;

@property (nonatomic, copy) NSString *str;

@property (nonatomic, copy) void(^cliclBlock)();

- (void)setPic:(NSString *)picName title:(NSString *)title;

@end
