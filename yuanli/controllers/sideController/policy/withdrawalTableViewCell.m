//
//  withdrawalTableViewCell.m
//  yuanli
//
//  Created by 代忙 on 16/3/18.
//  Copyright © 2016年 wxw. All rights reserved.
//

#import "withdrawalTableViewCell.h"

@implementation withdrawalTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [FrameSize MLBFrameSize:self];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(withdrawalModel *)model
{
    _model = model;
    
    _noLabel.text = [NSString stringWithFormat:@"提现单号:%@",model.take_cash_no];
    _cashLabel.text = [NSString stringWithFormat:@"%@元",model.cash];
    
    NSString* attStr = [NSString stringWithFormat:@"%@ %@",model.date,[model.type isEqualToString:@"ali_pay"]?@"转入支付宝":@"转入微信"];
//    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:attStr];
//    
//    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#999999"] range:NSMakeRange(0, model.date.length)];
//    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#f86d6d"] range:NSMakeRange(model.date.length,attStr.length - model.date.length)];
    self.dateLabel.text = attStr;
    self.dateLabel.adjustsFontSizeToFitWidth = YES;
    self.noLabel.adjustsFontSizeToFitWidth = YES;
    self.cashLabel.adjustsFontSizeToFitWidth = YES;
    switch (model.status.integerValue) {
        case 0:
        {
            _statusLabel.text = @"正在审核";
        }
            break;
        case 1:
        {
            _statusLabel.text = @"正在操作";
        }
            break;
        case 2:
        {
            _statusLabel.text = @"已完成";
        }
            break;
        case 3:
        {
            _statusLabel.text = @"操作失败";
        }
            break;
            
        default:
            break;
    }
    
}

@end
