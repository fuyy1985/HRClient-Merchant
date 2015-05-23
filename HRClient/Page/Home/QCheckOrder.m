//
//  QCheckOrder.m
//  HRClient
//
//  Created by chenyf on 14/12/2.
//  Copyright (c) 2014年 panyj. All rights reserved.
//

#import "QCheckOrder.h"
#import "QViewController.h"
#import "QHttpMessageManager.h"

@implementation QCheckOrder

- (NSString*)title
{
    return _T(@"验单");
}

- (QCacheType)pageCacheType
{
    return kCacheTypeAlways;
}

- (QNavigationType)navigationType
{
    return kNavigationTypeNormal;
}

- (void)setActiveWithParams:(NSDictionary *)params
{
}

- (void)pageEvent:(QPageEventType)eventType
{
    if (eventType == kPageEventWillShow)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(successLogin:) name:kLogin object:nil];
        [[QHttpMessageManager sharedHttpMessageManager] accessLogin:@"15157193193" andPassword:@"000000"];
    }
    else if (eventType == kPageEventWillHide)
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:kLogin object:nil];
    }
    else if (eventType == kPageEventViewCreate)
    {
    }
    else if (eventType == kPageEventViewDispose)
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}

- (QBottomMenuType)bottomMenuType
{
    return kBottomMenuTypeNormal;
}

- (void)gotoScanPage:(id)sender
{
    
}

- (void)gotoCheck:(id)sender
{
    UITextField *infoText = (UITextField*)[_view viewWithTag:10000];
    NSLog(@"%@",infoText.text);
}

- (UIView *)viewWithFrame:(CGRect)frame
{
    if ([super viewWithFrame:frame]) {
        
        //scan
        UIButton *scanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        scanBtn.frame = CGRectMake(14,13,frame.size.width - 28,45);
        [scanBtn setTitle:@"  扫描验单" forState:UIControlStateNormal];
        [scanBtn setImage:IMAGEOF(@"shaomiao") forState:UIControlStateNormal];
        [scanBtn setTitleColor:ColorTheme forState:UIControlStateNormal];
        [scanBtn setTitleColor:ColorLightGray forState:UIControlStateHighlighted];
        scanBtn.backgroundColor = [UIColor whiteColor];
        scanBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [scanBtn addTarget:self action:@selector(gotoScanPage:) forControlEvents:UIControlEventTouchUpInside];
        [_view addSubview:scanBtn];
        
        //state
        UILabel *stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(14,CGRectGetMaxY(scanBtn.frame)+13,frame.size.width - 28,40)];
        stateLabel.backgroundColor = [UIColor clearColor];
        stateLabel.font = [UIFont systemFontOfSize:15];
        stateLabel.textColor = ColorTheme;
        stateLabel.text = @"您也可以输入消费码进行验证";
        [_view addSubview:stateLabel];
        
        //验证码输入
        UITextField* inputNewTextFiled = [[UITextField alloc] initWithFrame:CGRectMake(14, CGRectGetMaxY(stateLabel.frame)+13,
                                                                                       frame.size.width - 28, 45)];
        inputNewTextFiled.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        inputNewTextFiled.tag = 10000;
        inputNewTextFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
        inputNewTextFiled.keyboardType = UIKeyboardTypeNumberPad;
        inputNewTextFiled.font = [UIFont systemFontOfSize:15];
        inputNewTextFiled.secureTextEntry = NO;
        inputNewTextFiled.placeholder = @"输入8位消费劵密码";
        inputNewTextFiled.textAlignment = NSTextAlignmentCenter;
        inputNewTextFiled.backgroundColor = [UIColor whiteColor];
        inputNewTextFiled.textColor = ColorTheme;
        [_view addSubview:inputNewTextFiled];
        
        //check
        UIButton *checkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        checkBtn.frame = CGRectMake(14,CGRectGetMaxY(inputNewTextFiled.frame)+30,frame.size.width - 28,45);
        [checkBtn setTitle:@"验单" forState:UIControlStateNormal];
        [checkBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [checkBtn setTitleColor:ColorLightGray forState:UIControlStateHighlighted];
        checkBtn.backgroundColor = ColorTheme;
        checkBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [checkBtn addTarget:self action:@selector(gotoCheck:) forControlEvents:UIControlEventTouchUpInside];
        [_view addSubview:checkBtn];
        
    }
    
    return _view;
}

#pragma mark - Noticiation
- (void)successLogin:(NSNotification*)noti
{
    [[QHttpMessageManager sharedHttpMessageManager] accessGetOrderDetail:[NSNumber numberWithInt:1189]];
}


@end
