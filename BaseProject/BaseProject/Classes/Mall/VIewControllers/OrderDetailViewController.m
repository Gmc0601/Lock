//
//  ConfirmOrderViewController.m
//  BaseProject
//
//  Created by LeoGeng on 27/11/2017.
//  Copyright © 2017 cc. All rights reserved.
//
#import "SHPlacePickerView.h"
#import "OrderDetailViewController.h"
#import "KLCPopup.h"
#import "UIColor+BGHexColor.h"
#define Share_TAG 100000
#define CBX_PAY_TAG 2003


@interface OrderDetailViewController ()<UITableViewDelegate,UITableViewDataSource>{
    int _numberOfSection;
}

@property (nonatomic, retain) UITableView *tb;
@property (nonatomic, retain) UILabel *lblAmount;
@property (nonatomic, retain) UILabel *lblGooodsPrice;
@property (nonatomic, retain) UILabel *lblInstallPrice;
@property (nonatomic, retain) UILabel *lblCoupon;
@property(retain,atomic) UILabel *lblName;
@property(retain,atomic) UILabel *lblTelNo;
@property(retain,atomic) UILabel *lblAddress;
@property(retain,atomic) UIImageView *imgGoods;
@property(retain,atomic) UILabel *lblGoodsTitle;
@property(assign,atomic) BOOL needInstall;
@property(retain,atomic) KLCPopup* installPopup;
@property(retain,atomic) KLCPopup* serviceDescPopup;
@property(retain,atomic) KLCPopup* PayPopup;
@property(retain,atomic) UIView* alView;
@property(retain,atomic) UIView* wcView;
@property(assign,atomic) BOOL isWechatPay;
@property(retain,atomic) UIImageView* imgStatus;
@property(retain,atomic) UILabel* lblStatus;
@end

@implementation OrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _needInstall = YES;
    [self resetFather];
    [self addFooter];
    [self addTableView];
    _numberOfSection = 3;
    self.automaticallyAdjustsScrollViewInsets = NO;
}

-(void) ShowHeader{
    if (_imgStatus != nil) {
        return;
    }
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, SizeHeight(140))];
    headerView.backgroundColor = [UIColor whiteColor];
    _imgStatus = [UIImageView new];
    _imgStatus.image = [UIImage imageNamed:@"ddxq_icon_yfh"];
    [headerView addSubview:_imgStatus];
    
    [_imgStatus mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headerView);
        make.top.equalTo(headerView).offset(SizeHeight(71/2));
        make.width.equalTo(@(SizeWidth(44)));
        make.height.equalTo(@(SizeHeight(56.2/2)));
    }];
    
    _lblStatus = [UILabel new];
    _lblStatus.font = PingFangSCBOLD(SizeWidth(15));
    _lblStatus.textColor = RGBColor(51,51,51);
    _lblStatus.textAlignment = NSTextAlignmentCenter;
    _lblStatus.text = @"等待平台发货";
    [headerView addSubview:_lblStatus];
    
    [_lblStatus mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_imgStatus.mas_centerX);
        make.top.equalTo(_imgStatus.mas_bottom).offset(SizeHeight(51.8/2));
        make.width.equalTo(headerView);
        make.height.equalTo(@(SizeHeight(18)));
    }];
    [self addBorder:headerView];
    _tb.tableHeaderView  = headerView;
}

- (void)resetFather {
    self.line.hidden = YES;
    self.titleLab.text = @"确认订单";
    [self.rightBar setTitle:@"客服" forState:UIControlStateNormal];
}

-(void) addTableView{
    _tb = [[UITableView alloc] initWithFrame:CGRectMake(0, SizeHeight(64), kScreenW, kScreenH - SizeHeight(64)- SizeHeight(55)) style:UITableViewStyleGrouped];
    _tb.backgroundColor = RGBColorAlpha(224,224,224,1);
    _tb.backgroundColor = RGBColor(239, 240, 241);
    _tb.delegate = self;
    _tb.dataSource = self;
    
    [_tb setSeparatorStyle:UITableViewCellSeparatorStyleNone];
 
    
    _tb.tableFooterView = ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW,  SizeHeight(0))];
        view.backgroundColor = [UIColor blueColor];
        view;
    });
    
    [self ShowHeader];
    [self.view addSubview:_tb];
}

