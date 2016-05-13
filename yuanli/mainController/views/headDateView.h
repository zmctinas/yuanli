//
//  headDateView.h
//  yuanli
//
//  Created by 代忙 on 16/3/11.
//  Copyright © 2016年 wxw. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^dateBtnBlock)(NSInteger btnTag);

@interface headDateView : UIView<UIScrollViewDelegate>

@property(strong,nonatomic)UIScrollView* dateScrollView;
@property(strong,nonatomic)dateBtnBlock touchDateBtn;

-(void)addItemWithBlock:(dateBtnBlock)btnBlock;

@end
