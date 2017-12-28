//
//  MyOrderViewController.m
//  BaseProject
//
//  Created by LeoGeng on 04/12/2017.
//  Copyright © 2017 cc. All rights reserved.
//

#import "MyOrderViewController.h"
#import "OrderCell.h"
#import <KLCPopup/KLCPopup.h>
#import "OrderDetailViewController.h"
#import "NetworkHelper.h"

@interface MyOrderViewController ()<UITableViewDelegate,UITableViewDataSource,OrderCellDelegate>
@property (nonatomic, retain) UITableView *tb;
@property (atomic, retain) KLCPopup *confirmPopup;
@property (atomic, retain) NSArray *datasource;
@property (atomic, retain) OrderModel *selectedModel;
@end

@implementation MyOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;

    [self resetFather];
    
    _tb = [[UITableView alloc] initWithFrame:CGRectMake(0, SizeHeight(64), kScreenW, kScreenH - SizeHeight(64)- SizeHeight(55)) style:UITableViewStyleGrouped];
    _tb.backgroundColor = RGBColor(239, 240, 241);
    
    _tb.delegate = self;
    _tb.dataSource = self;
    [_tb registerClass:[OrderCell class] forCellReuseIdentifier:@"cell"];
    _tb.rowHeight = SizeWidth(200);
    [_tb setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    _tb.tableFooterView = ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW,  SizeHeight(0))];
        view.backgroundColor = [UIColor blueColor];
        view;
    });
    
    [self.view addSubview:_tb];
    
    [self reload];
    
}

-(void) reload{
    [NetworkHelper getOrderListWithCallBack:^(NSString *error, NSArray *orders) {
        _datasource = orders;
        [_tb reloadData];
    }];
}

- (void)resetFather {
    self.line.hidden = YES;
    self.titleLab.text = @"我的订单";
    [self.rightBar setTitle:@"客服" forState:UIControlStateNormal];
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return _datasource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{ return SizeHeight(5);}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OrderCell *cell = (OrderCell *)[_tb dequeueReusableCellWithIdentifier:@"cell"];
    cell.model = _datasource[indexPath.section];
    cell.delegate = self;
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    OrderModel *model = _datasource[indexPath.row];
    OrderDetailViewController *newVC = [OrderDetailViewController new];
    newVC.orderId = model.order_id;
    [self.navigationController pushViewController:newVC animated:YES];
}

-(void)dismissPopup{
    [KLCPopup dismissAllPopups];
}

-(void) confirmReceive{
    [KLCPopup dismissAllPopups];
}

-(void) showConfirmView:(OrderModel *) model{
    _selectedModel = model;
    if (_confirmPopup == nil) {
        _confirmPopup = [self getPopup:@"确认已经收到货了吗？" withCancelText:@"取消" withOKText:@"确认"];
    }
    
   
    [_confirmPopup show];
}

-(KLCPopup *) getPopup:(NSString *) msg withCancelText:(NSString *) cancelText
            withOKText:(NSString *) okText{
    UIView *contentView = [self getContentWithSize:CGSizeMake(SizeWidth(710/2),SizeHeight(350/2))];
    
    UILabel *lblTitle = [UILabel new];
    lblTitle.font = PingFangSCBOLD(SizeWidth(15));
    lblTitle.textColor = RGBColor(51,51,51);
    lblTitle.textAlignment = NSTextAlignmentLeft;
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
    [btnClose addTarget:self action:@selector(dismissPopup) forControlEvents:UIControlEventTouchUpInside];
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
    [btnConfirm addTarget:self action:@selector(confirmReceive) forControlEvents:UIControlEventTouchUpInside];
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

-(UIView *) getContentWithSize:(CGSize ) size{
    UIView* contentView = [[UIView alloc] init];
    contentView.frame = CGRectMake(self.view.centerX, self.view.centerY, size.width, size.height);
    contentView.layer.cornerRadius = 5;
    
    return contentView;
}

-(void) tapPopoverOkButton{
    if (_selectedModel.status == OrderStatus_hasSend) {
        [self updateOrder:@"3"];
    }else if (_selectedModel.status != OrderStatus_complete && _selectedModel.added_fee > 0) {
        [self updateOrder:@"10"];
    }else if (_selectedModel.status == OrderStatus_padyed || _selectedModel.status == OrderStatus_complete){
        [self updateOrder:@"4"];
    }
}


-(void) updateOrder:(NSString *) status{
    [ConfigModel showHud:self];
    
    [NetworkHelper modifyOrderWithOrderId:_selectedModel.order_id withStatus:status WithCallBack:^(NSString *error, NSString *msg) {
        [ConfigModel hideHud:self];
        
        if (error == nil) {
            [self reload];
            [ConfigModel mbProgressHUD:msg andView:self.view];
        }else{
            [ConfigModel mbProgressHUD:error andView:self.view];
        }
        
        [KLCPopup dismissAllPopups];
    }];
}
@end
