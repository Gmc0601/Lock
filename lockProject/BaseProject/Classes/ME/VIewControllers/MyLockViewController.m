//
//  MyLockViewController.m
//  BaseProject
//
//  Created by cc on 2018/1/4.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "MyLockViewController.h"
#import "LockModel.h"
#import "NODataView.h"
#import "DeviceViewController.h"

@interface MyLockViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) UITableView *noUseTableView;

@property (nonatomic, retain) NSArray *dataArr, *nameArr;

@property (nonatomic, retain) NODataView *nodataView;

@end

@implementation MyLockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationView.hidden = YES;
    
}

- (void)viewWillAppear:(BOOL)animated {
    self.leftBar.hidden = NO;
    self.navigationController.navigationBar.hidden = YES;
    [[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleDefault animated:YES];
    [LockModel getlockCallBack:^(NSString *error, NSArray *findArr, NSArray *nameArr) {
        if (!error) {
            self.dataArr = findArr;
            self.nameArr = nameArr;
            if (IsNULL(self.dataArr)) {
                [self.noUseTableView removeFromSuperview];
                [self.view addSubview:self.nodataView];
            }else {
                [self.nodataView removeFromSuperview];
                [self.view addSubview:self.noUseTableView];
                [self.noUseTableView reloadData];
            }
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellId = [NSString stringWithFormat:@"%ld", indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    LockModel *model =self.dataArr[indexPath.row];
    cell.textLabel.text = model.lock_name;
    return cell;
    
}

- (void)del:(NSIndexPath *)index {
    
}

#pragma mark - UITableDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return SizeHeight(55);
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LockModel *model =self.dataArr[indexPath.row];
    DeviceViewController *vc = [[DeviceViewController alloc] init];
    vc.model = model;
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (UITableView *)noUseTableView {
    if (!_noUseTableView) {
        _noUseTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH - 64 - 54) style:UITableViewStylePlain];
        _noUseTableView.backgroundColor = [UIColor whiteColor];
        _noUseTableView.delegate = self;
        _noUseTableView.dataSource = self;
        _noUseTableView.tableHeaderView = ({
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 0)];
            view;
        });
        _noUseTableView.tableFooterView = ({
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW,  SizeHeight(0))];
            
            view;
        });
    }
    return _noUseTableView;
}

- (NODataView *)nodataView {
    if (!_nodataView) {
        _nodataView = [[NODataView alloc] initWithFrame:FRAME(kScreenW/2 - SizeWidth(65), kScreenH/2 - 100, SizeWidth(130), SizeHeight(110)) withimage:@"icon_qx" andtitle:@"暂无数据"];
        _nodataView.clickBlock = ^{
        };
    }
    return _nodataView;
}

@end
