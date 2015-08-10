//
//  QHttpMessageManager.h
//  HRClient
//
//  Created by ekoo on 15/1/4.
//  Copyright (c) 2015年 panyj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QHttpManager.h"

#define kInterfaceFailed @"kInterfaceFailed"
#define kLogin @"kLogin"
#define kScanCode @"kScanCode"
#define GetOrderList @"kGetOrderList"
#define kGetOrderDetail @"kGetOrderDetail"
#define kOrderNotarize @"kOrderNotarize"
#define kAllOrderNotarize @"kAllOrderNotarize"
#define kGetCompanyAccount @"kGetCompanyAccount"
#define kAcquireCode @"kAcquireCode"
#define kInsertBank @"kInsertBank"
#define kDeleteBank @"kDeleteBank"
#define kGetCompanyBankList @"kGetCompanyBankList"
#define kWithdrawCash @"kWithdrawCash"
#define kMyService @"kMyService"

#define kSetPayPwd @"kSetPayPwd"
#define kAcommedPayPwd @"kAcommedPayPwd"
#define kFindPayPwd @"kFindPayPwd"
#define kReSetPayPwd @"kResetPayPwd"

#define kFindLoginPwd @"kFindLoginPwd"
#define kSureFindLoginPwd @"kSureFindLoginPwd"
#define kAcommendLoginPwd @"kAcommendLoginPwd"

#define kGetAgreement @"kGetAgreement"

@interface QHttpMessageManager : NSObject<QiaoHttpDelegate>

@property (nonatomic,copy)NSString *filePath;
+ (QHttpMessageManager *)sharedHttpMessageManager;
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
//验证码
- (void)accessAcquireCode:(NSString *)phone andMessage:(NSString *)message;
//增加绑定银行卡
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
