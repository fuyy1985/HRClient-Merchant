//
//  QHttpManager.h
//  HRClient
//
//  Created by ekoo on 15/1/4.
//  Copyright (c) 2015年 panyj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Header.h"
#import "QDataModel.h"
#import "QMyListDetailModel.h"
#import "QBusinessDetailModel.h"
#import "QBusinessDetailComment.h"
#import "QBusinessDetailResult.h"
#import "QProductDetailCompany.h"
#import "QProductDetail.h"
#import "QMyCouponDetailModel.h"
#import "QAppDelegate.h"
#import "QMyListModel.h"

#define USER_INFO_KEY_TYPE          @"requestType"
typedef enum{
    kLogin = 0,
    kScanCode,
    kGetOrderList,
    kGetOrderDetail,
    kOrderNotarize,
    kAllOrderNotarize,
    kGetCompanyAccount,
    kAcquireCode,
    kInsertBank,
    kDeleteBank,
    kWithdrawCash,
    kMyService,
    
    kAcommendLoginPwd,
    kFindLoginPwd,
    kSureFindLoginPwd,
    
    kAcommendPayPwd,
    kFindPayPwd,
    kSetPayPwd,//设置支付密码
    kReSetPayPwd,
    
    kGetAgreement,//用户使用协议
    
}RequestType;

@protocol QiaoHttpDelegate <NSObject>
//代理方法
//接口返回失败
- (void)didGetDataFailed:(RequestType)type;
//登录
- (void)didGetLogin:(QLoginModel *)dataArr;
//扫描用户版的二维码
- (void)didScanCode:(id)model;
//订单列表
- (void)didGetOrderList:(NSMutableArray*)dataArr;
//订单详情
- (void)didGetOrderDetail:(id)model;
//确认提款
- (void)didFinishOrderNotarize:(id)model;
//一键全部订单提款
- (void)didFinishAllOrderNotarize:(id)model;
//账户信息
- (void)didGetCompanyAccount:(id)model;
//验证码的回调方法
- (void)didGetAcquireCode:(NSString *)code;
//增加银行卡
- (void)didInsertBank:(id)model;
//删除银行卡
- (void)didDeleteBankCard:(id)model;
//提取现金
- (void)didWithdrawCash:(id)model;
//我的服务
- (void)didGetMyService:(NSArray*)dataArr;


//修改登录密码
- (void)didGetNewLoginPwd:(NSString *)message;
//找回登录密码
- (void)didGetLoginPwd:(QLoginModel *)dataArr;
//确认找回登录密码
- (void)didGetSureFindLginPwd:(NSString *)message;

//修改支付密码
- (void)didGetNewPayPwd:(NSString *)message;
//找回支付密码
- (void)didGetPayPwd:(NSString *)message;
//设置支付密码
- (void)didSetPayPwd:(NSString *)message;
//重置支付密码
- (void)didReSetPayPwd:(NSString*)message;
//协议
- (void)didGetAgreement:(id)model;

@end


@class ASINetworkQueue;
@interface QHttpManager : NSObject

@property (nonatomic,strong)ASINetworkQueue *networkQueue;
@property (nonatomic,assign)id<QiaoHttpDelegate>delegate;

- (BOOL)isRunning;
- (void)start;
- (void)pause;
- (void)resume;
- (void)cancel;

- (id)initWithDelegate:(id<QiaoHttpDelegate>)delegate;
//需要用的方法
//登录
- (void)accessLogin:(NSString *)nick andPassword:(NSString *)password;
//扫描用户版的二维码
- (void)accessScanCode:(NSString*)verificationCode;
//订单列表
- (void)accessGetOrderList;
//订单详情
- (void)accessGetOrderDetail:(NSNumber*)orderListId;
//确认提款
- (void)accessOrderNotarize:(NSNumber*)orderListId;
//一键确认订单
- (void)accessAllOrderNotarize;
//账户信息
- (void)accessGetCompanyAccount;
//获取验证码
- (void)accessAcquireCode:(NSString *)phone andMessage:(NSString *)message;
//增加银行卡
- (void)accessInsertBankCard:(NSString*)cardUserName andBankName:(NSString*)bankName andBankNo:(NSString*)bankNo andPhone:(NSString*)phone andVerifyCode:(NSString*)verifyCode;
//删除银行卡
- (void)accessDeleteBankCard:(NSNumber*)bankId;
//提取现金
- (void)accessWithdrawCash:(NSNumber*)bankId andPayPassword:(NSString*)payPassword andMoney:(NSNumber*)money;
//我的服务
- (void)accessGetMyService;

//修改登录密码
- (void)accessAcommendLoginPwd:(NSString *)oldPassword andPassword:(NSString *)password andVerifyPassword:(NSString *)verifyPassword;
//找回登录密码
- (void)accessFindLoginPwd:(NSString *)phone andVerifyCode:(NSString *)verifyCode;
//确认找回登录密码
- (void)accessSureFindLoginPwd:(NSString *)newPassword andVerifyNewPassword:(NSString *)verifyNewPassword;

//修改支付密码
- (void)accessAcommendPayPwd:(NSString *)oldPayPasswd andNewPayPasswd:(NSString *)newPayPasswd andVerifyNewPayPasswd:(NSString *)verifyNewPayPasswd;
//找回支付密码
- (void)accessFindePayPwd:(NSString *)phone andVerifyCode:(NSString *)verifyCode;
//设置支付密码
- (void)accessSetPayPwd:(NSString *)payPasswd andVerifyPayPasswd:(NSString *)verifyPayPasswd andPhone:(NSString *)phone andVerifyCode:(NSString *)verifyCode;
//重置支付密码
- (void)accessReSetPayPwd:(NSString *)payPasswd andVerifyPayPasswd:(NSString *)verifyPayPasswd;
//协议
- (void)accessGetAgreement:(int)agreementType;

@end
