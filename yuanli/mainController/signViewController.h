//
//  signViewController.h
//  yuanli
//
//  Created by 代忙 on 16/3/27.
//  Copyright © 2016年 wxw. All rights reserved.
//

#import "fatherViewController.h"

@interface signViewController : fatherViewController

@property(strong,nonatomic)NSString* sign_times;
@property(strong,nonatomic)NSNumber* score;
@property(nonatomic)BOOL isShow;


-(void)addAnimotion;
@end
