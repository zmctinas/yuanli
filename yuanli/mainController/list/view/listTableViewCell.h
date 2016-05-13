//
//  listTableViewCell.h
//  yuanli
//
//  Created by 代忙 on 16/3/8.
//  Copyright © 2016年 wxw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "listModel.h"

@interface listTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *orderLabel;
@property (strong, nonatomic) IBOutlet UIImageView *iconView;
@property (strong, nonatomic) IBOutlet UILabel *nickName;
@property (strong, nonatomic) IBOutlet UILabel *stepNumLabel;
@property (weak, nonatomic) IBOutlet UIImageView *rangImage;

@property(strong,nonatomic)listModel* listModel;






@end
