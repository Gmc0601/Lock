//
//  MemberViewController.m
//  BaseProject
//
//  Created by cc on 2018/1/3.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "MemberViewController.h"
#import "NODataView.h"
#import "ChangeInfoViewController.h"
#import "ChangeInfoViewController.h"

@implementation MemberModle
@end

@interface MemberViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) NODataView *nodataView;

@property (nonatomic,retain) NSMutableArray *dataArr;

@property (nonatomic, retain)UITableView *noUseTableView;

@end

@implementation MemberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self resetFather];
    [self createData];
}

- (void)resetFather {
    self.titleLab.text = @"成员管理";
    self.rightBar.hidden = YES;
}

- (void)createData {
    
    NSDictionary *dic = @{
                          @"lock_id" : self.lockId,
                          };
    
    [HttpRequest postPath:@"Lock/lockuser" params:dic resultBlock:^(id responseObject, NSError *error) {
        if([error isEqual:[NSNull null]] || error == nil){
            NSLog(@"success");
        }
        NSDictionary *datadic = responseObject;
        if ([datadic[@"success"] intValue] == 1) {
            
            NSArray *data = datadic[@"data"];
            if (IsNULL(data)) {
                [self.view addSubview:self.nodataView];
            }else {
                if (data.count <= 0) {
                    [self.view addSubview:self.nodataView];
                    return ;
                }
                [self.view addSubview:self.noUseTableView];
                for (NSDictionary*dic in data) {
                    MemberModle *model = [[MemberModle alloc] init];
                    model.un_user_id = dic[@"un_user_id"];
                    model.type = dic[@"type"];
                    model.remark = dic[@"remark"];
                    [self.dataArr addObject:model];
                }
                [self.noUseTableView reloadData];
            }
        }else {
            NSString *str = datadic[@"msg"];
            [ConfigModel mbProgressHUD:str andView:nil];
        }
    }];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellId = [NSString stringWithFormat:@"%lu", indexPath.row];
    UITableViewCell *cell = [self.noUseTableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
    }
    MemberModle *model = [[MemberModle alloc] init];
    model = self.dataArr[indexPath.row];
    cell.textLabel.text = model.remark;
    if ([model.type intValue] == 2) {
        cell.detailTextLabel.text = @"APP";
    }else if ([model.type intValue] == 1) {
        cell.detailTextLabel.text = @"密码";
    }else if ([model.type intValue] == 4){
        cell.detailTextLabel.text = @"卡片";
    }else {
        cell.detailTextLabel.text = @"指纹";
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
    
}

#pragma mark - UITableDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return SizeHeight(55);
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MemberModle *model = [[MemberModle alloc] init];
    model = self.dataArr[indexPath.row];
    ChangeInfoViewController *vc = [[ChangeInfoViewController alloc] init];
    vc.userId = model.un_user_id;
    vc.userName = model.remark;
    [self.navigationController pushViewController:vc animated:YES];
}
- (UITableView *)noUseTableView {
    if (!_noUseTableView) {
        _noUseTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenW, kScreenH - 64) style:UITableViewStylePlain];
        _noUseTableView.backgroundColor = [UIColor whiteColor];
        _noUseTableView.delegate = self;
        _noUseTableView.dataSource = self;
        _noUseTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _noUseTableView.tableHeaderView = ({
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 40)];
            UILabel *lab = [[UILabel alloc] initWithFrame:FRAME(15, 10, kScreenW, 20)];
            lab.textColor = UIColorFromHex(0x666666);
            NSString *str = [NSString stringWithFormat:@"以下为%@的成员信息", self.lockName];
            lab.text = str;
            lab.font = [UIFont systemFontOfSize:14];
            [view addSubview:lab];
            view;
        });
        _noUseTableView.tableFooterView = ({
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 0)];
            view;
        });
    }
    return _noUseTableView;
}

- (NODataView *)nodataView {
    if (!_nodataView) {
        _nodataView = [[NODataView alloc] initWithFrame:FRAME(kScreenW/2 - SizeWidth(65), kScreenH/2, SizeWidth(130), SizeHeight(110)) withimage:@"icon_qx" andtitle:@"暂无成员"];
        _nodataView.clickBlock = ^{
        };
    }
    return _nodataView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray new];
    }
    return _dataArr;
}

@end
