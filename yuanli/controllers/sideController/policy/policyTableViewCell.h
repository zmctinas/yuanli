//
//  policyTableViewCell.h
//  yuanli
//
//  Created by 代忙 on 16/3/18.
//  Copyright © 2016年 wxw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "policyModel.h"

@interface policyTableViewCell : UITableViewCell

@property(strong,nonatomic)policyModel* policyModel;

//@property (strong, nonatomic) IBOutlet UIImageView *statusImageView;

@property (strong, nonatomic) IBOutlet UILabel *tradeName;
@property (strong, nonatomic) IBOutlet UILabel *tradeTime;
@property (strong, nonatomic) IBOutlet UILabel *tradeStatus;



@end
