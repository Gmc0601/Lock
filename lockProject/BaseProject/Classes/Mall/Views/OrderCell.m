//
//  OrderCell.m
//  BaseProject
//
//  Created by LeoGeng on 04/12/2017.
//  Copyright © 2017 cc. All rights reserved.
//

#import "OrderCell.h"
#import <Masonry/Masonry.h>
#import <KLCPopup/KLCPopup.h>
#import "UIImageView+WebCache.h"
#import "NetworkHelper.h"

@interface OrderCell()
@property(retain,atomic) UILabel *lblOrder;
@property(retain,atomic) UILabel *lblTitle;
@property(retain,atomic) UILabel *lblAmount;
@property(retain,atomic) UILabel *lblStatus;
@property(retain,atomic) UIImageView *img;
@property(retain,atomic) UIButton *btn;
@end

@implementation OrderCell
@synthesize model = _model;
-(void) setModel:(OrderModel *)model{
    _model = model;
    _lblOrder.text = model.order_sn;
    _lblTitle.text = model.goods_name;
    [_lblTitle sizeToFit];
    _lblAmount.text = model.order_amount;
    [_img sd_setImageWithURL:[NSURL URLWithString:model.head_img]];
    [self setFooterStyle];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier {
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    [self addHeader];
    [self addBorderTo:self topOffSet:SizeHeight(92/2)];
    [self addContent];
    [self addBorderTo:self topOffSet:SizeHeight(277/2)];
    [self addFooter];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    return self;
}

-(void) addHeader{
    UILabel *lblTitle = [UILabel new];
    lblTitle.font = PingFangSCMedium(SizeWidth(13));
    lblTitle.textColor = RGBColor(51,51,51);
    lblTitle.textAlignment = NSTextAlignmentLeft;
    lblTitle.text = @"订单编号:";
    [self addSubview:lblTitle];
    
    [lblTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(SizeWidth(32/2));
        make.top.equalTo(self).offset(SizeHeight(33/2));
        make.width.equalTo(@(SizeWidth(115/2)));
        make.height.equalTo(@(SizeHeight(28/2)));
    }];
    
    _lblOrder = [UILabel new];
    _lblOrder.font = Helvetica(SizeWidth(13));
    _lblOrder.textColor = RGBColor(51,51,51);
    _lblOrder.textAlignment = NSTextAlignmentLeft;
    [self addSubview:_lblOrder];
    
    [_lblOrder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lblTitle.mas_right).offset(SizeWidth(5));
        make.centerY.equalTo(lblTitle.mas_centerY);
        make.width.equalTo(self);
        make.height.equalTo(@(SizeHeight(22/2)));
    }];
    
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_gd"]];
    [self addSubview:imgView];
    
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_lblOrder.mas_centerY);
        make.right.equalTo(self).offset(-SizeWidth(32/2));
        make.width.equalTo(@(SizeWidth(28/2)));
        make.height.equalTo(@(SizeHeight(44/2)));
    }];
}

-(void) addBorderTo:(UIView *) superView topOffSet:(CGFloat) offset{
    UIView *border1 = [UIView new];
    border1.backgroundColor = RGBColorAlpha(224,224,224,1);
    [superView addSubview:border1];
    
    [border1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superView.mas_top).offset(offset);
        make.left.equalTo(superView.mas_left);
        make.right.equalTo(superView.mas_right);
        make.height.equalTo(@(1));
    }];
}

-(void) addContent{
    _img = [UIImageView new];
    [self addSubview:_img];
    
    [_img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(SizeWidth(32/2));
        make.top.equalTo(self).offset(SizeHeight(113/2));
        make.width.equalTo(@(SizeWidth(144/2)));
        make.height.equalTo(@(SizeHeight(144/2)));
    }];
    
    _lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(SizeWidth(207/2), SizeHeight(120/2), SizeWidth(300), SizeHeight(75))];
    _lblTitle.font = PingFangSCMedium(SizeWidth(15));
    _lblTitle.textColor = RGBColorAlpha(51,51,51,1);
    _lblTitle.textAlignment = NSTextAlignmentLeft;
    _lblTitle.text = @"shahahahahahaahahahaahahahahaha";
    _lblTitle.numberOfLines = 2;
    _lblTitle.lineBreakMode = NSLineBreakByTruncatingTail;
    [self addSubview:_lblTitle];
    [_lblTitle sizeToFit];
    
    _lblAmount = [UILabel new];
    _lblAmount.font = Helvetica(SizeWidth(13));
    _lblAmount.textColor = RGBColor(51,51,51);
    _lblAmount.textAlignment = NSTextAlignmentLeft;
    _lblAmount.text = [self getAmout:@"12302.02"];
    [self addSubview:_lblAmount];
    
    [_lblAmount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_img.mas_right).offset(SizeWidth(30/2));
        make.bottom.equalTo(_img.mas_bottom).offset(-SizeHeight(5));
        make.width.equalTo(@(SizeWidth(250/2)));
        make.height.equalTo(@(SizeHeight(26/2)));
    }];
}