-(void) addFooter{
    UIView *footer = [UIView new];
    footer.backgroundColor = RGBColorAlpha(255,255,255,1);
    [self.view addSubview:footer];
    
    [footer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view);
        make.height.equalTo(@(SizeHeight(110/2)));
        make.bottom.equalTo(self.view);
        make.left.equalTo(self.view);
    }];
    
    UILabel *lblTitle = [UILabel new];
    lblTitle.font = PingFangSCMedium(SizeWidth(13));
    lblTitle.textColor = RGBColorAlpha(51,51,51,1);
    lblTitle.textAlignment = NSTextAlignmentLeft;
    lblTitle.text = @"总计";
    [footer addSubview:lblTitle];
    
    [lblTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(footer.mas_left).offset(SizeWidth(32/2));
        make.centerY.equalTo(footer.mas_centerY);
        make.width.equalTo(@(SizeWidth(55/2)));
        make.height.equalTo(@(SizeHeight(25/2)));
    }];
    
    _lblAmount = [UILabel new];
    _lblAmount.font = PingFangSC(SizeWidth(15));
    _lblAmount.textColor = RGBColorAlpha(248,179,23,1);
    _lblAmount.textAlignment = NSTextAlignmentLeft;
    _lblAmount.text = @"266000";
    [footer addSubview:_lblAmount];
    
    [_lblAmount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lblTitle.mas_right).offset(SizeWidth(16/2));
        make.centerY.equalTo(footer.mas_centerY);
        make.width.equalTo(@(SizeWidth(200)));
        make.height.equalTo(@(SizeHeight(28/2)));
    }];
    
    UIButton *btnSubmit = [UIButton new];
    [btnSubmit setTitle:@"提交订单" forState:UIControlStateNormal];
    [btnSubmit addTarget:self action:@selector(tapSubmitButton) forControlEvents:UIControlEventTouchUpInside];
    btnSubmit.titleLabel.font = PingFangSC(SizeWidth(15));
    btnSubmit.backgroundColor = RGBColorAlpha(248,179,23,1);;
    [btnSubmit setTitleColor:RGBColorAlpha(255,255,255,1) forState:UIControlStateNormal];
    btnSubmit.titleLabel.textAlignment = NSTextAlignmentCenter;
    [footer addSubview:btnSubmit];
    
    [btnSubmit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(footer.mas_right).offset(SizeWidth(-32/2));
        make.centerY.equalTo(footer.mas_centerY);
        make.width.equalTo(@(SizeWidth(186/2)));
        make.height.equalTo(@(SizeHeight(66/2)));
    }];
}

-(void) tapSubmitButton{
    [self showPayTypeView];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _numberOfSection;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    int number = 0;
    switch (section) {
        case 0:
            number = 4;
            break;
        case 1:
            number = 3;
            break;
        case 2:
            number = 4;
            break;
        default:
            break;
    }
    
    return number;
}

- (UITableViewCell *)defaleCellWithCellId:(NSString *)cellId {
    UITableViewCell *cell = [_tb dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
    }
    
    return cell;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellId = [NSString stringWithFormat:@"%ld%ld", (long)indexPath.section, (long)indexPath.row];
    UITableViewCell *cell =   [self defaleCellWithCellId:cellId];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0) {
        [self addContentForDeliveryAddrees:cell withIndex:indexPath.row];
    }else if(indexPath.section == 1){
        if (indexPath.row == 0) {
            [self addGoodInfoTo:cell];
        }else{
            [self addNeedInstall:cell withIndex:indexPath.row];
        }
    }else if(indexPath.section == 2){
        [self addCostDetail:cell withIndex:indexPath.row];
    }
    
    return cell;
}


#pragma mark - UITableDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = SizeHeight(40);
    switch (indexPath.section) {
            case 0:
            if (indexPath.row == 2) {
                height = SizeHeight(50);
            }
            break;
        case 1:
            if (indexPath.row == 0) {
                height = SizeHeight(166/2);
            }else{
                height = SizeHeight(130/2);
            }
            break;
            
        default:
            break;
    }
    return height;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:FRAME(0, 0, kScreenW, SizeHeight(45))];
    view.backgroundColor = [UIColor whiteColor];
    NSString *title = @"";
    switch (section) {
        
        case 1:
            title = @"商品信息";
            break;
        case 2:
            title = @"费用明细";
            break;
        default:
            break;
    }
    
    [self addHeaderTitle:view withTitle:title];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return SizeHeight(10);
    }
    return SizeHeight(0);
}

