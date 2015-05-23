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
/*
@property (nonatomic, strong) UIScrollView      *scrollView;
@property (nonatomic, strong) UIPageControl     *pageControl;
@property (nonatomic, assign) NSInteger         nCurrentPage;*/
{
    UITextField *keyTextFiled;
    UITextField *accountTextFiled;
}

@end

@implementation QGuidepageController

- (void)gotoFindeKey
{
    [QViewController gotoPage:@"QFindLoginKey" withParam:nil];
}

- (void)loginToAccount{
    [keyTextFiled resignFirstResponder];
    [accountTextFiled resignFirstResponder];
    
    if ([accountTextFiled.text isEqualToString:@""]) {
        [ASRequestHUD showErrorWithStatus:@"用户名不能为空"];
    }else if ([keyTextFiled.text isEqualToString:@""]){
        [ASRequestHUD showErrorWithStatus:@"登录密码不能为空"];
    } else if ([keyTextFiled.text length] < 6 || [keyTextFiled.text length] > 12) {
        [ASRequestHUD showErrorWithStatus:@"请输入6-12英文或者数字"];
    }
    else{
        [[QHttpMessageManager sharedHttpMessageManager] accessLogin:accountTextFiled.text andPassword:keyTextFiled.text];
        [ASRequestHUD show];
    }
}

