//
//  QHttpManager.m
//  HRClient
//
//  Created by ekoo on 15/1/4.
//  Copyright (c) 2015年 panyj. All rights reserved.
//

#import "QHttpManager.h"
#import "QDataModel.h"
#import "QViewController.h"
#import "QDataCenter.h"

@interface QHttpManager (){
    NSArray *cookie;
    NSString *str1;
}

@end

@implementation QHttpManager

- (id)initWithDelegate:(id<QiaoHttpDelegate>)delegate{
    if (self = [super init]) {
//        开辟空间
        _networkQueue = [[ASINetworkQueue alloc] init];
//        设置代理
        _networkQueue.delegate = self;
//        设置回调方法
//        设置一个线程开始启动时的回调方法
        [_networkQueue setRequestDidStartSelector:@selector(requestDidStart:)];
        //        2)设置一个线程成功结束时的回调方法
        [_networkQueue setRequestDidFinishSelector:@selector(requestDidFinish:)];
        //        3)设置一个线程失败时的回调方法
        [_networkQueue setRequestDidFailSelector:@selector(requestDidFail:)];
        //        4)设置队列里面所有的线程都结束的回调方法
        [_networkQueue setQueueDidFinishSelector:@selector(queueDidFinish:)];
        //
        self.delegate = delegate;
    }
    return self;
}

#pragma mark - Operate queue
//判断self.netWorkQueue是否处于运行状态
- (BOOL)isRunning
{
    return ![self.networkQueue isSuspended];
}
//启动队列
- (void)start
{
    if( [self.networkQueue isSuspended] )
        [self.networkQueue go];
}
//停止
- (void)pause
{
    [self.networkQueue setSuspended:YES];
}
//重新开始
- (void)resume
{
    [self.networkQueue setSuspended:NO];
}
//取消队列里面所有线程
- (void)cancel
{
    [self.networkQueue cancelAllOperations];
}

#pragma mark --代理回调方法
//开始
- (void)requestDidStart:(ASIHTTPRequest*)request{
    
}


