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
#import "OrderModel.h"
#import "NetworkHelper.h"
#import "RegionModel.h"
#import "MallViewController.h"
#import "InstallSummeryView.h"

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
@property (nonatomic, retain) UILabel *lblAddedService;
@property (nonatomic, retain) UILabel *lblExpressStatus;
@property(retain,atomic) UILabel *lblName;
@property(retain,atomic) UILabel *lblTelNo;
@property(retain,atomic) UILabel *lblExpressNo;
@property(retain,atomic) UILabel *lblExpressComponyName;
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
@property(retain,atomic) UILabel* lblNeedInstall;
@property(retain,atomic) UILabel* lblOrder;
@property(retain,atomic) UILabel* lblPayWay;
@property(retain,atomic) UILabel* lblOrderDate;
@property(retain,atomic) UILabel* lblOrderNo;
@property(retain,atomic) UIView *footer;
@property(retain,atomic) UILabel* lblConfirmReceiveDate;
@property(retain,atomic) UIButton* btnCancelOrder;
@property(retain,atomic) OrderModel* order;
@property(retain,atomic)  UIWebView *serviceWebView;
@property(assign,atomic)  int countOfUpdateDate;
@property(assign,atomic)  int countOfFee;
@property (atomic, retain) KLCPopup *confirmPopup;
@property(retain,atomic)  NSArray *requireInstall;
@property(retain,atomic)  NSArray *unReqiureInstall;
@end

@implementation OrderDetailViewController
-(void) setOrderId:(NSString *)orderId{
    _orderId = orderId;
    [self loadData];
}

-(void) loadData{
    [NetworkHelper getInstallCallBack:^(NSString *error, NSArray *requireInstall, NSArray *unReqiureInstall) {
        _requireInstall = requireInstall;
        _unReqiureInstall = unReqiureInstall;
    }];
    
    [NetworkHelper getOrderDetailWithId:_orderId WithCallBack:^(NSString *error, OrderModel *order) {
        _order = order;

        if ([order.wuliu_type isEqualToString:@"0"] && (order.status == OrderStatus_complete || _order.status == OrderStatus_hasSend)) {
            _numberOfSection = 5;
        }
        
        if (_order.status == OrderStatus_waitingPay || _order.status == OrderStatus_Cancel) {
            _countOfFee = 1;
        }else{
            _countOfFee = 2;
        }
        
        if (order.status == OrderStatus_complete) {
             _countOfUpdateDate = 4;
        }
        
        if(order.install_fee.floatValue > 0){
            _countOfFee += 1;
        }
        
        if (order.added_fee.floatValue > 0) {
            _countOfFee += 1;
        }
        
        if (order.discount_amount.floatValue > 0) {
            _countOfFee += 1;
        }
        
        [self addTableView];
        if (_footer != nil) {
            [_footer removeFromSuperview];
            _footer = nil;
        }
        if (_order.added_fee.floatValue > 0) {
            if (_order.status != OrderStatus_RefundComplete) {
                [self addFooter];
                if (_order.status == OrderStatus_hasSend ) {
                    [self addRefundTips];
                }else{
                    [self addServiceLayer];
                }
            }else{
                _tb.frame = CGRectMake(0, SizeHeight(64), kScreenW, kScreenH - SizeHeight(64));
            }
          
        }else{
            if (_order.status != OrderStatus_waitingPay) {
                _btnCancelOrder.hidden = YES;
            }
            if (_order.status == OrderStatus_waitingPay || _order.status == OrderStatus_hasSend) {
                [self addFooter];
            }else{
                _tb.frame = CGRectMake(0, SizeHeight(64), kScreenW, kScreenH - SizeHeight(64));
            }
        }
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _countOfUpdateDate = 3;
    _countOfFee = 1;
    
    _needInstall = YES;
    [self resetFather];
    _numberOfSection = 4;
    self.automaticallyAdjustsScrollViewInsets = NO;
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(completePay) name:@"completePay" object:nil];
}

-(void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [NSNotificationCenter.defaultCenter removeObserver:self name:@"completePay" object:nil];
}

-(void) completePay{
    [self loadData];
}

- (void)back:(UIButton *)sender {
    if (self.fromBuy) {
        for (UIViewController *vc in self.navigationController.viewControllers) {
            if ([vc isKindOfClass:[MallViewController class]]) {
                [self.navigationController popToViewController:vc animated:YES];
                return;
            }
        }
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void) ShowHeader{
//    if (_imgStatus == nil) {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, SizeHeight(140))];
        headerView.backgroundColor = [UIColor whiteColor];
        _imgStatus = [UIImageView new];
        [headerView addSubview:_imgStatus];
        
        [_imgStatus mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(headerView);
            make.top.equalTo(headerView).offset(SizeHeight(52/2));
            make.width.equalTo(@(SizeWidth(44)));
            make.height.equalTo(@(SizeHeight(56.2/2)));
        }];
        
        _lblStatus = [UILabel new];
        _lblStatus.font = PingFangSCBOLD(SizeWidth(15));
        _lblStatus.textColor = RGBColor(51,51,51);
        _lblStatus.textAlignment = NSTextAlignmentCenter;
        [headerView addSubview:_lblStatus];
        
        [_lblStatus mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_imgStatus.mas_centerX);
            make.top.equalTo(_imgStatus.mas_bottom).offset(SizeHeight(15));
            make.width.equalTo(headerView);
            make.height.equalTo(@(SizeHeight(18)));
        }];
        [self addBorder:headerView];
        _tb.tableHeaderView  = headerView;
