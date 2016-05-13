//
//  CrazyAutoLayout.h
//  ocCrazy
//
//  Created by dukai on 16/1/5.
//  Copyright © 2016年 dukai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIView(View)

@property(nonatomic,strong)NSString * mark;

@end


@interface CrazyAutoLayout : NSObject

@property(nonatomic)float scale;
+(void)layoutOfSuperView:(UIView *)superView;//适配view
+(CGFloat)getFontSize:(CGFloat)fontSize;//获取字体大小
+(CGFloat)getUIScale;//比例
+(CGFloat)crazyHeight:(float)height;//cell 增量高度

@end
