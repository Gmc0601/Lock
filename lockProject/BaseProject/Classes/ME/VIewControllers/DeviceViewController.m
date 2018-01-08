//
//  DeviceViewController.m
//  BaseProject
//
//  Created by cc on 2018/1/4.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "DeviceViewController.h"

@interface DeviceViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, retain) UITableView *noUseTableView;
@property (nonatomic, retain) UITextField *text1, *text2, *text3;
@property (nonatomic, retain) NSArray *arr, *pleaceArr;

@end

@implementation DeviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLab.text = @"设备管理";
    [self.rightBar setTitle:@"删除" forState:UIControlStateNormal];
    [self.view addSubview:self.noUseTableView];
    
}

- (void)more:(UIButton *)sender {
    //  删除
    
    NSDictionary *dic = @{
                          @"lock_id" : self.model.lock_id
                          };
    
    [HttpRequest postPath:@"Lock/del" params:dic resultBlock:^(id responseObject, NSError *error) {
        if([error isEqual:[NSNull null]] || error == nil){
            NSLog(@"success");
        }
        NSDictionary *datadic = responseObject;
        if ([datadic[@"success"] intValue] == 1) {
            
            [ConfigModel mbProgressHUD:@"删除成功" andView:nil];
            [self.navigationController popViewControllerAnimated:YES];
            
        }else {
            NSString *str = datadic[@"msg"];
            [ConfigModel mbProgressHUD:str andView:nil];
        }
    }];
}

- (void)save {
    if (!self.text1.text) {
        [ConfigModel mbProgressHUD:@"请修改智能锁名称" andView:nil];
        return;
    }
    
    NSDictionary *dic = @{
                          @"lock_name" : self.text1.text,
                          @"lock_id" : self.model.lock_id
                          };
    [HttpRequest postPath:@"Lock/setName" params:dic resultBlock:^(id responseObject, NSError *error) {
        if([error isEqual:[NSNull null]] || error == nil){
            NSLog(@"success");
        }
        NSDictionary *datadic = responseObject;
        if ([datadic[@"success"] intValue] == 1) {
            
            [ConfigModel mbProgressHUD:@"修改成功" andView:nil];
            [self.navigationController popViewControllerAnimated:YES];
            
        }else {
            NSString *str = datadic[@"msg"];
            [ConfigModel mbProgressHUD:str andView:nil];
        }
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *str = [NSString stringWithFormat:@"%ld", indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    UITextField *text;
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:str];
        text = [[UITextField alloc] initWithFrame:FRAME(kScreenW/2 - 15, 0, kScreenW/2, 20)];
        text.centerY  = cell.contentView.centerY;
        text.textAlignment = NSTextAlignmentRight;
        text.userInteractionEnabled = NO;
        [cell.contentView addSubview:text];
    }
    cell.textLabel.text = self.arr[indexPath.row];
    if (indexPath.row ==0) {
        self.text1 = text;
        self.text1.userInteractionEnabled = YES;
    }else if (indexPath.row == 1){
        self.text2 = text;
    }else {
        self.text3 = text;
    }
    text.placeholder = self.pleaceArr[indexPath.row];
    return cell;
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
        _noUseTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenW, kScreenH - 64) style:UITableViewStylePlain];
        _noUseTableView.backgroundColor = [UIColor whiteColor];
        _noUseTableView.delegate = self;
        _noUseTableView.dataSource = self;
        _noUseTableView.tableHeaderView = ({
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 0)];
            view;
        });
        _noUseTableView.tableFooterView = ({
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 50)];
            UIButton *btn = [[UIButton alloc] initWithFrame:FRAME( 50, 20, kScreenW- 100, 30)];
            [btn setTitle:@"保存" forState:UIControlStateNormal];
            [btn setTitleColor:UIColorFromHex(0x648DDD) forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
            btn.titleLabel.font = [UIFont boldSystemFontOfSize:24];
            [view addSubview:btn];
            view;
        });
    }
    return _noUseTableView;
}



- (NSArray *)arr {
    if (!_arr) {
        _arr = @[@"智能锁名称", @"智能锁ID", @"所属网关"];
    }
    return _arr;
}

- (NSArray *)pleaceArr {
    if (!_pleaceArr) {
        _pleaceArr = @[self.model.lock_name, self.model.lock_id, self.model.gateway_name];
    }
    return _pleaceArr;
}

@end
