//
//  ConfirmOrderViewController.m
//  BaseProject
//
//  Created by LeoGeng on 27/11/2017.
//  Copyright © 2017 cc. All rights reserved.
//
#import "SHPlacePickerView.h"
#import "ConfirmOrderViewController.h"
#import "KLCPopup.h"
#import "UIColor+BGHexColor.h"
#import "NetworkHelper.h"
#import "InstallSummeryView.h"
#import "OrderModel.h"
#import <UMSocialCore/UMSocialCore.h>
#import "NSString+Category.h"
#import "RegionModel.h"
#import "OrderResult.h"
#import "OrderDetailViewController.h"
#import "PayManager.h"

#define Share_TAG 100000
#define CBX_PAY_TAG 2003


@interface ConfirmOrderViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>{
    int _numberOfSection;
}
@property (nonatomic, retain) UITableView *tb;
@property (nonatomic, retain) UILabel *lblAmount;
@property (nonatomic, retain) UILabel *lblGooodsPrice;
//@property (nonatomic, retain) UILabel *lblInstallPrice;
//@property (nonatomic, retain) UILabel *lblCoupon;
@property(retain,atomic) UITextField *txtName;
@property(retain,atomic) UITextField *txtTelNo;
@property(retain,atomic) UITextField *txtAddress;
@property(retain,atomic) UIButton *btnRegion;
@property(retain,atomic) UIImageView *imgGoods;
@property(retain,atomic) UILabel *lblGoodsTitle;
@property(assign,atomic) BOOL needInstall;
@property(assign,atomic) BOOL forceInstall;
@property(assign,atomic) BOOL canInstall;
@property(retain,atomic)  SHPlacePickerView *shplacePicker;
@property(retain,atomic) KLCPopup* sharePopup;
@property(retain,atomic) KLCPopup* installPopup;
@property(retain,atomic) KLCPopup* serviceDescPopup;
@property(retain,atomic) KLCPopup* PayPopup;
@property(retain,atomic) UIView* alView;
@property(retain,atomic) UIView* wcView;
@property(assign,atomic) BOOL isWechatPay;
@property(retain,atomic) NSString *goodsId;
@property(retain,atomic) UILabel *lblShareSaveMoney;
@property(retain,atomic) GoodsInfo *goodsInfo;
@property(retain,atomic) InstallSummeryView *installSummeryView;
@property(retain,atomic)  UIWebView *serviceWebView;
@property(retain,atomic)  NSArray *requireInstall;
@property(retain,atomic)  NSArray *unReqiureInstall;
@property(retain,atomic)  NSString *strSevice;
@property(assign,atomic)  int countOfFee;
@property(assign,atomic)  NSString *installPrice;
@property(assign,atomic)  BOOL needAddedService;
@property(assign,atomic)  BOOL hasShare;
@property(retain,atomic)  NSString *city;
@property(retain,atomic)  NSString *province;
@property(retain,atomic)  NSString *county;
@property(retain,atomic)  NSString *discountMoney;
@property(retain,atomic)  UISwitch * needInstallSwitch;
@property(retain,atomic)  NSString * orderId;
@property(retain,atomic)  NSMutableArray * regionArr;

@end

@implementation ConfirmOrderViewController