//    }
  
    _imgStatus.image = [UIImage imageNamed:@"ddxq_icon_yfh"];
    _lblStatus.text = [self getStatusString:_order.status];

}

- (void)resetFather {
    self.line.hidden = YES;
    self.titleLab.text = @"订单详情";
    [self.rightBar setTitle:@"客服" forState:UIControlStateNormal];
     [self.rightBar setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
}

- (void)more:(UIButton *)sender {
    NSMutableString* str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",[ConfigModel getStringforKey:@"phone"]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

-(void) addTableView{
    if(_tb != nil){
        [_tb removeFromSuperview];
        _tb = nil;
    }
    _tb = [[UITableView alloc] initWithFrame:CGRectMake(0, SizeHeight(64), kScreenW, kScreenH - SizeHeight(64)- SizeHeight(55)) style:UITableViewStyleGrouped];
    _tb.backgroundColor = RGBColorAlpha(224,224,224,1);
    _tb.backgroundColor = RGBColor(239, 240, 241);
    _tb.delegate = self;
    _tb.dataSource = self;
    [_tb registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
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
    _footer = [UIView new];
    _footer.backgroundColor = RGBColorAlpha(255,255,255,1);
    [self.view addSubview:_footer];
    
    [_footer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view);
        make.height.equalTo(@(SizeHeight(110/2)));
        make.bottom.equalTo(self.view);
        make.left.equalTo(self.view);
    }];
    
    if (_order.status == OrderStatus_waitingRefund) {
        return;
    }
    
    UIButton *btnSubmit = [UIButton new];
    [btnSubmit addTarget:self action:@selector(tapSubmitButton) forControlEvents:UIControlEventTouchUpInside];

    btnSubmit.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_footer addSubview:btnSubmit];
    
    [btnSubmit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_footer.mas_right).offset(SizeWidth(-32/2));
        make.centerY.equalTo(_footer.mas_centerY);
        make.width.equalTo(@(SizeWidth(186/2)));
        make.height.equalTo(@(SizeHeight(66/2)));
    }];
    
    
    UIFont *font = PingFangSC(SizeWidth(15));
    UIColor *backgroundColor = RGBColorAlpha(248,179,23,1);
    UIColor *titleColor = RGBColorAlpha(255,255,255,1);
    NSString *title = @"立即支付";
    
    if (_order.status == OrderStatus_waitingPay) {
        UILabel *lblTitle = [UILabel new];
        lblTitle.font = PingFangSCMedium(SizeWidth(13));
        lblTitle.textColor = RGBColorAlpha(51,51,51,1);
        lblTitle.textAlignment = NSTextAlignmentLeft;
        lblTitle.text = @"总计";
        [_footer addSubview:lblTitle];
        
        [lblTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_footer.mas_left).offset(SizeWidth(32/2));
            make.centerY.equalTo(_footer.mas_centerY);
            make.width.equalTo(@(SizeWidth(55/2)));
            make.height.equalTo(@(SizeHeight(25/2)));
        }];
        
        _lblAmount = [UILabel new];
        _lblAmount.font = PingFangSC(SizeWidth(15));
        _lblAmount.textColor = RGBColorAlpha(248,179,23,1);
        _lblAmount.textAlignment = NSTextAlignmentLeft;
        _lblAmount.text = [NSString stringWithFormat:@"￥%@", _order.order_amount];
        [_footer addSubview:_lblAmount];
        
        [_lblAmount mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lblTitle.mas_right).offset(SizeWidth(16/2));
            make.centerY.equalTo(_footer.mas_centerY);
            make.width.equalTo(@(SizeWidth(200)));
            make.height.equalTo(@(SizeHeight(28/2)));
        }];

    }else{
        title = @"确认收货";

        if (_order.status == OrderStatus_padyed || _order.status == OrderStatus_complete) {
            title = @"退款";
        }
        font = PingFangSCMedium(SizeWidth(13));
        backgroundColor = [UIColor whiteColor];
        titleColor = RGBColor(51,51,51);
        btnSubmit.layer.borderColor = RGBColor(51,51,51).CGColor;
        btnSubmit.layer.borderWidth = 1;
        btnSubmit.layer.cornerRadius = 2;
    }
    
    btnSubmit.titleLabel.font = font;
    btnSubmit.backgroundColor = backgroundColor;
    [btnSubmit setTitleColor:titleColor forState:UIControlStateNormal];
    [btnSubmit setTitle:title forState:UIControlStateNormal];
}

-(void) tapSubmitButton{
    if (_order.status == OrderStatus_waitingPay) {
        [NetworkHelper pay:_order.order_id];
        
    }else if (_order.status == OrderStatus_hasSend) {
        [self showConfirmView:@"确认已经收到货了吗？" withLeftTitle:@"取消" withRightTitle:@"确认"];
  
    }else{
        if (_installPopup == nil) {
            _installPopup = [KLCPopup popupWithContentView:[self getContentForTuiKuanTips]];
            _installPopup.showType = KLCPopupShowTypeSlideInFromTop;
            _installPopup.dismissType = KLCPopupDismissTypeSlideOutToTop;
        }
        
        [_installPopup show];
    }
}

