//
//  MeViewController.m
//  BaseProject
//
//  Created by cc on 2017/11/17.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "MeViewController.h"
#import "MeHeadView.h"
#import "MyFavoritesViewController.h"
#import "DeviceCommandViewController.h"
#import "UserInfoViewController.h"

@interface MeViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) UITableView *noUseTableView;
@property (nonatomic, retain) NSArray *titleArr;

@end

@implementation MeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self resetFather];
    [self.view addSubview:self.noUseTableView];
}

- (void)resetFather {
    self.navigationView.hidden = YES;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *cellId = @"cellID";
    UITableViewCell *cell = [self.noUseTableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
    }
    
    cell.textLabel.text = self.titleArr[indexPath.row];
    if (indexPath.row < 2) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}

#pragma mark - UITableDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return SizeHeight(55);
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        [self.navigationController pushViewController:[MyFavoritesViewController new] animated:YES];
    }
    if (indexPath.row == 1) {
        [self.navigationController pushViewController:[DeviceCommandViewController new] animated:YES];
    }
    if (indexPath.row == 2) {
        
    }
}
- (UITableView *)noUseTableView {
    if (!_noUseTableView) {
        _noUseTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenW, kScreenH - 50) style:UITableViewStylePlain];
        _noUseTableView.backgroundColor = RGBColor(239, 240, 241);
        _noUseTableView.delegate = self;
        _noUseTableView.dataSource = self;
        _noUseTableView.tableHeaderView = ({
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, SizeHeight(320))];
            MeHeadView *head = [[MeHeadView alloc] initWithFrame:FRAME(0, 0, kScreenW, SizeHeight(310))];
            WeakSelf(weak);
            head.messageBlock = ^{
            //  消息点击
                
            };
            
            head.headImgBlock = ^{
              // 头像点击
                [weak.navigationController pushViewController:[UserInfoViewController new] animated:YES];
            };
            
            head.orderBlock = ^(int num) {
              //  订单 点击 num 0 - 3
            };
            [view addSubview:head];
            view;
        });
        _noUseTableView.tableFooterView = ({
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW,  0)];
            view;
        });
    }
    return _noUseTableView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSArray *)titleArr {
    if (!_titleArr) {
        _titleArr = @[@"我的收藏", @"设备管理", @"联系客服"];
    }
    return _titleArr;
}


@end
