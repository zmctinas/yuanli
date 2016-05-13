//
//  listHeadView.h
//  yuanli
//
//  Created by 代忙 on 16/3/8.
//  Copyright © 2016年 wxw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface listHeadView : UIView

@property (strong, nonatomic) IBOutlet UIImageView *iconView;
@property (strong, nonatomic) IBOutlet UILabel *nickName;
@property (strong, nonatomic) IBOutlet UILabel *myOrderLabel;

@property (strong, nonatomic) IBOutlet UILabel *stepNunLabel;
@property (strong, nonatomic) IBOutlet UILabel *lengLabel;
@property (strong, nonatomic) IBOutlet UILabel *heatLabel;

@property(strong, nonatomic)NSDictionary* messageDic;

@end