-(void) updateOrder:(NSString *) status{
    [ConfigModel showHud:self];

    [NetworkHelper modifyOrderWithOrderId:_order.order_id withStatus:status WithCallBack:^(NSString *error, NSString *msg) {
        [ConfigModel hideHud:self];
        
        if (error == nil) {
            [self loadData];
            [ConfigModel mbProgressHUD:msg andView:self.view];
        }else{
            [ConfigModel mbProgressHUD:error andView:self.view];
        }
        
        [KLCPopup dismissAllPopups];
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _numberOfSection;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    int number = 0;
    int baseIndex = 0;
    if (_numberOfSection == 5) {
        baseIndex+=1;
        if (section == 0) {
            return 3;
        }
    }
    if (section == baseIndex) {
        number = 3;
    }else if (section == baseIndex + 1) {
        number = 2;
    }else if (section == baseIndex + 2) {
        number = _countOfFee;
    }
    else if (section == baseIndex + 3) {
        number = _countOfUpdateDate;
    }
    
    return number;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSString *cellId = [NSString stringWithFormat:@"%ld%ld", (long)indexPath.section, (long)indexPath.row];
    UITableViewCell         *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];

//    if (!cell) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
//    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    int baseIndex = 0;
    
    if (_numberOfSection == 5) {
        baseIndex += 1;
        if (indexPath.section == 0) {
            [self addContentForExpress:cell withIndex:indexPath.row];
            return cell;
        }
    }
   
    if (indexPath.section == baseIndex ) {
        [self addContentForDeliveryAddrees:cell withIndex:indexPath.row];
    }else if(indexPath.section == baseIndex + 1){
        if (indexPath.row == 0) {
            [self addGoodInfoTo:cell];
        }else{
            [self addNeedInstall:cell withIndex:indexPath.row];
        }
    }else if(indexPath.section == baseIndex +2){
        [self addCostDetail:cell withIndex:indexPath.row];
    }else if (indexPath.section == baseIndex+3){
        [self addOrderDetail:cell withIndex:indexPath.row];
    }
    
    return cell;
}

#pragma mark - UITableDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = SizeHeight(35);
    int baseIndex = 0;
    if (_numberOfSection == 5) {
        baseIndex += 1;
        if (indexPath.section == 0) {
            if (indexPath.row == 2) {
                return SizeHeight(40);
            }
            return  height;
        }
    }
    
    if (indexPath.section == baseIndex && indexPath.row == 2) {
        return SizeHeight(40);
    }else if (indexPath.section == baseIndex + 2) {
        if (indexPath.row == 2) {
            height = SizeHeight(50);
        }
    }else if (indexPath.section == baseIndex + 1){
        if (indexPath.row == 0) {
            height = SizeHeight(166/2);
        }else{
            height = SizeHeight(130/2);
        }
    }
    
    return height;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:FRAME(0, 0, kScreenW, SizeHeight(45))];
    view.backgroundColor = [UIColor whiteColor];
    NSString *title = @"";
//    switch (section) {
//
//        case 1:
//            title = @"商品信息";
//            break;
//        case 2:
//            title = @"费用明细";
//            break;
//        default:
//            break;
//    }
    
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
    
    if (offset < 0) {
        lblName.textAlignment = NSTextAlignmentRight;
    }
    
    return lblName;
}


-(UILabel *) addTitleLable:(NSString *) title withSuperView:(UIView *) superView {
    return [self addTitleLable:title withSuperView:superView withFontColor:RGBColorAlpha(51,51,51,1) rightOffSet:0];
}

-(UILabel *) addLabelTo:(UIView *) superView withLeftView:(UILabel *) leftView{
    
    UILabel *lbl = [UILabel new];
    lbl.textAlignment = NSTextAlignmentLeft;
    lbl.textColor = RGBColorAlpha(51,51,51,1);

    if (leftView != nil) {
        if([leftView.text isEqualToString:@"收货人:"]){
            lbl.font = PingFangSCBOLD(SizeWidth(15));
        }else{
            lbl.font = PingFangSCMedium(SizeWidth(13));
        }
        
        if ([leftView.text isEqualToString:@"收货地址:"]) {
            lbl.numberOfLines = 2;
        }
    }
   
    
    [superView addSubview:lbl];
    [lbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(superView.mas_centerY);
        make.right.equalTo(superView.mas_right).offset(-SizeWidth(10));
        if (leftView == nil) {
            make.left.equalTo(superView.mas_left).offset(SizeWidth(25/2));
        }else{
            make.left.equalTo(leftView.mas_right).offset(SizeWidth(0));
        }
        if (leftView != nil && [leftView.text isEqualToString:@"收货地址:"]) {
            make.height.equalTo(superView);
        }else{
            make.height.equalTo(@(SizeHeight(25/2)));
        }
    }];

    
    return lbl;
}

-(UILabel *) addExpressInfoLabelTo:(UIView *) superView{
    
    UILabel *lbl = [UILabel new];
    lbl.textAlignment = NSTextAlignmentLeft;
    lbl.textColor = RGBColorAlpha(51,51,51,1);
        lbl.font = PingFangSCBOLD(SizeWidth(15));
    
    [superView addSubview:lbl];
    [lbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superView).offset(SizeHeight(20));
        make.left.equalTo(superView).offset(SizeWidth(32/2));
        make.right.equalTo(superView).offset(-SizeWidth(32/2));
        make.height.equalTo(@(SizeHeight(25/2)));
    }];
    
    
    return lbl;
}

