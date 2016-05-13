//
//  withdrawalTableViewCell.h
//  yuanli
//
//  Created by 代忙 on 16/3/18.
//  Copyright © 2016年 wxw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "withdrawalModel.h"

@interface withdrawalTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *noLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UILabel *cashLabel;
@property (strong, nonatomic) IBOutlet UILabel *statusLabel;



@property(strong,nonatomic)withdrawalModel* model;

@end
