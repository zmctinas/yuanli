//
//  policyDetailViewController.m
//  yuanli
//
//  Created by 代忙 on 16/3/18.
//  Copyright © 2016年 wxw. All rights reserved.
//

#import "policyDetailViewController.h"
#import "WXLabel.h"

@interface policyDetailViewController ()
@property (strong, nonatomic) IBOutlet UIView *numsBackView;
@property (strong, nonatomic) IBOutlet WXLabel *numsLabel;
@property (strong, nonatomic) IBOutlet UILabel *buydateLabel;
@property (strong, nonatomic) IBOutlet UILabel *begintimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *lasttaskLabel;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) IBOutlet UILabel *taskStepLabel;
@property (strong, nonatomic) IBOutlet UILabel *calorieLabel;
@property (strong, nonatomic) IBOutlet UILabel *interestLabel;





@end

@implementation policyDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"详情";
    
    [FrameSize MLBFrameSize:self.view];
    
    [self setUpUI];
    
    [self requestMessage];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private

-(void)setUpUI
{
    for (int i = 0 ; i < 3; i++) {
        UILabel* label = (UILabel*)[self.view viewWithTag:10+i];
        label.layer.masksToBounds = YES;
        label.layer.cornerRadius = 4;
        label.layer.borderColor = [UIColor colorWithHexString:@"#d82b2b"].CGColor;
        label.layer.borderWidth = 1;
    }
}

-(void)refreshUI:(NSDictionary*)dic
{
    if ([[dic allValues] count]<=0) {
        return;
    }
    _numsBackView.layer.cornerRadius = _numsBackView.frame.size.height/2;
    _numsBackView.layer.masksToBounds = YES;
    _numsLabel.text = [dic[@"nums"] isKindOfClass:[NSString class]]?dic[@"nums"]:@"0";
    [_numsLabel setVerticalAlignment:VerticalAlignmentMiddle];
    _buydateLabel.text = [dic[@"buy_date"] componentsSeparatedByString:@" "][0];
    _begintimeLabel.text = dic[@"begin"];
    
    
    if ([dic[@"task_step"] intValue] - _numsLabel.text.intValue <= 0) {
//        if ([dic[@"last_task_time"] isKindOfClass:[NSString class]]&&[dic[@"last_task_time"] isEqualToString:@"0000-00-00"]) {
//            
//        }else
//        {
            _lasttaskLabel.text = dic[@"last_task_time"];
//        }
    }else
    {
        _lasttaskLabel.text = @"未完成";
    }
    
//    _lasttaskLabel.text = ([dic[@"last_task_time"] isKindOfClass:[NSString class]]||![dic[@"last_task_time"] isEqualToString:@"0000-00-00"])?dic[@"last_task_time"]:@"未完成";
    _priceLabel.text = [NSString stringWithFormat:@"%@元",dic[@"price"]];
    _taskStepLabel.text = [NSString stringWithFormat:@"%d次",[dic[@"task_step"] intValue] - _numsLabel.text.intValue];
    
    _calorieLabel.text = [NSString stringWithFormat:@"%@千卡",dic[@"calorie"]];
    _interestLabel.text = [NSString stringWithFormat:@"%@%@",dic[@"interest"],@"元"];
}

-(void)requestMessage
{
    
    NSDictionary* dic = @{@"service":GetTradeDetail_IF,
                          
                          @"out_trade_no":_tradeNo,
                          
                          };
    NSLog(@"%@",_tradeNo);
    [HTTPRequest requestWitUrl:@"" andArgument:dic andType:WXHTTPRequestGet Finished:^(NSURLResponse *response, NSDictionary *requestDic) {
        NSLog(@"%@",requestDic);
        NSLog(@"%@",requestDic[@"msg"]);
        
        [self refreshUI:requestDic[@"data"][@"data"] ];
        
    } Falsed:^(NSError *error) {
        
    }];
}

@end
