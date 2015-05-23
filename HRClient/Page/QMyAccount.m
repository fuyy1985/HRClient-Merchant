//
//  QMyAccount.m
//  HRClient
//
//  Created by ekoo on 14/12/17.
//  Copyright (c) 2014年 panyj. All rights reserved.
//

#import "QMyAccount.h"

#import "QMyAccount.h"
#import "QHttpMessageManager.h"
#import "QViewController.h"


@interface QMyAccount ()
{
    UITableView *collectTableView;
}

@end

@implementation QMyAccount


- (void)pageEvent:(QPageEventType)eventType
{
    if (eventType == kPageEventWillShow)
    {
    }
    else if (eventType == kPageEventWillHide)
    {
        [ASRequestHUD dismiss];
        [collectTableView reloadData];
    }
    else if (eventType == kPageEventViewCreate)
    {
        //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(successToGetMyFavoirty:) name:kMyFavority object:nil];
    }
    else if (eventType == kPageEventViewDispose)
    {
        //[[NSNotificationCenter defaultCenter] removeObserver:self name:kMyFavority object:nil];
    }
}

- (NSString *)title{
    return @"我的账户";
}

- (void)gotoApplyCrash:(id)sender
{
    
}

- (UIView *)viewWithFrame:(CGRect)frame{
    if ([super viewWithFrame:frame]) {

        collectTableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        collectTableView.delegate = self;
        collectTableView.dataSource = self;
        collectTableView.backgroundColor = [QTools colorWithRGB:240 :239 :237];
        collectTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_view addSubview:collectTableView];
        
        UIView* footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, 90)];
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, frame.size.width - 20, 40)];
        titleLabel.textColor = ColorTheme;
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.adjustsFontSizeToFitWidth = YES;
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        titleLabel.font = [UIFont systemFontOfSize:15];
        titleLabel.text = @"注:申请提现后1-3个工作日到账";
        [footView addSubview:titleLabel];
        
        //scan
        UIButton *applyCashBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        applyCashBtn.frame = CGRectMake(14,45,frame.size.width - 28,45);
        [applyCashBtn setTitle:@"申请提现" forState:UIControlStateNormal];
        [applyCashBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [applyCashBtn setTitleColor:ColorLightGray forState:UIControlStateHighlighted];
        applyCashBtn.backgroundColor = ColorTheme;
        applyCashBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [applyCashBtn addTarget:self action:@selector(gotoApplyCrash:) forControlEvents:UIControlEventTouchUpInside];
        [footView addSubview:applyCashBtn];
        
        collectTableView.tableFooterView = footView;
    }
    
    return _view;
}

#pragma mark - UITableView DataSource

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 1;
            
        case 1:
            return 3;
            
        case 2:
            return 1;
            
        case 3:
            return 1;
            break;
            
        default:
            break;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1)
        return 40;
    else
        return 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1)
    {
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 40)];
        titleLabel.textColor = ColorTheme;
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.adjustsFontSizeToFitWidth = YES;
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        titleLabel.font = [UIFont systemFontOfSize:15];
        titleLabel.text = @"  您有未确认的订单，请进行确认后再提现";
        
        return titleLabel;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *collectID = @"myaccountCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:collectID];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:collectID];
    }
    
    [cell.contentView.subviews respondsToSelector:@selector(removeFromSuperview)];
    
    switch (indexPath.section) {
        case 0:
        {
            cell.textLabel.textAlignment = NSTextAlignmentLeft;
            cell.textLabel.font = [UIFont systemFontOfSize:15.f];
            cell.textLabel.text = @"可用余额:";
            cell.textLabel.textColor = ColorDarkGray;
            
            cell.detailTextLabel.text = @"10002";
            cell.detailTextLabel.textAlignment = NSTextAlignmentLeft;
            cell.detailTextLabel.font = [UIFont systemFontOfSize:18.f];
            cell.detailTextLabel.textColor = ColorTheme;
            
            
        }break;
        case 1:
        {
            
        }break;
            
        case 2:
        {
            
        }break;
            
        case 3:
        {
            
        }break;
            
        default:
            break;
    }
    
    return cell;
}

#pragma mark - UITableDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.editing)
    {
    }
    else
    {
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
