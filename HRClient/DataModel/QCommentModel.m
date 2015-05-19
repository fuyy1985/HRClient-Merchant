//
//  QCommentModel.m
//  HRClient
//
//  Created by ekoo on 15/1/6.
//  Copyright (c) 2015年 panyj. All rights reserved.
//

#import "QCommentModel.h"

@implementation QCommentModel

+ (QCommentModel *)getModelFromCommentDic:(NSDictionary *)dic{
    QCommentModel *model = [[QCommentModel alloc] init];
    [model setValuesForKeysWithDictionary:dic];
    return model;
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    //    if ([key isEqualToString:@"id"]) {
    //        self.id000 = value;
    //    }
}
-(id)valueForUndefinedKey:(NSString *)key
{
    return nil;
}

@end