-(void) addHeaderTitle:(UIView *) header withTitle:(NSString *) title{
    UILabel *lblTitle = [UILabel new];
    lblTitle.font = PingFangSCBOLD(SizeWidth(15));
    lblTitle.textColor = RGBColor(51,51,51);
    lblTitle.textAlignment = NSTextAlignmentLeft;
    lblTitle.text = title;
    [header addSubview:lblTitle];
    
    [lblTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(header.mas_left).offset(SizeWidth(33/2));
        make.top.equalTo(header.mas_top).offset(SizeHeight(30/2));
        make.width.equalTo(@(SizeWidth(200)));
        make.height.equalTo(@(SizeHeight(29/2)));
    }];
}

-(void) addBorder:(UIView *) superView{
    UIView *border = [UIView new];
    border.backgroundColor = RGBColorAlpha(224,224,224,1);
    [superView addSubview:border];
    
    [border mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superView.mas_bottom).offset(-1);
        make.left.equalTo(superView.mas_left).offset(SizeWidth(30/2));
        make.right.equalTo(superView.mas_right).offset(-SizeWidth(30/2));
        make.height.equalTo(@(1));
    }];
}

-(UILabel *) addTitleLable:(NSString *) title withSuperView:(UIView *) superView withFontColor:(UIColor *) fontColor rightOffSet:(CGFloat) offset{
    UILabel *lblName = [[UILabel alloc] init];
    lblName.textColor = fontColor;
    lblName.text = title;
    [superView addSubview:lblName];
    
    if ([title isEqualToString:@"收货人:"]) {
        lblName.font = PingFangSCBOLD(SizeWidth(15));
    }else{
        lblName.font = PingFangSCMedium(26/2);
    }
    
    CGFloat width =  [lblName.text widthWithFont:lblName.font height:SizeHeight(25/2)];
    [lblName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(superView.mas_centerY);
        make.width.equalTo(@(width));
        make.height.equalTo(@(SizeHeight(25/2)));
        if (offset < 0) {
            make.right.equalTo(superView.mas_right).offset(offset);
        }else{
            make.left.equalTo(superView.mas_left).offset(SizeWidth(16));
            
        }
    }];
    
    return lblName;
}


-(UILabel *) addTitleLable:(NSString *) title withSuperView:(UIView *) superView {
    return [self addTitleLable:title withSuperView:superView withFontColor:RGBColorAlpha(51,51,51,1) rightOffSet:0];
}

-(UILabel *) addLabelTo:(UIView *) superView withLeftView:(UILabel *) leftView{
    
    UILabel *txt = [UILabel new];
    txt.textAlignment = NSTextAlignmentLeft;
    txt.textColor = RGBColorAlpha(51,51,51,1);

    if([leftView.text isEqualToString:@"收货人:"]){
        txt.font = PingFangSCBOLD(SizeWidth(15));
    }else{
        txt.font = PingFangSCMedium(SizeWidth(13));

    }
    
    [superView addSubview:txt];
    [txt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(leftView.mas_centerY);
        make.right.equalTo(superView.mas_right).offset(-SizeWidth(10));
        make.left.equalTo(leftView.mas_right).offset(SizeWidth(25/2));
        make.height.equalTo(@(SizeHeight(25/2)));
        if ([leftView.text isEqualToString:@"收货地址:"]) {
            make.height.equalTo(superView);
        }else{
            make.height.equalTo(@(SizeHeight(25/2)));
        }
    }];

    
    return txt;
}

-(void) addContentForDeliveryAddrees:(UITableViewCell *)cell withIndex:(NSInteger) index{
    if (cell.subviews.count >= 4) {
        return;
    }
    
    NSString *titile = @"";
    switch (index) {
        case 0:
            titile = @"收货人:";
            break;
        case 1:
            titile = @"联系电话:";
            break;
        case 2:
            titile = @"收货地址:";
            break;
        default:
            break;
    }
    
    UILabel *lblTitle = [self addTitleLable:titile withSuperView:cell];
  
        switch (index) {
            case 0:
                _lblName =  [self addLabelTo:cell withLeftView:lblTitle];
                break;
            case 1:
                _lblTelNo =  [self addLabelTo:cell withLeftView:lblTitle];
                break;
            case 2:
                _lblAddress =  [self addLabelTo:cell withLeftView:lblTitle];
                break;
            default:
                break;
        }
}

