//
//  aliAcountViewController.m
//  yuanli
//
//  Created by 代忙 on 16/4/6.
//  Copyright © 2016年 wxw. All rights reserved.
//

#import "aliAcountViewController.h"
#import "withdrawalRecordViewController.h"

@interface aliAcountViewController ()

@property (strong, nonatomic) IBOutlet UITextField *aliAcoutnField;
@property (strong, nonatomic) IBOutlet UITextField *reAliAcountField;
- (IBAction)withdrawalBtn:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITextField *realNameField;
@property (weak, nonatomic) IBOutlet UIButton *withdrawlBtn;

- (IBAction)addBtn:(UIButton *)sender;



@end

@implementation aliAcountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"支付宝账号";
    
    [FrameSize MLBFrameSize:self.view];
    
    // Do any additional setup after loading the view from its nib.
    
    self.withdrawlBtn.layer.masksToBounds = YES;
    self.withdrawlBtn.layer.cornerRadius = 2;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)addAli_pay
{
    
    NSDictionary* dic = @{@"service":AddAliPay_IF,
                          
                          @"user_id":UID,
                          @"ali_pay":self.aliAcoutnField.text,
                          
                          };
    NSLog(@"%@",dic);
    [HTTPRequest requestWitUrl:@"" andArgument:dic andType:WXHTTPRequestGet Finished:^(NSURLResponse *response, NSDictionary *requestDic) {
        NSLog(@"%@",requestDic);
        NSLog(@"%@",requestDic[@"msg"]);
        
        
        if ([requestDic[@"data"][@"code"] isEqualToNumber:@1]) {
            [USERDefaults setObject:self.aliAcoutnField.text forKey:@"ali_pay"];
            [USERDefaults synchronize];
            [self requestMessage];
        }else if ([requestDic[@"data"][@"code"] isEqualToNumber:@0])
        {
            NSLog(@"%@",requestDic[@"msg"]);
            NSLog(@"%@",requestDic[@"data"][@"msg"]);
        }
        
    } Falsed:^(NSError *error) {
        
    }];
}
-(void)requestMessage
{
    
    
    [HTTPRequest requestWitUrl:@"" andArgument:_messageDic andType:WXHTTPRequestGet Finished:^(NSURLResponse *response, NSDictionary *requestDic) {
        NSLog(@"%@",requestDic);
        
        if ([requestDic[@"data"][@"code"] isEqualToNumber:@0]) {
            NSLog(@"%@",requestDic[@"data"][@"msg"]);
            NSLog(@"%@",requestDic[@"msg"]);
        }else if ([requestDic[@"data"][@"code"] isEqualToNumber:@1])
        {
            UIAlertAction* action = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                withdrawalRecordViewController* record = [[withdrawalRecordViewController alloc]init];
                record.isRootPush = YES;
                [self.navigationController pushViewController:record animated:YES];
            }];
            UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"领取" message:@"领取信息已提交,请注意查收\n(预计72小时内到账，节假日顺延)" preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:action];
            [self presentViewController:alertController animated:YES completion:^{
                
            }];
            
        }
        
    } Falsed:^(NSError *error) {
        
    }];
}

- (IBAction)withdrawalBtn:(UIButton *)sender {
    
    
    if ([self.aliAcoutnField.text isEqualToString:self.reAliAcountField.text]&&![self.aliAcoutnField.text isEqualToString:[USERDefaults objectForKey:@"ali_pay"]]) {
        if (self.realNameField.text.length>0) {
            [self addAli_pay];
        }else
        {
            UIAlertAction* action = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入真实姓名" preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:action];
            [self presentViewController:alertController animated:YES completion:^{
                
            }];

        }
        
    }else
    {
        UIAlertAction* action = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"两次输入不一致或账号以添加" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:action];
        [self presentViewController:alertController animated:YES completion:^{
            
        }];
    }
    
    
    
}


@end
