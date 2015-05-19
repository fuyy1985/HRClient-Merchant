//
//  QMyOrders.m
//  HRClient
//
//  Created by chenyf on 14/12/2.
//  Copyright (c) 2014年 panyj. All rights reserved.
//

#import "QMyOrders.h"
#import "QViewController.h"

@implementation QMyOrders

- (NSString*)title
{
    return _T(@"我的订单");
}

- (QCacheType)pageCacheType
{
    return kCacheTypeAlways;
}

- (QNavigationType)navigationType
{
    return kNavigationTypeNormal;
}

- (void)setActiveWithParams:(NSDictionary *)params
{
}

- (void)pageEvent:(QPageEventType)eventType
{
    if (eventType == kPageEventWillShow)
    {
        //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationDone:) name:Noti_Location_Done object:nil];
    }
    else if (eventType == kPageEventWillHide)
    {
        //[[NSNotificationCenter defaultCenter] removeObserver:self name:kHomePage object:nil];
    }
    else if (eventType == kPageEventViewCreate)
    {
    }
    else if (eventType == kPageEventViewDispose)
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}

- (QBottomMenuType)bottomMenuType
{
    return kBottomMenuTypeNormal;
}


- (UIView *)viewWithFrame:(CGRect)frame
{
    if ([super viewWithFrame:frame]) {
        
    }
    
    return _view;
}


@end
