//
//  activityViewController.m
//  yuanli
//
//  Created by 代忙 on 16/3/16.
//  Copyright © 2016年 wxw. All rights reserved.
//

#import "activityViewController.h"
#import "actRulesViewController.h"
#import "securityViewController.h"
#import "theOrderViewController.h"

@interface activityViewController ()<UITextFieldDelegate>
{
    NSInteger num;
    NSInteger max;
    NSInteger min;
    CGFloat money;
    NSMutableDictionary* messageDic;
}
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *buyBtn;

@property (strong, nonatomic) IBOutlet UILabel *contentLabel;
@property (strong, nonatomic) IBOutlet UILabel *interestLabel;
//@property (strong, nonatomic) IBOutlet UILabel *minLabel;
//@property (strong, nonatomic) IBOutlet UILabel *maxLabel;
@property (strong, nonatomic) IBOutlet UILabel *remainderLabel;
@property (strong, nonatomic) IBOutlet UILabel *totalMoneyLabel;
@property (strong, nonatomic) IBOutlet UILabel *moneyLabel;
@property (strong, nonatomic) IBOutlet UITextField *numLabel;

@property (strong, nonatomic) IBOutlet UIButton *minusBtn;

- (IBAction)endEditing:(UITextField *)sender;


- (IBAction)changeNumBtn:(UIButton *)sender;

- (IBAction)popBtn:(UIButton *)sender;
- (IBAction)actRulesBtn:(UIButton *)sender;
- (IBAction)securityBtn:(UIButton *)sender;
- (IBAction)gobuyBtn:(UIButton *)sender;




@end

@implementation activityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [FrameSize MLBFrameSize:self.view];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    messageDic = [NSMutableDictionary dictionary];
    self.minusBtn.enabled = NO;
    
    [self setUpUI];
    
    [self getremainder];
    
//    [self getActivityMessage];
    
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

#pragma mark - UITextFieldDelegate



#pragma mark - private

-(void)setUpUI
{
//    self.minLabel.adjustsFontSizeToFitWidth = YES;
//    self.maxLabel.adjustsFontSizeToFitWidth = YES;
    self.remainderLabel.adjustsFontSizeToFitWidth = YES;
    
    self.buyBtn.layer.cornerRadius = 4;
    self.buyBtn.layer.masksToBounds = YES;
    
    self.nameLabel.text = self.model.title;
    self.interestLabel.text = [NSString stringWithFormat:@"%.1f%@年化收益",self.model.interest.floatValue*100.0f,@"%"];
    self.moneyLabel.text = [NSString stringWithFormat:@"一天内完成%@步为一次",self.model.step];
    self.contentLabel.text = [NSString stringWithFormat:@"须完成%@次",self.model.num];
    self.remainderLabel.text = [NSString stringWithFormat:@"%ld元一份",self.model.min.integerValue * self.model.money.integerValue];
    
}

-(void)getremainder
{
    NSDictionary* dic = @{@"service":GetRemainder_IF,
                          
                          @"user_id":UID,
                          @"act_id":self.model.id,
                          
                          };
    
    [HTTPRequest requestWitUrl:@"" andArgument:dic andType:WXHTTPRequestGet Finished:^(NSURLResponse *response, NSDictionary *requestDic) {
        NSLog(@"%@",requestDic);
        
        NSDictionary* data = requestDic[@"data"];
        NSNumber* code = data[@"code"];
        if ([code isEqualToNumber:@1]) {
            NSDictionary* dic = data[@"data"];
            max = [dic[@"remainder"] integerValue];
        }
        
    } Falsed:^(NSError *error) {
        
    }];
    
}

