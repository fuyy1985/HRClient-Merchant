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
#import "QCountDown.h"
#import "QViewController.h"

@interface QAddCardPage ()<UITableViewDataSource,UITableViewDelegate, UITextFieldDelegate>
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
        
        _titleArray = @[@"持卡人", @"银行名称", @"开户地址", @"银卡卡号", @"确认卡号", @"验证码"];
        
        _tableView = [[UITableView alloc] initWithFrame:_view.bounds style:UITableViewStylePlain];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.allowsSelection = NO;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_view addSubview:_tableView];
        
        UIView* footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, 65)];
        
        UIButton *applyCashBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        applyCashBtn.frame = CGRectMake(14,25,frame.size.width - 28,45);
        [applyCashBtn setTitle:@"绑定" forState:UIControlStateNormal];
        [applyCashBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [applyCashBtn setTitleColor:ColorLightGray forState:UIControlStateHighlighted];
        applyCashBtn.backgroundColor = ColorTheme;
        applyCashBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [applyCashBtn addTarget:self action:@selector(onBindBankCard:) forControlEvents:UIControlEventTouchUpInside];
        [footView addSubview:applyCashBtn];
        
        _tableView.tableFooterView = footView;
        
        CGFloat x = 120;
        
        _nameTextField = [[UITextField alloc] initWithFrame:CGRectMake(x, 2, 170, 36)];
        _nameTextField.placeholder = @"请输入持卡人姓名";
        _nameTextField.text = [QDataCenter sharedDataCenter]->companyModel.legalPerson;
        _nameTextField.font = [UIFont systemFontOfSize:14];
        _nameTextField.delegate = self;
        _nameTextField.textColor = [QTools colorWithRGB:150 :150 :150];
        
        _bankTextField = [[UITextField alloc] initWithFrame:CGRectMake(x, 2, 170, 36)];
        _bankTextField.placeholder = @"请输入银行名称";
        _bankTextField.font = [UIFont systemFontOfSize:14];
        _bankTextField.textColor = [QTools colorWithRGB:150 :150 :150];
        
        _locationTextField = [[UITextField alloc] initWithFrame:CGRectMake(x, 2, 170, 36)];
        _locationTextField.placeholder = @"请输入开户行地址";
        _locationTextField.font = [UIFont systemFontOfSize:14];
        _locationTextField.textColor = [QTools colorWithRGB:150 :150 :150];
        
        _bankNoTextField = [[UITextField alloc] initWithFrame:CGRectMake(x, 2, 170, 36)];
        _bankNoTextField.placeholder = @"请输入银行卡卡号";
        _bankNoTextField.font = [UIFont systemFontOfSize:14];
        _bankNoTextField.textColor = [QTools colorWithRGB:150 :150 :150];
        
        _sureBankNoTextField = [[UITextField alloc] initWithFrame:CGRectMake(x, 2, 170, 36)];
        _sureBankNoTextField.placeholder = @"请输入确认卡号";
        _sureBankNoTextField.font = [UIFont systemFontOfSize:14];
        _sureBankNoTextField.textColor = [QTools colorWithRGB:150 :150 :150];
        
        _verifyCodeTextField = [[UITextField alloc] initWithFrame:CGRectMake(x, 2, 80, 36)];
        _verifyCodeTextField.placeholder = @"输入验证码";
        _verifyCodeTextField.font = [UIFont systemFontOfSize:14];
        _verifyCodeTextField.textColor = [QTools colorWithRGB:150 :150 :150];
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
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(successInsertCard:) name:kInsertBank object:nil];
    }
    else if (eventType == kPageEventViewDispose)
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}

- (NSString *)title{
    return @"绑定银行卡";
}

#pragma mark - Action
- (void)onGetVerifyCode:(id)sender
{
    [QCountDown startTime:(UIButton*)sender];
    [[QHttpMessageManager sharedHttpMessageManager] accessAcquireCode:[ASUserDefaults objectForKey:LoginUserPhone] andMessage:@"(绑定银行卡验证码)"];
}

- (void)onBindBankCard:(id)sender
{
    if ([_nameTextField.text isEqualToString:@""])
    {
        [ASRequestHUD showErrorWithStatus:@"请输入持卡人信息"];
        return ;
    }
    if ([_bankTextField.text isEqualToString:@""])
    {
        [ASRequestHUD showErrorWithStatus:@"请输入银行卡名称"];
        return ;
    }
    if ([_bankNoTextField.text isEqualToString:@""])
    {
        [ASRequestHUD showErrorWithStatus:@"请输入银行卡号"];
        return ;
    }
    if (![_bankNoTextField.text isEqualToString:_sureBankNoTextField.text])
    {
        [ASRequestHUD showErrorWithStatus:@"银行卡号前后两次输入不一致"];
        return;
    }
    if ([_verifyCodeTextField.text isEqualToString:@""])
    {
        [ASRequestHUD showErrorWithStatus:@"请输入验证码"];
        return ;
    }
    
    [[QHttpMessageManager sharedHttpMessageManager] accessInsertBankCard:_nameTextField.text
                                                             andBankName:_bankTextField.text
                                                               andBankNo:_bankNoTextField.text
                                                                andPhone:[ASUserDefaults objectForKey:LoginUserPhone]
                                                           andVerifyCode:_verifyCodeTextField.text];
}

#pragma mark - Notification

- (void)successInsertCard:(NSNotification*)noti
{
    [[QHttpMessageManager sharedHttpMessageManager] accessGetCompanyAccount];
    [QViewController backPageWithParam:nil];
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
            
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(_verifyCodeTextField.deFrameRight, 2, 100, 36)];
            [button setBackgroundImage:[QTools createImageWithColor:ColorTheme] forState:UIControlStateNormal];
            [button setTitle:@"获取验证码" forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:14];
            [button addTarget:self action:@selector(onGetVerifyCode:) forControlEvents:UIControlEventTouchUpInside];
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

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == _nameTextField) {
        return NO;
    }
    return YES;
}

@end
