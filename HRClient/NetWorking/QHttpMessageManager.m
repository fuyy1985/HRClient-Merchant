//
//  QHttpMessageManager.m
//  HRClient
//
//  Created by ekoo on 15/1/4.
//  Copyright (c) 2015年 panyj. All rights reserved.
//

#import "QHttpMessageManager.h"
#import "QDataModel.h"
#import "QDifStatusListQtyModel.h"
#import "QMyListDetailModel.h"
#import "QProductDetail.h"
#import "QMyListModel.h"
#import "QRegisterModel.h"

@interface QHttpMessageManager ()
@property (nonatomic,strong)QHttpManager *httpManager;

@end

static QHttpMessageManager *httpMessageManager = nil;

@implementation QHttpMessageManager

+ (QHttpMessageManager *)sharedHttpMessageManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        httpMessageManager = [[super allocWithZone:NULL] init];
    });
    return httpMessageManager;
}

- (id)init{
    if (self = [super init]) {
        _httpManager = [[QHttpManager alloc] initWithDelegate:self];
        [self.httpManager start];
    }
    return self;
}

- (void)didGetDataFailed:(RequestType)type
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kInterfaceFailed object:[NSNumber numberWithInt:type]];
}

//登录
- (void)accessLogin:(NSString *)nick andPassword:(NSString *)password{
    [self.httpManager accessLogin:nick andPassword:password];
}
- (void)didGetLogin:(QLoginModel *)dataArr{
    [[NSNotificationCenter defaultCenter] postNotificationName:kLogin object:dataArr];
}

//扫描用户版的二维码
- (void)accessScanCode:(NSString*)verificationCode
{
    [self.httpManager accessScanCode:verificationCode];
}
- (void)didScanCode:(id)model
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kScanCode object:model];
}

//订单列表
- (void)accessGetOrderList
{
    [self.httpManager accessGetOrderList];
}
- (void)didGetOrderList:(NSMutableArray*)dataArr
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kGetOrderList object:dataArr];
}

//订单详情
- (void)accessGetOrderDetail:(NSNumber*)orderListId
{
    [self.httpManager accessGetOrderDetail:orderListId];
}
- (void)didGetOrderDetail:(id)model
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kGetOrderDetail object:model];
}

//确认提款
- (void)accessOrderNotarize:(NSNumber*)orderListId
{
    [self.httpManager accessOrderNotarize:orderListId];
}

- (void)didFinishOrderNotarize:(id)model
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kOrderNotarize object:model];
}

//一键确认订单
- (void)accessAllOrderNotarize
{
    [self.httpManager accessAllOrderNotarize];
}

- (void)didFinishAllOrderNotarize:(id)model
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kAllOrderNotarize object:model];
}

//账户信息
- (void)accessGetCompanyAccount
{
    [self.httpManager accessGetCompanyAccount];
}

- (void)didGetCompanyAccount:(id)model
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kGetCompanyAccount object:model];
}

- (void)accessAcquireCode:(NSString *)phone andMessage:(NSString *)message{
    [self.httpManager accessAcquireCode:phone andMessage:message];
}

- (void)didGetAcquireCode:(NSString *)whetherSuccess{
    [[NSNotificationCenter defaultCenter] postNotificationName:kAcquireCode object:whetherSuccess];
}

//增加绑定银行卡
- (void)accessInsertBankCard:(NSString*)cardUserName andBankName:(NSString*)bankName andBankNo:(NSString*)bankNo andPhone:(NSString*)phone andVerifyCode:(NSString*)verifyCode
{
    [self.httpManager accessInsertBankCard:cardUserName andBankName:bankName andBankNo:bankNo andPhone:phone andVerifyCode:verifyCode];
}
- (void)didInsertBank:(id)model
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kInsertBank object:model];
}

//删除银行卡
- (void)accessDeleteBankCard:(NSNumber*)bankId
{
    [self.httpManager accessDeleteBankCard:bankId];
}
- (void)didDeleteBankCard:(id)model
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kDeleteBank object:model];
}

