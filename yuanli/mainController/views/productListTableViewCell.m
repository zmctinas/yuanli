//
//  productListTableViewCell.m
//  yuanli
//
//  Created by daimangkeji on 16/5/9.
//  Copyright © 2016年 wxw. All rights reserved.
//

#import "productListTableViewCell.h"

@implementation productListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [FrameSize MLBFrameSize:self];
    
    
    [self initUI];
    
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(productModel *)model
{
    _model = model;
    
    
    self.nameLabel.text = model.title;
    self.interestLabel.text = [NSString stringWithFormat:@"预期年化收益%.1f%@",model.interest.floatValue*100.0,@"%"];
    self.stepNumLabel.text = [NSString stringWithFormat:@"一天内完成%@步为一次",model.step];
    self.exctptLabel.text = [NSString stringWithFormat:@"需完成%@次，%ld元起投",model.num,model.money.integerValue*model.min.integerValue];
    
}

-(void)initUI
{
    self.backView.layer.cornerRadius = 10;
    self.backView.layer.masksToBounds = YES;
    self.backView.layer.borderColor = [UIColor colorWithHexString:@"#d82b2b"].CGColor;
    self.backView.layer.borderWidth = 2;
}

@end
