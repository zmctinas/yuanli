//
//  WXLoginViewController.m
//  yuanli
//
//  Created by 代忙 on 16/3/4.
//  Copyright © 2016年 wxw. All rights reserved.
//

#import "WXLoginViewController.h"
#import "registerViewController.h"
#import "resetPswViewController.h"


@interface WXLoginViewController ()

@property (strong, nonatomic) IBOutlet UITextField *mobileField;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;




- (IBAction)loginBtn:(UIButton *)sender;
- (IBAction)registerBtn:(UIButton *)sender;
- (IBAction)resetAcountBtn:(UIButton *)sender;


@end

@implementation WXLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [CrazyAutoLayout layoutOfSuperView:self.view];
    [FrameSize MLBFrameSize:self.view];
    UIScrollView* scroll = (UIScrollView*)[self.view viewWithTag:230103];
    if (scroll) {
        scroll.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0);
    }
    
    self.loginBtn.layer.masksToBounds = YES;
    self.loginBtn.layer.cornerRadius = 5;
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (IBAction)loginBtn:(UIButton *)sender {
    
    if ([easyflyRegular validatePhone:self.mobileField.text]) {
        NSDictionary* dic = @{@"service":LOGIN_IF,
                              @"phone_number":self.mobileField.text,
                              @"password":[MyMD5 md32:self.passwordField.text],
                              
                              };
        NSMutableDictionary* messageDic = [NSMutableDictionary dictionaryWithDictionary:dic];
        if (RegistrationID) {
            [messageDic setObject:@"registration_id" forKey:RegistrationID];
        }
        NSLog(@"%@",dic);
        [HTTPRequest requestWitUrl:@"" andArgument:messageDic andType:WXHTTPRequestGet Finished:^(NSURLResponse *response, NSDictionary *requestDic) {
            
            NSDictionary* dic = requestDic[@"data"];
            if ([dic[@"code"] isEqualToNumber:@1]) {
                NSLog(@"登陆成功");
                NSLog(@"%@",requestDic);
                NSDictionary* data = dic[@"data"];
                NSUserDefaults* userdefaults = [NSUserDefaults standardUserDefaults];
                [userdefaults setObject:self.passwordField.text forKey:@"PSD"];
                [userdefaults setObject:self.mobileField.text forKey:@"Mobile"];
                [userdefaults setObject:data[@"user_id"] forKey:@"UID"];
                [userdefaults setObject:data[@"sex"] forKey:@"SEX"];
                [userdefaults setObject:data[@"user_name"] forKey:@"userName"];
                [userdefaults setObject:data[@"height"] forKey:@"height"];
                [userdefaults setObject:data[@"weight"] forKey:@"weight"];
                NSString* st =[data[@"photo"] isKindOfClass:[NSNull class]]?@"":data[@"photo"];
                if ([data[@"photo"] isKindOfClass:[NSNull class]]) {
                    st = @"";
                }
                NSLog(@"%@",st);
                [userdefaults setObject:[data[@"photo"] isKindOfClass:[NSNull class]]?@"":data[@"photo"] forKey:@"PHOTO"];
                [userdefaults setObject:data[@"is_buy"] forKey:@"IS_BUY"];
                NSDictionary* cur_step = data[@"cur_step"];
                [userdefaults setObject:cur_step[@"calorie"] forKey:@"calorie"];
                [userdefaults setObject:cur_step[@"distance"] forKey:@"distance"];
                [userdefaults setObject:cur_step[@"step_num"] forKey:@"step_num"];
                [userdefaults setBool:YES forKey:@"isLogin"];
                [USERDefaults setObject:@"0" forKey:@"WXStepCount"];
                [USERDefaults setObject:@"0" forKey:@"toDayStepNum"];
                
                [userdefaults synchronize];
                
                [self.navigationController popToRootViewControllerAnimated:YES];
                
            }else
            {
                NSLog(@"%@",dic[@"msg"]);
                UIAlertAction* action = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"提示" message:dic[@"msg"] preferredStyle:UIAlertControllerStyleAlert];
                [alertController addAction:action];
                [self presentViewController:alertController animated:YES completion:^{
                    
                }];
            }
            
            NSLog(@"%@",requestDic[@"msg"]);
            
        } Falsed:^(NSError *error) {
            
        }];
    }else
    {
        UIAlertAction* action = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入正确的电话号码" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:action];
        [self presentViewController:alertController animated:YES completion:^{
            
        }];
    }
    
}

- (IBAction)registerBtn:(UIButton *)sender {
    
    registerViewController* reg = [[registerViewController alloc]init];
    [self.navigationController pushViewController:reg animated:YES];
    
}

- (IBAction)resetAcountBtn:(UIButton *)sender {
    
    resetPswViewController* reset = [[resetPswViewController alloc]init];
    [self.navigationController pushViewController:reset animated:YES];
    
    
}
@end
