//
//  weixinWitdrawalTypeViewController.m
//  yuanli
//
//  Created by 代忙 on 16/3/26.
//  Copyright © 2016年 wxw. All rights reserved.
//

#import "weixinWitdrawalTypeViewController.h"
#import "withdrawalRecordViewController.h"

@interface weixinWitdrawalTypeViewController ()
{
    NSDictionary* codeDic;
}

@property (strong, nonatomic) IBOutlet UITextField *acountField;

@property (weak, nonatomic) IBOutlet UIButton *clickBtn;
@property (weak, nonatomic) IBOutlet UIButton *withdrawalBtn;


- (IBAction)getAcountBtn:(UIButton *)sender;

- (IBAction)withDrawalBtn:(UIButton *)sender;


@end

@implementation weixinWitdrawalTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"微信账号";
    
    [FrameSize MLBFrameSize:self.view];
    
    if ([[USERDefaults objectForKey:@"wei_pay"] length]>0) {
        self.acountField.text = [USERDefaults objectForKey:@"wei_pay"];
    }
    
    [self setUpUI];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private

-(void)setUpUI
{
    self.clickBtn.layer.masksToBounds = YES;
    self.clickBtn.layer.cornerRadius = 2;
    self.clickBtn.layer.borderWidth = 1;
    self.clickBtn.layer.borderColor = [UIColor colorWithHexString:@"#d82b2b"].CGColor;
    
    self.withdrawalBtn.layer.masksToBounds = YES;
    self.withdrawalBtn.layer.cornerRadius = 2;
    
}

-(void)requestdate
{
    
    
    [HTTPRequest requestWitUrl:@"" andArgument:_messageDic andType:WXHTTPRequestGet Finished:^(NSURLResponse *response, NSDictionary *requestDic) {
        NSLog(@"%@",requestDic);
        
        if ([requestDic[@"data"][@"code"] isEqualToNumber:@0]) {
            NSLog(@"%@",requestDic[@"data"][@"msg"]);
            NSLog(@"%@",requestDic[@"msg"]);
        }else if ([requestDic[@"data"][@"code"] isEqualToNumber:@1])
        {
            withdrawalRecordViewController* record = [[withdrawalRecordViewController alloc]init];
            record.isRootPush = YES;
            [self.navigationController pushViewController:record animated:YES];
        }
        
    } Falsed:^(NSError *error) {
        
    }];
}

-(void)requestMessage
{
    
    NSDictionary* dic = @{@"service":GetOpenId_IF,
                          
                          @"user_id":UID,
                          @"code":codeDic[@"code"],
                          
                          };
    [HTTPRequest requestWitUrl:@"" andArgument:dic andType:WXHTTPRequestGet Finished:^(NSURLResponse *response, NSDictionary *requestDic) {
        NSLog(@"%@",requestDic);
        NSLog(@"%@",requestDic[@"msg"]);
        
        if ([requestDic[@"data"][@"code"] isEqualToNumber:@1]) {
            self.acountField.text = requestDic[@"data"][@"data"][@"openid"];
            [USERDefaults setObject:requestDic[@"data"][@"data"][@"openid"] forKey:@"wei_pay"];
            [USERDefaults synchronize];
        }
        
    } Falsed:^(NSError *error) {
        
    }];
}

-(void)sendAuthRequest
{
    
    [weixinObject getOpenid:^(NSDictionary *dic) {
        NSLog(@"%@",dic);
        
        codeDic = dic;
        
        [self requestMessage];
        
    }];
}

#pragma mark - xib

- (IBAction)getAcountBtn:(UIButton *)sender {
    
    [self sendAuthRequest];
    
}

- (IBAction)withDrawalBtn:(UIButton *)sender {
    
    [self requestdate];
    
}
@end
