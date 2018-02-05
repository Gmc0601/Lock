//
//  UserInfoViewController.m
//  BaseProject
//
//  Created by cc on 2017/12/11.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "UserInfoViewController.h"
#import <UIImageView+WebCache.h>
#import "GTMBase64.h"

@interface UserInfoViewController ()<UITableViewDelegate, UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

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
    
    [HttpRequest postPath:@"Public/logout" params:nil resultBlock:^(id responseObject, NSError *error) {
        if([error isEqual:[NSNull null]] || error == nil){
            NSLog(@"success");
        }
        NSDictionary *datadic = responseObject;
        if ([datadic[@"success"] intValue] == 1) {
            
            [ConfigModel saveBoolObject:NO forKey:IsLogin];
            [self.navigationController popViewControllerAnimated:YES];
            
        }else {
            NSString *str = datadic[@"msg"];
            [ConfigModel mbProgressHUD:str andView:nil];
        }
    }];
    
    
}

- (void)viewWillDisappear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = YES;
}

- (void)resetFather {
    [self.rightBar setTitle:@"保存" forState:UIControlStateNormal];
    self.titleLab.text = @"个人信息";
}

- (void)more:(UIButton *)sender {
    
    [ConfigModel showHud:self];
    NSData *imgData = UIImageJPEGRepresentation(self.headImage.image,0.5);
    NSString *imgStr = [GTMBase64 stringByEncodingData:imgData];
    if (!imgStr) {
        imgStr = nil;
    }
    NSDictionary *dic = @{
                          @"face" : imgStr,
                          @"nickname" : self.nickName.text
                          };
    WeakSelf(weak);
    [HttpRequest postPath:@"Users/setUserInfo" params:dic resultBlock:^(id responseObject, NSError *error) {
        if([error isEqual:[NSNull null]] || error == nil){
            NSLog(@"success");
        }
        NSDictionary *datadic = responseObject;
        if ([datadic[@"success"] intValue] == 1) {
            [ConfigModel hideHud:weak];
            [ConfigModel mbProgressHUD:@"修改成功" andView:nil];
            [weak.navigationController popViewControllerAnimated:YES];
        }else {
            NSString *str = datadic[@"msg"];
            [ConfigModel mbProgressHUD:str andView:nil];
        }
    }];
    
    
    
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
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [cell.contentView addSubview:self.headImage];
    }else {
        [cell.contentView addSubview:self.nickName];
    }
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"选择图片来源" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self takeAlbum];
        }];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self takePhoto];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            //TODO
        }];
        [actionSheet addAction:action1];
        [actionSheet addAction:action2];
        [actionSheet addAction:cancelAction];
        
        [self.navigationController presentViewController:actionSheet animated:YES completion:nil];
    }
   
}

#pragma mark -- Photo
- (void)takeAlbum {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self.navigationController presentViewController:picker animated:YES completion:nil];
}


- (void)takePhoto {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:nil];
    } else {
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"当前相机不可用" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        [alter show];
    }
}
#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    self.headImage.image = editedImage;
    [self.noUseTableView reloadData];
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
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
        [_headImage sd_setImageWithURL:[NSURL URLWithString:[ConfigModel getStringforKey:User_headimage]] placeholderImage:[UIImage imageNamed:@"-s-xq_bg_tx"]];
    }
    return _headImage;
}

- (UITextField *)nickName {
    if (!_nickName) {
        _nickName = [[UITextField alloc] initWithFrame:FRAME(kScreenW/2, SizeHeight(15), kScreenW/2 - SizeWidth(30), SizeHeight(25))];
        _nickName.backgroundColor = [UIColor clearColor];
        _nickName.text = @"cc";
        _nickName.text = [ConfigModel getStringforKey:User_nickname];
        _nickName.placeholder = @"请输入昵称";
        _nickName.textColor = UIColorFromHex(0x666666);
        _nickName.textAlignment = NSTextAlignmentRight;
    }
    return _nickName;
}

@end
