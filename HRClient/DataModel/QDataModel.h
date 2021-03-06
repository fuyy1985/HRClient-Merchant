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

@interface QCompanyModel : QDataModel

@property (nonatomic, strong) NSNumber *companyId;
@property (nonatomic, strong) NSNumber *userId;
@property (nonatomic, strong) NSString *legalPerson;
@property (nonatomic, strong) NSString *companyName;
@property (nonatomic, strong) NSString *companyTel;
@property (nonatomic, strong) NSString *regionId;
@property (nonatomic, strong) NSString *regionName;
@property (nonatomic, strong) NSString *detailAddress;
@property (nonatomic, strong) NSString *locationBased;
@property (nonatomic, strong) NSString *longitude;
@property (nonatomic, strong) NSString *latitude;
@property (nonatomic, strong) NSString *telphone;
@property (nonatomic, strong) NSString *tradeLineId;
@property (nonatomic, strong) NSString *introduction;
@property (nonatomic, strong) NSString *gmtCreate;
@property (nonatomic, strong) NSString *gmtModified;
@property (nonatomic, strong) NSString *createUser;
@property (nonatomic, strong) NSString *modifiedUser;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *distance;
@property (nonatomic, strong) NSString *businessLicense;
@property (nonatomic, strong) NSString *outImage;
@property (nonatomic, strong) NSString *inImage;
@property (nonatomic, strong) NSString *photoPath;

+ (QCompanyModel*)getModelFromDic:(NSDictionary*)dic;

@end


@interface QScanModel : QDataModel
@property (nonatomic, strong) NSString *orderListNo;
@property (nonatomic, strong) NSString *verificationCode;
@property (nonatomic, strong) NSString *subject;
@property (nonatomic, strong) NSNumber *quantity;
@property (nonatomic, strong) NSNumber *total;

+ (QScanModel *)getModelFromDic:(NSDictionary *)dic;


@end

@interface QOrderModel : QDataModel

@property (nonatomic, strong) NSString *orderListNo;
@property (nonatomic, strong) NSNumber *orderListId;
@property (nonatomic, strong) NSNumber *gmtCreate;
@property (nonatomic, strong) NSString *nick;
@property (nonatomic, strong) NSString *subject;
@property (nonatomic, strong) NSNumber *price;
@property (nonatomic, strong) NSNumber *status;
@property (nonatomic, strong) NSNumber *receiptOrdLstId;
+ (QOrderModel *)getModelFromDic:(NSDictionary *)dic;

@end

@interface QOrderDetailModel : QDataModel
@property (nonatomic, strong) NSNumber *orderListId;
@property (nonatomic, strong) NSNumber *productId;
@property (nonatomic, strong) NSNumber *companyId;
@property (nonatomic, strong) NSNumber *payId;
@property (nonatomic, strong) NSNumber *unit_price;
@property (nonatomic, strong) NSNumber *price;
@property (nonatomic, strong) NSNumber *total;
@property (nonatomic, strong) NSNumber *actualSettlement;
@property (nonatomic, strong) NSNumber *quantity;
@property (nonatomic, strong) NSString *photo;
@property (nonatomic, strong) NSString *subject;
@property (nonatomic, strong) NSNumber *status;
@property (nonatomic, strong) NSNumber *gmtCreate;
@property (nonatomic, strong) NSNumber *gmtModified;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *orderListNo;
@property (nonatomic, strong) NSNumber *guaranteePeriod;
@property (nonatomic, strong) NSNumber *or_member;
@property (nonatomic, strong) NSNumber *returnNotSpending;
@property (nonatomic, strong) NSNumber *returnOverdue;
@property (nonatomic, strong) NSNumber *returnDissatisfied;
@property (nonatomic, strong) NSString *payNo;
@property (nonatomic, strong) NSNumber *expireDate;
@property (nonatomic, strong) NSString *verificationCode;

+ (QOrderDetailModel *)getModelFromDic:(NSDictionary *)dic;

@end

@interface QCompanyAccount : QDataModel

@property (nonatomic, strong) NSString *legalPerson;
@property (nonatomic, strong) NSString *telphone;
@property (nonatomic, strong) NSNumber *balance;
@property (nonatomic, strong) NSNumber *limitMin;
@property (nonatomic, strong) NSNumber *limitMax;
@property (nonatomic, strong) NSArray *bankList;

+ (QCompanyAccount*)getModelFromDic:(NSDictionary *)dic;

@end

@interface QBankModel : QDataModel

@property (nonatomic, strong) NSNumber *userId;
@property (nonatomic, strong) NSString *accName;
@property (nonatomic, strong) NSNumber *accType;
@property (nonatomic, strong) NSNumber *bankId;
@property (nonatomic, strong) NSString *bankName;
@property (nonatomic, strong) NSString *bankNo;
@property (nonatomic, strong) NSString *bankAddress;

@property (nonatomic, strong) NSNumber *createUser;
@property (nonatomic, strong) NSNumber *gmtCreate;
@property (nonatomic, strong) NSNumber *modifiedUser;
@property (nonatomic, strong) NSNumber *gmtModified;

@property (nonatomic, strong) NSNumber *status;

+ (QBankModel*)getModelFromDic:(NSDictionary *)dic;

@end

@interface QServiceModel : QDataModel

@property (nonatomic, strong) NSString *categoryName;
@property (nonatomic, strong) NSNumber *price;
@property (nonatomic, strong) NSNumber *bidPrice;
@property (nonatomic, strong) NSNumber *bidType;
@property (nonatomic, strong) NSNumber *guaranteePeriod;
@property (nonatomic, strong) NSNumber *gmtModified;

+ (QServiceModel*)getModelFromDic:(NSDictionary *)dic;

@end

@interface QAgreementModel : NSObject

@property (nonatomic, strong) NSNumber *agreementType;
@property (nonatomic, copy) NSString *content;

+ (QAgreementModel *)getModelFromDic:(NSDictionary *)dic;

@end

