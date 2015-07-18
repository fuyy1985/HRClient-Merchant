//
//  QAmendPayKey.m
//  HRClient
//
//  Created by ekoo on 14/12/18.
//  Copyright (c) 2014年 panyj. All rights reserved.
//

#import "QAmendPayKey.h"
#import "QHttpMessageManager.h"
#import "QViewController.h"

@interface QAmendPayKey () <UITextFieldDelegate>
{
    UITextField *nowKeyTextFiled;
    UITextField *againKeyTextFiled;
    UITextField *sureKeyTextFiled;
    
    NSString *oldPwd;
    NSString *newPwd;
    NSString *surePwd;
}

@end
@implementation QAmendPayKey

- (void)pageEvent:(QPageEventType)eventType
{
    if (eventType == kPageEventWillShow)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveAcommendPayPwd:) name:kAcommedPayPwd object:nil];
    }
    else if (eventType == kPageEventViewDispose)
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:kAcommedPayPwd object:nil];
    }
}

- (NSString *)title{
    return @"修改支付密码";
}

- (UIView *)viewWithFrame:(CGRect)frame{
    if ([super viewWithFrame:frame]) {
        
        _view.backgroundColor = [QTools colorWithRGB:240 :239 :237];
        CGFloat beforeW = 15.0;
        CGFloat topH = 25.0;
        CGFloat w = frame.size.width - 2*beforeW;
        CGFloat h = 37.0;
        CGFloat blank = 10.0;
        nowKeyTextFiled = [[UITextField alloc] initWithFrame:CGRectMake(beforeW, topH, w, h)];
        nowKeyTextFiled.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        nowKeyTextFiled.placeholder = @"原支付密码";
        nowKeyTextFiled.borderStyle = UITextBorderStyleRoundedRect;
        nowKeyTextFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
        nowKeyTextFiled.font = [UIFont systemFontOfSize:14];
        nowKeyTextFiled.secureTextEntry = YES;
        [_view addSubview:nowKeyTextFiled];
        
        againKeyTextFiled = [[UITextField alloc] initWithFrame:CGRectMake(beforeW, nowKeyTextFiled.deFrameBottom + blank, w, h)];
        againKeyTextFiled.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        againKeyTextFiled.placeholder = @"输入6-12英文或者数字";
        againKeyTextFiled.borderStyle = UITextBorderStyleRoundedRect;
        againKeyTextFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
        againKeyTextFiled.font = [UIFont systemFontOfSize:14];
        againKeyTextFiled.secureTextEntry = YES;
        againKeyTextFiled.delegate = self;
        [_view addSubview:againKeyTextFiled];
        
        sureKeyTextFiled = [[UITextField alloc] initWithFrame:CGRectMake(beforeW, againKeyTextFiled.deFrameBottom + blank, w, h)];
        sureKeyTextFiled.placeholder = @"确认新密码";
        sureKeyTextFiled.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        sureKeyTextFiled.borderStyle = UITextBorderStyleRoundedRect;
        sureKeyTextFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
        sureKeyTextFiled.font = [UIFont systemFontOfSize:14];
        sureKeyTextFiled.secureTextEntry = YES;
        sureKeyTextFiled.delegate = self;
        [_view addSubview:sureKeyTextFiled];
        
        UIButton *sureBtn = [[UIButton alloc] initWithFrame:CGRectMake(beforeW, sureKeyTextFiled.deFrameBottom + blank, w, h - 2)];
        [sureBtn setBackgroundImage:[QTools createImageWithColor:ColorTheme] forState:UIControlStateNormal];
        [sureBtn setTitle:@"确认修改" forState:UIControlStateNormal];
        sureBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        sureBtn.layer.masksToBounds = YES;
        sureBtn.layer.cornerRadius = 4.0;
        [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [sureBtn addTarget:self action:@selector(sureToAcommendPayPwd) forControlEvents:UIControlEventTouchUpInside];
        [_view addSubview:sureBtn];
     }
    return _view;
}

#pragma mark - Action

- (void)sureToAcommendPayPwd
{
    if ([nowKeyTextFiled.text isEqualToString:@""]) {
        
    }
    else if (againKeyTextFiled.text.length < 6) {
        [ASRequestHUD showErrorWithStatus:@"输入6-12英文或者数字"];
    }
    else if (![sureKeyTextFiled.text isEqualToString:againKeyTextFiled.text]) {
        [ASRequestHUD showErrorWithStatus:@"新密码两次输入不一致"];
    }
    else {
        [[QHttpMessageManager sharedHttpMessageManager] accessAcommendPayPwd:nowKeyTextFiled.text andNewPayPasswd:againKeyTextFiled.text andVerifyNewPayPasswd:sureKeyTextFiled.text];
        [ASRequestHUD show];
    }
}

#pragma mark - Notification

- (void)receiveAcommendPayPwd:(NSNotification *)noti{
    [ASRequestHUD dismissWithSuccess:@"新支付密码设置成功"];
    [QViewController backPageWithParam:nil];
}

#pragma mark - UITextFieldDelegate
//textField的限制
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if ([string isEqualToString:@"\n"]) {
        if (againKeyTextFiled == textField && [toBeString length] < 6) {
            [ASRequestHUD showErrorWithStatus:@"输入6-12英文或者数字"];
        }
        return NO;
    }
    
    if (againKeyTextFiled == textField) {
        if ([toBeString length] >12) {
            [ASRequestHUD showErrorWithStatus:@"输入6-12英文或者数字"];
            return NO;
        }
    }
    return YES;
/*
     NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:kAlphaNum] invertedSet];
     NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
     BOOL canChange = [string isEqualToString:filtered];
     return canChange;
*/
}

@end