//成功返回
- (void)requestDidFinish:(ASIHTTPRequest*)request
{
    //1.用NSData类型的指针去接收数据
    NSData *dataResult = [request responseData];
    //2.解析数据
    NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:dataResult options:NSJSONReadingMutableContainers error:nil];
    //3.创建一个可变的数组，目的：添加数据模型对象
    NSMutableArray *modeArray = [NSMutableArray array];
    NSNumber *number = [request.userInfo objectForKey:USER_INFO_KEY_TYPE];
    RequestType requestType = [number intValue];
    if ([[resultDic objectForKey:@"status"] intValue] == 0)
    {
        NSString *failure = [resultDic objectForKey:@"message"];
        if (![failure isEqualToString:@""])
        {
            debug_NSLog(@"errcode:%d", requestType);
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(didGetDataFailed:)]) {
                [self.delegate didGetDataFailed:requestType];
            }
            
            if (failure && ![failure isEqualToString:@""])
            {
                [ASRequestHUD showErrorWithStatus:failure];
            }
            else
            {
                [ASRequestHUD dismiss];
            }
            
            return;
        }
    }
    else if([[resultDic objectForKey:@"status"] intValue] == 1){
        //  状态为1时
        switch (requestType) {
            case kLogin:
            {
                NSDictionary *result1 = [resultDic objectForKey:@"result"];
                QLoginModel  *loginModel = [QLoginModel getModelFromDic:[result1 objectForKey:@"user"]];
                [QDataCenter sharedDataCenter]->loginModel = loginModel;
                
                QCompanyModel *companyModel = [QCompanyModel getModelFromDic:[result1 objectForKey:@"company"]];
                [QDataCenter sharedDataCenter]->companyModel = companyModel;
                
                if ([self.delegate respondsToSelector:@selector(didGetLogin:)]) {
                    [self.delegate didGetLogin:loginModel];
                }
                
                
                cookie = [request responseCookies];
                debug_NSLog(@"cookie%@",cookie);
            }
                break;
            case kScanCode:
            {
                NSDictionary *dict = [resultDic objectForKey:@"result"];
                QScanModel *model = [QScanModel getModelFromDic:dict];
                
                if ([self.delegate respondsToSelector:@selector(didScanCode:)]) {
                    [self.delegate didScanCode:model];
                }
            }
                break;
            case kGetOrderList:
            {
                NSArray *resultArray = [resultDic objectForKey:@"result"];
                for (NSDictionary *dict in resultArray)
                {
                    QOrderModel *hotModel = [QOrderModel getModelFromDic:dict];
                    [modeArray addObject:hotModel];
                }
                if ([self.delegate respondsToSelector:@selector(didGetOrderList:)]) {
                    [self.delegate didGetOrderList:modeArray];
                }
            }
                break;
            case kDeleteOrder:
            {
                if ([self.delegate respondsToSelector:@selector(didDeleteOrder:)]) {
                    [self.delegate didDeleteOrder:nil];
                }
            }
                break;
            case kGetOrderDetail:
            {
                NSDictionary *dict = [resultDic objectForKey:@"result"];
                QOrderDetailModel *model = [QOrderDetailModel getModelFromDic:dict];
                if ([self.delegate respondsToSelector:@selector(didGetOrderDetail:)]) {
                    [self.delegate didGetOrderDetail:model];
                }
            }
                break;
            case kOrderNotarize:
            {
                if (self.delegate && [self.delegate respondsToSelector:@selector(didFinishOrderNotarize:)]) {
                    [self.delegate didFinishOrderNotarize:nil];
                }
            }
                break;
            case kAllOrderNotarize:
            {
                if ([self.delegate respondsToSelector:@selector(didFinishAllOrderNotarize:)]) {
                    [self.delegate didFinishAllOrderNotarize:nil];
                }
            }
                break;
            case kGetCompanyAccount:
            {
                NSDictionary *dict = [resultDic objectForKey:@"result"];
                
                QCompanyAccount *model = [QCompanyAccount getModelFromDic:dict];
                [QDataCenter sharedDataCenter]->companyAccountModel = model;
                
                if ([self.delegate respondsToSelector:@selector(didGetCompanyAccount:)]) {
                    [self.delegate didGetCompanyAccount:model];
                }
            }
                break;
            case kAcquireCode://验证码
            {
                NSString *success = [resultDic objectForKey:@"message"];
                if ([self.delegate respondsToSelector:@selector(didGetAcquireCode:)]) {
                    [self.delegate didGetAcquireCode:success];
                }
            }
                break;
            case kInsertBank:
            {
                if ([self.delegate respondsToSelector:@selector(didInsertBank:)]) {
                    [self.delegate didInsertBank:nil];
                }
            }
                break;
            case kDeleteBank:
            {
                if ([self.delegate respondsToSelector:@selector(didDeleteBankCard:)]){
                    [self.delegate didDeleteBankCard:nil];
                }
            }
                break;
            case kWithdrawCash:
            {
                if ([self.delegate respondsToSelector:@selector(didWithdrawCash:)]) {
                    [self.delegate didWithdrawCash:nil];
                }
            }
                break;
            case kMyService:
            {
                NSArray *resultArray = [resultDic objectForKey:@"result"];
                for (NSDictionary *dict in resultArray)
                {
                    QServiceModel *hotModel = [QServiceModel getModelFromDic:dict];
                    [modeArray addObject:hotModel];
                }
                if ([self.delegate respondsToSelector:@selector(didGetMyService:)]) {
                    [self.delegate didGetMyService:modeArray];
                }
            }
                break;
            
            case kAcommendPayPwd:
            {//修改支付密码
                NSString *alertStr = [resultDic objectForKey:@"message"];
                if ([self.delegate respondsToSelector:@selector(didGetNewPayPwd:)]) {
                    [self.delegate didGetNewPayPwd:alertStr];
                }
            }
                break;
            case kFindPayPwd:
            {//找回支付密码
                NSString *alertStr = [resultDic objectForKey:@"message"];
                if ([self.delegate respondsToSelector:@selector(didGetPayPwd:)]) {
                    [self.delegate didGetPayPwd:alertStr];
                }
            }
                break;
            case kSetPayPwd:
            {//设置支付密码
                NSString *message = [resultDic objectForKey:@"message"];
                if ([self.delegate respondsToSelector:@selector(didSetPayPwd:)]) {
                    [self.delegate didSetPayPwd:message];
                }
                
            }
                break;
            case kReSetPayPwd:
            {
                NSString *message = [resultDic objectForKey:@"message"];
                if ([self.delegate respondsToSelector:@selector(didReSetPayPwd:)]) {
                    [self.delegate didReSetPayPwd:message];
                }
            }
                break;
            
            case kFindLoginPwd:
            {//找回登录密码
                NSDictionary *result = [resultDic objectForKey:@"result"];
                QLoginModel  *loginModel = [QLoginModel getModelFromDic:result];
                if ([self.delegate respondsToSelector:@selector(didGetLoginPwd:)]) {
                    [self.delegate didGetLoginPwd:loginModel];
                }
            }
                break;
            case kSureFindLoginPwd:
            {//确认找回
                NSString *alertStr = [resultDic objectForKey:@"message"];
                if ([self.delegate respondsToSelector:@selector(didGetSureFindLginPwd:)]) {
                    [self.delegate didGetSureFindLginPwd:alertStr];
                }
            }
                break;
            
            case kAcommendLoginPwd:
            {//修改登录密码
                NSString *message = [resultDic objectForKey:@"message"];
                if ([self.delegate respondsToSelector:@selector(didGetNewLoginPwd:)]) {
                    [self.delegate didGetNewLoginPwd:message];
                }
            }
                break;
            case kGetAgreement:
            {
                NSDictionary *agreeDict = [resultDic objectForKey:@"result"];
                
                QAgreementModel *model = [QAgreementModel getModelFromDic:agreeDict];
                
                if (self.delegate && [self.delegate respondsToSelector:@selector(didGetAgreement:)]) {
                    [self.delegate didGetAgreement:model];
                }
            }
                break;
            default:
                break;
        }
    }
}