-(void) addContentForExpress:(UITableViewCell *)cell withIndex:(NSInteger) index{
    UILabel *lblTitle = [cell viewWithTag:401];
    
    switch (index) {
        case 0:
           
            break;
        case 1:
            lblTitle = [self addTitleLable:@"快递公司:" withSuperView:cell];;
            break;
        case 2:
            lblTitle = [self addTitleLable:@"快递单号:" withSuperView:cell];
            break;
        default:
            break;
    }
    
    lblTitle.tag = 401;
    switch (index) {
        case 0:
            _lblExpressStatus = [self addLabelTo:cell withLeftView:nil];
            _lblExpressStatus.font = PingFangSCBOLD(SizeWidth(15));
            _lblExpressStatus.text = _order.express_status;
            break;
        case 1:
            _lblExpressComponyName =  [self addLabelTo:cell withLeftView:lblTitle];
            _lblExpressComponyName.text =  _order.express_name;
            break;
        case 2:
            _lblExpressNo =  [self addLabelTo:cell withLeftView:lblTitle];
            _lblExpressNo.text = _order.express_no;
            break;
        default:
            break;
    }
}


-(void) addContentForDeliveryAddrees:(UITableViewCell *)cell withIndex:(NSInteger) index{
    UILabel *lblTitle = [cell viewWithTag:401];
   
    
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
    
    lblTitle = [self addTitleLable:titile withSuperView:cell];
    lblTitle.tag = 401;
        switch (index) {
            case 0:
                _lblName =  [self addLabelTo:cell withLeftView:lblTitle];
                _lblName.text = _order.consignee;
                break;
            case 1:
                _lblTelNo =  [self addLabelTo:cell withLeftView:lblTitle];
                _lblTelNo.text = _order.phone;
                break;
            case 2:{
                _lblAddress =  [self addLabelTo:cell withLeftView:lblTitle];
                NSString *strProvince = [RegionModel getRegionName:_order.province];
                NSString *strCity = [RegionModel getRegionName:_order.city];
                NSString *strCounty = [RegionModel getRegionName:_order.county];
                _lblAddress.text = [NSString stringWithFormat:@"%@%@%@%@",strProvince,strCity,strCounty,_order.address];
            }
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
    [_imgGoods sd_setImageWithURL:[NSURL URLWithString:_order.head_img]];
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
    _lblGoodsTitle.text = _order.goods_name;
    _lblGoodsTitle.numberOfLines = 2;
    _lblGoodsTitle.lineBreakMode = NSLineBreakByTruncatingTail;
    [cell addSubview:_lblGoodsTitle];
    [_lblGoodsTitle sizeToFit];
    
    [self addBorder:cell];
}

-(void) addNeedInstall:(UITableViewCell *)cell withIndex:(NSInteger) index{
    UILabel *lblTitle = [cell viewWithTag:301];
    
    NSString *title = @"是否需要上门安装";
    if (index==2) {
        title = @"增值服务";
    }else{
        [self addBorder:cell];
    }
    
    lblTitle = [self addTitleLable:title withSuperView:cell];
    lblTitle.tag = 301;
    _lblNeedInstall = [UILabel new];
    _lblNeedInstall.textAlignment = NSTextAlignmentRight;
    _lblNeedInstall.textColor = RGBColorAlpha(51,51,51,1);
   _lblNeedInstall.font = PingFangSCMedium(SizeWidth(13));
    _lblNeedInstall.text = _order.is_install == 0? @"无需上门安装":@"需要上门安装";
    
   
    if (index == 1 &&_order.status == OrderStatus_waitingPay) {
        UIButton *btnTip = [UIButton new];
        [btnTip setImage:[UIImage imageNamed:@"qrdd_icon_zy"] forState:UIControlStateNormal];
        [btnTip addTarget:self action:@selector(tapInstallTipsButton) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:btnTip];
        
        [btnTip mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lblTitle.mas_right).offset(SizeWidth(10));
            make.centerY.equalTo(lblTitle);
            make.width.equalTo(@(SizeWidth(32/2)));
            make.height.equalTo(@(SizeHeight(32/2)));
        }];
    }
    
   
    
    [cell addSubview:_lblNeedInstall];
    [_lblNeedInstall mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(lblTitle.mas_centerY);
        make.right.equalTo(cell.mas_right).offset(-SizeWidth(10));
        make.left.equalTo(lblTitle.mas_right).offset(SizeWidth(25/2));
        make.height.equalTo(@(SizeHeight(25/2)));
            make.height.equalTo(@(SizeHeight(25/2)));
    }];
}

-(void) needInstall:(UISwitch *) sender{
    _needInstall = sender.on;
}

-(void) tapInstallTipsButton{
    if (_installPopup == nil) {
        UIView *content = [self getContentForTips];
        InstallSummeryView *_installSummeryView= [InstallSummeryView new];
        _installSummeryView.require = _requireInstall;
        _installSummeryView.unRequire = _unReqiureInstall;
        [content addSubview:_installSummeryView];
        [_installSummeryView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(content);
            make.right.equalTo(content);
            make.top.equalTo(content);
            make.bottom.equalTo(content).offset(-SizeHeight(100/2));
        }];
        
        _installPopup = [KLCPopup popupWithContentView:content];
        _installPopup.showType = KLCPopupShowTypeSlideInFromTop;
        _installPopup.dismissType = KLCPopupDismissTypeSlideOutToTop;
        [_installSummeryView loadData];
    }
    
    [_installPopup show];
}


