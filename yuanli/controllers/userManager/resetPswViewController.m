//
//  resetPswViewController.m
//  yuanli
//
//  Created by 代忙 on 16/3/7.
//  Copyright © 2016年 wxw. All rights reserved.
//

#import "resetPswViewController.h"
#import "newPasswordViewController.h"

@interface resetPswViewController ()
{
    NSNumber* code;
}

@property (strong, nonatomic) IBOutlet UITextField *mobileField;
@property (strong, nonatomic) IBOutlet UITextField *codeField;
@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *reSetBtn;


- (IBAction)getCodeBtn:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *reSetPasswordBtn;

- (IBAction)reSetPassword:(UIButton *)sender;


@end

@implementation resetPswViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"忘记密码";
    
//    [CrazyAutoLayout layoutOfSuperView:self.view];
    [FrameSize MLBFrameSize:self.view];
    
    self.reSetPasswordBtn.layer.cornerRadius = 5;
    self.reSetPasswordBtn.layer.masksToBounds = YES;

    [self setUpUI];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setUpUI
{
    self.getCodeBtn.layer.masksToBounds = YES;
    self.getCodeBtn.layer.cornerRadius = 2;
    self.reSetBtn.layer.masksToBounds = YES;
    self.reSetBtn.layer.cornerRadius = 2;
}

- (IBAction)getCodeBtn:(UIButton *)sender {
    
    if ([easyflyRegular validatePhone:self.mobileField.text]) {
        [HTTPRequest requestWitUrl:@"" andArgument:@{@"service":SendCode_IF,@"phone_number":self.mobileField.text} andType:WXHTTPRequestGet Finished:^(NSURLResponse *response, NSDictionary *requestDic) {
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
        UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入正确的手机号" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:action];
        [self presentViewController:alertController animated:YES completion:^{
            
        }];
    }
    
    
}

- (IBAction)reSetPassword:(UIButton *)sender {
    
    if ([self.codeField.text integerValue] == code.integerValue && self.codeField.text.length>0) {
        
        newPasswordViewController* newPass = [[newPasswordViewController alloc]init];
        newPass.mobile = self.mobileField.text;
        [self.navigationController pushViewController:newPass animated:YES];
        
        
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
