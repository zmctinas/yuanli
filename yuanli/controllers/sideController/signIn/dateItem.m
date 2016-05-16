//
//  dateItem.m
//  yuanli
//
//  Created by 代忙 on 16/3/22.
//  Copyright © 2016年 wxw. All rights reserved.
//

#import "dateItem.h"

@interface dateItem ()

@property(strong,nonatomic)UIButton* itemBtn;

@property(strong,nonatomic)UILabel* ItemLabel;

@end

@implementation dateItem


- (instancetype)initWithFrame:(CGRect)frame andDateString:(NSString*)dateString andLunarDay:(NSString*)lunarday andItemStatus:(WXSignInType)itemType
{
    self = [self initWithFrame:frame];
    self.dateString = dateString;
    self.lunarDay = lunarday;
    self.ItemSatus = itemType;
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initItem];
    }
    return self;
}

-(void)initItem
{
    [self addSubview:self.itemBtn];
    [self addSubview:self.ItemLabel];
    
}


#pragma mark - private

-(void)setDateString:(NSString *)dateString
{
    _dateString = dateString;
    [self.itemBtn setTitle:_dateString forState:UIControlStateNormal];
    
}

-(void)setLunarDay:(NSString *)lunarDay
{
    _lunarDay = lunarDay;
    _ItemLabel.text = _lunarDay;
}

-(void)setItemSatus:(WXSignInType)ItemSatus
{
    switch (ItemSatus) {
        case WXSignInUnSign:
        {
            self.itemBtn.selected = NO;
            self.itemBtn.highlighted = NO;
        }
            break;
        case WXSignInSigned:
        {
            self.itemBtn.highlighted = YES;
        }
            break;
        case WXSignInSigning:
        {
            self.itemBtn.highlighted = NO;
            self.itemBtn.selected = YES;
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - getter

-(UIButton*)itemBtn
{
    if (_itemBtn == nil) {
        _itemBtn = [UIButton buttonWithType:0];
        _itemBtn.frame = CGRectMake(1, 4, 30, 30);
        _itemBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_itemBtn setTitleColor:[UIColor colorWithHexString:@"#8b8b8b"] forState:UIControlStateNormal];
        [_itemBtn setTitleColor:[UIColor colorWithHexString:@"#8b8b8b"] forState:UIControlStateHighlighted];
        [_itemBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [_itemBtn setBackgroundImage:[UIImage imageNamed:@"qiandao_btn_yiqian"] forState:UIControlStateHighlighted];
        [_itemBtn setBackgroundImage:[UIImage imageNamed:@"qiandao_btn_yiqianjingri"] forState:UIControlStateSelected];
    }
    return _itemBtn;
}

-(UILabel*)ItemLabel
{
    if (_ItemLabel == nil) {
        _ItemLabel = [[UILabel alloc]initWithFrame:CGRectMake(1, 40, 30, 10)];
        _ItemLabel.font = [UIFont systemFontOfSize:10];
        _ItemLabel.textAlignment = NSTextAlignmentCenter;
        _ItemLabel.textColor = [UIColor colorWithHexString:@"#d1d1d1"];
//        _ItemLabel.textColor = [UIColor orangeColor];
    }
    return _ItemLabel;
}

@end
