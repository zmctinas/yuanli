//
//  integralModel.h
//  yuanli
//
//  Created by daimangkeji on 16/5/12.
//  Copyright © 2016年 wxw. All rights reserved.
//

#import "rootModel.h"

@interface integralModel : rootModel

@property(copy,nonatomic)NSString* year;
@property(copy,nonatomic)NSString* day;
@property(copy,nonatomic)NSString* score;
@property(nonatomic)BOOL isEnd;


@end
