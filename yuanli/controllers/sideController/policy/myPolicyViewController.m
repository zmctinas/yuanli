//
//  myPolicyViewController.m
//  yuanli
//
//  Created by 代忙 on 16/3/18.
//  Copyright © 2016年 wxw. All rights reserved.
//

#import "myPolicyViewController.h"
#import "policyRecordViewController.h"
#import "withdrawalRecordViewController.h"
#import "withDrawlViewController.h"
#import "payRecordViewController.h"

@interface myPolicyViewController ()
{
    NSString* remainMoney;
}

@property(strong,nonatomic)UIBarButtonItem* leftItem;

@property (strong, nonatomic) IBOutlet UILabel *balanceLabel;
@property (strong, nonatomic) IBOutlet UILabel *TotalRevenueLabel;
@property (strong, nonatomic) IBOutlet UILabel *actBalanceLabel;
@property (weak, nonatomic) IBOutlet UIView *BackView;
@property (weak, nonatomic) IBOutlet UIButton *withdrawalBtn;
@property (weak, nonatomic) IBOutlet UILabel *profitLabel;



- (IBAction)withdrawalRecordBtn:(UIButton *)sender;

- (IBAction)policyRecordBtn:(UIButton *)sender;

- (IBAction)withdrawalBtn:(UIButton *)sender;

@end

@implementation myPolicyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的健身卡";
    
    if (_isRootPush) {
        self.navigationItem.leftBarButtonItem = self.leftItem;
    }
    
    [FrameSize MLBFrameSize:self.view];
    
    UIScrollView* scroll = (UIScrollView*)[self.view viewWithTag:230103];
    if (scroll) {
        scroll.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0);
    }
    
    [self setUpUI];
    
    [self requestMessage];
    
    _balanceLabel.adjustsFontSizeToFitWidth = YES;
    _TotalRevenueLabel.adjustsFontSizeToFitWidth = YES;
    
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - getter

-(UIBarButtonItem*)leftItem
{
 
    if (_leftItem == nil) {
        
        UIButton* btn = [UIButton buttonWithType:0];
        btn.frame = CGRectMake(0, 0, 40, 40);
        [btn setImage:[UIImage imageNamed:@"top_btn_fanhui.png"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];
        _leftItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    }
    return _leftItem;
}


#pragma mark - private

-(void)setUpUI
{
    self.BackView.layer.cornerRadius = 8;
    self.BackView.layer.borderWidth = 3;
    self.BackView.layer.borderColor = [UIColor colorWithHexString:@"#d83b3b"].CGColor;
    self.BackView.layer.masksToBounds = YES;
    
    self.withdrawalBtn.layer.cornerRadius = 4;
    self.withdrawalBtn.layer.borderWidth = 2;
    self.withdrawalBtn.layer.borderColor = [UIColor colorWithHexString:@"#1f1f33"].CGColor;
    self.withdrawalBtn.layer.masksToBounds = YES;
}

-(void)backBtn:(UIButton*)button
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)requestMessage
{
    
    NSDictionary* dic = @{@"service":BALANCE_IF,
                          
                          @"user_id":UID,
                          
                          };
    [HTTPRequest requestWitUrl:@"" andArgument:dic andType:WXHTTPRequestGet Finished:^(NSURLResponse *response, NSDictionary *requestDic) {
        NSLog(@"%@",requestDic);
        NSLog(@"%@",requestDic[@"msg"]);
        
        NSDictionary* data = requestDic[@"data"][@"data"];
        _balanceLabel.text = [data[@"balance"] floatValue]>0?data[@"balance"]:@"0.00";
        
        _profitLabel.text = [NSString stringWithFormat:@"%.2f",[data[@"profit"] floatValue]];
        
        [USERDefaults setObject:_balanceLabel.text forKey:@"Balance"];
        [USERDefaults synchronize];
        _TotalRevenueLabel.text = [data[@"cumulative"] floatValue]>0?data[@"cumulative"]:@"0.00";
        //[NSString stringWithFormat:@"可提现%@元",[data[@"balance"] floatValue]>0?data[@"balance"]:@"0.00"];
        _actBalanceLabel.text = [NSString stringWithFormat:@"可提现%@元",[data[@"cash"] length]>0?[NSString stringWithFormat:@"%.2f",[data[@"cash"] floatValue]]:@"0.00"];
        remainMoney = [data[@"cash"] length]>0?[NSString stringWithFormat:@"%.2f",[data[@"cash"] floatValue]]:@"0.00";
        
    } Falsed:^(NSError *error) {
        
    }];
}

#pragma mark - xib

- (IBAction)withdrawalBtn:(UIButton *)sender {
    
//    if (!self.actBalanceLabel.text.integerValue>0) {
//        [self.view makeToast:@"可领取金额为0,无法领取"];
//        return;
//    }
    withDrawlViewController* select = [[withDrawlViewController alloc]init];
    select.remainderMoney = remainMoney;
    [self.navigationController pushViewController:select animated:YES];
    
}
- (IBAction)withdrawalRecordBtn:(UIButton *)sender {
    
    withdrawalRecordViewController* record = [[withdrawalRecordViewController alloc]init];
    [self.navigationController pushViewController:record animated:YES];
    
}

- (IBAction)policyRecordBtn:(UIButton *)sender {
    
    payRecordViewController* record = [[payRecordViewController alloc]init];
    [self.navigationController pushViewController:record animated:YES];
    
}
@end