- (BOOL)textField:(UITextField *) textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSUInteger oldLength = [textField.text length];
    NSUInteger replacementLength = [string length];
    NSUInteger rangeLength = range.length;
    
    NSUInteger newLength = oldLength - rangeLength + replacementLength;
    
    BOOL returnKey = [string rangeOfString: @"\n"].location != NSNotFound;
    
    return newLength <= 11 || returnKey;
}

-(void) addGoodInfoTo:(UITableViewCell *)cell{
    _imgGoods = [UIImageView new];
    [cell addSubview:_imgGoods];
    
    [_imgGoods mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell.mas_left).offset(SizeWidth(32/2));
        make.top.equalTo(cell);
        make.width.equalTo(@(SizeWidth(144/2)));
        make.height.equalTo(@(SizeHeight(144/2)));
    }];
    
    _lblGoodsTitle = [[UILabel alloc] initWithFrame:CGRectMake(SizeWidth(207/2), SizeHeight(5), SizeWidth(506/2), SizeHeight(75))];
    _lblGoodsTitle.font = PingFangSCMedium(SizeWidth(15));
    _lblGoodsTitle.textColor = RGBColorAlpha(51,51,51,1);
    _lblGoodsTitle.textAlignment = NSTextAlignmentLeft;
    _lblGoodsTitle.text = @"智能锁 | 守护你的家庭安全";
    _lblGoodsTitle.numberOfLines = 2;
    _lblGoodsTitle.lineBreakMode = NSLineBreakByTruncatingTail;
    [cell addSubview:_lblGoodsTitle];
    [_lblGoodsTitle sizeToFit];
    
    [self addBorder:cell];
}

-(void) addNeedInstall:(UITableViewCell *)cell withIndex:(NSInteger) index{
    if (cell.subviews.count >= 4) {
        return;
    }
    NSString *title = @"需要上门安装";
    if (index==2) {
        title = @"增值服务";
    }else{
        [self addBorder:cell];
    }
    
    UILabel *lbl = [self addTitleLable:title withSuperView:cell];
    
    UIButton *btnTip = [UIButton new];
    [btnTip setImage:[UIImage imageNamed:@"qrdd_icon_zy"] forState:UIControlStateNormal];
    if (index == 2) {
        [btnTip addTarget:self action:@selector(tapServiceTipsButton) forControlEvents:UIControlEventTouchUpInside];
    }else{
        [btnTip addTarget:self action:@selector(tapInstallTipsButton) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [cell addSubview:btnTip];
    
    [btnTip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbl.mas_right).offset(SizeWidth(10));
        make.centerY.equalTo(lbl);
        make.width.equalTo(@(SizeWidth(32/2)));
        make.height.equalTo(@(SizeHeight(32/2)));
    }];
    
    UISwitch *sw = [UISwitch new];
    sw.on = _needInstall;
    [sw addTarget:self action:@selector(needInstall:) forControlEvents:UIControlEventValueChanged];
    [cell addSubview:sw];
    
    [sw mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(cell).offset(-SizeWidth(16));
        make.centerY.equalTo(lbl);
        make.width.equalTo(@(SizeWidth(102/2)));
        make.height.equalTo(@(SizeHeight(62/2)));
    }];
}

-(void) needInstall:(UISwitch *) sender{
    _needInstall = sender.on;
}

-(void) tapInstallTipsButton{
    if (_installPopup == nil) {
        _installPopup = [KLCPopup popupWithContentView:[self getContentForTips]];
        _installPopup.showType = KLCPopupShowTypeSlideInFromTop;
        _installPopup.dismissType = KLCPopupDismissTypeSlideOutToTop;
    }
    
    [_installPopup show];
}


-(void) tapServiceTipsButton{
    if (_serviceDescPopup == nil) {
        
        _serviceDescPopup = [KLCPopup popupWithContentView:[self getContentForTips]];
        _serviceDescPopup.showType = KLCPopupShowTypeSlideInFromTop;
        _serviceDescPopup.dismissType = KLCPopupDismissTypeSlideOutToTop;
    }
    
    [_serviceDescPopup show];
}

-(UIView *) getContentForTips{
    
    UIView *content = [self getContentWithSize:CGSizeMake( SizeWidth(686/2), SizeHeight(1082/2))];
    [self addCancelButtonTo:content];
    
    return content;
}

