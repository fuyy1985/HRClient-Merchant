//
//  QCheckOrder.m
//  HRClient
//
//  Created by chenyf on 14/12/2.
//  Copyright (c) 2014年 panyj. All rights reserved.
//

#import "QCheckOrder.h"
#import "QViewController.h"
#import "QHttpMessageManager.h"

@implementation QCheckOrder

- (NSString*)title
{
    return _T(@"验单");
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
        [[QHttpMessageManager sharedHttpMessageManager] accessScanCode:@"999034926502"];
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
