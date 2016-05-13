//
//  registerViewController.m
//  yuanli
//
//  Created by 代忙 on 16/3/4.
//  Copyright © 2016年 wxw. All rights reserved.
//

#import "registerViewController.h"
#import "setMessageViewController.h"

@interface registerViewController ()
{
    NSNumber* code;
}

@property (strong, nonatomic) IBOutlet UITextField *mobileTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UITextField *codeTextFiled;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;

@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;



- (IBAction)getCodeBtn:(UIButton *)sender;
- (IBAction)registerBtn:(UIButton *)sender;

@end

@implementation registerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"注册";
    
//    [CrazyAutoLayout layoutOfSuperView:self.view];
    [FrameSize MLBFrameSize:self.view];
    
    self.registerBtn.layer.cornerRadius = 5;
    self.registerBtn.layer.masksToBounds = YES;
    
    self.getCodeBtn.layer.cornerRadius = 2;
    self.getCodeBtn.layer.masksToBounds = YES;
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    
    // Dispose of any resources that can be recreated.
}

- (IBAction)getCodeBtn:(UIButton *)sender {
    
    if ([easyflyRegular validatePhone:self.mobileTextField.text]) {
        if (self.passwordTextField.text.length>=6) {
            [HTTPRequest requestWitUrl:@"" andArgument:@{@"service":SendCode_IF,@"phone_number":_mobileTextField.text} andType:WXHTTPRequestGet Finished:^(NSURLResponse *response, NSDictionary *requestDic) {
                NSLog(@"%@",requestDic);
                NSDictionary* dic = requestDic[@"data"];
                if ([dic[@"code"] isEqualToNumber:@1]) {
                    NSDictionary* data = dic[@"data"];
                    code = data[@"code"];
                    NSLog(@"%@",code);
                }
            } Falsed:^(NSError *error) {
                
            }];
        }else
        {
            UIAlertAction* action = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"密码至少6位数" preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:action];
            [self presentViewController:alertController animated:YES completion:^{
                
            }];
        }
        
        
        
    }else
    {
        UIAlertAction* action = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入正确的手机号码" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:action];
        [self presentViewController:alertController animated:YES completion:^{
            
        }];
    }
    
    
    
    
    
}

- (IBAction)registerBtn:(UIButton *)sender {
    
    if ([self.codeTextFiled.text integerValue] == code.integerValue && self.codeTextFiled.text.length>0) {
        setMessageViewController* message = [[setMessageViewController alloc]init];
        message.mobile = self.mobileTextField.text;
        message.password = self.passwordTextField.text;
        [self.navigationController pushViewController:message animated:YES];
    }else
    {
        UIAlertAction* action = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入正确的验证码" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:action];
        [self presentViewController:alertController animated:YES completion:^{
            
        }];
    }
    
    
}
@end
