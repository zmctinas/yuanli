//
//  rootModel.m
//  yuanli
//
//  Created by 代忙 on 16/3/7.
//  Copyright © 2016年 wxw. All rights reserved.
//

#import "rootModel.h"

@implementation rootModel

-(void)setValue:(id)value forKey:(NSString *)key
{
    if (![value isEqual:[NSNull null]]) {
        [super setValue:value forKey:key];
    }else
    {
        [super setValue:@"" forKeyPath:key];
    }
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

@end
