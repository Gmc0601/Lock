//
//  PCBClickLabel.m
//  部分label点击事件
// 简书 http://www.jianshu.com/u/bb2db3428fff
//  Created by pcb on 16/2/5.
//  Copyright © 2016年 DWade. All rights reserved.
//
#define originY 60
#import "PCBClickLabel.h"
@interface PCBClickLabel()
@property (nonatomic, strong)UILabel *commonLabel;
@property (nonatomic, strong)UILabel *clickLabel;
@property (nonatomic, assign)CGRect commonLabelFrame;
@property (nonatomic, assign)CGRect clickLabelFrame;
@property (nonatomic, strong)NSString *clickLabStr;

@end

@implementation PCBClickLabel


- (instancetype)initLabelViewWithLab:(NSString *)text clickTextRange:(NSRange)clickTextRange frame:(CGRect)fram clickAtion:(clickBlock)clickAtion {
    self = [super init];
    if (self) {
        //变量
        NSString *clickText;
        NSString *commonText;
        NSString *commonText2;
        UILabel *commonLabel = [UILabel new];
        UILabel *clickLabel = [UILabel new];
        UILabel *commonLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        
        //如果选择的范围文字是文尾的文字，而不是中间的文字或者开头的文字
        if (clickTextRange.location + clickTextRange.length == text.length) {
            clickText = [text substringWithRange:clickTextRange];
            commonText = [text substringToIndex:clickTextRange.location];
            //label的位置
            commonLabel.frame = CGRectMake(0, 0, [[self class] calculateRowWidth:commonText], 30);
            clickLabel.frame = CGRectMake(commonLabel.frame.size.width+commonLabel.frame.origin.x, 0, [[self class] calculateRowWidth:clickText], 30);
        }else if (clickTextRange.location == 0) {//选择的范围文字是开头的
            clickText = [text substringWithRange:clickTextRange];
            commonText = [text substringWithRange:NSMakeRange(clickText.length, text.length-clickText.length)];
            
            //label的位置
            clickLabel.frame = CGRectMake(0, 0, [[self class] calculateRowWidth:clickText], fram.size.height);
            commonLabel.numberOfLines = 0;
            commonLabel.textColor =UIColorFromHex(0x999999);
            commonLabel.font = [UIFont systemFontOfSize:14];
            clickLabel.font = [UIFont systemFontOfSize:14];
            clickLabel.textColor = [UIColor blueColor];
            commonLabel.frame = CGRectMake(clickLabel.frame.size.width+clickLabel.frame.origin.x, 0, [[self class] calculateRowWidth:commonText], fram.size.height);
        }else { //可点击文字在整段文字中间
            clickText = [text substringWithRange:clickTextRange];
            commonText = [text substringToIndex:clickTextRange.location];
            commonText2 = [text substringWithRange:NSMakeRange(clickTextRange.length+clickTextRange.location, text.length-clickText.length-commonText.length)];
            commonLabel2 = [UILabel new];
            //label的位置
            commonLabel.frame = CGRectMake(0, 0, [[self class] calculateRowWidth:commonText], 30);
            clickLabel.frame = CGRectMake(commonLabel.frame.size.width+commonLabel.frame.origin.x, 0, [[self class] calculateRowWidth:clickText], 30);
            commonLabel2.frame = CGRectMake(clickLabel.frame.size.width+clickLabel.frame.origin.x, 0, [[self class] calculateRowWidth:commonText2], 30);
            commonLabel2.text = commonText2;
            [self addSubview:commonLabel2];
        }
        
        commonLabel.text = commonText;
       //  [clickText addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
        clickLabel.text = clickText;
        clickLabel.textColor = MainBlue;
        self.clickLabStr = clickText;
        clickLabel.userInteractionEnabled = YES;
        
        
        UILabel *line = [[UILabel alloc] initWithFrame:FRAME(0, 29, clickLabel.frame.size.width - 5, 1)];
        line.backgroundColor = MainBlue;
        [clickLabel addSubview:line];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(labClick)];
        [clickLabel addGestureRecognizer:tap];
        
        
        self.backgroundColor = UIColorFromHex(0xF1F2F2);
        self.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width-(clickLabel.frame.size.width+commonLabel.frame.size.width+commonLabel2.frame.size.width))/2, originY, [[self class] calculateRowWidth:text], 30);
        self.clickBlock = clickAtion;
//        self.clickLab = clickLabel;
        [self addSubview:commonLabel];
        [self addSubview:clickLabel];

    }
    return self;

}

+ (CGFloat)calculateRowWidth:(NSString *)string {
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:17]};  //指定字号
    CGRect rect = [string boundingRectWithSize:CGSizeMake(0, 30)/*计算宽度时要确定高度*/ options:NSStringDrawingUsesLineFragmentOrigin |
                   NSStringDrawingUsesFontLeading attributes:dic context:nil];
    return rect.size.width;
}

- (void)labClick {
        NSLog(@"点击了”%@“",self.clickLabStr);
    self.clickBlock();
}


@end