-(void) tapServiceTipsButton{
    if (_serviceDescPopup == nil) {
        UIView *content = [self getContentForTips];
        UILabel *lblTitle = [UILabel new];
        lblTitle.font = PingFangSCBOLD(SizeWidth(15));
        lblTitle.textColor = RGBColor(51,51,51);
        lblTitle.textAlignment = NSTextAlignmentCenter;
        lblTitle.text = @"增值服务说明";
        [content addSubview:lblTitle];
        
        [lblTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(content);
            make.top.equalTo(content).offset(SizeHeight(23));
            make.width.equalTo(content);
            make.height.equalTo(@(SizeHeight(17)));
        }];
        
        _serviceWebView= [UIWebView new];
        _serviceWebView.backgroundColor = [UIColor clearColor];
        _serviceWebView.opaque = NO;
        [content addSubview:_serviceWebView];
        [_serviceWebView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(content).offset(SizeWidth(15));
            make.right.equalTo(content).offset(-SizeWidth(15));
            make.top.equalTo(lblTitle.mas_bottom).offset(SizeHeight(20));
            make.bottom.equalTo(content).offset(-SizeHeight(100/2));
        }];
        
        _serviceDescPopup = [KLCPopup popupWithContentView:content];
        _serviceDescPopup.showType = KLCPopupShowTypeSlideInFromTop;
        _serviceDescPopup.dismissType = KLCPopupDismissTypeSlideOutToTop;
    
    }
    
    [_serviceDescPopup show];
    [ConfigModel showHud:self];
    [NetworkHelper getAddServiceCallBack:^(NSString *error, NSString *addedValueService) {
        [ConfigModel hideHud:self];
        [_serviceWebView loadHTMLString:addedValueService baseURL:nil];
    }];
}

//- (void)webViewDidFinishLoad:(UIWebView *)webView {
//    for (UIView *_aView in [_serviceWebView subviews])
//    {
//        if ([_aView isKindOfClass:[UIScrollView class]])
//        {
//            [(UIScrollView *)_aView setShowsVerticalScrollIndicator:NO];
//            //右侧的滚动条
//            
//            [(UIScrollView *)_aView setShowsHorizontalScrollIndicator:NO];
//            //下侧的滚动条
//            
//            for (UIView *_inScrollview in _aView.subviews)
//            {
//                _inScrollview.backgroundColor = [UIColor whiteColor];
//                if ([_inScrollview isKindOfClass:[UIImageView class]])
//                {
//                    _inScrollview.hidden = YES;  //上下滚动出边界时的黑色的图片
//                }
//            }
//        }
//    }
//}


-(UIView *) getContentForTips{
    
    UIView *content = [self getContentWithSize:CGSizeMake( SizeWidth(686/2), SizeHeight(1082/2))];
    [self addCancelButtonTo:content];
    
    return content;
}

-(UIView *) getContentForTuiKuanTips{
    
    UIView *contentView = [self getContentWithSize:CGSizeMake( SizeWidth(686/2), SizeHeight(1082/2))];
    
    UILabel *lblTitle = [UILabel new];
    lblTitle.font = PingFangSCBOLD(SizeWidth(15));
    lblTitle.textColor = RGBColor(51,51,51);
    lblTitle.textAlignment = NSTextAlignmentCenter;
    lblTitle.text = @"退款规则";
    [contentView addSubview:lblTitle];
    
    [lblTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(contentView);
        make.top.equalTo(contentView).offset(SizeHeight(23));
        make.width.equalTo(contentView);
        make.height.equalTo(@(SizeHeight(17)));
    }];
    
    UIButton *btnTuikuan = [UIButton new];
//    btnTuikuan.backgroundColor = RGBColor(241,242,242);
    [btnTuikuan setTitleColor:RGBColor(51,51,51) forState:UIControlStateNormal];;
    btnTuikuan.titleLabel.font = PingFangSCBOLD(SizeWidth(18));
    btnTuikuan.titleLabel.textAlignment = NSTextAlignmentCenter;
    btnTuikuan.layer.cornerRadius = SizeWidth(5);
    [btnTuikuan setTitle:@"退款" forState:UIControlStateNormal];
        [btnTuikuan addTarget:self action:@selector(tapPopoverOkButton) forControlEvents:UIControlEventTouchUpInside];
    
    [contentView addSubview:btnTuikuan];
    [btnTuikuan mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView.mas_left).offset(SizeWidth(40/2));
        make.bottom.equalTo(contentView.mas_bottom).offset(-SizeHeight(30/2));
        make.width.equalTo(@(SizeWidth(289/2)));
        make.height.equalTo(@(SizeHeight(88/2)));
    }];
    
    UIButton *btnCancel = [UIButton new];
    [btnCancel setTitleColor:RGBColor(51,51,51) forState:UIControlStateNormal];;
    btnCancel.titleLabel.font = btnTuikuan.titleLabel.font;
    btnCancel.titleLabel.textAlignment = NSTextAlignmentCenter;
    [btnCancel setTitle:@"取消" forState:UIControlStateNormal];
    btnCancel.layer.cornerRadius = SizeWidth(5);
//    btnCancel.backgroundColor = RGBColor(99,142,220);
   
        [btnCancel addTarget:self action:@selector(dismissPopup) forControlEvents:UIControlEventTouchUpInside];
        
    [contentView addSubview:btnCancel];
    
    [btnCancel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(btnTuikuan.mas_right).offset(SizeWidth(34/2));
        make.bottom.equalTo(btnTuikuan.mas_bottom);
        make.width.equalTo(btnTuikuan);
        make.height.equalTo(btnTuikuan);
    }];
    
    UIWebView *webView = [UIWebView new];
    webView.opaque = NO;

    [contentView addSubview:webView];
    
    [webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView).offset(SizeWidth(15));
        make.right.equalTo(contentView).offset(-SizeWidth(15));
        make.top.equalTo(lblTitle.mas_bottom).offset(SizeHeight(20));
        make.bottom.equalTo(contentView).offset(-SizeHeight(100/2));
    }];
    
    [ConfigModel showHud:self];
    [NetworkHelper getRefundCallBack:^(NSString *error, NSString *addedValueService) {
        [ConfigModel hideHud:self];
        if (error == nil) {
            [webView loadHTMLString:addedValueService baseURL:nil];
        }
    }];
    return contentView;
}


