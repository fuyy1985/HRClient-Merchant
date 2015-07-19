//
//  QAddCardPage.m
//  HRClient
//
//  Created by amy.fu on 15/7/18.
//  Copyright (c) 2015年 panyj. All rights reserved.
//

#import "QAddCardPage.h"
#import "QDataCenter.h"
#import "QHttpMessageManager.h"

@interface QAddCardPage ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *_titleArray;
    UITextField *_nameTextField;
    UITextField *_bankTextField;
    UITextField *_locationTextField;
    UITextField *_bankNoTextField;
    UITextField *_sureBankNoTextField;
}

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation QAddCardPage

- (UIView*)viewWithFrame:(CGRect)frame
{
    if ([super viewWithFrame:frame]) {
        
        _titleArray = @[@"持卡人", @"银行名称", @"开户银行所在地", @"银卡卡号", @"确认银卡卡号", @"验证码"];
        
        _tableView = [[UITableView alloc] initWithFrame:_view.bounds style:UITableViewStylePlain];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.allowsSelection = NO;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_view addSubview:_tableView];
    }
    return _view;
}

- (void)pageEvent:(QPageEventType)eventType
{
    if (eventType == kPageEventWillShow)
    {
    }
    else if (eventType == kPageEventWillHide)
    {
    }
    else if (eventType == kPageEventViewCreate)
    {
    }
    else if (eventType == kPageEventViewDispose)
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}

- (NSString *)title{
    return @"绑定银行卡";
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, 40 - .5f, tableView.deFrameWidth - 2*10, .4f)];
    lineView.backgroundColor = ColorLine;
    [cell.contentView addSubview:lineView];
    
    cell.textLabel.text = _titleArray[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.textColor = [QTools colorWithRGB:3 :3 :3];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

@end
