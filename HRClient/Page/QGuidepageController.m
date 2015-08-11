//
//  QGuidepageController.m
//  DSSClient
//
//  Created by panyj on 14-5-26.
//  Copyright (c) 2014年 SDK. All rights reserved.
//

#import "QGuidepageController.h"
#import "UIDevice+Resolutions.h"
#import "QViewController.h"
#import "QHttpMessageManager.h"
#import "QDataModel.h"
#import "QDataCenter.h"

@interface QGuidepageController ()
{
    UITextField *keyTextFiled;
    UITextField *accountTextFiled;
    UIButton *autoLoginButton;
}

@end

@implementation QGuidepageController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(successLogin:) name:kLogin object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(failedLogin:) name:kInterfaceFailed object:nil];

    self.view.backgroundColor = [QTools colorWithRGB:240 :239 :237];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.deFrameWidth, 44)];
    titleLabel.backgroundColor = ColorTheme;
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"车夫商户版";
    [self.view addSubview:titleLabel];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, titleLabel.deFrameBottom + 16, self.view.deFrameWidth, 80)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    
    // 线
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, titleLabel.deFrameBottom + 16, titleLabel.deFrameWidth, .5f)];
    lineView.backgroundColor = ColorLine;
    [self.view addSubview:lineView];
    
    accountTextFiled = [[UITextField alloc] initWithFrame:CGRectMake(20, titleLabel.deFrameBottom + 16, self.view.deFrameWidth - 2*20, 40)];
    accountTextFiled.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    accountTextFiled.font = [UIFont systemFontOfSize:14];
    accountTextFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
    accountTextFiled.returnKeyType = UIReturnKeyNext;
    accountTextFiled.placeholder = @"管理员账号/门店账号";
    accountTextFiled.delegate = (id<UITextFieldDelegate>)self;
    [self.view addSubview:accountTextFiled];
    
    lineView = [[UIView alloc] initWithFrame:CGRectMake(20, accountTextFiled.deFrameBottom, accountTextFiled.deFrameWidth, .5f)];
    lineView.backgroundColor = ColorLine;
    [self.view addSubview:lineView];
    
    keyTextFiled = [[UITextField alloc] initWithFrame:CGRectMake(20, accountTextFiled.deFrameBottom, accountTextFiled.deFrameWidth, 40)];
    keyTextFiled.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    keyTextFiled.font = [UIFont systemFontOfSize:14];
    keyTextFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
    keyTextFiled.returnKeyType = UIReturnKeyJoin;
    keyTextFiled.placeholder = @"输入密码";
    keyTextFiled.secureTextEntry = YES;
    keyTextFiled.delegate = (id<UITextFieldDelegate>)self;
    [self.view addSubview:keyTextFiled];
    
    lineView = [[UIView alloc] initWithFrame:CGRectMake(0, keyTextFiled.deFrameBottom, self.view.deFrameWidth, .5f)];
    lineView.backgroundColor = ColorLine;
    [self.view addSubview:lineView];
    
    UIButton *loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, keyTextFiled.deFrameBottom + 30, self.view.deFrameWidth - 2*15, 40)];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginBtn setBackgroundImage:[QTools createImageWithColor:ColorTheme] forState:UIControlStateNormal];
    loginBtn.layer.masksToBounds = YES;
    loginBtn.layer.cornerRadius = 2.5f;
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [loginBtn addTarget:self action:@selector(loginToAccount) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(10, loginBtn.deFrameBottom, 100, 60)];
    [button setTitle:@" 自动登录" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"loging_select_n"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"login_select_p"] forState:UIControlStateSelected];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button addTarget:self action:@selector(onSelectAutoLogin) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    autoLoginButton = button;
    
    button = [[UIButton alloc] initWithFrame:CGRectMake(0, loginBtn.deFrameBottom, 80, 60)];
    button.deFrameRight = self.view.deFrameWidth - 10;
    [button setTitle:@"忘记密码" forState:UIControlStateNormal];
    [button setTitleColor:[QTools colorWithRGB:0xc4 :0x00 :0x01] forState:UIControlStateNormal];
    button.titleLabel.textAlignment = NSTextAlignmentRight;
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button addTarget:self action:@selector(gotoFindeKey) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    //初始化数据
    NSNumber *isAutoLogin = [ASUserDefaults objectForKey:LoginIsAutoLogin];
    if (!isAutoLogin || [isAutoLogin boolValue])
    {
        autoLoginButton.selected = YES;
        
        accountTextFiled.text = NSString_No_Nil([ASUserDefaults objectForKey:LoginUserPhone]);
        keyTextFiled.text = NSString_No_Nil([ASUserDefaults objectForKey:LoginUserPassCode]);
    }
    
    if ([isAutoLogin boolValue]
        && ![accountTextFiled.text isEqualToString:@""]
        && ![keyTextFiled.text isEqualToString:@""])
    {
        [self loginToAccount];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kLogin object:nil];
}

- (void)enter
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(closeGuideView)]) {
        [self.delegate closeGuideView];
    }
}

#pragma mark - Action

- (void)onSelectAutoLogin
{
    autoLoginButton.selected = !autoLoginButton.selected;
}

- (void)gotoFindeKey
{
    [QViewController gotoPage:@"QFindLoginKey" withParam:nil];
}

- (void)loginToAccount
{
    [keyTextFiled resignFirstResponder];
    [accountTextFiled resignFirstResponder];
    
    //保存全局数据
    [ASUserDefaults setObject:[NSNumber numberWithBool:autoLoginButton.selected] forKey:LoginIsAutoLogin];
    [ASUserDefaults setObject:accountTextFiled.text forKey:LoginUserPhone];
    [ASUserDefaults setObject:keyTextFiled.text forKey:LoginUserPassCode];
    
    if ([accountTextFiled.text isEqualToString:@""]) {
        [ASRequestHUD showErrorWithStatus:@"用户名不能为空"];
    }else if ([keyTextFiled.text isEqualToString:@""]){
        [ASRequestHUD showErrorWithStatus:@"登录密码不能为空"];
    } else if ([keyTextFiled.text length] < 6 || [keyTextFiled.text length] > 12) {
        [ASRequestHUD showErrorWithStatus:@"输入6-12英文或者数字"];
    }
    else{
        [[QHttpMessageManager sharedHttpMessageManager] accessLogin:accountTextFiled.text andPassword:keyTextFiled.text];
        [ASRequestHUD show];
    }
}

#pragma mark - Noficiation

- (void)successLogin:(NSNotification*)noti
{
    [ASRequestHUD dismiss];
    QLoginModel *model = noti.object;
    
    //登录成功
    if (model.status.intValue)
    {
        [self enter];
    }
    else
    {
        [QViewController showMessage:@"登录失败，请检查您的用户名或密码是否正确，如有问题请联系客服。"];
    }
    [[QHttpMessageManager sharedHttpMessageManager] accessGetMyService];
}

- (void)failedLogin:(NSNotification*)noti
{
    RequestType type = [noti.object intValue];
    if (0 == type)//网络原因,登录失败
    {
        ;
    }
}

#pragma mark StatusBar

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark -
#pragma mark rotate

- (BOOL)shouldAutorotate
{
    return YES;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait|UIDeviceOrientationPortraitUpsideDown;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait|UIInterfaceOrientationMaskPortraitUpsideDown;
}

@end
