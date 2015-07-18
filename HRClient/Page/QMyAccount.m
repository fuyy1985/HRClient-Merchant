//
//  QMyAccount.m
//  HRClient
//
//  Created by ekoo on 14/12/17.
//  Copyright (c) 2014年 panyj. All rights reserved.
//

#import "QMyAccount.h"
#import "QHttpMessageManager.h"
#import "QDataCenter.h"
#import "QViewController.h"


@interface QMyAccount ()<UITextFieldDelegate, UIActionSheetDelegate>
{
    UITableView *collectTableView;
    UITextField *_pwdTextField;
    UITextField *_cashTextField;
    NSArray *_bankList;
    QBankModel *_selectBankModel;
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
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(successGetCompanyAccout:) name:kCompanyAccount object:nil];
        [[QHttpMessageManager sharedHttpMessageManager] accessGetCompanyAccount];
        [ASRequestHUD show];
        
        _bankList = [[NSArray alloc] initWithArray:[QDataCenter sharedDataCenter]->companyAccountModel.bankList];
        if (_bankList.count > 0) _selectBankModel = _bankList[0];
    }
    else if (eventType == kPageEventViewDispose)
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
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
        titleLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        titleLabel.font = [UIFont systemFontOfSize:12];
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

#pragma mark - Action

- (void)onAddCard
{
    [QViewController gotoPage:@"QAddCardPage" withParam:nil];
}

#pragma mark - Notification

- (void)successGetCompanyAccout:(NSNotification*)noti
{
    QCompanyAccount *model = (QCompanyAccount*)noti.object;
    _bankList = model.bankList;
    
    if (!_selectBankModel && _bankList.count > 0) _selectBankModel = _bankList[0];
    
    [collectTableView reloadData];
    
    [ASRequestHUD dismiss];
}