- (instancetype)initWithGoodsId:(GoodsInfo *) goodsInfo
{
    self = [super init];
    if (self) {
        _goodsInfo = goodsInfo;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _needInstall = NO;
    [self resetFather];
    [self addFooter];
    [self addTableView];
    _numberOfSection = 3;
    _countOfFee = 1;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [ConfigModel showHud:self];
    [NetworkHelper getAddressWtihCallBack:^(NSString *error, AddressModel *addr) {
        _regionArr =  [RegionModel getRegions];
        if (addr != nil) {
            _county = addr.county;
            _province = addr.province;
            _city = addr.city;
            _txtName.text = addr.consignee;
            _txtTelNo.text = addr.phone;
            [self chooseArea:_county];
            [ConfigModel hideHud:self];
            NSString *strProvince = [RegionModel getRegionName:_province];
            NSString *strCity = [RegionModel getRegionName:_city];
            NSString *strCounty = [RegionModel getRegionName:_county];
            NSString *strAddree = [NSString stringWithFormat:@"%@ %@ %@",strProvince,strCity,strCounty];
            [_btnRegion setTitle:strAddree forState:UIControlStateNormal];
            _btnRegion.titleLabel.font = PingFangSCMedium(SizeWidth(13));
            [_btnRegion setTitleColor:RGBColorAlpha(51,51,51,1) forState:UIControlStateNormal];
            _txtAddress.text = addr.address;
        }
        [NetworkHelper getDiscountAmount:^(NSString *error, NSString *money) {
            if (error == nil) {
                _lblShareSaveMoney.text = [self getShareString:money];
            }
            [NetworkHelper getAddServiceCallBack:^(NSString *error, NSString *addedValueService) {
                if (error == nil) {
                    _strSevice = addedValueService;
                    
                    [self setPrice];
                    [ConfigModel hideHud:self];
                }
                
            }];
        }];
    }];
    
    
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
    OrderDetailViewController *newVC = [OrderDetailViewController new];
    newVC.orderId = _orderId;
    newVC.fromBuy = YES;
    [self.navigationController pushViewController:newVC animated:YES];
}

-(NSString *) getShareString:(NSString *) money{
    return [NSString stringWithFormat:@"分享立减%@元",money];
}

-(void) ShowHeader{
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, SizeHeight(120))];
    img.image = [UIImage imageNamed:@"yhbjt"];
    _lblShareSaveMoney = [UILabel new];
    _lblShareSaveMoney.font = PingFangSCBOLD(18);
    _lblShareSaveMoney.textColor = RGBColor(255,255,255);
    _lblShareSaveMoney.textAlignment = NSTextAlignmentCenter;
    _lblShareSaveMoney.text = [self getShareString:@"0"];
    [img addSubview:_lblShareSaveMoney];
    
    [_lblShareSaveMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(img.mas_centerX);
        make.top.equalTo(img.mas_top).offset(SizeHeight(53/2));
        make.width.equalTo(img);
        make.height.equalTo(@(SizeHeight(18)));
    }];
    
    UIButton *btnShare = [UIButton new];
    btnShare.titleLabel.font = PingFangSCMedium(15);
    btnShare.titleLabel.textColor = RGBColor(255,255,255);
    btnShare.titleLabel.textAlignment = NSTextAlignmentCenter;
    [btnShare setTitle:@"点击分享" forState:UIControlStateNormal];
    btnShare.layer.borderWidth = 1;
    btnShare.layer.borderColor = btnShare.titleLabel.textColor.CGColor ;
    [btnShare addTarget:self action:@selector(showShareView) forControlEvents:UIControlEventTouchUpInside];
    img.userInteractionEnabled = YES;
    [img addSubview:btnShare];
    
    [btnShare mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(img.mas_centerX);
        make.bottom.equalTo(img.mas_bottom).offset(-SizeHeight(33/2));
        make.width.equalTo(@(SizeWidth(186/2)));
        make.height.equalTo(@(SizeHeight(33)));
    }];
    
    _tb.tableHeaderView = img;
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
    _tb.tableHeaderView = ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 0)];
        view;
    });
    
    _tb.tableFooterView = ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW,  SizeHeight(0))];
        view.backgroundColor = [UIColor blueColor];
        view;
    });
    
    [self ShowHeader];
    [self.view addSubview:_tb];
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [_tb addGestureRecognizer:gestureRecognizer];
}

