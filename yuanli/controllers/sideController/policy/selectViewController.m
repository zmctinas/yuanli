//
//  selectViewController.m
//  yuanli
//
//  Created by 代忙 on 16/3/25.
//  Copyright © 2016年 wxw. All rights reserved.
//

#import "selectViewController.h"
#import "withdrawalRecordViewController.h"
#import "aliWithdrawalViewController.h"
#import "weixinWitdrawalTypeViewController.h"

@interface selectViewController ()
{
    NSInteger selectIndex;
}


- (IBAction)selectBtn:(UIButton *)sender;
- (IBAction)nextBtn:(UIButton *)sender;

@end

@implementation selectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"选择领取方式";
    selectIndex = 10;
    
    [FrameSize MLBFrameSize:self.view];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private



#pragma mark - xib

- (IBAction)nextBtn:(UIButton *)sender {
    
    
    NSDictionary* dic = @{@"service":Withdrawal_IF,
                          
                          @"user_id":UID,
                          @"money":[NSNumber numberWithFloat:self.money.floatValue],
                          @"type":selectIndex==10?@"ali_pay":@"wei_pay",
                          
                          };
    switch (selectIndex) {
        case 10:
        {
            aliWithdrawalViewController* ali = [[aliWithdrawalViewController alloc]init];
            ali.messageDic = dic;
            [self.navigationController pushViewController:ali animated:YES];
        }
            break;
        case 11:
        {
            weixinWitdrawalTypeViewController* ali = [[weixinWitdrawalTypeViewController alloc]init];
            ali.messageDic = dic;
            [self.navigationController pushViewController:ali animated:YES];
        }
            break;
            
        default:
            break;
    }
    
//    [self requestMessage];
    
}
- (IBAction)selectBtn:(UIButton *)sender {
    
    sender.selected = YES;
    selectIndex = sender.tag;
    for (int i = 0 ; i < 2; i++) {
        UIButton* btn = (UIButton*)[self.view viewWithTag:10+i];
        if (btn.tag != sender.tag) {
            btn.selected = NO;
        }
    }
    
}
@end
