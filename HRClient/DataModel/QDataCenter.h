//
//  QDataCenter.h
//  DahuaVision
//
//  Created by nobuts on 14-4-21.
//  Copyright (c) 2013年 Dahuatech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QConfigration.h"
#import "QDataModel.h"

@interface QDataCenter : NSObject
{
@public
    QLoginModel *loginModel;
    QCompanyModel *companyModel;
}

+ (QDataCenter *) sharedDataCenter;

@end
