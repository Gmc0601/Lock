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
#import <UMSocialCore/UMSocialCore.h>
#import "CCWebViewViewController.h"
@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *phoneText;
@property (weak, nonatomic) IBOutlet UITextField *codeText;
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;
@property (weak, nonatomic) IBOutlet UIButton *LoginBtn;
@property (weak, nonatomic) IBOutlet UIButton *wechatBtn;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.line.hidden= YES;
    self.rightBar.hidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.leftBar setImage:[UIImage imageNamed:@"icon_sc"] forState:UIControlStateNormal];
    self.LoginBtn.userInteractionEnabled = NO;
    self.LoginBtn.layer.masksToBounds = YES;
    self.LoginBtn.layer.cornerRadius = 21;
    [self.phoneText addTarget:self action:@selector(textchange) forControlEvents:UIControlEventEditingChanged];
    [self.codeText addTarget:self action:@selector(textchange) forControlEvents:UIControlEventEditingChanged];
    
}

- (void)viewWillAppear:(BOOL)animated {
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"Whatapp://"]] || [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]]) {
        //微信
        self.wechatBtn.hidden = NO;
        
    }else {
        self.wechatBtn.hidden = YES;
    }
    self.leftBar.hidden = NO;
    
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string

{
    
    if (textField == self.phoneText) {
        if (string.length == 0) return YES;
        NSMutableString *newtxt = [NSMutableString stringWithString:textField.text];
        
        [newtxt replaceCharactersInRange:range withString:string];
        
        if (newtxt.length > 11) return NO;
    }
    
    if (textField == self.codeText) {
        if (string.length == 0) return YES;
        NSMutableString *newtxt = [NSMutableString stringWithString:textField.text];
        
        [newtxt replaceCharactersInRange:range withString:string];
        
        if (newtxt.length > 4) return NO;
    }
    
    
    return YES;
    
}

- (void)back:(UIButton *)sender {
    if (self.homeBlocl) {
        self.homeBlocl();
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    });
   
    
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
    
    if (self.phoneText.text.length != 11) {
        [ConfigModel mbProgressHUD:@"请输入11位有效手机号" andView:nil];
        return;
    }
    WeakSelf(weak);
    NSDictionary *dic = @{
                          @"phone" : self.phoneText.text,
                          };
    [HttpRequest postPath:@"Public/sendCode" params:dic resultBlock:^(id responseObject, NSError *error) {
        if([error isEqual:[NSNull null]] || error == nil){
            NSLog(@"success");
        }
        NSDictionary *datadic = responseObject;
        if ([datadic[@"success"] intValue] == 1) {
            [ConfigModel mbProgressHUD:@"发送成功" andView:nil];
            __block int timeout=59 ; //倒计时时间
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
            dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
            dispatch_source_set_event_handler(_timer, ^{
                if(timeout<=0){ //倒计时结束，关闭
                    dispatch_source_cancel(_timer);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //设置界面的按钮显示 根据自己需求设置
                        
//                        [weak.codeBtn setTitleColor:UIColorFromHex(0x666666) forState:UIControlStateNormal];
                        [weak.codeBtn setTitle:@"重获验证码" forState:UIControlStateNormal];
                        weak.codeBtn .userInteractionEnabled = YES;
                    });
                }else{
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //设置界面的按钮显示 根据自己需求设置
                        NSString *strTime = [NSString stringWithFormat:@"%d", timeout];
                        [self.codeBtn setTitle:[NSString stringWithFormat:@"(%@s)",strTime] forState:UIControlStateNormal];
                        weak.codeBtn .userInteractionEnabled = NO;
                    });
                    timeout--;
                }
            });
            dispatch_resume(_timer);
            
        }else {
            NSString *str = datadic[@"msg"];
            [ConfigModel mbProgressHUD:str andView:nil];
        }

    }];
    
   
}
- (IBAction)loginBtnClick:(id)sender {
    //  登录
    
    
    NSDictionary *dic = @{
                          @"phone" : self.phoneText.text,
                          @"vcode" : self.codeText.text,
                          @"os" : @"0",
                          @"clientid" : [ConfigModel getStringforKey:GTclientId],
                          };
    WeakSelf(weak);
    [HttpRequest postPath:@"Public/login" params:dic resultBlock:^(id responseObject, NSError *error) {
        if([error isEqual:[NSNull null]] || error == nil){
            NSLog(@"success");
        }
        NSDictionary *datadic = responseObject;
        if ([datadic[@"success"] intValue] == 1) {
            
            NSDictionary *data = datadic[@"data"];
            NSString *phone = data[@"phone"];
            NSString *nick_name = [NSString stringWithFormat:@"%@",data[@"nick_name"]];
            NSString *head_imgurl = data[@"head_imgurl"];
            NSString *user_token = data[@"user_token"];
            [ConfigModel saveBoolObject:YES forKey:IsLogin];
            [ConfigModel saveString:user_token forKey:UserToken];
            [ConfigModel saveString:phone forKey:User_phone];
            [ConfigModel saveString:nick_name forKey:User_nickname];
            [ConfigModel saveString:head_imgurl forKey:User_headimage];
            if ([data[@"status"] intValue] == 0) {
                [ConfigModel saveBoolObject:YES forKey:User_State];
            }else {
                [ConfigModel saveBoolObject:NO forKey:User_State];
            }
            
            [weak dismissViewControllerAnimated:YES completion:nil];
            
        }else {
            NSString *str = datadic[@"msg"];
            [ConfigModel mbProgressHUD:str andView:nil];
        }
    }];
}