//失败
- (void)requestDidFail:(ASIHTTPRequest*)request
{
    [ASRequestHUD showErrorWithStatus:@"网络异常，请稍后尝试"];
    NSError *err = [request error];
    debug_NSLog(@"%@",err);
    
    NSNumber *number = [request.userInfo objectForKey:USER_INFO_KEY_TYPE];
    RequestType requestType = [number intValue];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didGetDataFailed:)]) {
        [self.delegate didGetDataFailed:requestType];
    }
}
//所有线程任务完成
- (void)queueDidFinish:(ASINetworkQueue*)networkQueue{
    
}

#pragma mark -- 设置request的userInfo属性
-(void)setGetMthodWith:(ASIHTTPRequest*)request andRequestType:(RequestType)type{
    NSNumber *number = [NSNumber numberWithInt:type];
    NSDictionary *tempDic = [NSDictionary dictionaryWithObject:number forKey:USER_INFO_KEY_TYPE];
    [request setUserInfo:tempDic];
}

#pragma mark --接口访问的方法

//登录
- (void)accessLogin:(NSString *)nick andPassword:(NSString *)password
{
    NSString *path = [NSString stringWithFormat:@"%@%@",SERVERADRESS, Q_Login];
    NSURL *url = [NSURL URLWithString:path];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setRequestMethod:@"POST"];
    [request setPostValue:nick forKey:@"nick"];
    [request setPostValue:password forKey:@"password"];
    [request setUseCookiePersistence:YES];
    [self setGetMthodWith:request andRequestType:kLogin];
    [_networkQueue addOperation:request];
}
//扫描用户版的二维码
- (void)accessScanCode:(NSString*)verificationCode
{
    NSString *path = [NSString stringWithFormat:@"%@%@",SERVERADRESS, Q_ScanCode];
    NSURL *url = [NSURL URLWithString:path];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setRequestMethod:@"POST"];
    [request setPostValue:verificationCode forKey:@"verificationCode"];
    [request setUseCookiePersistence:YES];
    [self setGetMthodWith:request andRequestType:kScanCode];
    [_networkQueue addOperation:request];
}
//订单列表, 2-待服务，5-退款，7-待确认 , 8-已提款（已成交)
- (void)accessGetOrderList:(int)nextPage
{
    NSString *path = [NSString stringWithFormat:@"%@%@",SERVERADRESS, Q_OrderList];
    NSURL *url = [NSURL URLWithString:path];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setRequestMethod:@"POST"];
    [request setPostValue:[NSNumber numberWithInt:nextPage] forKey:@"currentPage"];
    [request setPostValue:[NSNumber numberWithInt:10] forKey:@"pageSize"];
    [request setUseCookiePersistence:YES];
    [self setGetMthodWith:request andRequestType:kGetOrderList];
    [_networkQueue addOperation:request];
}

