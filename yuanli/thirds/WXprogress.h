//
//  WXprogress.h
//  yuanli
//
//  Created by 代忙 on 16/3/29.
//  Copyright © 2016年 wxw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WXprogress : UIView

+(instancetype)shareProcess;

-(void)showProgress;

-(void)dismissProgress;

@end
