//
//  withdrawalModel.h
//  yuanli
//
//  Created by 代忙 on 16/3/26.
//  Copyright © 2016年 wxw. All rights reserved.
//

#import "rootModel.h"

@interface withdrawalModel : rootModel

@property(copy , nonatomic)NSString* cash;
@property(copy , nonatomic)NSString* date;
@property(copy , nonatomic)NSString* id;
@property(copy , nonatomic)NSString* status;
@property(copy , nonatomic)NSString* take_cash_no;
@property(copy , nonatomic)NSString* type;
@property(copy , nonatomic)NSString* user_id;

@end