- (void) hideKeyboard {
    [self.view endEditing:YES];
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
    _lblAmount.text = _goodsInfo.price;
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
    if ([_txtName.text isEqualToString:@""]) {
        [ConfigModel mbProgressHUD:@"请输入收货人" andView:self.view];
        return;
    }else if([_txtAddress.text isEqualToString:@""]){
        [ConfigModel mbProgressHUD:@"请输入收货地址" andView:self.view];
        return;
    }else if([_txtTelNo.text isEqualToString:@""] || ![_txtTelNo.text isTelNumber]){
        [ConfigModel mbProgressHUD:@"请输入正确的手机号" andView:self.view];
        return;
    }else if([_btnRegion.titleLabel.text isEqualToString:@""]){
        [ConfigModel mbProgressHUD:@"请选择地区" andView:self.view];
        return;
    }
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
            number = _countOfFee;
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


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:FRAME(0, 0, kScreenW, SizeHeight(45))];
    view.backgroundColor = [UIColor whiteColor];
    NSString *title = @"";
    switch (section) {
        case 0:
            title = @"收货信息";
            break;
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
    return SizeHeight(45);
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
    lblName.font = PingFangSCMedium(26/2);
    lblName.textColor = fontColor;
    lblName.text = title;
    [superView addSubview:lblName];
    
    CGFloat width =  [lblName.text widthWithFont:lblName.font height:SizeHeight(25/2)];
    [lblName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(superView.mas_centerY);
        if([title isEqualToString:@"安装费"]){
            make.width.equalTo(@(SizeWidth(100)));
        }else{
            make.width.equalTo(@(width));
        }
        
        make.height.equalTo(superView);
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

-(UITextField *) addTextFieldTo:(UIView *) superView withLeftView:(UIView *) leftView withPlaceHolder:(NSString *) placeHolder{
    
    UITextField *txt = [UITextField new];
    txt.font = PingFangSCMedium(SizeWidth(13));
    txt.textColor = RGBColorAlpha(51,51,51,1);
    txt.textAlignment = NSTextAlignmentLeft;
    txt.delegate = self;
    
    [superView addSubview:txt];
    [txt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(leftView.mas_centerY);
        make.right.equalTo(superView.mas_right).offset(-SizeWidth(10));
        make.left.equalTo(leftView.mas_right).offset(SizeWidth(25/2));
        make.height.equalTo(superView);
    }];
    
    if (placeHolder != nil && ![@"" isEqualToString:placeHolder]) {
        UIFont *placeHolderFont = PingFangSCMedium(SizeWidth(13));
        UIColor *placeHolderColor = RGBColorAlpha(204,204,204,1);
        
        NSAttributedString *str = [[NSAttributedString alloc] initWithString:placeHolder attributes:@{ NSForegroundColorAttributeName : placeHolderColor,NSFontAttributeName:placeHolderFont}];
        txt.attributedPlaceholder = str;
    }
    
    return txt;
}

-(UIButton *) addRegionButtonTo:(UIView *)superView withLeftView:(UIView *)leftView{
    
    _btnRegion = [UIButton new];
    [_btnRegion setTitle:@"请选择所在地区" forState:UIControlStateNormal];
    _btnRegion.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    UIFont *placeHolderFont = PingFangSCMedium(SizeWidth(13));
    UIColor *placeHolderColor = RGBColorAlpha(204,204,204,1);
    
    _btnRegion.titleLabel.font = placeHolderFont;
    [_btnRegion setTitleColor:placeHolderColor forState:UIControlStateNormal];
    [_btnRegion addTarget:self action:@selector(tapRegionButton:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [superView addSubview:_btnRegion];
    [_btnRegion mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(leftView.mas_centerY);
        make.left.equalTo(leftView.mas_right).offset(SizeWidth(0));
        make.right.equalTo(superView.mas_right).offset(SizeWidth(-16));
        make.height.equalTo(superView.mas_height);
    }];
    
    _btnRegion.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _btnRegion.imageView.contentMode = UIViewContentModeScaleAspectFit;
    _btnRegion.titleEdgeInsets = UIEdgeInsetsMake(0, SizeWidth(10), 0, 0);
    
    UIImageView *rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_gd"]];
    [_btnRegion addSubview:rightView];
    
    [rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_btnRegion.mas_centerY);
        make.right.equalTo(_btnRegion.mas_right);
        make.height.equalTo(@(SizeHeight(22)));
        make.width.equalTo(@(SizeWidth(28/2)));
    }];
    
    return _btnRegion;
}

