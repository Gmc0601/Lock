//
//  MyOrderViewController.m
//  BaseProject
//
//  Created by LeoGeng on 04/12/2017.
//  Copyright © 2017 cc. All rights reserved.
//

#import "MyOrderViewController.h"
#import "OrderCell.h"

@interface MyOrderViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, retain) UITableView *tb;
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
    
}

- (void)resetFather {
    self.line.hidden = YES;
    self.titleLab.text = @"我的订单";
    [self.rightBar setTitle:@"客服" forState:UIControlStateNormal];
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{ return SizeHeight(5);}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [_tb dequeueReusableCellWithIdentifier:@"cell"];
    
    return cell;
}

@end