-(UIView *) getContentWithSize:(CGSize ) size{
    UIView* contentView = [[UIView alloc] init];
    contentView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    contentView.frame = CGRectMake(self.view.centerX, self.view.centerY, size.width, size.height);
    contentView.layer.cornerRadius = 5;
    
    return contentView;
}

-(void) addCostDetail:(UITableViewCell *)cell withIndex:(NSInteger) index{
    UILabel *lblTitle = [cell viewWithTag:201 + index];
  
    
    NSString *title = @"";
    NSString *price = @"";
    UIColor *fontColor = RGBColor(102, 102, 102);
    if (index == 0) {
        title =@"商品金额";
        price = [NSString stringWithFormat:@"￥%@",_order.goods_price];
        _lblGooodsPrice = [self addTitleLable:price withSuperView:cell withFontColor:fontColor rightOffSet:SizeWidth(-10)];
    }else if(index == 1 && _order.install_fee.floatValue > 0){
        title =@"安装费";
        price = [NSString stringWithFormat:@"+￥%@",_order.install_fee];

          _lblInstallPrice = [self addTitleLable:price withSuperView:cell withFontColor:fontColor rightOffSet:SizeWidth(-10)];
    }else if((index == 1 && _order.added_fee.floatValue > 0 && _order.install_fee.floatValue <= 0) || (index == 2 && _order.added_fee.floatValue > 0 && _order.install_fee.floatValue > 0)){
        title =@"增值服务";
        price = [NSString stringWithFormat:@"+￥%@",_order.added_fee];

          _lblAddedService = [self addTitleLable:price withSuperView:cell withFontColor:fontColor rightOffSet:SizeWidth(-10)];
    }else if(_order.discount_amount.floatValue > 0 && ((_order.added_fee.floatValue > 0 && _order.install_fee.floatValue > 0 && index == 3) ||((_order.added_fee.floatValue > 0 || _order.install_fee.floatValue > 0) && index == 2)|| index == 1)){
        title =@"分享立减";
        price = [NSString stringWithFormat:@"-￥%@",_order.discount_amount];

          _lblCoupon = [self addTitleLable:price withSuperView:cell withFontColor:fontColor rightOffSet:SizeWidth(-10)];
    }else if(_order.status != OrderStatus_waitingPay){
        title =@"实付款";
        price = [NSString stringWithFormat:@"￥%@",_order.order_amount];

         [self addTitleLable:price withSuperView:cell withFontColor:fontColor rightOffSet:SizeWidth(-10)];
    }
    
    if ([title isEqualToString:@""]) {
        return;
    }
    lblTitle = [self addTitleLable:title withSuperView:cell withFontColor:fontColor rightOffSet:0];
    lblTitle.tag = 201;
   
}

-(void) addOrderDetail:(UITableViewCell *)cell withIndex:(NSInteger) index{
    UILabel *lbl = [cell viewWithTag:101];
  
    NSString *title = @"";
    UIColor *fontColor = RGBColor(153,153,153);
    if (index == 0) {
            title =@"订单编号:";
            UILabel *lbl =  [self addTitleLable:title withSuperView:cell withFontColor:fontColor rightOffSet:0];
            lbl.tag = 101;
            
            UILabel *txt = [self addLabelTo:cell withLeftView:lbl];
            txt.textColor = RGBColor(153,153,153);
            txt.text = _order.order_sn;
            [self addBtnCancelOrderTo:cell];
    }else if(index == 1){
        title =@"支付方式:";
        if(lbl == nil || _lblPayWay == nil){
            lbl =  [self addTitleLable:title withSuperView:cell withFontColor:fontColor rightOffSet:0];
            _lblPayWay = [self addLabelTo:cell withLeftView:lbl];
            _lblPayWay.textColor = RGBColor(153,153,153);
            _lblPayWay.text = _order.pay_type == 0 ? @"支付宝支付":@"微信支付";
        }
    }else if(index == 2){
        title =@"下单时间:";
        UILabel *lbl =  [self addTitleLable:title withSuperView:cell withFontColor:fontColor rightOffSet:0];
        lbl.tag = 101;

        _lblOrderDate = [self addLabelTo:cell withLeftView:lbl];
        _lblOrderDate.textColor = RGBColor(153,153,153);
        _lblOrderDate.text = _order.create_time;
    }else{
        title =@"确认收货时间:";
        UILabel *lbl =  [self addTitleLable:title withSuperView:cell withFontColor:fontColor rightOffSet:0];
        lbl.tag = 101;
        _lblConfirmReceiveDate = [self addLabelTo:cell withLeftView:lbl];
        _lblConfirmReceiveDate.textColor = RGBColor(153,153,153);
        _lblConfirmReceiveDate.text = _order.update_time;
    }
}