- (void)successLogin:(NSNotification*)noti
{
    [ASRequestHUD dismiss];
    QLoginModel *model = noti.object;
    
    if (model)
    {
        [QDataCenter sharedDataCenter]->loginModel = model;
    }
    
    //登录成功
    if (model.status.intValue)
    {
        [self enter];
    }
    else
    {
        [QViewController showMessage:@"登录失败，请检查您的用户名或密码是否正确，如有问题请联系客服。"];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kLogin object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(successLogin:) name:kLogin object:nil];
    
    self.view.backgroundColor = [QTools colorWithRGB:255 :255 :255];
    CGFloat beforeW = 30.0;
    CGFloat topH = 24.0;
    CGFloat w = self.view.frame.size.width - 60;
    CGFloat h = 35.0;
    CGFloat blank = 10.0;
    
    UIImageView *loginImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 198)];
    loginImageView.image = [UIImage imageNamed:@"pic_login_head"];
    [self.view addSubview:loginImageView];
    
    // 外框
    UILabel *accountLabel = [[UILabel alloc] initWithFrame:CGRectMake(beforeW, loginImageView.frame.size.height + loginImageView.frame.origin.y + topH, w, h)];
    accountLabel.backgroundColor = [UIColor clearColor];
    accountLabel.layer.masksToBounds = YES;
    accountLabel.layer.cornerRadius = 4.0;
    accountLabel.layer.borderColor = [QTools colorWithRGB:213 :213 :213].CGColor;
    accountLabel.layer.borderWidth = 1;
    accountLabel.userInteractionEnabled = YES;
    [self.view addSubview:accountLabel];
    
    // icon
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(9, 9, 17, 16)];
    iconImageView.image = [UIImage imageNamed:@"icon_login_name"];
    [accountLabel addSubview:iconImageView];
    
    // 竖线
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(iconImageView.frame.origin.x + iconImageView.frame.size.width +10, iconImageView.frame.origin.y - 1, 1, iconImageView.frame.size.height + 2)];
    lineLabel.backgroundColor = ColorLine;
    [accountLabel addSubview:lineLabel];
    
    accountTextFiled = [[UITextField alloc] initWithFrame:CGRectMake(lineLabel.frame.origin.x + 4, 0, accountLabel.frame.size.width - lineLabel.frame.origin.x - 2, accountLabel.frame.size.height)];
    accountTextFiled.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    accountTextFiled.font = [UIFont systemFontOfSize:14];
    accountTextFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
    accountTextFiled.returnKeyType = UIReturnKeyNext;
    accountTextFiled.placeholder = @"手机/用户名";
    accountTextFiled.delegate = (id<UITextFieldDelegate>)self;
    [accountLabel addSubview:accountTextFiled];
    
    // 外框,输入密码
    UILabel *keyLabel = [[UILabel alloc] initWithFrame:CGRectMake(beforeW, accountLabel.frame.size.height + accountLabel.frame.origin.y + blank, w, h)];
    keyLabel.layer.masksToBounds = YES;
    keyLabel.backgroundColor = [UIColor clearColor];
    keyLabel.layer.cornerRadius = 4.0;
    keyLabel.layer.borderColor = [QTools colorWithRGB:213 :213 :213].CGColor;
    keyLabel.layer.borderWidth = 1;
    keyLabel.userInteractionEnabled = YES;
    [self.view addSubview:keyLabel];
    
    // icon
    UIImageView *keyImageView = [[UIImageView alloc] initWithFrame:CGRectMake(9, 9, 17, 16)];
    keyImageView.image = [UIImage imageNamed:@"icon_login_pwd"];
    [keyLabel addSubview:keyImageView];
    
    // 竖线
    UILabel *keyLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(keyImageView.frame.origin.x + keyImageView.frame.size.width +10, keyImageView.frame.origin.y - 1, 1, keyImageView.frame.size.height + 2)];
    keyLineLabel.backgroundColor = [QTools colorWithRGB:239 :239 :239];
    [keyLabel addSubview:keyLineLabel];
    
    keyTextFiled = [[UITextField alloc] initWithFrame:CGRectMake(keyLineLabel.frame.origin.x + 4, 0, keyLabel.frame.size.width - keyLineLabel.frame.origin.x - 2, keyLabel.frame.size.height)];
    keyTextFiled.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    keyTextFiled.font = [UIFont systemFontOfSize:14];
    keyTextFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
    keyTextFiled.returnKeyType = UIReturnKeyJoin;
    keyTextFiled.placeholder = @"输入您的密码";
    keyTextFiled.secureTextEntry = YES;
    keyTextFiled.delegate = (id<UITextFieldDelegate>)self;
    [keyLabel addSubview:keyTextFiled];
    
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame = CGRectMake(beforeW, keyLabel.frame.origin.y + keyLabel.frame.size.height + 0.5*topH, (keyLabel.frame.size.width - blank)/2, h);
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginBtn setBackgroundImage:[QTools createImageWithColor:ColorTheme] forState:UIControlStateNormal];
    loginBtn.layer.masksToBounds = YES;
    loginBtn.layer.cornerRadius = 4.0;
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [loginBtn addTarget:self action:@selector(loginToAccount) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    
    UIButton *speedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    speedBtn.frame = CGRectMake(loginBtn.frame.origin.x + loginBtn.frame.size.width + blank, keyLabel.frame.origin.y + keyLabel.frame.size.height + 0.5*topH, (keyLabel.frame.size.width - blank)/2, h);
    [speedBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
    [speedBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [speedBtn setBackgroundImage:[QTools createImageWithColor:[QTools colorWithRGB:244 :80 :25]] forState:UIControlStateNormal];
    speedBtn.layer.masksToBounds = YES;
    speedBtn.layer.cornerRadius = 4.0;
    [speedBtn addTarget:self action:@selector(gotoFindeKey) forControlEvents:UIControlEventTouchUpInside];
    speedBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:speedBtn];
    
    //test
    accountTextFiled.text = @"18958056805";
    keyTextFiled.text = @"123456";
    
    /*
    CGFloat lineW = 0.3 * self.view.frame.size.width;
    CGFloat lineTop = 42;
    
    UILabel *leftLabal = [[UILabel alloc] initWithFrame:CGRectMake(0, loginBtn.frame.origin.y + loginBtn.frame.size.height + lineTop, lineW, 0.5f)];
    leftLabal.backgroundColor = [QTools colorWithRGB:223 :223 :223];
    [self.view addSubview:leftLabal];
    
    UIButton *accountRegisterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    accountRegisterBtn.frame = CGRectMake(leftLabal.frame.origin.x + leftLabal.frame.size.width, leftLabal.frame.origin.y - 13, self.view.frame.size.width/2 - leftLabal.frame.size.width, 26);
    [accountRegisterBtn setTitle:@"用户注册" forState:UIControlStateNormal];
    [accountRegisterBtn setTitleColor:ColorTheme forState:UIControlStateNormal];
    accountRegisterBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [accountRegisterBtn addTarget:self action:@selector(gotoAccountRegister) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:accountRegisterBtn];
    
    UILabel *erectLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2, leftLabal.frame.origin.y - 8, 0.5f, 26/2)];
    erectLabel.backgroundColor = ColorLine;
    [self.view addSubview:erectLabel];
    
    UIButton *forgetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    forgetBtn.frame = CGRectMake(self.view.frame.size.width - leftLabal.frame.size.width - accountRegisterBtn.frame.size.width, leftLabal.frame.origin.y - 13, self.view.frame.size.width/2 - leftLabal.frame.size.width, 26);
    [forgetBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
    [forgetBtn setTitleColor:ColorTheme forState:UIControlStateNormal];
    forgetBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [forgetBtn addTarget:self action:@selector(gotoFindeKey) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:forgetBtn];
    
    UILabel *rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width - lineW, loginBtn.frame.origin.y + loginBtn.frame.size.height + lineTop, lineW, 0.5f)];
    rightLabel.backgroundColor = ColorLine;
    [self.view addSubview:rightLabel];*/

    
    /*
    _nCurrentPage = 0;
    NSUInteger numberofPages = 3;
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    if (!SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        height -= 20;
    }
    //big scrollView
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, width, height)];
    _scrollView.pagingEnabled = YES;
    _scrollView.contentSize = CGSizeMake(width * (numberofPages+1), height);
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.scrollsToTop = NO;
    _scrollView.delegate = self;
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    for (int i = 0; i < 3; i++)
    {
        CGRect rect = CGRectMake(width * i,0,width,height);
        UIView *bgView = [[UIView alloc] initWithFrame:rect];
        UIImageView *imageView ;
        switch (i) {
            case 0:
                bgView.backgroundColor = [QTools colorWithRGB:145 :111 :171];
                imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pic_yindao1"]];
                break;
                
            case 1:
                bgView.backgroundColor = [QTools colorWithRGB:255 :116 :55];
                imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pic_yindao2"]];
                break;
                
            case 2:
                bgView.backgroundColor = [QTools colorWithRGB:248 :89 :89];
                imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pic_yindao3"]];
                break;
                
            default:
                break;
        }
        
        [_scrollView addSubview:bgView];
        CGFloat rate = width/320;
        imageView.frame = CGRectMake(0, (height - CGRectGetHeight(imageView.frame)*rate - 57)/2, width, CGRectGetHeight(imageView.frame)*rate);
        [bgView addSubview:imageView];

        if (numberofPages == (i+1))
        {
            
            CGFloat marginY = 0;
            if (([UIDevice currentScreenSize] == UIDevice_3_5_Inch)) {
                if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
                    marginY = 10;
                }
            }
            else {
                marginY = 30;
            }

            UIButton *btnStart = [UIButton buttonWithType:UIButtonTypeCustom];
            btnStart.frame = CGRectMake((width -140)/2, CGRectGetMaxY(imageView.frame)+marginY, 140, 40);
            [btnStart setImage:IMAGEOF(@"btn_start") forState:UIControlStateNormal];
            [btnStart addTarget:self action:@selector(enter) forControlEvents:UIControlEventTouchUpInside];
            [bgView addSubview:btnStart];
            
            bgView.userInteractionEnabled = YES;
        }
    }
    
    [self.view addSubview:_scrollView];
    
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, height - 37 - 5, width, 37)];
    _pageControl.numberOfPages = numberofPages;
    _pageControl.currentPage = _nCurrentPage;
    _pageControl.backgroundColor = [UIColor clearColor];
    _pageControl.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:_pageControl];
     */
}

- (void)enter
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(closeGuideView)]) {
        [self.delegate closeGuideView];
    }
}

/*
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGPoint offset = scrollView.contentOffset;
    if (offset.x > SCREEN_SIZE_WIDTH*2) {
        //close GuideView
        if (self.delegate && [self.delegate respondsToSelector:@selector(closeGuideView)]) {
            [self.delegate closeGuideView];
        }
    }
    else {
        _pageControl.currentPage = round(offset.x/scrollView.bounds.size.width);
    }
}*/

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
