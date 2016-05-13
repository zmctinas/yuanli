//
//  rootTableViewCell.m
//  yuanli
//
//  Created by 代忙 on 16/3/8.
//  Copyright © 2016年 wxw. All rights reserved.
//

#import "rootTableViewCell.h"

@implementation rootTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
