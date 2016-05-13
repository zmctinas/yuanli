//
//  theOrderViewController.m
//  yuanli
//
//  Created by 代忙 on 16/3/17.
//  Copyright © 2016年 wxw. All rights reserved.
//

#import "theOrderViewController.h"
#import "policyRecordViewController.h"

@interface theOrderViewController ()
{
    NSInteger selectBtnTag;
}


@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) IBOutlet UILabel *interestLabel;
@property (strong, nonatomic) IBOutlet UILabel *goalLabel;

@property (strong, nonatomic) IBOutlet UILabel *totalPriceLabel;

@property (strong, nonatomic) IBOutlet UILabel *balanceLabel;


- (IBAction)payBtn:(id)sender;

- (IBAction)selectBtn:(UIButton *)sender;

@end

@implementation theOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"付款";
    
    
    [FrameSize MLBFrameSize:self.view];
    
    [self setUpUI];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private

-(void)cancelOrder:(NSString*)tradeNo
{
    
    NSDictionary* dic = @{@"service":CloseTrade_IF,
                          
                          @"out_trade_no":tradeNo,
                          
                          };
    [HTTPRequest requestWitUrl:@"" andArgument:dic andType:WXHTTPRequestGet Finished:^(NSURLResponse *response, NSDictionary *requestDic) {
        NSLog(@"%@",requestDic);
        NSLog(@"%@",requestDic[@"msg"]);
        if ([requestDic[@"data"][@"code"] isEqualToNumber:@1]) {
            
//            [self.navigationController popViewControllerAnimated:YES];
            
        }
        
    } Falsed:^(NSError *error) {
        
    }];
}

-(void)setUpUI
{
    
    _priceLabel.text = [NSString stringWithFormat:@"￥%@",_messagDic[@"total"]];
    _interestLabel.text = [NSString stringWithFormat:@"%.1f%@",[_messagDic[@"interest"] floatValue]*100,@"%"];
    _goalLabel.text = [NSString stringWithFormat:@"任务：每天%@步，累计%@次",_messagDic[@"step"],_messagDic[@"num"]];
//    _totalPriceLabel.text = _priceLabel.text;
    
//    _balanceLabel.text = [NSString stringWithFormat:@"余额付款(余额：%ld元)",[[USERDefaults objectForKey:@"Balance"] integerValue]];
}

#pragma mark - xib

- (IBAction)payBtn:(id)sender {
    
    NSString* type = nil;
    switch (selectBtnTag) {
        case 10:
            type = @"aliwap";
            break;
        case 11:
            type = @"weicaht";
            break;
        case 12:
            type = @"cash";
            break;
            
        default:
            type = @"aliwap";
            break;
    }
    
    if ([type isEqualToString:@"weicaht"]) {
        UIAlertAction* action = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"暂停该支付方式" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:action];
        [self presentViewController:alertController animated:YES completion:^{
            
        }];
        return;
    }
    
    NSDictionary* dic = @{@"service":AddTrade_IF,
                          
                          @"user_id":UID,
                          @"nums":_messagDic[@"nums"],
                          @"price":_messagDic[@"total"],
                          @"act_id":_messagDic[@"id"],
                          @"type":type,
                          };
    [HTTPRequest requestWitUrl:@"" andArgument:dic andType:WXHTTPRequestGet Finished:^(NSURLResponse *response, NSDictionary *requestDic) {
        NSLog(@"%@",requestDic);
        NSDictionary* data = requestDic[@"data"][@"data"];
        NSLog(@"%@",data);
        
        if ([requestDic[@"data"][@"code"] isEqualToNumber:@1]) {
            NSString*  out_trade_no = requestDic[@"data"][@"data"][@"out_trade_no"];
            
            switch (selectBtnTag) {
                case 10:
                {
                    [alipayObject alipay:[_messagDic[@"total"] floatValue] order:out_trade_no block:^(NSDictionary *dic) {
                        NSLog(@"%@",dic);
                        if ([dic[@"resultStatus"] isEqualToString:@"9000"]) {
                            policyRecordViewController* record = [[policyRecordViewController alloc]init];
                            record.isRootPush = YES;
                            record.title = _messagDic[@"name"];
                            record.listID = _messagDic[@"id"];
                            [self.navigationController pushViewController:record animated:YES];
                        }else
                        {
                            [self cancelOrder:out_trade_no];
                        }
                    }];
                }
                    break;
                case 11:
                {
                    [weixinObject weixinPay:[_messagDic[@"total"]floatValue] order:out_trade_no block:^(BOOL payRet) {
                        if (payRet) {
                            policyRecordViewController* record = [[policyRecordViewController alloc]init];
                            record.isRootPush = YES;
                            record.title = _messagDic[@"name"];
                            record.listID = _messagDic[@"id"];
                            [self.navigationController pushViewController:record animated:YES];
                        }
                    }];
                }
                    break;
                case 12:
                {
                    policyRecordViewController* record = [[policyRecordViewController alloc]init];
                    record.isRootPush = YES;
                    record.title = _messagDic[@"name"];
                    record.listID = _messagDic[@"id"];
                    [self.navigationController pushViewController:record animated:YES];
                }
                    
                    break;
                    
                default:
                {
                    
                    [alipayObject alipay:[_messagDic[@"total"]floatValue] order:out_trade_no block:^(NSDictionary *dic) {
                        NSLog(@"%@",dic);
                        if ([dic[@"resultStatus"] isEqualToString:@"9000"]) {
                            policyRecordViewController* record = [[policyRecordViewController alloc]init];
                            record.isRootPush = YES;
                            record.title = _messagDic[@"name"];
                            record.listID = _messagDic[@"id"];
                            [self.navigationController pushViewController:record animated:YES];
                        }else
                        {
                            [self cancelOrder:out_trade_no];
                        }
                    }];
                }
                    break;
            }
        }else if ([requestDic[@"data"][@"code"] isEqualToNumber:@0])
        {
            
            NSLog(@"%@",requestDic[@"data"][@"msg"]);
            UIAlertAction* action = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"提示" message:requestDic[@"data"][@"msg"] preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:action];
            [self presentViewController:alertController animated:YES completion:^{
                
            }];
        }
        
    } Falsed:^(NSError *error) {
        
    }];
    
}

- (IBAction)selectBtn:(UIButton *)sender {
    
    sender.selected = YES;
    selectBtnTag = sender.tag;
    for (int i = 0 ; i < 3; i++) {
        UIButton* btn = (UIButton*)[self.view viewWithTag:10+i];
        if (btn.tag != sender.tag) {
            btn.selected = NO;
        }
    }
    
    
}
@end