-(void) addContentForDeliveryAddrees:(UITableViewCell *)cell withIndex:(NSInteger) index{
    if (cell.subviews.count >= 4) {
        return;
    }
    
    NSString *titile = @"";
    NSString *placeHolder = @"";
    switch (index) {
        case 0:
            titile = @"收货人:";
            placeHolder = @"请填写收货人";
            break;
        case 1:
            titile = @"联系电话:";
            placeHolder = @"请填写联系电话";
            break;
        case 2:
            titile = @"所在地区:";
            placeHolder = @"请选择所在地区";
            break;
        case 3:
            titile = @"详细地址:";
            placeHolder = @"街道 楼牌号";
            break;
        default:
            break;
    }
    
    UILabel *lblTitle = [self addTitleLable:titile withSuperView:cell];
    
    if (index == 2) {
        [self addRegionButtonTo:cell withLeftView:lblTitle];
    }else{
        switch (index) {
            case 0:
                _txtName =  [self addTextFieldTo:cell withLeftView:lblTitle withPlaceHolder:placeHolder];
                break;
            case 1:
                _txtTelNo =  [self addTextFieldTo:cell withLeftView:lblTitle withPlaceHolder:placeHolder];
                _txtTelNo.keyboardType = UIKeyboardTypePhonePad;
                _txtTelNo.delegate = self;
                break;
            case 3:
                _txtAddress =  [self addTextFieldTo:cell withLeftView:lblTitle withPlaceHolder:placeHolder];
                break;
            default:
                break;
        }
        
    }
    
    [self addBorder:cell];
}

-(void) tapRegionButton:(UIButton *) sender{
    [ConfigModel showHud:self];
    
    __weak __typeof(self)weakSelf = self;
    if (_shplacePicker == nil) {
        _shplacePicker = [[SHPlacePickerView alloc] initWithIsRecordLocation:YES SendPlaceArray:^(NSArray *placeArray) {
            _province = [RegionModel getRegionCode:placeArray[0] withFid:@"0"];
            _city = [RegionModel getRegionCode:placeArray[1] withFid:_province];
            _county = [RegionModel getRegionCode:placeArray[2] withFid:_city];
            NSLog(@"---------");
            
            [self chooseArea:_county];
            weakSelf.btnRegion.titleLabel.font = PingFangSCMedium(SizeWidth(13));
            [weakSelf.btnRegion setTitleColor:RGBColorAlpha(51,51,51,1) forState:UIControlStateNormal];
            [weakSelf.btnRegion setTitle:[NSString stringWithFormat:@"%@ %@ %@",placeArray[0],placeArray[1],placeArray[2]] forState:UIControlStateNormal];
        } withDataSource:_regionArr];
    }
    
    [self.view endEditing:YES];
    [self.view addSubview:_shplacePicker];
    NSLog(@"==============");
    
    [ConfigModel hideHud:self];
}

-(void) chooseArea:(NSString *) arearId{
    [ConfigModel showHud:self];
    [NetworkHelper getInstallFeeWithArea:arearId WithCallBack:^(NSString *error, NSString *installFee , BOOL canInstall, BOOL forceInstall) {
        [ConfigModel hideHud:self];
        _installPrice = installFee;
        _forceInstall = forceInstall;
        _canInstall = canInstall;
        if (_needInstall != canInstall) {
            _needInstall = canInstall;
            _needInstallSwitch.on = canInstall;
        }else{
            _needInstall = canInstall;
            _needInstallSwitch.on = canInstall;
        }
        
        [self changePrice:_needInstall];
        
    }];
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
    [_imgGoods sd_setImageWithURL:[NSURL URLWithString:_goodsInfo.head_img]];
    
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
    _lblGoodsTitle.text = _goodsInfo.goods_name;
    [_lblGoodsTitle size];
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
    if (index==2) {
        title = @"增值服务";
        [sw addTarget:self action:@selector(needAddedService:) forControlEvents:UIControlEventValueChanged];
        
    }else{
        _needInstallSwitch = sw;
        sw.on = _needInstall;
        [sw addTarget:self action:@selector(needInstall:) forControlEvents:UIControlEventValueChanged];
    }
    
    [cell addSubview:sw];
    
    [sw mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(cell).offset(-SizeWidth(16));
        make.centerY.equalTo(lbl);
        make.width.equalTo(@(SizeWidth(102/2)));
        make.height.equalTo(@(SizeHeight(62/2)));
    }];
}

