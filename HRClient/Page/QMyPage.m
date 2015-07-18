//
//  QMyPage.m
//  HRClient
//
//  Created by ekoo on 14/12/15.
//  Copyright (c) 2014年 panyj. All rights reserved.
//

#import "QMyPage.h"
#import "QMyPageCell.h"
#import "QViewController.h"
#import "VPImageCropperViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "QHttpMessageManager.h"
#import "QDataCenter.h"
#import "UIImageView+WebCache.h"

#define ORIGINAL_MAX_WIDTH 640.0f

@interface QMyPage () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    NSArray *imageArr;
    NSArray *titleArr;
    UIImageView *iconImageView;
    QLoginModel *dataArr;//页面的数据
    
    UILabel *nameLabel;
    UILabel *_balanceLabel;
    UILabel *_couponLabel;
}

@property (nonatomic, strong) UIImageView *portraitImageView;

@end

@implementation QMyPage

- (NSString *)title{
    return @"商户中心";
}

- (void)pageEvent:(QPageEventType)eventType
{
    if (eventType == kPageEventViewCreate)
    {
    }
    else if (eventType == kPageEventWillShow)
    {
        //TODO:每次到这里都要更新账户信息
        //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(successUpdateMyAccountInfo:) name:kGetMyAccountInfro object:nil];
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

- (UIView *)viewWithFrame:(CGRect)frame{
    if ([super viewWithFrame:frame]) {
        _view.backgroundColor = [QTools colorWithRGB:240 :239 :237];
        imageArr = @[@"wodezhanghu",@"dingdan",@"mima"];
        titleArr = @[@"我的账户",@"可提现订单",@"密码管理"];
        
        UIImageView *firstImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 115)];
        firstImageView.image = [UIImage imageNamed:@"backgroundmine01.png"];
        firstImageView.userInteractionEnabled = YES;
        [_view addSubview:firstImageView];
        
        CGFloat iconBeforeW = 25;
        CGFloat iconTopH = 15;
        CGFloat iconW = 80;
        CGFloat iconH = 80;
        
        iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(iconBeforeW, iconTopH, iconW, iconH)];
        iconImageView.layer.cornerRadius = iconImageView.frame.size.width/2;
        iconImageView.clipsToBounds = YES;
        iconImageView.layer.borderWidth = 3.0f;
        iconImageView.layer.borderColor = [UIColor whiteColor].CGColor;
        iconImageView.contentMode = UIViewContentModeScaleAspectFill;
        
        //头像
        UIImage *iconImage = [UIImage imageNamed:@"head.png"];
        QLoginModel *model = [QDataCenter sharedDataCenter]->loginModel;
        
        if (model.photoPath && ![model.photoPath isEqualToString:@""])
        {
            NSString *str = PICTUREHTTP(model.photoPath);
            [iconImageView sd_setImageWithURL:[NSURL URLWithString:str]
                    placeholderImage:[UIImage imageNamed:@"head.png"]
                             options:SDWebImageRefreshCached];
        }
        else
        {
            iconImageView.image = iconImage;
        }
        iconImageView.userInteractionEnabled = NO; //yes->no
        [firstImageView addSubview:iconImageView];
        
        //名字
        CGFloat nameTopH = 28;
        CGFloat contentBlank = 10;
        CGFloat nameBeforeW = iconImageView.deFrameRight +contentBlank;
        CGFloat nameW = 140;
        CGFloat nameH = 26;
        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameBeforeW, nameTopH, nameW, nameH)];
        nameLabel.backgroundColor = [UIColor clearColor];
        QCompanyModel *companyModel = [QDataCenter sharedDataCenter]->companyModel;
        if (companyModel.companyName && ![companyModel.companyName isEqualToString:@"N/A"])
        {
            nameLabel.text = companyModel.companyName;
        }
        else
        {
            nameLabel.text = companyModel.telphone;
        }
        nameLabel.textColor = [UIColor whiteColor];
        nameLabel.font = [UIFont boldSystemFontOfSize:18];
        [firstImageView addSubview:nameLabel];
                
        //余额
        CGFloat balanceTopH = nameLabel.deFrameBottom + contentBlank - 5;
        CGFloat balanceBeforeW = nameBeforeW;
        CGFloat balanceW = nameW;
        CGFloat balanceH = nameH;
        UILabel *balanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(balanceBeforeW, balanceTopH, balanceW, balanceH)];
        balanceLabel.text = [NSString stringWithFormat:@"可提现余额：%.2f元", [model.balance doubleValue]];
        balanceLabel.backgroundColor = [UIColor clearColor];
        balanceLabel.textColor = [UIColor whiteColor];
        balanceLabel.font = [UIFont boldSystemFontOfSize:13];
        [firstImageView addSubview:balanceLabel];
        _balanceLabel = balanceLabel;
        
        UIImageView *buttomImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, firstImageView.deFrameBottom, frame.size.width, frame.size.height - firstImageView.deFrameBottom)];
        buttomImageView.userInteractionEnabled = YES;
        [_view addSubview:buttomImageView];
        
        UIView *cardView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, buttomImageView.frame.size.width, 0)]; //45
        cardView.backgroundColor = [UIColor whiteColor];
        [buttomImageView addSubview:cardView];
        
        CGFloat buttomTopH = cardView.deFrameBottom;
        CGFloat buttomW = frame.size.width;
        CGFloat buttomH = buttomImageView.frame.size.height - buttomTopH;
        UIView *buttomView = [[UIView alloc] initWithFrame:CGRectMake(0, buttomTopH, buttomW, buttomH)];
        buttomView.backgroundColor = [QTools colorWithRGB:255 :255 :255];
        [buttomImageView addSubview:buttomView];
        
        CGFloat tableH;
        if (SCREEN_SIZE_HEIGHT == 480) {
            tableH = 240;
        }else{
            tableH = 300;
        }
        UITableView *myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width ,buttomView.deFrameHeight) style:UITableViewStylePlain];
        myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        myTableView.dataSource = self;
        myTableView.delegate = self;
        if (SCREEN_SIZE_HEIGHT == 480) {
            myTableView.scrollEnabled = YES;
        }else{
            myTableView.scrollEnabled = NO;
        }
        [buttomView addSubview:myTableView];
        
    }
    return _view;
}

#pragma mark - Notification

- (void)successUpdateMyAccountInfo:(NSNotification*)noti
{
    //_balanceLabel.text = [NSString stringWithFormat:@"账户余额：%.2f元", [[QUser sharedQUser].normalAccount.balance doubleValue]];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return imageArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return CellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *myCellID = @"myCell_Identifer";
    QMyPageCell *myCell = [tableView dequeueReusableCellWithIdentifier:myCellID];
    if (myCell == nil) {
        myCell = [[QMyPageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myCellID];
        myCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    [myCell configureModelForCell:imageArr andTitle:titleArr andIndexPath:indexPath];
    return myCell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0)
    {
        //我的账户
        [QViewController gotoPage:@"QMyAccount" withParam:nil];
    }
    else if (indexPath.row == 1)
    {
        //可提现订单
        NSString *row = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
        NSDictionary *dic = @{@"page":row};
        [QViewController gotoPage:@"QMyList" withParam:dic];
    }
    else if (indexPath.row == 2)
    {
        //密码管理
        [QViewController gotoPage:@"QMyData" withParam:nil];
    }
}

@end