-(void) addBtnCancelOrderTo:(UITableViewCell *) cell{
    if (_order.status != OrderStatus_waitingPay) {
        return;
    }
    if (_btnCancelOrder!= nil) {
        [_btnCancelOrder removeFromSuperview];
        _btnCancelOrder = nil;
    }
   
    _btnCancelOrder = [UIButton new];
    [_btnCancelOrder setTitle:@"取消订单" forState:UIControlStateNormal];
    [_btnCancelOrder setTitleColor:RGBColor(51,51,51) forState:UIControlStateNormal];
    _btnCancelOrder.titleLabel.font = PingFangSCBOLD(SizeWidth(13));
    [cell addSubview:_btnCancelOrder];
    
    [_btnCancelOrder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(SizeHeight(27/2)));
        make.width.equalTo(@(SizeWidth(140/2)));
        make.right.equalTo(cell).offset(-SizeWidth(33/2));
        make.top.equalTo(cell).offset(SizeHeight(29/2));
    }];
    
    [_btnCancelOrder addTarget:self action:@selector(tapCancelOrderButton) forControlEvents:UIControlEventTouchUpInside];
}

-(void) tapCancelOrderButton{
    [self showConfirmView:@"确定取消该订单吗？" withLeftTitle:@"确认取消" withRightTitle:@"暂不取消"];
}

-(NSString *) getOrderIdText:(NSString *) orderId{
    return [NSString stringWithFormat:@"订单编号:  %@",orderId];
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

-(void) addRefundTips{
    UIView *layer = [UIView new];
    layer.backgroundColor = RGBColorAlpha(0,0,0,0.38);
    [self.view addSubview:layer];
    [layer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view);
        make.height.equalTo(@(SizeHeight(33)));
        make.bottom.equalTo(self.view).offset(-SizeHeight(55));
        make.left.equalTo(self.view);
    }];
    
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ddxq_icon_tsb"]];
    [layer addSubview:imgView];
    
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(layer).offset(SizeWidth(36/2));
        make.centerY.equalTo(layer);
        make.width.equalTo(@(SizeWidth(32/2)));
        make.height.equalTo(@(SizeHeight(32/2)));
    }];
    
    UILabel *lbl = [UILabel new];
    lbl.font = PingFangSCMedium(13);
    lbl.textColor = RGBColor(255,255,255);
    lbl.textAlignment = NSTextAlignmentLeft;
    lbl.text = @"确认收货后，才能申请退款哦";
    [layer addSubview:lbl];
    
    [lbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(layer.mas_centerY);
        make.left.equalTo(layer).offset(SizeWidth(84/2));
        make.right.equalTo(layer);
        make.height.equalTo(@(SizeHeight(15)));
    }];
}

-(void) addServiceLayer{
    UILabel *lblService = [UILabel new];
    lblService.font = PingFangSC(13);
    lblService.textColor = RGBColor(248,179,23);
    lblService.textAlignment = NSTextAlignmentLeft;
    NSDictionary *underlineAttribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)};
    lblService.attributedText = [[NSAttributedString alloc] initWithString:@"《增值服务协议》"attributes:underlineAttribute];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapServiceTipsButton)];
    [lblService addGestureRecognizer:tapGesture];
    lblService.userInteractionEnabled = YES;
    
    if(_order.status == OrderStatus_waitingPay ){
        UIView *layer = [UIView new];
        layer.backgroundColor = RGBColorAlpha(0,0,0,0.36);
        [self.view addSubview:layer];
        [layer mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(self.view);
            make.height.equalTo(@(SizeHeight(33)));
            make.bottom.equalTo(self.view).offset(-SizeHeight(55));
            make.left.equalTo(self.view);
        }];
        
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ksjl_icon_zc"]];
        [layer addSubview:imgView];
        
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(layer).offset(SizeWidth(36/2));
            make.centerY.equalTo(layer);
            make.width.equalTo(@(SizeWidth(32/2)));
            make.height.equalTo(@(SizeHeight(32/2)));
        }];
        
        UILabel *lbl = [UILabel new];
        lbl.font = PingFangSC(13);
        lbl.textColor = RGBColor(255,255,255);
        lbl.textAlignment = NSTextAlignmentRight;
        lbl.text = @"我已阅读并同意";
        [layer addSubview:lbl];
        
        [lbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(layer.mas_centerY);
            make.left.equalTo(layer).offset(SizeWidth(84/2));
            make.width.equalTo(@(SizeWidth(95)));
            make.height.equalTo(@(SizeHeight(15)));
        }];
        
        [layer addSubview:lblService];
        
        [lblService mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(lbl.mas_centerY);
            make.left.equalTo(lbl.mas_right);
            make.width.equalTo(@(SizeWidth(150)));
            make.height.equalTo(@(SizeHeight(15)));
        }];
    }else  if(_order.status == OrderStatus_padyed || _order.status == OrderStatus_complete || _order.status == OrderStatus_waitingRefund){
        [_footer addSubview:lblService];
        [lblService mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_footer);
            make.left.equalTo(_footer).offset(SizeWidth(32/2));
            make.width.equalTo(@(SizeWidth(150)));
            make.height.equalTo(@(SizeHeight(15)));
        }];
    }
}

-(NSString *) getStatusString:(OrderStatus) status{
    NSString *strStatus = @"";
    if(status == OrderStatus_waitingPay){
        strStatus = @"等待买家付款";
    }
     else  if  ( status == OrderStatus_padyed){
        strStatus = @"等待平台发货";
    }else if (status == OrderStatus_hasSend){
        strStatus = @"平台已发货";
    }else if (status == OrderStatus_complete){
        strStatus = @"已完成";
        [self updateStatusImg:@"ddxq_icon_ywc"];
    }else if (status == OrderStatus_waitingRefund){
        strStatus = @"退款审核中";
        [self updateStatusImg:@"ddxq_icon_shz"];
        [self addTipsTo:_imgStatus.superview withTitle:@"平台将会及时和您联系退款事宜"];
    }else if (status == OrderStatus_RefundComplete){
        strStatus = @"退款成功";
        [self updateStatusImg:@"ddxq_icon_ywc"];
        [self addTipsTo:_imgStatus.superview withTitle:@"钱已退回原支付账户"];
    }else{
        strStatus = @"已取消";

    }
    
    return strStatus;
}

