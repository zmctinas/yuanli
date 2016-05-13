//
//  policyTableViewCell.m
//  yuanli
//
//  Created by 代忙 on 16/3/18.
//  Copyright © 2016年 wxw. All rights reserved.
//

#import "policyTableViewCell.h"

@implementation policyTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    [FrameSize MLBFrameSize:self];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setPolicyModel:(policyModel *)policyModel
{
    _policyModel = policyModel;
    
    _tradeName.text = [NSString stringWithFormat:@"购买%@元",_policyModel.price];
//    NSArray* arr = [_policyModel.date componentsSeparatedByString:@" "];
    _tradeTime.text = [NSString stringWithFormat:@"%@",_policyModel.date ];
    switch ([_policyModel.status integerValue]) {
        case 0:
        {
            _tradeStatus.text = @"未付款";
//            _tradeStatus.textColor = [UIColor colorWithHexString:@"#80c269"];
        }
            break;
        case 1:
        {
            _tradeStatus.text = [NSString stringWithFormat:@"已完成%@次",[_policyModel.nums isKindOfClass:[NSString class]]?_policyModel.nums:@"0"];
//            _tradeStatus.textColor = [UIColor colorWithHexString:@"#f86d6d"];
        }
            break;
        case 2:
        {
            _tradeStatus.text = @"已完成任务";
//            _tradeStatus.textColor = [UIColor colorWithHexString:@"#80c269"];
//            self.statusImageView.image = [UIImage imageNamed:@"yundongmubiao_icon_lvtiao.png"];
        }
            break;
            
        default:
            break;
    }
    
}

@end
