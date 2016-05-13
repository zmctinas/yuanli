//
//  productModel.h
//  yuanli
//
//  Created by daimangkeji on 16/5/9.
//  Copyright © 2016年 wxw. All rights reserved.
//

#import "rootModel.h"

@interface productModel : rootModel

@property(copy,nonatomic)NSString* title;
@property(strong,nonatomic)NSNumber* step;
@property(copy,nonatomic)NSString* interest;
@property(strong,nonatomic)NSNumber* num;
@property(copy,nonatomic)NSString* money;
@property(strong,nonatomic)NSNumber* min;
@property(strong,nonatomic)NSNumber* max;
@property(copy,nonatomic)NSString* id;

@end