-(UIView *) getContentWithSize:(CGSize ) size{
    UIView* contentView = [[UIView alloc] init];
    contentView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    contentView.frame = CGRectMake(self.view.centerX, self.view.centerY, size.width, size.height);
    contentView.layer.cornerRadius = 5;
    
    return contentView;
}

-(void) addCostDetail:(UITableViewCell *)cell withIndex:(NSInteger) index{
    if (cell.subviews.count >= 4) {
        return;
    }
    
    NSString *title = @"";
    UIColor *fontColor = RGBColor(102, 102, 102);
    if (index == 0) {
        title =@"商品金额";
    }else if(index == 1){
        title =@"安装费";
    }else if(index == 2){
        title =@"增值服务";
    }else{
        title =@"分享立减";
    }
    
    [self addTitleLable:title withSuperView:cell withFontColor:fontColor rightOffSet:0];
    
    [self addTitleLable:@"￥1222" withSuperView:cell withFontColor:fontColor rightOffSet:SizeWidth(-32/1)];
}



-(void) addCancelButtonTo:(UIView *) sender{
    UIButton *btnClose = [UIButton new];
    [btnClose setTitleColor:RGBColor(51,51,51) forState:UIControlStateNormal];;
    btnClose.titleLabel.font = PingFangSCBOLD(SizeWidth(18));
    btnClose.titleLabel.textAlignment = NSTextAlignmentCenter;
    [btnClose setTitle:@"我知道了" forState:UIControlStateNormal];
    [btnClose addTarget:self action:@selector(dismissPopup) forControlEvents:UIControlEventTouchUpInside];
    [sender addSubview:btnClose];
    [btnClose mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(sender.mas_centerX);
        make.bottom.equalTo(sender.mas_bottom).offset(-SizeHeight(38/2));
        make.width.equalTo(@(SizeWidth(150/2)));
        make.height.equalTo(@(SizeHeight(34/2)));
    }];
}

-(void) dismissPopup{
    [KLCPopup dismissAllPopups];
}

-(void) showPayTypeView{
    
    if (_PayPopup == nil) {
        UIView *contentView = [self getContentWithSize:CGSizeMake(SizeWidth(686/2), SizeHeight(596/2))];
        
        UILabel *lblTitle = [UILabel new];
        lblTitle.font = PingFangSCBOLD(SizeWidth(15));
        lblTitle.textColor = RGBColor(51,51,51);
        lblTitle.textAlignment = NSTextAlignmentLeft;
        lblTitle.text = @"支付方式";
        [contentView addSubview:lblTitle];
        
        [lblTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(contentView.mas_left).offset(SizeWidth(41/2));
            make.top.equalTo(contentView.mas_top).offset(SizeHeight(85/2));
            make.width.equalTo(@(SizeWidth(200)));
            make.height.equalTo(@(SizeHeight(30/2)));
        }];
        
        _alView = [self addPayWayView:1 withTopView:lblTitle toSuperView:contentView];
        
        UIView *border = [UIView new];
        border.backgroundColor = RGBColorAlpha(224,224,224,1);
        [contentView addSubview:border];
        
        [border mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_alView.mas_bottom).offset(SizeHeight(25));
            make.left.equalTo(_alView.mas_left);
            make.right.equalTo(_alView.mas_right);
            make.height.equalTo(@(1));
        }];
        
        _wcView = [self addPayWayView:0 withTopView:border toSuperView:contentView];
        
        UIButton *btnClose = [UIButton new];
        [btnClose setTitleColor:RGBColor(51,51,51) forState:UIControlStateNormal];;
        btnClose.titleLabel.font = PingFangSCBOLD(SizeWidth(18));
        btnClose.titleLabel.textAlignment = NSTextAlignmentCenter;
        [btnClose setTitle:@"取消" forState:UIControlStateNormal];
        [btnClose addTarget:self action:@selector(dismissPopup) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:btnClose];
        [btnClose mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(contentView.mas_left).offset(SizeWidth(136/2));
            make.bottom.equalTo(contentView.mas_bottom).offset(-SizeHeight(30/2));
            make.width.equalTo(@(SizeWidth(70/2)));
            make.height.equalTo(@(SizeHeight(34/2)));
        }];
        
        UIButton *btnPay = [UIButton new];
        [btnPay setTitleColor:RGBColor(51,51,51) forState:UIControlStateNormal];;
        btnPay.titleLabel.font = PingFangSCBOLD(SizeWidth(18));
        btnPay.titleLabel.textAlignment = NSTextAlignmentCenter;
        [btnPay setTitle:@"立即支付" forState:UIControlStateNormal];
        [btnPay addTarget:self action:@selector(dismissPopup) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:btnPay];
        [btnPay mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(btnClose.mas_left).offset(SizeWidth(237/2));
            make.bottom.equalTo(btnClose.mas_bottom);
            make.width.equalTo(@(SizeWidth(150/2)));
            make.height.equalTo(@(SizeHeight(34/2)));
        }];
        
        UIView *border1 = [UIView new];
        border1.backgroundColor = RGBColorAlpha(224,224,224,1);
        [contentView addSubview:border1];
        
        [border1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(btnPay.mas_top).offset(-SizeHeight(13/2));
            make.left.equalTo(contentView.mas_left);
            make.right.equalTo(contentView.mas_right);
            make.height.equalTo(@(1));
        }];
        
        _PayPopup = [KLCPopup popupWithContentView:contentView];
        _PayPopup.showType = KLCPopupShowTypeSlideInFromTop;
        _PayPopup.dismissType = KLCPopupDismissTypeSlideOutToTop;
    }
    
    [_PayPopup show];
}

