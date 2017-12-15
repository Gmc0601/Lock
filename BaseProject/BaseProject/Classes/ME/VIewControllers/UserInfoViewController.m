//
//  UserInfoViewController.m
//  BaseProject
//
//  Created by cc on 2017/12/11.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "UserInfoViewController.h"

@interface UserInfoViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic,retain) UITableView *noUseTableView;

@property (nonatomic, retain) UITextField *nickName;

@property (nonatomic, retain) UIImageView *headImage;

@end

@implementation UserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self resetFather];
    [self.view addSubview:self.noUseTableView];
    UIButton *logoutBtn =  [[UIButton alloc] initWithFrame:FRAME(0, kScreenH - SizeHeight(60), kScreenW, SizeHeight(50))];
    logoutBtn.backgroundColor = [UIColor clearColor];
    [logoutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    [logoutBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [logoutBtn addTarget:self action:@selector(logout:) forControlEvents:UIControlEventTouchUpInside];
    logoutBtn.titleLabel.font = BOLDSYSTEMFONT(18);
    [self.view addSubview:logoutBtn];
    
}

- (void)logout:(id)sender {
    //  退出登录
    
}

- (void)resetFather {
    [self.rightBar setTitle:@"保存" forState:UIControlStateNormal];
    self.titleLab.text = @"个人信息";
}

- (void)more:(UIButton *)sender {
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellId = @"cellID";
    UITableViewCell *cell = [self.noUseTableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
    }
     cell.textLabel.text = @"昵称";
    if (indexPath.row==0) {
     cell.textLabel.text = @"头像";
        [cell.contentView addSubview:self.headImage];
    }else {
        [cell.contentView addSubview:self.nickName];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - UITableDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return SizeHeight(75);
    }
    return SizeHeight(55);
}

- (UITableView *)noUseTableView {
    if (!_noUseTableView) {
        _noUseTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenW, kScreenH - 64) style:UITableViewStylePlain];
        _noUseTableView.backgroundColor = RGBColor(239, 240, 241);
        _noUseTableView.delegate = self;
        _noUseTableView.dataSource = self;
        _noUseTableView.tableHeaderView = ({
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, SizeHeight(0))];
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

- (UIImageView *)headImage {
    if (!_headImage) {
        _headImage = [[UIImageView alloc] initWithFrame:FRAME(kScreenW - SizeWidth(70), 15, SizeWidth(40), SizeWidth(40))];
        _headImage.backgroundColor = [UIColor clearColor];
        _headImage.layer.masksToBounds =  YES;
        _headImage.layer.cornerRadius = SizeWidth(20);
        _headImage.image = [UIImage imageNamed:@"-s-xq_bg_tx"];
    }
    return _headImage;
}

- (UITextField *)nickName {
    if (!_nickName) {
        _nickName = [[UITextField alloc] initWithFrame:FRAME(kScreenW/2, SizeHeight(15), kScreenW/2 - SizeWidth(30), SizeHeight(25))];
        _nickName.backgroundColor = [UIColor clearColor];
        _nickName.text = @"cc";
        _nickName.placeholder = @"请输入昵称";
        _nickName.textColor = UIColorFromHex(0x666666);
        _nickName.textAlignment = NSTextAlignmentRight;
    }
    return _nickName;
}

@end
