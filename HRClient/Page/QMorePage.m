//
//  QMorePage.m
//  DSSClient
//
//  Created by pany on 14-4-18.
//  Copyright (c) 2014年 SDK. All rights reserved.
//

#import "QMorePage.h"
#import "QViewController.h"
#import "QGuidepageController.h"
#import "SDImageCache.h"
#import "UMSocialSnsService.h"
#import "UMSocialSnsPlatformManager.h"

@interface QMorePage()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,UMSocialUIDelegate>
{
    UITableView *contentTable;
    NSArray *titleArray;
}

@end

@implementation QMorePage

- (void)pageEvent:(QPageEventType)eventType
{
    if (eventType == kPageEventWillShow)
    {
        
    }
}

- (QNavigationType)navigationType
{
    return kNavigationTypeNormal;
}

- (QBottomMenuType)bottomMenuType
{
    return kBottomMenuTypeNormal;
}

- (UIView*)viewWithFrame:(CGRect)frame
{
    if ([super viewWithFrame:frame])
    {
        //数据源
        titleArray = @[@"商家结算说明", @"商家结算费率"];
        
        contentTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, _view.deFrameWidth, _view.deFrameHeight)];
        contentTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        contentTable.delegate = self;
        contentTable.dataSource = self;
        contentTable.backgroundColor = [UIColor clearColor];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, contentTable.deFrameWidth, 20)];
        view.backgroundColor = [UIColor clearColor];
        contentTable.tableHeaderView = view;
        
        [_view addSubview:contentTable];
    }
    
    return _view;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return titleArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *myCellID = @"morePag";
    
    UITableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:myCellID];
    if (myCell == nil)
    {
        myCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myCellID];
        myCell.textLabel.font = [UIFont systemFontOfSize:14];
        myCell.textLabel.textColor = ColorDarkGray;
        myCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 44 - 0.5f, tableView.deFrameWidth, 0.5f)];
        lineView.backgroundColor = ColorLine;
        [myCell.contentView addSubview:lineView];
    }
    
    myCell.textLabel.text = titleArray[indexPath.row];
    
    return myCell;
    
}

#pragma maek - UITalbeViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row)
    {
        case 0://商家结算说明
        {
            [QViewController gotoPage:@"QAgreementPage" withParam:[[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInt:1], @"agreementType", nil]];
        }
            break;
        case 1://商家结算费率
        {
            [QViewController gotoPage:@"QAgreementPage" withParam:[[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInt:1], @"agreementType", nil]];
        }
            break;
        default:
            break;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UIAlertView
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        
    }
    else if(buttonIndex == 1)
    {
        [[SDImageCache sharedImageCache] clearDisk];
    }
}


#pragma mark - view circle

- (NSString*)title
{
    return _T(@"更多");
}

- (QCacheType)pageCacheType
{
    return kCacheTypeAlways;
}

#pragma mark - Rotate
- (BOOL)pageShouldAutorotate
{
    return YES;
}

- (NSUInteger)pageSupportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskPortraitUpsideDown;
}

-(void)didSelectSocialPlatform:(NSString *)platformName withSocialData:(UMSocialData *)socialData
{
    [UMSocialData defaultData].extConfig.wechatSessionData.title = @"车夫-您的全能养车小帮手";
    [UMSocialData defaultData].extConfig.wechatTimelineData.title = @"车夫-您的全能养车小帮手";
}

@end