-(void) updateStatusImg:(NSString *) img{
    _imgStatus.image = [UIImage imageNamed:img];
    [_imgStatus mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(SizeWidth(98/2)));
        make.height.equalTo(@(SizeHeight(98/2)));
    }];
}

-(void) addTipsTo:(UIView *) cell withTitle:(NSString *) title{
    UILabel *lbl = [UILabel new];
    lbl.text = title;
    lbl.font = PingFangSCMedium(12);
    lbl.textColor = RGBColor(204,204,204);
    lbl.textAlignment = NSTextAlignmentCenter;
    
    [cell addSubview:lbl];
    [lbl mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(cell);
        make.width.equalTo(@(SizeWidth(200)));
        make.bottom.equalTo(cell).offset(-SizeHeight(15));
        make.height.equalTo(@(SizeHeight(15)));
    }];
}

-(void) showConfirmView:(NSString *) msg withLeftTitle:(NSString *) leftmsg withRightTitle:(NSString *) rightMsg {
        _confirmPopup = [self getPopup:msg withCancelText:leftmsg withOKText:rightMsg];
    
    [_confirmPopup show];
}

-(KLCPopup *) getPopup:(NSString *) msg withCancelText:(NSString *) cancelText
            withOKText:(NSString *) okText {
    UIView *contentView = [self getContentWithSize:CGSizeMake(SizeWidth(710/2),SizeHeight(350/2))];
    
    UILabel *lblTitle = [UILabel new];
    lblTitle.font = PingFangSCBOLD(SizeWidth(15));
    lblTitle.textColor = RGBColor(51,51,51);
    lblTitle.textAlignment = NSTextAlignmentCenter;
    lblTitle.text = msg;
    [contentView addSubview:lblTitle];
    
    [lblTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(contentView.mas_centerX);
        make.top.equalTo(contentView.mas_top).offset(SizeHeight(107/2));
        make.width.equalTo(@(SizeWidth(200)));
        make.height.equalTo(@(SizeHeight(18/2)));
    }];
    
    UIButton *btnClose = [UIButton new];
    btnClose.backgroundColor = RGBColor(241,242,242);
    [btnClose setTitleColor:RGBColor(51,51,51) forState:UIControlStateNormal];;
    btnClose.titleLabel.font = PingFangSCMedium(SizeWidth(15));
    btnClose.titleLabel.textAlignment = NSTextAlignmentCenter;
    btnClose.layer.cornerRadius = SizeWidth(5);
    [btnClose setTitle:cancelText forState:UIControlStateNormal];
    if(_order.status == OrderStatus_hasSend){
        [btnClose addTarget:self action:@selector(dismissPopup) forControlEvents:UIControlEventTouchUpInside];
    }else{
        [btnClose addTarget:self action:@selector(tapPopoverOkButton) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [contentView addSubview:btnClose];
    [btnClose mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView.mas_left).offset(SizeWidth(40/2));
        make.bottom.equalTo(contentView.mas_bottom).offset(-SizeHeight(30/2));
        make.width.equalTo(@(SizeWidth(289/2)));
        make.height.equalTo(@(SizeHeight(88/2)));
    }];
    
    UIButton *btnConfirm = [UIButton new];
    [btnConfirm setTitleColor:RGBColor(255,255,255) forState:UIControlStateNormal];;
    btnConfirm.titleLabel.font = PingFangSCMedium(SizeWidth(15));
    btnConfirm.titleLabel.textAlignment = NSTextAlignmentCenter;
    [btnConfirm setTitle:okText forState:UIControlStateNormal];
    btnConfirm.layer.cornerRadius = SizeWidth(5);
    btnConfirm.backgroundColor = RGBColor(99,142,220);
    if(_order.status == OrderStatus_hasSend){
        [btnConfirm addTarget:self action:@selector(tapPopoverOkButton) forControlEvents:UIControlEventTouchUpInside];
    }else{
        [btnConfirm addTarget:self action:@selector(dismissPopup) forControlEvents:UIControlEventTouchUpInside];

    }
    [contentView addSubview:btnConfirm];
    
    [btnConfirm mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(btnClose.mas_right).offset(SizeWidth(34/2));
        make.bottom.equalTo(btnClose.mas_bottom);
        make.width.equalTo(btnClose);
        make.height.equalTo(btnClose);
    }];
    
    
    KLCPopup *popup = [KLCPopup popupWithContentView:contentView];
    popup.showType = KLCPopupShowTypeSlideInFromTop;
    popup.dismissType = KLCPopupDismissTypeSlideOutToTop;
    
    return popup;
}

-(void) tapPopoverOkButton{
    if (_order.status == OrderStatus_hasSend) {
         [self updateOrder:@"3"];
    }else if (_order.status == OrderStatus_padyed || _order.status == OrderStatus_complete){
        [self updateOrder:@"4"];
    }else if (_order.status != OrderStatus_complete && _order.added_fee > 0) {
        [self updateOrder:@"10"];
    }
}


@end