-(void) needInstall:(UISwitch *) sender{
    if (!_canInstall) {
        sender.on = NO;
        [ConfigModel mbProgressHUD:@"您所在区域暂不支持安装服务" andView:self.view];
        return;
    }
    
    if (_forceInstall) {
        sender.on = YES;
        
        [ConfigModel mbProgressHUD:@"你所在区域为强制安装区域" andView:self.view];
        return;
    }
    _needInstall = sender.on;
    [self changePrice:_needInstall];
}

-(void) needAddedService:(UISwitch *) sender{
    _needAddedService = sender.on;
    if (_needInstallSwitch) {
        [ConfigModel showHud:self];
        [NetworkHelper getAddedFeeWithCallBack:^(NSString *error, NSString *added_price) {
            [ConfigModel hideHud:self];
            _goodsInfo.added_price = added_price;
            [self changePrice:_needAddedService];
        }];
    }else{
        [self changePrice:_needAddedService];
    }
}

-(void) changePrice:(BOOL) need{
    _countOfFee = 1;
    if (_needAddedService) {
        _countOfFee += 1;
    }
    
    if (_needInstall) {
        _countOfFee += 1;
    }
    
    if (_hasShare) {
        _countOfFee += 1;
    }
    
    [_tb reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationNone];
    [self setPrice];
}

-(void) tapInstallTipsButton{
    if (_installPopup == nil) {
        UIView *content = [self getContentForTips];
        _installSummeryView= [InstallSummeryView new];
        _installSummeryView.require = _requireInstall;
        _installSummeryView.unRequire = _unReqiureInstall;
        [content addSubview:_installSummeryView];
        [_installSummeryView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(content);
            make.right.equalTo(content);
            make.top.equalTo(content);
            make.bottom.equalTo(content).offset(-SizeHeight(80/2));
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
        _serviceWebView.backgroundColor = self.view.backgroundColor;
        [_serviceWebView loadHTMLString:_strSevice baseURL:nil];
        _serviceWebView.opaque = NO;
        [content addSubview:_serviceWebView];
        [_serviceWebView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(content).offset(SizeWidth(15));
            make.right.equalTo(content).offset(-SizeWidth(15));
            make.top.equalTo(lblTitle.mas_bottom).offset(SizeHeight(20));
            make.bottom.equalTo(content).offset(-SizeHeight(80/2));
        }];
        
        _serviceDescPopup = [KLCPopup popupWithContentView:content];
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
    
    NSString *title = @"";
    NSString *price = @"0";
    UIColor *fontColor = RGBColor(102, 102, 102);
    if (index == 0) {
        title =@"商品金额";
        price = _goodsInfo.price;
    }else if(index == 1 && _needInstall){
        title =@"安装费";
        price =  _installPrice;
    }else if((index == 1 || index == 2) && _needAddedService){
        title =@"增值服务";
        price = _goodsInfo.added_price;
    }else if(_hasShare){
        title =@"分享立减";
        price = _lblShareSaveMoney.text;
    }
    if (![title isEqualToString:@""]) {
        UILabel *lblTitle = (UILabel *)[cell viewWithTag:9001];
        if (lblTitle != nil) {
            lblTitle.text = title;
        }else{
            lblTitle  = [self addTitleLable:title withSuperView:cell withFontColor:fontColor rightOffSet:0];
            lblTitle.tag = 9001;
        }
        
        UILabel *lblValue = (UILabel *)[cell viewWithTag:9002];
        if (lblValue != nil) {
            lblValue.text = price;
        }else{
            lblValue = [self addTitleLable:price withSuperView:cell withFontColor:fontColor rightOffSet:SizeWidth(-32/1)];
            lblValue.tag = 9002;
            
        }
    }
    
    
}

-(void) showShareView{
    if (_sharePopup == nil) {
        UIView* contentView = [[UIView alloc] init];
        contentView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        CGFloat width = self.view.frame.size.width;
        contentView.frame = CGRectMake(self.view.centerX, self.view.centerX - SizeHeight(368/2), width, SizeHeight(368/2));
        
        
        CGFloat offset = - SizeWidth(88+62+62/2+88/2)/2;
        [self addButtonToShareView:contentView withImage:@"fx_icon_pyq" withTitle:@"朋友圈" withLeft:offset withIndex:1];
        offset = -SizeWidth(62/2+88/2)/2;
        [self addButtonToShareView:contentView withImage:@"fx_icon_wx" withTitle:@"微信好友" withLeft:offset withIndex:2];
        
        offset = SizeWidth(62/2+88/2)/2;
        [self addButtonToShareView:contentView withImage:@"fx_icon_qq" withTitle:@"QQ好友" withLeft:offset withIndex:3];
        offset = SizeWidth(88+62+62/2+88/2)/2;
        
        [self addButtonToShareView:contentView withImage:@"fx_icon_kj" withTitle:@"QQ空间" withLeft:offset withIndex:4];
        
        
        UIButton *btnClose = [UIButton new];
        [btnClose setTitleColor:RGBColor(51,51,51) forState:UIControlStateNormal];;
        btnClose.titleLabel.font = PingFangSCBOLD(SizeWidth(18));
        btnClose.titleLabel.textAlignment = NSTextAlignmentCenter;
        [btnClose setTitle:@"取消" forState:UIControlStateNormal];
        [btnClose addTarget:self action:@selector(dismissPopup) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:btnClose];
        [btnClose mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(contentView.mas_centerX);
            make.bottom.equalTo(contentView.mas_bottom).offset(-SizeHeight(29/2));
            make.width.equalTo(@(SizeWidth(90/2)));
            make.height.equalTo(@(SizeHeight(34/2)));
        }];
        
        _sharePopup = [KLCPopup popupWithContentView:contentView];
        _sharePopup.showType = KLCPopupShowTypeSlideInFromBottom;
        _sharePopup.dismissType = KLCPopupDismissTypeSlideOutToBottom;
    }
    
    [_sharePopup showAtCenter:CGPointMake(self.view.centerX, self.view.centerY * 2 - SizeHeight(368/4)) inView:self.view];
}

