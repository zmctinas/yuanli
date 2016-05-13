//
//  listHeadView.m
//  yuanli
//
//  Created by 代忙 on 16/3/8.
//  Copyright © 2016年 wxw. All rights reserved.
//

#import "listHeadView.h"

@implementation listHeadView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [CrazyAutoLayout layoutOfSuperView:self];
    }
    return self;
}

-(void)setMessageDic:(NSDictionary *)messageDic
{
    _messageDic = messageDic;
    
    self.myOrderLabel.text = [NSString stringWithFormat:@"第%@名",_messageDic[@"my_order"]];
    self.nickName.text = USERNAME;
    
    self.lengLabel.text = [NSString stringWithFormat:@"%@",_messageDic[@"distance"]];
    self.heatLabel.text = [NSString stringWithFormat:@"%@",_messageDic[@"calorie"]];
    
    NSString* attStr = [NSString stringWithFormat:@"%@步",_messageDic[@"step_num"]];
//    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:attStr];
//    
// 	[str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:30] range:NSMakeRange(0, attStr.length-1)];
// 	[str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(attStr.length - 1,1)];
 	
 	self.stepNunLabel.text = attStr;
    
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMGHEAD,[USERDefaults objectForKey:@"PHOTO"]]] placeholderImage:[UIImage imageNamed:@"paihangbang_morenxiao.png"]];
 
    self.iconView.layer.cornerRadius = self.iconView.frame.size.height/2;
    self.iconView.layer.masksToBounds = YES;
}

@end