-(UIView *) addPayWayView:(int) type withTopView:(UIView *) topView toSuperView:(UIView *) superView{
    UIView *content = [UIView new];
    content.tag = type;
    content.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPayWay:)];
    [content addGestureRecognizer:tap];
    
    [superView addSubview:content];
    [content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_bottom).offset(SizeHeight(25));
        make.left.equalTo(superView.mas_left).offset(SizeWidth(20));
        make.right.equalTo(superView.mas_right).offset(-SizeWidth(20));
        make.height.equalTo(@(SizeHeight(25)));
    }];
    
    UIImageView *img = [UIImageView new];
    NSString *title = @"支付宝支付";
    if (type == 0) {
        img.image = [UIImage imageNamed:@"zf_icon_wx"];
        title = @"微信支付";
    }else{
        img.image = [UIImage imageNamed:@"zf_icon_zfb"];
    }
    [content addSubview:img];
    
    [img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(content);
        make.left.equalTo(content);
        make.width.equalTo(@(SizeWidth(56/2)));
        make.height.equalTo(@(SizeHeight(46/2)));
    }];
    
    UILabel *lblTitle = [UILabel new];
    lblTitle.font = PingFangSCMedium(SizeWidth(13));
    lblTitle.textColor = RGBColor(51,51,51);
    lblTitle.textAlignment = NSTextAlignmentLeft;
    lblTitle.text = title;
    [content addSubview:lblTitle];
    
    [lblTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(img.mas_right).offset(SizeWidth(7));
        make.centerY.equalTo(img.mas_centerY);
        make.width.equalTo(@(SizeWidth(100)));
        make.height.equalTo(@(SizeHeight(26)));
    }];
    
    UIImageView *payimg = [UIImageView new];
    payimg.tag = CBX_PAY_TAG;
    if (type == 0) {
        payimg.image = [UIImage imageNamed:@"icon_xz"];
    }else{
        payimg.image = [UIImage imageNamed:@"icon_xz_pre"];
    }
    
    [content addSubview:payimg];
    
    [payimg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(content);
        make.right.equalTo(content);
        make.width.equalTo(@(SizeWidth(32/2)));
        make.height.equalTo(@(SizeHeight(32/2)));
    }];
    
    return content;
}

-(void) tapPayWay:(UITapGestureRecognizer *) guesture{
    UIView *sender = guesture.view;
    UIImageView *alImgView = (UIImageView *)[_alView viewWithTag:CBX_PAY_TAG];
    UIImageView *wcImgView = (UIImageView *)[_wcView viewWithTag:CBX_PAY_TAG];
    
    if((sender.tag == 0 && _isWechatPay )||(sender.tag == 1 && !_isWechatPay)){
        return;
    }else if(sender.tag == 0 && !_isWechatPay){
        alImgView.image = [UIImage imageNamed:@"icon_xz"];
        wcImgView.image = [UIImage imageNamed:@"icon_xz_pre"];
        _isWechatPay = YES;
    }else{
        alImgView.image = [UIImage imageNamed:@"icon_xz_pre"];
        wcImgView.image = [UIImage imageNamed:@"icon_xz"];
        _isWechatPay = NO;
    }
}
@end