-(void) addButtonToShareView:(UIView *) superView withImage:(NSString *) img withTitle:(NSString *) title withLeft:(CGFloat) offset withIndex:(NSInteger) index{
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:img]];
    imgView.tag = Share_TAG + index;
    [superView addSubview:imgView];
    imgView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGuesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapShareButton:)];
    [imgView addGestureRecognizer:tapGuesture];
    
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(superView.mas_centerX).offset(offset);
        make.top.equalTo(superView).offset(SizeHeight(62/2));
        make.width.equalTo(@(SizeWidth(88/2)));
        make.height.equalTo(@(SizeHeight(88/2)));
    }];
    
    UILabel *lblTitle = [UILabel new];
    lblTitle.font = PingFangSCMedium(SizeWidth(13));
    lblTitle.textColor = RGBColor(51,51,51);
    lblTitle.textAlignment = NSTextAlignmentLeft;
    lblTitle.text = title;
    [superView addSubview:lblTitle];
    
    [lblTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(imgView.mas_centerX);
        make.top.equalTo(imgView.mas_bottom).offset(SizeHeight(48/2));
        make.width.equalTo(@(SizeWidth(70)));
        make.height.equalTo(@(SizeHeight(12)));
    }];
}

-(void) tapShareButton:(UITapGestureRecognizer *) gesture{
    NSInteger index = gesture.view.tag;
    UMSocialPlatformType type = UMSocialPlatformType_WechatTimeLine ;
    switch (index) {
        case 100002:
            type = UMSocialPlatformType_WechatSession;
            break;
        case 100003:
            type = UMSocialPlatformType_QQ;
            break;
        case 100004:
            type = UMSocialPlatformType_Qzone;
            break;
    }
    
    [self shareWebPageToPlatformType:type];
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
            make.width.equalTo(@(SizeWidth(90/2)));
            make.height.equalTo(@(SizeHeight(34/2)));
        }];
        
        UIButton *btnPay = [UIButton new];
        [btnPay setTitleColor:RGBColor(51,51,51) forState:UIControlStateNormal];;
        btnPay.titleLabel.font = PingFangSCBOLD(SizeWidth(18));
        btnPay.titleLabel.textAlignment = NSTextAlignmentCenter;
        [btnPay setTitle:@"立即支付" forState:UIControlStateNormal];
        [btnPay addTarget:self action:@selector(payNow) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:btnPay];
        [btnPay mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(contentView.mas_right).offset(SizeWidth(-100/2));
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

-(void) payNow{
    
    OrderModel *order = [OrderModel new];
    order.goods_id = _goodsInfo.goods_id;
    order.goods_num = 1;
    order.consignee = _txtName.text;
    order.address = _txtAddress.text;
    order.city = _city;
    order.province = _province;
    order.county = _county;
    order.phone = _txtTelNo.text;
    order.type = 0;
    order.added_fee = _needAddedService ? _strSevice:0;
    order.is_install = _needInstall ? 1:0;;
    order.install_fee = _needInstall? _installPrice:0;
    order.discount_amount = _discountMoney;
    order.pay_type = _isWechatPay ? 1:0;
    [ConfigModel showHud:self];
    [NetworkHelper addOrder:order withCallBack:^(NSString *error, OrderResult *result) {
        [ConfigModel hideHud:self];
        if (error) {
            [ConfigModel mbProgressHUD:error andView:self.view];
        }else{
            if(_isWechatPay){
                [NetworkHelper WXPay:result];
            }else{
                [[PayManager manager] payByAlipay:result];
            }
            _orderId = result.order_id;
            //            [ConfigModel mbProgressHUD:msg andView:self.view];
        }
    }];
    [KLCPopup dismissAllPopups];
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
        make.height.equalTo(@(SizeHeight(50/2)));
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

-(void) setPrice{
    float amount = _goodsInfo.price.floatValue;
    if (_needInstall) {
        amount += _installPrice.floatValue;
    }
    
    if (_needAddedService) {
        amount += _goodsInfo.added_price.floatValue;
    }
    
    if (_hasShare) {
        amount -= _lblShareSaveMoney.text.floatValue;
    }
    
    _lblAmount.text = [NSString stringWithFormat:@"%.2f",amount];
}

- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
{
    [ConfigModel showHud:self];
    [HttpRequest getPath:@"public/fenxiang" params:nil resultBlock:^(id responseObject, NSError *error) {
        [ConfigModel hideHud:self];
        [KLCPopup dismissAllPopups];
        if (error) {
            return ;
        }
        
        if (responseObject[@"success"] == 0) {
            [ConfigModel mbProgressHUD:responseObject[@"msg"] andView:self.view];
        }
        
        NSString *thumbURL = responseObject[@"data"][@"img_url"];
        NSString *title = responseObject[@"data"][@"title"];
        NSString *desc = responseObject[@"data"][@"subtitle"];
        NSString *url = responseObject[@"data"][@"url"];
        
        //创建分享消息对象
        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
        
        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:desc thumImage:thumbURL];
        //设置网页地址
        shareObject.webpageUrl = url;
        
        //分享消息对象设置分享内容对象
        messageObject.shareObject = shareObject;
        
        //调用分享接口
        [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
            if (error) {
                UMSocialLogInfo(@"************Share fail with error %@*********",error);
            }else{
                _hasShare = true;
                [self changePrice:YES];
                if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                    UMSocialShareResponse *resp = data;
                    //分享结果消息
                    UMSocialLogInfo(@"response message is %@",resp.message);
                    //第三方原始返回的数据
                    UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                    
                }else{
                    UMSocialLogInfo(@"response data is %@",data);
                }
            }
        }];
    }];
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (_shplacePicker!=nil) {
        [_shplacePicker removeFromSuperview];
    }
}

@end
