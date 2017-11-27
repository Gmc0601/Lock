//
//  ConfirmOrderViewController.m
//  BaseProject
//
//  Created by LeoGeng on 27/11/2017.
//  Copyright © 2017 cc. All rights reserved.
//

#import "ConfirmOrderViewController.h"

@interface ConfirmOrderViewController ()<UITableViewDelegate,UITableViewDataSource>{
    int _numberOfSection;
}
@property (nonatomic, retain) UITableView *tb;
@property (nonatomic, retain) UILabel *lblAmount;
@property(retain,atomic) UITextField *txtName;
@property(retain,atomic) UITextField *txtTelNo;
@property(retain,atomic) UITextField *txtAddress;
@property(retain,atomic) UIButton *btnRegion;
@end

@implementation ConfirmOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self resetFather];
    [self addFooter];
    [self addTableView];
    _numberOfSection = 4;
}
- (void)resetFather {
    self.line.hidden = YES;
    self.titleLab.text = @"确认订单";
    [self.rightBar setTitle:@"客服" forState:UIControlStateNormal];
}

-(void) addTableView{
    _tb = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenW, kScreenH - 64- SizeHeight(55)) style:UITableViewStyleGrouped];
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
            number = 2;
            break;
        case 2:
            number = 2;
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
    }
    
    return cell;
}


#pragma mark - UITableDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = SizeHeight(50);
    return height;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
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
    lblTitle.textColor = RGBColorAlpha(51,51,51,1);
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

-(UILabel *) addTitleLable:(NSString *) title withSuperView:(UIView *) superView {
    UILabel *lblName = [[UILabel alloc] init];
    lblName.font = PingFangSCMedium(26/2);
    lblName.textColor = RGBColorAlpha(102,102,102,1);
    lblName.text = title;
    [superView addSubview:lblName];
    
    CGFloat width =  [lblName.text widthWithFont:lblName.font height:SizeHeight(25/2)];
    [lblName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(superView.mas_centerY);
        make.left.equalTo(superView.mas_left).offset(SizeWidth(16));
        make.width.equalTo(@(width));
        make.height.equalTo(@(SizeHeight(25/2)));
    }];
    
    return lblName;
}

-(UITextField *) addTextFieldTo:(UIView *) superView withLeftView:(UIView *) leftView withPlaceHolder:(NSString *) placeHolder{
   
    UITextField *txt = [UITextField new];
    txt.font = PingFangSCMedium(SizeWidth(13));
    txt.textColor = RGBColorAlpha(51,51,51,1);
    txt.textAlignment = NSTextAlignmentLeft;
    
    [superView addSubview:txt];
    [txt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(superView.mas_centerY);
        make.right.equalTo(superView.mas_right).offset(-SizeWidth(10));
        make.left.equalTo(leftView.mas_right).offset(SizeWidth(25/2));
        make.height.equalTo(@(SizeHeight(25/2)));
    }];
    
    if (placeHolder != nil && ![@"" isEqualToString:placeHolder]) {
        UIFont *placeHolderFont = PingFangSCMedium(SizeWidth(13));
        UIColor *placeHolderColor = RGBColorAlpha(204,204,204,1);
        
        NSAttributedString *str = [[NSAttributedString alloc] initWithString:placeHolder attributes:@{ NSForegroundColorAttributeName : placeHolderColor,NSFontAttributeName:placeHolderFont}];
        txt.attributedPlaceholder = str;
    }
    
    return txt;
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
            break;
        case 1:
            titile = @"联系电话:";
            break;
        case 2:
            titile = @"所在地区:";
            break;
        case 3:
            titile = @"详细地址:";
            placeHolder = @"街道 楼牌号";
            break;
        default:
            break;
    }
    
     UILabel *lblTitle = [self addTitleLable:titile withSuperView:cell];
    [self addTextFieldTo:cell withLeftView:lblTitle withPlaceHolder:placeHolder];
    [self addBorder:cell];
}
@end