//删除订单
- (void)accessDeleteOrder:(NSNumber*)orderListId
{
    NSString *path = [NSString stringWithFormat:@"%@%@",SERVERADRESS, Q_DeleteOrder];
    NSURL *url = [NSURL URLWithString:path];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setRequestMethod:@"POST"];
    [request setPostValue:orderListId forKey:@"orderListId"];
    [request setUseCookiePersistence:YES];
    [self setGetMthodWith:request andRequestType:kDeleteOrder];
    [_networkQueue addOperation:request];
}

//订单详情
- (void)accessGetOrderDetail:(NSNumber*)orderListId
{
    NSString *path = [NSString stringWithFormat:@"%@%@",SERVERADRESS, Q_OrderDetail];
    NSURL *url = [NSURL URLWithString:path];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setRequestMethod:@"POST"];
    [request setPostValue:orderListId forKey:@"orderListId"];
    [request setUseCookiePersistence:YES];
    [self setGetMthodWith:request andRequestType:kGetOrderDetail];
    [_networkQueue addOperation:request];
}

//确认订单
- (void)accessOrderNotarize:(NSNumber*)orderListId
{
    NSString *path = [NSString stringWithFormat:@"%@%@",SERVERADRESS, Q_OrderNotarize];
    NSURL *url = [NSURL URLWithString:path];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setRequestMethod:@"POST"];
    [request setPostValue:orderListId forKey:@"receiptOrdLstId"];
    [request setUseCookiePersistence:YES];
    [self setGetMthodWith:request andRequestType:kOrderNotarize];
    [_networkQueue addOperation:request];
}
//一键确认订单
- (void)accessAllOrderNotarize
{
    NSString *path = [NSString stringWithFormat:@"%@%@",SERVERADRESS, Q_AllOrderNotarize];
    NSURL *url = [NSURL URLWithString:path];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setRequestMethod:@"POST"];
    [request setUseCookiePersistence:YES];
    [self setGetMthodWith:request andRequestType:kAllOrderNotarize];
    [_networkQueue addOperation:request];
}
//账户信息
- (void)accessGetCompanyAccount
{
    NSString *path = [NSString stringWithFormat:@"%@%@",SERVERADRESS, Q_CompanyAccount];
    NSURL *url = [NSURL URLWithString:path];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setRequestMethod:@"POST"];
    [request setUseCookiePersistence:YES];
    [self setGetMthodWith:request andRequestType:kGetCompanyAccount];
    [_networkQueue addOperation:request];
}
//获取验证码
- (void)accessAcquireCode:(NSString *)phone andMessage:(NSString *)message
{
    NSString *path = [NSString stringWithFormat:@"%@%@",SERVERADRESS,Q_AcquireCode];
    NSURL *url = [NSURL URLWithString:path];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setRequestMethod:@"POST"];
    [request setPostValue:phone forKey:@"phone"];
    [request setPostValue:message forKey:@"message"];
    [self setGetMthodWith:request andRequestType:kAcquireCode];
    [_networkQueue addOperation:request];
}
//添加银行卡
- (void)accessInsertBankCard:(NSString*)cardUserName andBankName:(NSString*)bankName andBankNo:(NSString*)bankNo andPhone:(NSString*)phone andVerifyCode:(NSString*)verifyCode
{
    NSString *path = [NSString stringWithFormat:@"%@%@",SERVERADRESS, Q_InsertBank];
    NSURL *url = [NSURL URLWithString:path];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setRequestMethod:@"POST"];
    [request setPostValue:cardUserName forKey:@"accName"];
    [request setPostValue:bankName forKey:@"bankName"];
    [request setPostValue:bankNo forKey:@"bankNo"];
    [request setPostValue:phone forKey:@"phone"];
    [request setPostValue:verifyCode forKey:@"verifyCode"];
    [self setGetMthodWith:request andRequestType:kInsertBank];
    [_networkQueue addOperation:request];
}
//删除银行卡
- (void)accessDeleteBankCard:(NSNumber*)bankId
{
    NSString *path = [NSString stringWithFormat:@"%@%@",SERVERADRESS, Q_DeleteBank];
    NSURL *url = [NSURL URLWithString:path];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setRequestMethod:@"POST"];
    [request setPostValue:bankId forKey:@"bankId"];
    [self setGetMthodWith:request andRequestType:kDeleteBank];
    [_networkQueue addOperation:request];
}

