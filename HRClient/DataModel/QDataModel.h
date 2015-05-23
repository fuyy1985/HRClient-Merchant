//
//  QDataModel.h
//  HRClient
//
//  Created by amy.fu on 15/5/23.
//  Copyright (c) 2015年 panyj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QDataModel : NSObject

@end

@interface QLoginModel : QDataModel

@property (nonatomic,strong)NSNumber *balance;
@property (nonatomic,strong)NSNumber *ticket;
@property (nonatomic,strong)NSNumber *member;
@property (nonatomic,copy)NSString *photoPath;
@property (nonatomic,strong)NSNumber *userId;
@property (nonatomic, strong)NSString *realName;
@property (nonatomic,copy)NSString *nick;
@property (nonatomic,copy)NSString *mail;
@property (nonatomic,copy)NSString *phone;
@property (nonatomic,copy)NSString *password;
@property (nonatomic,copy)NSString *payPasswd;
@property (nonatomic,strong)NSNumber *gmtCreate;
@property (nonatomic,strong)NSNumber *gmtModified;
@property (nonatomic,strong)NSNumber *createUser;
@property (nonatomic,strong)NSNumber *modifiedUser;
@property (nonatomic,strong)NSNumber *status;

+ (QLoginModel *)getModelFromDic:(NSDictionary *)dic;

- (void)savetoLocal:(NSString*)password;

@end

@interface QScanModel : QDataModel
@property (nonatomic, strong) NSString *orderListNo;
@property (nonatomic, strong) NSString *verificationCode;
@property (nonatomic, strong) NSString *subject;
@property (nonatomic,strong)NSNumber *quantity;

+ (QScanModel *)getModelFromDic:(NSDictionary *)dic;


@end

@interface QOrderModel : QDataModel

@property (nonatomic, strong) NSString *orderListNo;
@property (nonatomic, strong) NSNumber *orderListId;
@property (nonatomic, strong) NSNumber *gmtCreate;
@property (nonatomic, strong) NSString *nick;
@property (nonatomic, strong) NSString *subject;
@property (nonatomic, strong) NSNumber *price;
@property (nonatomic,strong)NSNumber *status;
@property (nonatomic,strong)NSNumber *receiptOrdLstId;
+ (QOrderModel *)getModelFromDic:(NSDictionary *)dic;

@end