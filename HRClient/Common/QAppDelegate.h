//
//  QAppDelegate.h
//  DSSClient
//
//  Created by pany on 14-4-18.
//  Copyright (c) 2014年 SDK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "ASIDownloadCache.h"


@interface QAppDelegate : UIResponder <UIApplicationDelegate>{
}

@property (strong, nonatomic) UIWindow *window;
@property (assign, nonatomic) UIBackgroundTaskIdentifier bgTask;
@property (nonatomic,strong)  ASIDownloadCache *myCache;

@property (nonatomic,strong)NSString *partner;
@property (nonatomic,strong)NSString *seller;
@property (nonatomic,strong)NSString *privateKey;

@end
