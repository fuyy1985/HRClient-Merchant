//
//  QAppDelegate.m
//  DSSClient
//
//  Created by pany on 14-4-18.
//  Copyright (c) 2014年 SDK. All rights reserved.
//

#import "QAppDelegate.h"
#import "QConfigration.h"
#import "QViewController.h"
#import "QDataCenter.h"
#import "QGuidepageController.h"
#import "SDImageCache.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"

void handler(int n)
{
    //nothing
}

@implementation QAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    struct sigaction sa;
    sa.__sigaction_u.__sa_handler = handler;
    sigaction(SIGPIPE, &sa, 0);
    
    [UMSocialData setAppKey:UMSocalAppKey];
    
    //urlType也需要改，是appid，我写的是appkey
    [UMSocialWechatHandler setWXAppId:@"wxba1f0f3a73571da2" appSecret:@"60837783636e52eedd34b7675c0d793c"
                                  url:@"http://www.wanliwuyou.com/member/downloadiPhone.html"];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    [[QConfigration sharedInstance] loadFile];
    
    //start
    self.window.rootViewController = [QViewController shareController];
    
    NSString *bundledPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"CustomPathImages"];
    [[SDImageCache sharedImageCache] addReadOnlyCachePath:bundledPath];
    
    [self installDownloadCache];
    return YES;
}

- (void)installDownloadCache
{
    NSURLCache *URLCache = [[NSURLCache alloc] initWithMemoryCapacity:4 * 1024 * 1024 diskCapacity:20 * 1024 * 1024 diskPath:nil];
    [NSURLCache setSharedURLCache:URLCache];
    ASIDownloadCache *cache = [[ASIDownloadCache alloc] init];
    self.myCache = cache;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    [self.myCache setStoragePath:[documentDirectory stringByAppendingPathComponent:@"resource"]];
    [self.myCache setDefaultCachePolicy:ASIOnlyLoadIfNotCachedCachePolicy];
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [QConfigration saveFile];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [UMSocialSnsService handleOpenURL:url];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    //保存文件
    [QConfigration saveFile];
}

@end

int main(int argc, char * argv[])
{
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([QAppDelegate class]));
    }
}