-(void) addFooter{
    _lblStatus = [UILabel new];
    _lblStatus.font = PingFangSCMedium(SizeWidth(14));
    _lblStatus.textColor = RGBColor(248,179,23);
    _lblStatus.textAlignment = NSTextAlignmentLeft;
    _lblStatus.text = @"待付款";
    [self addSubview:_lblStatus];
    
    [_lblStatus mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_img.mas_left);
        make.bottom.equalTo(self.mas_bottom).offset(-SizeHeight(24));
        make.width.equalTo(@(SizeWidth(170/2)));
        make.height.equalTo(@(SizeHeight(26/2)));
    }];
    
    _btn = [UIButton new];
    [_btn setTitleColor:RGBColor(255,255,255) forState:UIControlStateNormal];
    [_btn setTitle:@"立即支付" forState:UIControlStateNormal];
    [_btn addTarget:self action:@selector(tapActionButton) forControlEvents:UIControlEventTouchUpInside];
    _btn.backgroundColor = RGBColor(248,179,23);
    _btn.titleLabel.font = PingFangSCMedium(SizeWidth(13));
    [self addSubview:_btn];
    
    [_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(SizeWidth(-32/2));
        make.centerY.equalTo(_lblStatus);
        make.width.equalTo(@(SizeWidth(164/2)));
        make.height.equalTo(@(SizeHeight(66/2)));
    }];
}

-(void) tapActionButton{
    if(_model.status == OrderStatus_waitingPay){
        [NetworkHelper pay:_model.order_id];
    }else if(_model.status == OrderStatus_hasSend){
         [self.delegate showConfirmView:_model];
    }
}

-(NSString *) getAmout:(NSString *) amount{
    return [NSString stringWithFormat:@"合计:￥%@",amount];
}

-(void) setFooterStyle{
    _btn.hidden = YES;
    _btn.layer.borderWidth = 0;
    
    if (_model.status == OrderStatus_waitingPay) {
        _lblStatus.textColor = RGBColor(248,179,23);
        _lblStatus.text = @"待付款";
        [_btn setTitleColor:RGBColor(255,255,255) forState:UIControlStateNormal];
        _btn.backgroundColor = RGBColor(248,179,23);
        _btn.hidden = NO;

    }else if (_model.status == OrderStatus_padyed){
        _lblStatus.textColor = RGBColor(51,51,51);
        _lblStatus.text = @"待发货";
    }else if(_model.status == OrderStatus_hasSend){
        _lblStatus.textColor = RGBColor(51,51,51);
        _lblStatus.text = @"待收货";
        [_btn setTitleColor:RGBColor(51,51,51) forState:UIControlStateNormal];
        _btn.backgroundColor = [UIColor whiteColor];
        _btn.layer.borderColor = RGBColor(224,224,224).CGColor;
        _btn.layer.borderWidth = 1;
        _btn.hidden = NO;
        [_btn setTitle:@"确认收货" forState:UIControlStateNormal];
        
    }else if (_model.status == OrderStatus_complete){
        _lblStatus.textColor = RGBColor(153,153,153);
        _lblStatus.text = @"已完成";
    }else if (_model.status == OrderStatus_waitingRefund){
        _lblStatus.textColor = RGBColor(51,51,51);
        _lblStatus.text = @"退款审核中";
    }else if (_model.status == OrderStatus_RefundComplete){
        _lblStatus.textColor = RGBColor(153,153,153);
        _lblStatus.text = @"退款成功";
    }else{
        _lblStatus.textColor = RGBColor(51,51,51);
        _lblStatus.text = @"已取消";
    }
}
@end
