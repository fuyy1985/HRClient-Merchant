//
//  QMyList.m
//  HRClient
//
//  Created by ekoo on 14/12/11.
//  Copyright (c) 2014年 panyj. All rights reserved.
//

#import "QMyList.h"
#import "QMyListCell.h"
#import "QViewController.h"
#import "QHttpMessageManager.h"
#import "QMyListDetailModel.h"
#import "QDataPaging.h"
#import "MJRefresh.h"

@interface QMyList ()<QMyListCellDelegate>
{
    UILabel *_lbCashDetail; //目前已验券xx单，实际结算金额xx元
    QDataPaging *_dataPage;
}
@property (nonatomic,strong)UITableView *myListTableView;
@property (nonatomic,strong)NSDictionary *dic;

@end

@implementation QMyList

- (NSString *)title
{
    return _T(@"可提现订单");;
}

- (QCacheType)pageCacheType //NOTE:页面缓存方式
{
    return kCacheTypeCommon;
}

- (void)pageEvent:(QPageEventType)eventType
{
    if (eventType == kPageEventWillShow)
    {
    }
    else if (eventType == kPageEventViewCreate)
    {
        _dataPage = [[QDataPaging alloc] init];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(successGetOrderList:) name:kGetOrderList object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(successAllOrderNotarize:) name: kAllOrderNotarize object:nil];
        
        [_myListTableView.legendHeader beginRefreshing];
    }
    else if (eventType == kPageEventWillHide)
    {
        [ASRequestHUD dismiss];
    }
    else if (eventType == kPageEventViewDispose)
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}

- (void)setActiveWithParams:(NSDictionary*)params //NOTE:方便页面激活时接收参数
{
    self.dic = [NSDictionary dictionary];
    self.dic = params;
}

-(void)ChangeSegmentFont:(UIView *)aView
{
    if ([aView isKindOfClass:[UILabel class]]) {
        UILabel *lb = (UILabel    *)aView;
        [lb setTextAlignment:NSTextAlignmentCenter];
        [lb setFrame:CGRectMake(0, 0, 120, 30)];
        [lb setFont:[UIFont systemFontOfSize:14]];
    }
    NSArray *na = [aView subviews];
    NSEnumerator *ne = [na objectEnumerator];
    UIView *subView;
    while (subView = [ne nextObject]) {
        [self ChangeSegmentFont:subView];
    }
}

- (UIView *)viewWithFrame:(CGRect)frame{
    if ([super viewWithFrame:frame]) {
        
        _myListTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, _view.deFrameWidth, _view.deFrameHeight - 90) style:UITableViewStylePlain];
        _myListTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _myListTableView.dataSource = self;
        _myListTableView.delegate = self;
        _myListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _myListTableView.backgroundColor = [UIColor clearColor];
        _myListTableView.tableFooterView = [UIView new];
        [_view addSubview:_myListTableView];
        [_myListTableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, _view.deFrameHeight - 90, _view.deFrameWidth, 90)];
        view.backgroundColor = [UIColor clearColor];
        [_view addSubview:view];
        
        _lbCashDetail = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, view.deFrameWidth, 40)];
        _lbCashDetail.backgroundColor = [UIColor clearColor];
        _lbCashDetail.font = [UIFont systemFontOfSize:13];
        _lbCashDetail.textColor = ColorTheme;
        _lbCashDetail.textAlignment = NSTextAlignmentCenter;
        [view addSubview:_lbCashDetail];
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(15, view.deFrameHeight - 55, view.deFrameWidth - 2*15, 40)];
        [button setBackgroundImage:[QTools createImageWithColor:ColorTheme] forState:UIControlStateNormal];
        [button setTitle:@"确认结算" forState:UIControlStateNormal];
        button.layer.cornerRadius = 2.5f;
        button.layer.masksToBounds = YES;
        [button addTarget:self action:@selector(onCheckAllOrder:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
    }
    return _view;
}

#pragma mark - Private

- (void)headerRereshing
{
    [[QHttpMessageManager sharedHttpMessageManager] accessGetOrderList];
}

#pragma mark - Action
/**
    一键确认订单
 */
- (void)onCheckAllOrder:(id)sender
{
    [[QHttpMessageManager sharedHttpMessageManager] accessAllOrderNotarize];
    [ASRequestHUD show];
}

#pragma mark - Notification
/**
 成功获取商家可提现订单列表
 */
- (void)successGetOrderList:(NSNotification *)noti
{
    [_dataPage setMData:noti.object];
    
    [_myListTableView reloadData];
    
    double total = 0;
    for (QOrderModel *model in _dataPage.mData)
    {
        total = [model.price doubleValue];
    }
    
    _lbCashDetail.text = [NSString stringWithFormat:@"目前已验券%d单，实际结算金额%.2f元", _dataPage.mData.count, total];
    
    if (_myListTableView.legendHeader.isRefreshing)
        [_myListTableView.legendHeader endRefreshing];

}

- (void)successAllOrderNotarize:(NSNotification*)noti
{
    [ASRequestHUD dismissWithSuccess:@"结算成功"];
}


#pragma mark - UITabelViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataPage.mData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ListCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *myList = @"MyList";
    QMyListCell *cell = [tableView dequeueReusableCellWithIdentifier:myList];
    if (cell == nil)
    {
        cell = [[QMyListCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:myList];
        cell.delegate = self;
    }
    
    if (_dataPage.mData.count <= indexPath.row) {
        return cell;
    }
    
    [cell configureUIwithDataModel:_dataPage.mData[indexPath.row]];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    QMyListDetailModel *model = _dataPage.mData[indexPath.row];
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:model, @"model", nil];
    
    switch ([model.status intValue]) {
        case kOrderStatusUnPayed:
        case kOrderStatusUnUsed:
        case kOrderStatusRefund:
            [QViewController gotoPage:@"QListDetail" withParam:[[NSDictionary alloc] initWithObjectsAndKeys:model.orderListId, @"orderListId", model.status, @"status", nil]];
            break;
        case kOrderStatusNeedRemark:
            [QViewController gotoPage:@"QRemark" withParam:dic];
            break;
        default:
            break;
    }

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end

