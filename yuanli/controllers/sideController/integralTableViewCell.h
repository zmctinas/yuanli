//
//  integralTableViewCell.h
//  yuanli
//
//  Created by daimangkeji on 16/5/12.
//  Copyright © 2016年 wxw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "rootTableViewCell.h"
#import "integralModel.h"

@interface integralTableViewCell : rootTableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *pointImageView;
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *yearLabel;

@property(strong,nonatomic)integralModel* model;

@end
