//
//  interface.h
//  
//
//  Created by 代忙 on 16/3/4.
//
//

#ifndef interface_h
#define interface_h

#define LOGIN_IF @"User.UserLogin"//登录
#define LOGOUT_IF @"User.UserOut"//登出
#define REGISTER_IF @"User.UserReg"//注册
#define SendCode_IF @"User.SendCode"//发送验证码
#define UPPassWord_IF @"User.UpdatePassword"//修改密码
#define LIST_IF @"Sport.GetSportOrder"//排行榜信息
#define WEATHER_IF @"User.Index"//天气信息
#define SIGNIN_IF @"Sign.Index"//用户签到

#define GETSIGN_IF @"Sign.GetSign"//获取用户签到信息
#define GETSCORE_IF @"Sign.GetSignScore"//获取用户用户积分

#define GetUserInfo_IF @"User.GetUserInfo"//获取用户信息
#define UpDateUserInfo_IF @"User.UpdateUser"//用户信息修改

#define BALANCE_IF @"Money.Index"//用户余额、套餐信息

#define TradeList_IF @"Trade.GetTradeList"//购买列表
#define TradeUpList_IF @"Trade.GetTradeListById"//购买二级列表
#define GetRemainder_IF @"Trade.GetRemainderByUserId"//获取活动余量

#define Trade_IF @"Trade.Index"//返回用户订单列表
#define Takecash_IF @"Takecash.Index"//返回用户提现列表

#define AddTrade_IF @"Trade.AddTrade"//用户下单
#define GetTradeDetail_IF @"Trade.GetTradeDetail"//返回订单消息

#define BACK_IF @"Message.AddMessage"//添加反馈信息

#define Withdrawal_IF @"Money.TakeCash"//提现申请

#define AddAliPay_IF @"User.AddAliPay"//提交支付宝


#define ACTIVITY_IF @"Activity.Index"//获取活动列表

#define GetOpenId_IF @"User.GetOpenId"//获取用户微信openid

#define SPORT_IF @"Sport.Index"//返回用户运动信息

#define NOTIFY_IF @"Notify.Index"//支付回调
#define CashPay_IF @"Pay.CashPay"//支付接口
#define RULE_IF @"Rule.Index"//返回活动规则

#define GetTaskStep_IF @"Trade.GetTaskStep"//获取用户目标步数



#define ADDSPORT_IF @"Sport.AddSport"//添加用户运动信息

#define GetUserSportList_IF @"Sport.GetUserSportList"//获取用户在该时间段运动情况


#define CloseTrade_IF @"Trade.CloseTrade"//关闭订单

#define SuccessTrade_IF @"Trade.SuccessTrade"//交易成功






#endif /* interface_h */
