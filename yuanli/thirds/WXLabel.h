//
//  WXLabel.h
//  yuanli
//
//  Created by 代忙 on 16/3/25.
//  Copyright © 2016年 wxw. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    VerticalAlignmentTop = 0, // default
    VerticalAlignmentMiddle,
    VerticalAlignmentBottom,
} VerticalAlignment;

@interface WXLabel : UILabel

@property (nonatomic) VerticalAlignment verticalAlignment;  

@end