//提取现金
- (void)accessWithdrawCash:(NSNumber*)bankId andPayPassword:(NSString*)payPassword andMoney:(NSNumber*)money
{
    NSString *path = [NSString stringWithFormat:@"%@%@",SERVERADRESS, Q_WithdrawCash];
    NSURL *url = [NSURL URLWithString:path];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setRequestMethod:@"POST"];
    [request setPostValue:bankId forKey:@"bankId"];
    [request setPostValue:payPassword forKey:@"payPasswd"];
    [request setPostValue:money forKey:@"money"];
    [self setGetMthodWith:request andRequestType:kWithdrawCash];
    [_networkQueue addOperation:request];
}

//我的服务
- (void)accessGetMyService
{
    NSString *path = [NSString stringWithFormat:@"%@%@",SERVERADRESS, Q_MyService];
    NSURL *url = [NSURL URLWithString:path];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setRequestMethod:@"POST"];
    [self setGetMthodWith:request andRequestType:kMyService];
    [_networkQueue addOperation:request];
}

//修改登录密码
- (void)accessAcommendLoginPwd:(NSString *)oldPassword andPassword:(NSString *)password andVerifyPassword:(NSString *)verifyPassword{
    NSString *path = [NSString stringWithFormat:@"%@%@",SERVERADRESS,Q_ACOMMEND_LOGIN_KEY];
    NSURL *url = [NSURL URLWithString:path];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setRequestMethod:@"POST"];
    [request setPostValue:oldPassword forKey:@"oldPassword"];
    [request setPostValue:password forKey:@"password"];
    [request setPostValue:verifyPassword forKey:@"verifyPassword"];
    [request setUseCookiePersistence:YES];
    [self setGetMthodWith:request andRequestType:kSureFindLoginPwd];
    [_networkQueue addOperation:request];
}

//找回登录密码
- (void)accessFindLoginPwd:(NSString *)phone andVerifyCode:(NSString *)verifyCode{
    NSString *path = [NSString stringWithFormat:@"%@%@",SERVERADRESS,Q_FIND_LOGIN_PWD];
    NSURL *url = [NSURL URLWithString:path];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setRequestMethod:@"POST"];
    [request setPostValue:phone forKey:@"phone"];
    [request setPostValue:verifyCode forKey:@"verifyCode"];
    [request setUseCookiePersistence:YES];
    [self setGetMthodWith:request andRequestType:kFindLoginPwd];
    [_networkQueue addOperation:request];
}
//确认找回登录密码
- (void)accessSureFindLoginPwd:(NSString *)newPassword andVerifyNewPassword:(NSString *)verifyNewPassword{
    NSString *path = [NSString stringWithFormat:@"%@%@",SERVERADRESS,Q_SURE_FIND_LOGIN_PWD];
    NSURL *url = [NSURL URLWithString:path];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setRequestMethod:@"POST"];
    [request setPostValue:newPassword forKey:@"newPassword"];
    [request setPostValue:verifyNewPassword forKey:@"verifyNewPassword"];
    [request setUseCookiePersistence:YES];
    [self setGetMthodWith:request andRequestType:kSureFindLoginPwd];
    [_networkQueue addOperation:request];
}

