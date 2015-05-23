//
//  QDataModel.m
//  HRClient
//
//  Created by amy.fu on 15/5/23.
//  Copyright (c) 2015年 panyj. All rights reserved.
//

#import "QDataModel.h"

@implementation QDataModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
}

@end

@implementation QLoginModel

+ (QLoginModel *)getModelFromDic:(NSDictionary *)dic
{
    QLoginModel *model = [[QLoginModel alloc] init];
    [model setValuesForKeysWithDictionary:dic];
    return model;
}

/**
 password:
 nil, 退出登录,清除账号信息
 @“”, 无密码快速登录,一次有效
 @“XXXXXX”, 正常登录,下一次启动,自动验证登录
 */

- (void)savetoLocal:(NSString*)password
{
    NSUserDefaults *usrDefaults = [NSUserDefaults standardUserDefaults];
    //  加密
    //  NSString *password = [DES3Util encrypt:loginMoedel.password];
    //    [usrDefaults setObject:self.realName forKey:@"realName"];
    [usrDefaults setObject:self.mail forKey:@"mail"];
    [usrDefaults setObject:self.phone forKey:@"phone"];
    //  [usrDefaults setObject:loginMoedel.password forKey:@"password"];
    [usrDefaults setObject:self.gmtCreate forKey:@"gmtCreate"];
    [usrDefaults setObject:self.gmtModified forKey:@"gmtModified"];
    //  [usrDefaults setObject:loginMoedel.createUser forKey:@"createUser"];
    [usrDefaults setObject:self.modifiedUser forKey:@"modifiedUser"];
    [usrDefaults setObject:self.status forKey:@"status"];
    //  [usrDefaults setObject:loginMoedel.photoPath forKey:@"photoPath"];
    [usrDefaults synchronize];
    
    if (password && ![password isEqualToString:@""]) {
        [ASUserDefaults setBool:YES forKey:LoginIsAutoLogin];
    }
    else {
        [ASUserDefaults setBool:NO forKey:LoginIsAutoLogin];
    }
    
    [ASUserDefaults setObject:self.phone forKey:LoginUserPhone];
    [ASUserDefaults setObject:self.payPasswd forKey:AccountPayPasswd];
    [ASUserDefaults setObject:self.userId forKey:AccountUserID];
    [ASUserDefaults setObject:self.nick forKey:AccountNick];
    [ASUserDefaults setObject:self.ticket forKey:AccountTicket];
    [ASUserDefaults setObject:password forKey:LoginUserPassCode];
    [ASUserDefaults setObject:self.member forKey:AccountIsMember];
    [ASUserDefaults setObject:self.balance forKey:AccountBalance];         //普通账户余额
    
    [ASUserDefaults synchronize];
}

@end

@implementation QScanModel

+ (QScanModel *)getModelFromDic:(NSDictionary *)dic
{
    QScanModel *model = [[QScanModel alloc] init];
    [model setValuesForKeysWithDictionary:dic];
    return model;
}

@end

@implementation QOrderModel

+ (QOrderModel *)getModelFromDic:(NSDictionary *)dic
{
    QOrderModel *model = [[QOrderModel alloc] init];
    [model setValuesForKeysWithDictionary:dic];
    return model;
}

@end

@implementation QOrderDetailModel

+ (QOrderDetailModel *)getModelFromDic:(NSDictionary *)dic
{
    QOrderDetailModel *model = [[QOrderDetailModel alloc] init];
    [model setValuesForKeysWithDictionary:dic];
    return model;
}

@end

@implementation QCompanyAccount

+ (QCompanyAccount*)getModelFromDic:(NSDictionary *)dic
{
    QCompanyAccount *model = [[QCompanyAccount alloc] init];
    [model setValuesForKeysWithDictionary:dic];
    return model;
}

- (void)setValue:(id)value forKey:(NSString *)key
{
    if ([key isEqualToString:@"bankList"])
    {
        NSMutableArray *mArray = [[NSMutableArray alloc] initWithCapacity:0];
        NSArray *list = (NSArray*)value;
        for (NSDictionary *dict in list)
        {
            QBankModel *model = [QBankModel getModelFromDic:dict];
            [mArray addObject:model];
        }
        self.bankList = mArray;
    }
    else if ([key isEqualToString:@"legalPerson"])
        self.legalPerson = value;
    else if ([key isEqualToString:@"telphone"])
        self.telphone = value;
    else if ([key isEqualToString:@"balance"])
        self.balance = value;
}

@end

@implementation QBankModel

+ (QBankModel*)getModelFromDic:(NSDictionary *)dic
{
    QBankModel *model = [[QBankModel alloc] init];
    [model setValuesForKeysWithDictionary:dic];
    return model;
}

@end


