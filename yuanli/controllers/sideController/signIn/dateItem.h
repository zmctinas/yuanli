//
//  dateItem.h
//  yuanli
//
//  Created by 代忙 on 16/3/22.
//  Copyright © 2016年 wxw. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    WXSignInUnSign,
    WXSignInSigned,
    WXSignInSigning,
}WXSignInType;

@interface dateItem : UIView

@property(strong,nonatomic)NSString* dateString;
@property(nonatomic,strong)NSString* lunarDay;
@property(nonatomic)WXSignInType ItemSatus;

- (instancetype)initWithFrame:(CGRect)frame andDateString:(NSString*)dateString andLunarDay:(NSString*)lunarday andItemStatus:(WXSignInType)itemType;

@end
