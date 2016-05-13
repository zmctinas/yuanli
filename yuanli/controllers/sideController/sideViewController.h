//
//  sideViewController.h
//  yuanli
//
//  Created by 代忙 on 16/3/4.
//  Copyright © 2016年 wxw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ICSDrawerController.h"

@interface sideViewController : fatherViewController<ICSDrawerControllerPresenting,ICSDrawerControllerChild>

@property (nonatomic,weak) ICSDrawerController *drawer;

@property(nonatomic,assign)NSInteger stepNum;

@end