//获取订单信息
-(void)getActivityMessage
{
    NSDictionary* dic = @{@"service":ACTIVITY_IF,
                          
                          @"big":[NSNumber numberWithInt:1],
                          
                          };
    [HTTPRequest requestWitUrl:@"" andArgument:dic andType:WXHTTPRequestGet Finished:^(NSURLResponse *response, NSDictionary *requestDic) {
        NSLog(@"%@",requestDic);
        NSDictionary* data = requestDic[@"data"][@"data"];
//        NSInteger cou = ([data[@"interest"]integerValue]*1000);
        CGFloat interest = (float)(([data[@"interest"]floatValue]*1000)/(360/[data[@"num"] integerValue]));
        NSString* attStr = [NSString stringWithFormat:@"%.0f%@%@诚意金",interest,@"‰",@"×"];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:attStr];
        
//        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:50] range:NSMakeRange(0, attStr.length - 4)];
//        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(attStr.length - 4,4)];
        self.interestLabel.attributedText = str;
        
//        self.moneyLabel.text = [NSString stringWithFormat:@"%d元一份",[data[@"money"] intValue]];
        money = [data[@"money"] floatValue];
        _contentLabel.text = data[@"content"];
        
//        _minLabel.text = [NSString stringWithFormat:@"%@份起购",data[@"min"]];
        min = [data[@"min"] integerValue];
        num = 0;
        [self setTotalPrice:num];
//        _numLabel.text = [NSString stringWithFormat:@"%ld份",(long)min];
        
        NSString* attString = [NSString stringWithFormat:@"%ld元一份，剩余总份数:%@份",[data[@"money"] integerValue],data[@"remainder"]];
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:attString];
        
        [string addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#555555"] range:NSMakeRange(0, 6)];
        [string addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#f86d6d"] range:NSMakeRange(6,attString.length - 6)];
        
        self.remainderLabel.attributedText = string;
//        max = [data[@"remainder"] integerValue];
//        max = 99999999;
//        if ([data[@"max"] integerValue] == 0) {
//           _maxLabel.text = @"不封顶";
//        }else
//        {
//            _maxLabel.text = [NSString stringWithFormat:@"%@份封顶",data[@"remainder"]];
//        }
        
//        [messageDic setDictionary:requestDic[@"data"][@"data"]];
//        
//        for (NSString* str in [requestDic[@"data"][@"data"] allKeys]) {
//            NSLog(@"%@  %@",str,[requestDic[@"data"][@"data"]objectForKey:str]);
//        }
    } Falsed:^(NSError *error) {
        
    }];
}

-(void)setTotalPrice:(NSInteger)number
{
//    NSString* attStr = [NSString stringWithFormat:@"诚意金额:￥%.2f",money*number];
//    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:attStr];
//    
//    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#555555"] range:NSMakeRange(0, 5)];
//    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#f86d6d"] range:NSMakeRange(5,attStr.length - 5)];
//    self.totalMoneyLabel.attributedText = str;
    self.totalMoneyLabel.text = [NSString stringWithFormat:@"￥%.2f",self.model.money.floatValue*number];
}

#pragma mark - xib

- (IBAction)endEditing:(UITextField *)sender {
    
    
    if (self.model.max.integerValue != 0) {
        if (sender.text.integerValue>max) {
            sender.text = [NSString stringWithFormat:@"%ld",max];
            [self.view makeToast:[NSString stringWithFormat:@"本项最高还可购买%ld份",max]];
        }
        
    }else
    {
        
    }
    
    if (num <= min) {
        self.minusBtn.enabled = NO;
    }else
    {
        self.minusBtn.enabled = YES;
    }
    
    num = sender.text.integerValue;
    [self setTotalPrice:num];
    
}

- (IBAction)changeNumBtn:(UIButton *)sender {
    
    if (sender.tag == 10) {
        num = num==min?min:--num;
    }else
    {
        num ++;
        if (self.model.max.integerValue !=0) {
            
            if (num>max) {
                num = max;
                [self.view makeToast:[NSString stringWithFormat:@"本项最高还可购买%ld份",max]];
            }
            
        }
        
    }
    
    if (num <= min) {
        self.minusBtn.enabled = NO;
    }else
    {
        self.minusBtn.enabled = YES;
    }
    
    _numLabel.text = [NSString stringWithFormat:@"%ld",(long)num];
    [self setTotalPrice:num];
}

- (IBAction)popBtn:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)actRulesBtn:(UIButton *)sender {
    
    actRulesViewController* rules = [[actRulesViewController alloc]init];
    [self.navigationController pushViewController:rules animated:YES];
    
}

- (IBAction)securityBtn:(UIButton *)sender {
    
    
    [messageDic setObject:[NSNumber numberWithInteger:num] forKey:@"number"];
    
    securityViewController* security = [[securityViewController alloc]init];
    [self.navigationController pushViewController:security animated:YES];
}

- (IBAction)gobuyBtn:(UIButton *)sender {
    
//    if (max == 0) {
//        [self.view makeToast:@"本期活动已结束"];
//        return;
//    }
    
    if (num<1) {
        [self.view makeToast:@"请添加份数"];
        return;
    }
    
    [messageDic setObject:[NSNumber numberWithInteger:num] forKey:@"nums"];
    [messageDic setObject:self.model.id forKey:@"id"];
    [messageDic setObject:self.model.title forKey:@"name"];
    [messageDic setObject:self.model.num forKey:@"num"];
    [messageDic setObject:self.model.step forKey:@"step"];
    [messageDic setObject:[NSString stringWithFormat:@"%.2f",num*self.model.money.floatValue] forKey:@"total"];
    
    theOrderViewController* order = [[theOrderViewController alloc]init];
    order.messagDic = messageDic;
    [self.navigationController pushViewController:order animated:YES];
    
}
@end