#pragma mark - UITableView DataSource

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
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
        return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1)
    {
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, tableView.deFrameWidth, 40)];
        titleLabel.textColor = ColorTheme;
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.adjustsFontSizeToFitWidth = YES;
        titleLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        titleLabel.font = [UIFont systemFontOfSize:12];
        titleLabel.text = @"  您有未确认的订单，请进行确认后再提现";
        
        return titleLabel;
    }
    
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *collectID = @"myaccountCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:collectID];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:collectID];
    }
    
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
       cell.accessoryType = UITableViewCellAccessoryNone;
    
    switch (indexPath.section) {
        case 0:
        {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 75, 40)];
            label.font = [UIFont systemFontOfSize:15];
            label.textColor = [QTools colorWithRGB:3 :3 :3];
            label.text = @"可用余额:";
            [cell.contentView addSubview:label];

            label = [[UILabel alloc] initWithFrame:CGRectMake(90, 0, 170, 40)];
            label.font = [UIFont systemFontOfSize:18];
            label.textColor = ColorTheme;
            label.text = [NSString stringWithFormat:@"￥%.2f", [[QDataCenter sharedDataCenter]->loginModel.balance doubleValue]];
            [cell.contentView addSubview:label];
            
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(tableView.deFrameWidth - 100, 0, 100, 40)];
            [button setImage:[UIImage imageNamed:@"zengjia"] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"zengjia_press"] forState:UIControlStateHighlighted];
            [button setTitle:@"添加银行卡" forState:UIControlStateNormal];
            [button setTitleColor:ColorTheme forState:UIControlStateNormal];
            [button setTitleColor:[QTools colorWithRGB:255 :49 :50] forState:UIControlStateHighlighted];
            button.titleLabel.font = [UIFont systemFontOfSize:13];
            [button addTarget:self action:@selector(onAddCard) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:button];
            
        }
            break;
        case 1:
        {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            if (!_selectBankModel)
            {
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, 60)];
                label.font = [UIFont systemFontOfSize:16];
                label.textColor = [QTools colorWithRGB:3 :3 :3];
                label.text = @"添加银行卡";
                [cell.contentView addSubview:label];
            }
            else
            {
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 70, 30)];
                label.font = [UIFont systemFontOfSize:15];
                label.textColor = [QTools colorWithRGB:3 :3 :3];
                label.text = _selectBankModel.bankName;
                [cell.contentView addSubview:label];
                
                label = [[UILabel alloc] initWithFrame:CGRectMake(tableView.deFrameWidth - 70 - 30, 10, 70, 30)];
                label.font = [UIFont systemFontOfSize:13];
                label.textAlignment = NSTextAlignmentRight;
                label.textColor = ColorLightGray;
                [cell.contentView addSubview:label];
                
                NSString *bankNo = (_selectBankModel.bankNo.length > 4) ? ([_selectBankModel.bankNo substringFromIndex:_selectBankModel.bankNo.length - 4]) : _selectBankModel.bankNo;
                label.text = [NSString stringWithFormat:@"尾号%@", bankNo];
                
                label = [[UILabel alloc] initWithFrame:CGRectMake(15, 40, tableView.deFrameWidth - 2*10, 20)];
                label.font = [UIFont systemFontOfSize:11];
                label.textColor = [UIColor lightGrayColor];
                label.text = @"为了保护账户资金安全，只能绑定认证用户本人银行卡";
                [cell.contentView addSubview:label];
            }
            
        }
            break;
            
        case 2:
        {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 70, 40)];
            label.font = [UIFont systemFontOfSize:15];
            label.textColor = [QTools colorWithRGB:3 :3 :3];
            label.text = @"提现金额";
            [cell.contentView addSubview:label];
            
            UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(label.deFrameRight, 0, 100, 40)];
            textField.secureTextEntry = YES;
            textField.textAlignment = NSTextAlignmentRight;
            textField.delegate = self;
            [cell.contentView addSubview:textField];
            _cashTextField = textField;
            
            label = [[UILabel alloc] initWithFrame:CGRectMake(textField.deFrameRight, 0, 20, 40)];
            label.font = [UIFont systemFontOfSize:15];
            label.textColor = [QTools colorWithRGB:3 :3 :3];
            label.text = @"元";
            [cell.contentView addSubview:label];
            
            label = [[UILabel alloc] initWithFrame:CGRectMake(tableView.deFrameWidth - 100 -10, 0, 100, 40)];
            label.font = [UIFont systemFontOfSize:12];
            label.textColor = ColorLightGray;
            label.text = @"最低提现：200元";
            [cell.contentView addSubview:label];
        }
            break;
            
        case 3:
        {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 70, 40)];
            label.font = [UIFont systemFontOfSize:15];
            label.textColor = [QTools colorWithRGB:3 :3 :3];
            label.text = @"提现密码";
            [cell.contentView addSubview:label];
            
            UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(label.deFrameRight, 0, 120, 40)];
            textField.secureTextEntry = YES;
            textField.clearButtonMode = UITextFieldViewModeWhileEditing;
            textField.delegate = self;
            [cell.contentView addSubview:textField];
            _pwdTextField = textField;
            
            label = [[UILabel alloc] initWithFrame:CGRectMake(tableView.deFrameWidth - 60 -10, 0, 60, 40)];
            label.font = [UIFont systemFontOfSize:12];
            label.textColor = ColorTheme;
            label.text = @"忘记密码？";
            [cell.contentView addSubview:label];
        }
            break;
            
        default:
            break;
    }
    
    return cell;
}

#pragma mark - UITableDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        return 60;
    }
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            [self onAddCard];
        }
            break;
        case 1:
        {
            if (_bankList.count < 1)
            {
                //添加银行卡
                return ;
            }
            
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"选择银行卡"
                                                                     delegate:self
                                                            cancelButtonTitle:@"取消"
                                                       destructiveButtonTitle:nil
                                                            otherButtonTitles:nil];
            for (QBankModel *model in _bankList)
            {
                NSString *bankNo = (model.bankNo.length > 4) ? ([model.bankNo substringFromIndex:model.bankNo.length - 4]) : model.bankNo;
                [actionSheet addButtonWithTitle:[NSString stringWithFormat:@"%@（尾号）%@", model.bankName, bankNo]];
            }

            [actionSheet showInView:self.view];
        }
            break;
        case 3:
        {
            //忘记密码
            [QViewController gotoPage:@"QFindPayKey" withParam:nil];
        }
            break;
            
        default:
            break;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@"\n"]) {
        
        if (textField == _pwdTextField)
            [_cashTextField becomeFirstResponder];
        else if (textField == _cashTextField)
            [_cashTextField resignFirstResponder];
        return NO;
    }
    return YES;
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (0 == buttonIndex && _bankList.count <= buttonIndex-1) {
        return;
    }
    _selectBankModel = _bankList[buttonIndex-1];
    [collectTableView reloadData];
}

@end
