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
    UITextField *_verifyCodeTextField;
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
        
        _nameTextField = [[UITextField alloc] initWithFrame:CGRectMake(125, 2, 170, 36)];
        _nameTextField.placeholder = @"请输入持卡人姓名";
        _nameTextField.font = [UIFont systemFontOfSize:14];
        _nameTextField.textColor = [QTools colorWithRGB:0xc4 :0xc4 :0xc4];
        
        _bankTextField = [[UITextField alloc] initWithFrame:CGRectMake(125, 2, 170, 36)];
        _bankTextField.placeholder = @"请输入银行名称";
        _bankTextField.font = [UIFont systemFontOfSize:14];
        _bankTextField.textColor = [QTools colorWithRGB:0xc4 :0xc4 :0xc4];
        
        _locationTextField = [[UITextField alloc] initWithFrame:CGRectMake(125, 2, 170, 36)];
        _locationTextField.placeholder = @"请输入开户行地址";
        _locationTextField.font = [UIFont systemFontOfSize:14];
        _locationTextField.textColor = [QTools colorWithRGB:0xc4 :0xc4 :0xc4];
        
        _bankNoTextField = [[UITextField alloc] initWithFrame:CGRectMake(125, 2, 170, 36)];
        _bankNoTextField.placeholder = @"请输入银行卡卡号";
        _bankNoTextField.font = [UIFont systemFontOfSize:14];
        _bankNoTextField.textColor = [QTools colorWithRGB:0xc4 :0xc4 :0xc4];
        
        _sureBankNoTextField = [[UITextField alloc] initWithFrame:CGRectMake(125, 2, 170, 36)];
        _sureBankNoTextField.placeholder = @"请输入确认银行卡号";
        _sureBankNoTextField.font = [UIFont systemFontOfSize:14];
        _sureBankNoTextField.textColor = [QTools colorWithRGB:0xc4 :0xc4 :0xc4];
        
        _verifyCodeTextField = [[UITextField alloc] initWithFrame:CGRectMake(125, 2, 100, 36)];
        _verifyCodeTextField.placeholder = @"输入验证码";
        _verifyCodeTextField.font = [UIFont systemFontOfSize:14];
        _verifyCodeTextField.textColor = [QTools colorWithRGB:0xc4 :0xc4 :0xc4];
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
    cell.textLabel.textColor = [QTools colorWithRGB:0x33 :0x33 :0x33];
    switch (indexPath.row) {
        case 0:
        {
            [cell.contentView addSubview:_nameTextField];
        }
            break;
        case 1:
        {
            [cell.contentView addSubview:_bankTextField];
        }
            break;
        case 2:
        {
            [cell.contentView addSubview:_locationTextField];
        }
            break;
        case 3:
        {
            [cell.contentView addSubview:_bankNoTextField];
        }
            break;
        case 4:
        {
            [cell.contentView addSubview:_sureBankNoTextField];
        }
            break;
        case 5:
        {
            [cell.contentView addSubview:_verifyCodeTextField];
            
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(_verifyCodeTextField.deFrameRight, 2, 40, 36)];
            [button setTitle:@"获取验证码" forState:UIControlStateNormal];
            [cell.contentView addSubview:button];
        }
            break;
        default:
            break;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

@end
