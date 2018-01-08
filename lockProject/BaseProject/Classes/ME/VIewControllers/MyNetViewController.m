//
//  MyNetViewController.m
//  BaseProject
//
//  Created by cc on 2018/1/4.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "MyNetViewController.h"
#import <YYKit.h>
#import "NetAlter.h"
#import "NODataView.h"

@interface MyNetViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) UITableView *noUseTableView;

@property (nonatomic, retain) NSMutableArray *dataArr;

@property (nonatomic, retain) NODataView *nodataView;

@end

@implementation MyNetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationView.hidden = YES;
    [self.view addSubview:self.noUseTableView];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [self create];
}

- (void)create {
    [self.dataArr removeAllObjects];
    
    [HttpRequest postPath:@"GateWay/getlist" params:nil resultBlock:^(id responseObject, NSError *error) {
        if([error isEqual:[NSNull null]] || error == nil){
            NSLog(@"success");
        }
        NSDictionary *datadic = responseObject;
        if ([datadic[@"success"] intValue] == 1) {
            
            NSArray *data = datadic[@"data"];
            self.dataArr = [NSMutableArray new];
            if (IsNULL(data)) {
                [self.noUseTableView removeFromSuperview];
               [self.view addSubview:self.nodataView];
            }else {
                [self.nodataView removeFromSuperview];
                for (NSDictionary *dic in data) {
                    NetModel *model = [[NetModel alloc] init];
                    model.name = dic[@"name"];
                    model.gateway_id = dic[@"gateway_id"];
                    [self.dataArr addObject:model];
                }
                [self.view addSubview:self.noUseTableView];
                [self.noUseTableView reloadData];
                
            }

        }else {
            NSString *str = datadic[@"msg"];
            [ConfigModel mbProgressHUD:str andView:nil];
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
        UIButton *btn = [[UIButton alloc] init];
        btn.frame = FRAME(kScreenW - 50, 0, 40, 30);
        btn.centerY = cell.contentView.centerY;
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitle:@"删除" forState:UIControlStateNormal];
        btn.tag =100 + indexPath.row;
        [btn addTarget:self action:@selector(del:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:btn];
    }
    NetModel *model = self.dataArr[indexPath.row];
    cell.textLabel.text = model.name;
    return cell;
    
}

- (void)del:(UIButton *)sender {
    int i = (int)sender.tag - 100;
    NetModel *model = self.dataArr[i];
    
    NSDictionary *dic = @{
                          @"gateway_id" : model.gateway_id
                          };
    
    [HttpRequest postPath:@"GateWay/del" params:dic resultBlock:^(id responseObject, NSError *error) {
        if([error isEqual:[NSNull null]] || error == nil){
            NSLog(@"success");
        }
        NSDictionary *datadic = responseObject;
        if ([datadic[@"success"] intValue] == 1) {
            [self create];
            
        }else {
            NSString *str = datadic[@"msg"];
            [ConfigModel mbProgressHUD:str andView:nil];
        }
    }];
    
}

#pragma mark - UITableDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return SizeHeight(55);
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
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
        _nodataView = [[NODataView alloc] initWithFrame:FRAME(kScreenW/2 - SizeWidth(65), kScreenH/2- 100, SizeWidth(130), SizeHeight(110)) withimage:@"icon_qx" andtitle:@"暂无数据"];
        _nodataView.clickBlock = ^{
        };
    }
    return _nodataView;
}


@end
