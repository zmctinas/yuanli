//
//  newPasswordViewController.m
//  yuanli
//
//  Created by 代忙 on 16/3/7.
//  Copyright © 2016年 wxw. All rights reserved.
//

#import "newPasswordViewController.h"

@interface newPasswordViewController ()

@property (strong, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

- (IBAction)loginBtn:(UIButton *)sender;


@end

@implementation newPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"输入新密码";
//    [CrazyAutoLayout layoutOfSuperView:self.view];
    [FrameSize MLBFrameSize:self.view];

    self.loginBtn.layer.masksToBounds = YES;
    self.loginBtn.layer.cornerRadius = 2;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginBtn:(UIButton *)sender {
    
    if (self.passwordField.text.length>=6) {
        [HTTPRequest requestWitUrl:@"" andArgument:@{
                                 @"service":UPPassWord_IF,
                             @"phone_number":self.
                                     mobile,
                                 @"password":[MyMD5 md32:self.passwordField.text]
                                                     } andType:WXHTTPRequestGet Finished:^(NSURLResponse *response, NSDictionary *requestDic) {
            NSLog(@"%@",requestDic);
            NSDictionary* dic = requestDic[@"data"];
                                                         
             NSLog(@"%@",requestDic[@"msg"]);
            if ([dic[@"code"] isEqualToNumber:@1]) {
//                NSDictionary* data = dic[@"data"];
                
                UIViewController* controller = self.navigationController.viewControllers[1];
                
                [self.navigationController popToViewController:controller animated:YES];
            }
        } Falsed:^(NSError *error) {
            
        }];
    }
    
    
}
@end
