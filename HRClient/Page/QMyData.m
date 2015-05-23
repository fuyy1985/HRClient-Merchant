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

- (NSString *)title{
    return @"密码管理";
}

- (void)setActiveWithParams:(NSDictionary *)params
{
    titles = @[@"账户名",@"已绑定手机",@"支付密码",@"登录密码"];
}

- (void)pageEvent:(QPageEventType)eventType
{
    if (eventType == kPageEventWillShow)
    {
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(acomendNickSucess:) name:kAcommendNick object:nil];
    }
    else if (eventType == kPageEventWillHide)
    {
//        [[NSNotificationCenter defaultCenter] removeObserver:self name:kAcommendNick object:nil];
    }
}

- (UIView *)viewWithFrame:(CGRect)frame{
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

- (void)acomendNickSucess:(NSNotification*)noti
{
    [ASRequestHUD dismissWithSuccess:@"修改成功"];
    [ASUserDefaults setObject:newNick forKey:AccountNick];
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 2;
            break;
        case 1:
            return 2;
            break;
        default:
            return 0;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *MyData = @"MyData";
    QMyDataCell *cell = [tableView dequeueReusableCellWithIdentifier:MyData];
    if (cell == nil) {
        cell = [[QMyDataCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:MyData];
        cell.delegate = self;
    }
    if (indexPath.section == 1) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    [cell configurationCellWithModel:titles andIndexPath:indexPath andPayPwd:[ASUserDefaults objectForKey:AccountPayPasswd]];
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
    if (indexPath.section == 1)
    {
        if (indexPath.row == 0)
        {
            if ([[ASUserDefaults objectForKey:AccountPayPasswd] isEqualToString:@"Y"]) {
                [QViewController gotoPage:@"QAmmendOrSetKey" withParam:nil];
            }else{
                [QViewController gotoPage:@"QSetPayKey" withParam:nil];
            }
        }
        else if (indexPath.row == 1)
        {
            [QViewController gotoPage:@"QChangeLoginKey" withParam:nil];
        }
        
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
