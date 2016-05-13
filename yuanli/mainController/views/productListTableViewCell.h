//
//  productListTableViewCell.h
//  yuanli
//
//  Created by daimangkeji on 16/5/9.
//  Copyright © 2016年 wxw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "rootTableViewCell.h"
#import "productModel.h"

@interface productListTableViewCell : rootTableViewCell

@property (weak, nonatomic) IBOutlet UIView *backView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *interestLabel;
@property (weak, nonatomic) IBOutlet UILabel *stepNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *exctptLabel;

@property(strong,nonatomic)productModel* model;



@end
