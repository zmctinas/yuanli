//
//  listTableViewCell.m
//  yuanli
//
//  Created by 代忙 on 16/3/8.
//  Copyright © 2016年 wxw. All rights reserved.
//

#import "listTableViewCell.h"

@implementation listTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [CrazyAutoLayout layoutOfSuperView:self];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setListModel:(listModel *)listModel
{
    _listModel = listModel;
    
    self.stepNumLabel.text = [NSString stringWithFormat:@"%@步",_listModel.step_num];
    self.nickName.text = _listModel.user_name;
    self.orderLabel.text = [NSString stringWithFormat:@"%ld",self.tag+1];
    UIColor* labelColor ;
    if (self.tag == 0) {
        labelColor = [UIColor colorWithHexString:@"#d82b2b"];
    }else if (self.tag == 1)
    {
        labelColor = [UIColor colorWithHexString:@"#ff6600"];
    }else
    {
        labelColor = [UIColor colorWithHexString:@"#81bf6a"];
    }
    self.stepNumLabel.textColor = labelColor;
    if (self.tag<3) {
        self.rangImage.hidden = NO;
        self.orderLabel.hidden = YES;
        self.rangImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"top%ld",self.tag + 1]];
    }else
    {
        self.rangImage.hidden = YES;
        self.orderLabel.hidden = NO;
    }
    NSString* imageUrl = [NSString stringWithFormat:@"%@%@",IMGHEAD,_listModel.photo];
    NSLog(@"%@",imageUrl);
    
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"paihangbang_morenxiao.png"]];
    
    self.iconView.layer.cornerRadius = self.iconView.frame.size.height/2;
    self.iconView.layer.masksToBounds = YES;
    
    
}

@end
