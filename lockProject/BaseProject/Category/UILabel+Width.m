//
//  UILabel+Width.m
//  BaseProject
//
//  Created by cc on 2017/7/20.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "UILabel+Width.h"

@implementation UILabel (Width)

+ (CGFloat)getHeightByWidth:(CGFloat)width title:(NSString *)title font:(UIFont *)font
{
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 0)];
    label.text = title;
    label.font = font;
    label.numberOfLines = 0;
    [label sizeToFit];
    CGFloat height = label.frame.size.height;
    return height;
}

+ (CGFloat)getWidthWithTitle:(NSString *)title font:(UIFont *)font {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 1000, 0)];
    label.text = title;
    label.font = font;
    [label sizeToFit];
    return label.frame.size.width;
}


- (NSRange)allStr:(NSString *)allstr with:(NSString *)str {
    NSString *tmpStr = allstr;
    NSRange range;
    range = [tmpStr rangeOfString:str];
    return range;
}



-(void)fuwenbenLabel:(UILabel *)labell FontNumber:(CGFloat)font allStr:(NSString *)allstr with:(NSString *)str AndColor:(UIColor *)vaColor
{
    NSString *tmpStr = allstr;
    NSRange range;
    range = [tmpStr rangeOfString:str];
    NSMutableAttributedString *mustr = [[NSMutableAttributedString alloc] initWithString:labell.text];
    //设置字号
    [mustr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:font] range:range];
    //设置文字颜色
    [mustr addAttribute:NSForegroundColorAttributeName value:vaColor range:range];
    labell.attributedText = mustr;
}

@end