//修改支付密码
- (void)accessAcommendPayPwd:(NSString *)oldPayPasswd andNewPayPasswd:(NSString *)newPayPasswd andVerifyNewPayPasswd:(NSString *)verifyNewPayPasswd{
    NSString *path = [NSString stringWithFormat:@"%@%@",SERVERADRESS,Q_ACOMMENDPAYPWD];
    NSURL *url = [NSURL URLWithString:path];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setRequestMethod:@"POST"];
    [request setPostValue:oldPayPasswd forKey:@"oldPayPasswd"];
    [request setPostValue:newPayPasswd forKey:@"newPayPasswd"];
    [request setPostValue:verifyNewPayPasswd forKey:@"verifyNewPayPasswd"];
    [request setUseCookiePersistence:YES];
    [self setGetMthodWith:request andRequestType:kAcommendPayPwd];
    [_networkQueue addOperation:request];
}
//找回支付密码
- (void)accessFindePayPwd:(NSString *)phone andVerifyCode:(NSString *)verifyCode{
    NSString *path = [NSString stringWithFormat:@"%@%@",SERVERADRESS,Q_FINDPAYPWD];
    NSURL *url = [NSURL URLWithString:path];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setRequestMethod:@"POST"];
    [request setPostValue:phone forKey:@"phone"];
    [request setPostValue:verifyCode forKey:@"verifyCode"];
    [request setUseCookiePersistence:YES];
    [self setGetMthodWith:request andRequestType:kFindPayPwd];
    [_networkQueue addOperation:request];
}
//设置支付密码
- (void)accessSetPayPwd:(NSString *)payPasswd andVerifyPayPasswd:(NSString *)verifyPayPasswd andPhone:(NSString *)phone andVerifyCode:(NSString *)verifyCode{
    NSString *path = [NSString stringWithFormat:@"%@%@",SERVERADRESS,Q_SET_PAYPWD];
    NSURL *url = [NSURL URLWithString:path];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setRequestMethod:@"POST"];
    [request setPostValue:payPasswd forKey:@"payPasswd"];
    [request setPostValue:verifyPayPasswd forKey:@"verifyPayPasswd"];
    [request setPostValue:phone forKey:@"phone"];
    [request setPostValue:verifyCode forKey:@"verifyCode"];
    [request setUseCookiePersistence:YES];
    [self setGetMthodWith:request andRequestType:kSetPayPwd];
    [_networkQueue addOperation:request];
}
//重置支付密码
- (void)accessReSetPayPwd:(NSString *)payPasswd andVerifyPayPasswd:(NSString *)verifyPayPasswd
{
    NSString *path = [NSString stringWithFormat:@"%@%@",SERVERADRESS,Q_RESET_PAYPWD];
    NSURL *url = [NSURL URLWithString:path];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setRequestMethod:@"POST"];
    [request setPostValue:payPasswd forKey:@"newPayPasswd"];
    [request setPostValue:verifyPayPasswd forKey:@"verifyNewPayPasswd"];
    [request setUseCookiePersistence:YES];
    [self setGetMthodWith:request andRequestType:kReSetPayPwd];
    [_networkQueue addOperation:request];
}

//协议
- (void)accessGetAgreement:(int)agreementType
{
    NSString *path = [NSString stringWithFormat:@"%@%@", SERVERADRESS, Q_GET_AGREEMENT];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:path]];
    [request setRequestMethod:@"POST"];
    [request setPostValue:[NSNumber numberWithInt:agreementType] forKey:@"agreementType"];
    [request setUseCookiePersistence:YES];
    [self setGetMthodWith:request andRequestType:kGetAgreement];
    [_networkQueue addOperation:request];
}

@end
