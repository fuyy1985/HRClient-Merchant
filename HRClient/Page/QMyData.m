//
//  QMyData.m
//  HRClient
//
//  Created by ekoo on 14/12/10.
//  Copyright (c) 2014年 panyj. All rights reserved.
//

#import "QMyData.h"
#import "QMyDataCell.h"
#import "QViewController.h"
#import "QHttpMessageManager.h"


@interface QMyData () <QMyDataCellDelegate>
{
    NSDictionary *configDic;
    NSArray *titles;
    NSString *newNick;
}
@property (nonatomic,strong)UITableView *MyDataTableView;

@end

@implementation QMyData

- (NSString *)title
{
    return @"密码管理";
}

- (void)setActiveWithParams:(NSDictionary *)params
{
    titles = @[@"修改支付密码",@"找回支付密码",@"修改登录密码"];
}

- (void)pageEvent:(QPageEventType)eventType
{
    if (eventType == kPageEventWillShow)
    {
    }
    else if (eventType == kPageEventWillHide)
    {
    }
}

- (UIView *)viewWithFrame:(CGRect)frame
{
    if ([super viewWithFrame:frame]) {
        _view.backgroundColor = [QTools colorWithRGB:240 :239 :237];

        _MyDataTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)style:UITableViewStylePlain];
        _MyDataTableView.dataSource = self;
        _MyDataTableView.delegate = self;
        _MyDataTableView.backgroundColor = [QTools colorWithRGB:240 :239 :237];
        [_view addSubview:_MyDataTableView];
    }
    return _view;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return titles.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyData = @"MyData";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyData];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:MyData];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.textColor = [QTools colorWithRGB:3 :3 :3];
    }

    cell.textLabel.text = titles[indexPath.row];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.5;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_SIZE_WIDTH, 0.5)];
    return view;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_SIZE_WIDTH, 0.5)];
    return view;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        //修改支付密码
        [QViewController gotoPage:@"QAmendPayKey" withParam:nil];
    }
    else if (indexPath.row == 1)
    {
        //找回支付密码
        [QViewController gotoPage:@"QFindPayKey" withParam:nil];
    }
    else if (indexPath.row == 2)
    {
        //修改登录密码
        [QViewController gotoPage:@"QChangeLoginKey" withParam:nil];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
