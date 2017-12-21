//
//  AddmobileViewController.m
//  BaseProject
//
//  Created by cc on 2017/12/12.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "AddmobileViewController.h"

@interface AddmobileViewController ()

@property (weak, nonatomic) IBOutlet UITextField *phoneText;
@property (weak, nonatomic) IBOutlet UITextField *codetext;
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;
@property (weak, nonatomic) IBOutlet UIButton *LoginBtn;

@end

@implementation AddmobileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.rightBar.hidden = YES;
    self.line.hidden = YES;
    self.LoginBtn.layer.masksToBounds = YES;
    self.LoginBtn.layer.cornerRadius= 20;
    self.LoginBtn.userInteractionEnabled = NO;
    [self.phoneText addTarget:self action:@selector(textchange) forControlEvents:UIControlEventEditingChanged];
    [self.codetext addTarget:self action:@selector(textchange) forControlEvents:UIControlEventEditingChanged];
    
}
- (void)textchange {
    if (self.phoneText.text.length == 11 && self.codetext.text.length == 4) {
        self.LoginBtn.userInteractionEnabled = YES;
        self.LoginBtn.backgroundColor = RGBColor(102, 143, 218);
        [self.LoginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
}

- (IBAction)codeBtnClick:(id)sender {
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
                        
                        [weak.codeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                        [weak.codeBtn setTitle:@"重获验证码" forState:UIControlStateNormal];
                        weak.codeBtn .userInteractionEnabled = YES;
                    });
                }else{
                    int seconds = timeout % 60;
                    NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //设置界面的按钮显示 根据自己需求设置
                        [weak.codeBtn setTitleColor:UIColorFromHex(0x666666) forState:UIControlStateNormal];
                        [weak.codeBtn setTitle:[NSString stringWithFormat:@"(%@s)",strTime] forState:UIControlStateNormal];
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
    /*
     wx_openid：微信openid
     wx_headimgurl：微信headimgurl
     wx_nickname：微信nickname
     */
    
    NSDictionary *dic = @{
                          @"phone" : self.phoneText.text,
                          @"vcode" : self.codetext.text,
                          @"wx_openid" : self.wx_openid,
                          @"wx_headimgurl" : self.wx_headimgurl,
                          @"wx_nickname" : self.wx_nickname,
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
