//
//  LoginViewController.m
//  BaseProject
//
//  Created by cc on 2017/12/12.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "LoginViewController.h"
#import "AddmobileViewController.h"
#import "UserAgreeViewController.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *phoneText;
@property (weak, nonatomic) IBOutlet UITextField *codeText;
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;
@property (weak, nonatomic) IBOutlet UIButton *LoginBtn;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.line.hidden= YES;
    self.rightBar.hidden = YES;
    [self.leftBar setImage:[UIImage imageNamed:@"icon_sc"] forState:UIControlStateNormal];
    self.LoginBtn.userInteractionEnabled = NO;
    self.LoginBtn.layer.masksToBounds = YES;
    self.LoginBtn.layer.cornerRadius = 21;
    [self.phoneText addTarget:self action:@selector(textchange) forControlEvents:UIControlEventEditingChanged];
    [self.codeText addTarget:self action:@selector(textchange) forControlEvents:UIControlEventEditingChanged];
}

- (void)textchange {
    if (self.phoneText.text.length == 11 && self.codeText.text.length == 4) {
        self.LoginBtn.userInteractionEnabled = YES;
        self.LoginBtn.backgroundColor = RGBColor(102, 143, 218);
        [self.LoginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
}

- (IBAction)codeBtnClick:(id)sender {
//    [ConfigModel mbProgressHUD:@"发送成功" andView:nil];
    __block int timeout=59 ; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                
                [self.codeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [self.codeBtn setTitle:@"重获验证码" forState:UIControlStateNormal];
                self.codeBtn .userInteractionEnabled = YES;
            });
        }else{
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [self.codeBtn setTitleColor:UIColorFromHex(0x666666) forState:UIControlStateNormal];
                [self.codeBtn setTitle:[NSString stringWithFormat:@"(%@s)",strTime] forState:UIControlStateNormal];
                self.codeBtn .userInteractionEnabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}
- (IBAction)loginBtnClick:(id)sender {
    //  登录
    
}

- (IBAction)weichatClick:(id)sender {
    [self.navigationController pushViewController:[AddmobileViewController new] animated:YES];
}

- (IBAction)userAgreeClick:(id)sender {
    [self.navigationController pushViewController:[UserAgreeViewController new] animated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


@end
