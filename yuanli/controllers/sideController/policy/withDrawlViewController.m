//
//  withDrawlViewController.m
//  yuanli
//
//  Created by 代忙 on 16/3/25.
//  Copyright © 2016年 wxw. All rights reserved.
//

#import "withDrawlViewController.h"
#import "selectViewController.h"
#import "withdrawalRecordViewController.h"
#import "aliWithdrawalViewController.h"
#import "weixinWitdrawalTypeViewController.h"

@interface withDrawlViewController ()
{
    NSInteger selectIndex;
}
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

@property (strong, nonatomic) IBOutlet UITextField *moneyField;

@property (strong, nonatomic) IBOutlet UILabel *crashLabel;
- (IBAction)nextBtn:(UIButton *)sender;
- (IBAction)selectBtn:(UIButton *)sender;

@end

@implementation withDrawlViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"提现";
    
    [FrameSize MLBFrameSize:self.view];
    
    selectIndex = 10;
    
    [self refreshUI];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)refreshUI
{
    NSString* attStr = [NSString stringWithFormat:@"可领取余额%@元",_remainderMoney];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:attStr];
    
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#808080"] range:NSMakeRange(0, 5)];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#d82b2b"] range:NSMakeRange(5,attStr.length - 5)];
    self.crashLabel.attributedText = str;
    
    self.nextBtn.layer.cornerRadius = 4;
    self.nextBtn.layer.masksToBounds = YES;
}

- (IBAction)nextBtn:(UIButton *)sender {
    
//    if ([_moneyField.text floatValue]>0&&[_moneyField.text integerValue]<[_remainderMoney floatValue]) {
//        selectViewController* select = [[selectViewController alloc]init];
//        select.money = self.moneyField.text;
//        [self.navigationController pushViewController:select animated:YES];
//    }
    
    NSDictionary* dic = @{@"service":Withdrawal_IF,
                          
                          @"user_id":UID,
                          @"money":[NSNumber numberWithFloat:self.moneyField.text.floatValue],
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
