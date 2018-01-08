//
//  ChangeInfoViewController.m
//  BaseProject
//
//  Created by cc on 2018/1/3.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "ChangeInfoViewController.h"

@interface ChangeInfoViewController ()
@property (weak, nonatomic) IBOutlet UITextField *text;

@end

@implementation ChangeInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self resetFather];
    self.text.placeholder = self.userName;
}

- (void)resetFather {
    self.rightBar.hidden = YES;
    self.titleLab.text = @"修改成员昵称";
    
}
- (IBAction)touch:(id)sender {
    [self.text resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (IBAction)save:(id)sender {
    if (self.text.text.length <= 0) {
        [ConfigModel mbProgressHUD:@"请输入昵称" andView:nil];
        return;
    }
    NSDictionary *dic = @{
                          @"un_user_id":  self.userId,
                          @"remark" :self.text.text
                          };
    [HttpRequest postPath:@"Lock/setRemark" params:dic resultBlock:^(id responseObject, NSError *error) {
        if([error isEqual:[NSNull null]] || error == nil){
            NSLog(@"success");
        }
        NSDictionary *datadic = responseObject;
        if ([datadic[@"success"] intValue] == 1) {
            [ConfigModel mbProgressHUD:@"修改该成功" andView:nil];
            [self.navigationController popViewControllerAnimated:YES];
            
        }else {
            NSString *str = datadic[@"msg"];
            [ConfigModel mbProgressHUD:str andView:nil];
        }
    }];
    
    
}


@end
