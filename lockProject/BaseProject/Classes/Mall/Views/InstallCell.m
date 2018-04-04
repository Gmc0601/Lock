//
//  installCell.m
//  BaseProject
//
//  Created by LeoGeng on 16/12/2017.
//  Copyright © 2017 cc. All rights reserved.
//

#import "InstallCell.h"
#import "UIColor+BGHexColor.h"
#import <Masonry/Masonry.h>
#import "UILabel+Width.h"
#import <YYKit.h>

@interface InstallCell()
@property(retain ,atomic) UILabel *lblCity;
@property(retain ,atomic) UILabel *lblDistrict;
@end

@implementation InstallCell

-(void) setValue:(NSString *)value{
    _value = value;
    NSArray *arr = [value componentsSeparatedByString:@":"];
    _lblCity.text = arr[0];
    _lblDistrict.text = arr[1];
   
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier {
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    [self addSubViews];
    
    return self;
}

-(void) addSubViews{
    _lblCity = [UILabel new];
    _lblCity.font = PingFangSCMedium(SizeWidth(14));
    _lblCity.textColor = RGBColor(153,153,153);
    _lblCity.textAlignment = NSTextAlignmentLeft;
    
    [self addSubview:_lblCity];
    
    [_lblCity mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self).offset(SizeHeight(20));
        make.width.equalTo(self);
        make.height.equalTo(@(SizeHeight(15)));
    }];
    
    _lblDistrict = [UILabel new];
    _lblDistrict.font = PingFangSCBOLD(SizeWidth(15));
    _lblDistrict.textColor = RGBColor(51,51,51);
    _lblDistrict.numberOfLines = 0;
    _lblDistrict.textAlignment = NSTextAlignmentLeft;
    [self addSubview:_lblDistrict];
    
    [_lblDistrict mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_lblCity);
        make.top.equalTo(_lblCity.mas_bottom).offset(SizeHeight(15));
        make.width.equalTo(self);
        make.bottom.equalTo(self);
    }];
}

@end