//提取现金
- (void)accessWithdrawCash:(NSNumber*)bankId andPayPassword:(NSString*)payPassword andMoney:(NSNumber*)money
{
    [self.httpManager accessWithdrawCash:bankId andPayPassword:payPassword andMoney:money];
}
- (void)didWithdrawCash:(id)model
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kWithdrawCash object:nil];
}

//我的服务
- (void)accessGetMyService
{
    [self.httpManager accessGetMyService];
}
- (void)didGetMyService:(NSArray*)dataArr
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kMyService object:nil];
}

//修改登录密码
- (void)accessAcommendLoginPwd:(NSString *)oldPassword andPassword:(NSString *)password andVerifyPassword:(NSString *)verifyPassword{
    [self.httpManager accessAcommendLoginPwd:oldPassword andPassword:password andVerifyPassword:verifyPassword];
}
- (void)didGetNewLoginPwd:(NSString *)message{
    [[NSNotificationCenter defaultCenter] postNotificationName:kAcommendLoginPwd object:message];
}

//找回登录密码
- (void)accessFindLoginPwd:(NSString *)phone andVerifyCode:(NSString *)verifyCode{
    [self.httpManager accessFindLoginPwd:phone andVerifyCode:verifyCode];
}
- (void)didGetLoginPwd:(QLoginModel *)dataArr{
    [[NSNotificationCenter defaultCenter] postNotificationName:kFindLoginPwd  object:dataArr];
}

//确认找回登录密码
- (void)accessSureFindLoginPwd:(NSString *)newPassword andVerifyNewPassword:(NSString *)verifyNewPassword{
    [self.httpManager accessSureFindLoginPwd:newPassword andVerifyNewPassword:verifyNewPassword];
}
- (void)didGetSureFindLginPwd:(NSString *)message{
    [[NSNotificationCenter defaultCenter] postNotificationName:kSureFindLoginPwd object:message];
}


//修改支付密码
- (void)accessAcommendPayPwd:(NSString *)oldPayPasswd andNewPayPasswd:(NSString *)newPayPasswd andVerifyNewPayPasswd:(NSString *)verifyNewPayPasswd{
    [self.httpManager accessAcommendPayPwd:oldPayPasswd andNewPayPasswd:newPayPasswd andVerifyNewPayPasswd:verifyNewPayPasswd];
}
- (void)didGetNewPayPwd:(NSString *)message{
    [[NSNotificationCenter defaultCenter] postNotificationName:kAcommedPayPwd object:message];
}
//找回支付密码
- (void)accessFindePayPwd:(NSString *)phone andVerifyCode:(NSString *)verifyCode{
    [self.httpManager accessFindePayPwd:phone andVerifyCode:verifyCode];
}
- (void)didGetPayPwd:(NSString *)message{
    [[NSNotificationCenter defaultCenter] postNotificationName:kFindPayPwd object:message];
}
//设置支付密码
- (void)accessSetPayPwd:(NSString *)payPasswd andVerifyPayPasswd:(NSString *)verifyPayPasswd andPhone:(NSString *)phone andVerifyCode:(NSString *)verifyCode{
    [self.httpManager accessSetPayPwd:payPasswd andVerifyPayPasswd:verifyPayPasswd andPhone:phone andVerifyCode:verifyCode];
}
- (void)didSetPayPwd:(NSString *)message{
    [[NSNotificationCenter defaultCenter] postNotificationName:kSetPayPwd object:message];
}

- (void)accessReSetPayPwd:(NSString *)payPasswd andVerifyPayPasswd:(NSString *)verifyPayPasswd{
    [self.httpManager accessReSetPayPwd:payPasswd andVerifyPayPasswd:verifyPayPasswd];
}

- (void)didReSetPayPwd:(NSString*)message{
    [[NSNotificationCenter defaultCenter] postNotificationName:kReSetPayPwd object:message];
}

//协议
- (void)accessGetAgreement:(int)agreementType
{
    [self.httpManager accessGetAgreement:agreementType];
}

- (void)didGetAgreement:(id)model
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kGetAgreement object:model];
}

@end