- (IBAction)weichatClick:(id)sender {
    
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_WechatSession currentViewController:nil completion:^(id result, NSError *error) {
        if (error) {
            NSLog(@"...%@", error);
        } else {
            UMSocialUserInfoResponse *resp = result;
            
            // 授权信息
            NSLog(@"Wechat uid: %@", resp.uid);
            NSLog(@"Wechat openid: %@", resp.openid);
            NSLog(@"Wechat unionid: %@", resp.unionId);
            NSLog(@"Wechat accessToken: %@", resp.accessToken);
            NSLog(@"Wechat refreshToken: %@", resp.refreshToken);
            NSLog(@"Wechat expiration: %@", resp.expiration);
            
            // 用户信息
            NSLog(@"Wechat name: %@", resp.name);
            NSLog(@"Wechat iconurl: %@", resp.iconurl);
            NSLog(@"Wechat gender: %@", resp.unionGender);
            
            // 第三方平台SDK源数据
            NSLog(@"Wechat originalResponse: %@", resp.originalResponse);
            
            
            NSDictionary *dic = @{
                                  @"wx_openid" : resp.openid,
                                  @"clientid" : [ConfigModel getStringforKey:GTclientId],
                                  @"os" : @"0"
                                  };
            WeakSelf(weak);
            [HttpRequest postPath:@"Public/wxlogin" params:dic resultBlock:^(id responseObject, NSError *error) {
                if([error isEqual:[NSNull null]] || error == nil){
                    NSLog(@"success");
                }
                NSDictionary *datadic = responseObject;
                if ([datadic[@"success"] intValue] == 1) {
                    
                    NSDictionary *data = datadic[@"data"];
                    if (IsNULL(data)) {
                        AddmobileViewController *vc = [[AddmobileViewController alloc] init];
                        vc.wx_openid = resp.openid;
                        vc.wx_nickname = resp.name;
                        vc.wx_headimgurl = resp.iconurl;
                        [weak.navigationController pushViewController:vc animated:YES];
                        return ;
                    }
                    NSString *phone = data[@"phone"];
                    NSString *nick_name = [NSString stringWithFormat:@"%@",data[@"nick_name"]];
                    NSString *head_imgurl = data[@"head_imgurl"];
                    NSString *user_token = data[@"user_token"];
                    [ConfigModel saveBoolObject:YES forKey:IsLogin];
                    [ConfigModel saveString:user_token forKey:UserToken];
                    [ConfigModel saveString:phone forKey:User_phone];
                    [ConfigModel saveString:nick_name forKey:User_nickname];
                    [ConfigModel saveString:head_imgurl forKey:User_headimage];
                    if ([data[@"status"] intValue] == 0) {
                        [ConfigModel saveBoolObject:YES forKey:User_State];
                    }else {
                        [ConfigModel saveBoolObject:NO forKey:User_State];
                    }
                    
                    [weak dismissViewControllerAnimated:YES completion:nil];
                    
                }else {
                    NSString *str = datadic[@"msg"];
                    [ConfigModel mbProgressHUD:str andView:nil];
                }
            }];
            
           
            
        }
    }];
}

- (IBAction)userAgreeClick:(id)sender {
    CCWebViewViewController *vc = [[CCWebViewViewController alloc] init];
    vc.titlestr = @"注册协议";
    vc.UrlStr = @"http://116.62.142.20/Public/zcxy";
    [self.navigationController pushViewController:vc animated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


@end
