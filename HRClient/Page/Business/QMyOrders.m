//
//  QMyOrders.m
//  HRClient
//
//  Created by chenyf on 14/12/2.
//  Copyright (c) 2014年 panyj. All rights reserved.
//

#import "QMyOrders.h"
#import "QViewController.h"
#import "QDataPaging.h"
#import "MJRefresh.h"
#import "QHttpManager.h"
#import "QHttpMessageManager.h"

@interface QMyOrders ()<UITableViewDataSource, UITableViewDelegate>
{
    QDataPaging *_dataPage;
}

@property (nonatomic,strong)UISegmentedControl *segmentControl;
@property (nonatomic,strong)UITableView *myListTableView;

@end

@implementation QMyOrders

- (NSString*)title
{
    return _T(@"我的订单");
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
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(successGetOrderList:) name:GetOrderList object:nil];
    }
    else if (eventType == kPageEventWillHide)
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:GetOrderList object:nil];
    }
    else if (eventType == kPageEventViewCreate)
    {
        _dataPage = [[QDataPaging alloc] init];
        [_myListTableView.header beginRefreshing];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(failedGetOrderList:) name:kInterfaceFailed object:nil];
    }
    else if (eventType == kPageEventViewDispose)
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}

- (UIView *)viewWithFrame:(CGRect)frame
{
    if ([super viewWithFrame:frame]) {
        //segmentControl
        _segmentControl = [[UISegmentedControl alloc] initWithItems:@[@"全部", @"待确认", @"待服务", @"已成交"]];//
        _segmentControl.frame = CGRectMake(10, 8, (_view.frame.size.width - 20), 30);
        _segmentControl.tintColor = ColorTheme;
        _segmentControl.selectedSegmentIndex = 0;
        [_segmentControl addTarget:self action:@selector(segmentedControl:) forControlEvents:UIControlEventValueChanged];
        [_view addSubview:_segmentControl];
        
        _myListTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _segmentControl.deFrameBottom, frame.size.width, frame.size.height - _segmentControl.deFrameBottom) style:UITableViewStylePlain];
        _myListTableView.dataSource = self;
        _myListTableView.delegate = self;
        _myListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _myListTableView.backgroundColor = [UIColor clearColor];
        _myListTableView.tableFooterView = [UIView new];
        [_view addSubview:_myListTableView];
        
        [_myListTableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
    }
    
    return _view;
}

#pragma mark - Private

- (void)headerRereshing
{
    [[QHttpMessageManager sharedHttpMessageManager] accessGetOrderList];
}

#pragma mark - Notification

- (void)successGetOrderList:(NSNotification*)noti
{
    NSMutableArray *mArray = [[NSMutableArray alloc] initWithCapacity:0];
    if (0 == _segmentControl.selectedSegmentIndex)
    {
        [mArray addObjectsFromArray:noti.object];
    }
    else
    {
        for (QOrderModel *model in noti.object)
        {
            switch (_segmentControl.selectedSegmentIndex) {
                case 1:
                {
                    //待确认
                    if ([model.status intValue] == 7) [mArray addObject:model];
                }
                    break;
                case 2:
                {
                    //待服务
                    if ([model.status intValue] == 2) [mArray addObject:model];
                }
                    break;
                case 3://已成交
                {
                    if ([model.status intValue] == 8) [mArray addObject:model];
                }
                    break;
                default:
                    break;
            }
            
        }
    }
    [_dataPage setMData:mArray];
    
    if (_myListTableView.legendHeader.isRefreshing)
        [_myListTableView.legendHeader endRefreshing];
    [_myListTableView reloadData];
}

- (void)failedGetOrderList:(NSNotification*)noti
{
    RequestType type = [noti.object intValue];
    if (kGetOrderList == type)//网络原因,接口失败
    {
        [_myListTableView.header endRefreshing];
    }
}

#pragma mark - UISegmentedControl Delegate
- (void)segmentedControl:(UISegmentedControl*)segmentedControl
{
    if (!_myListTableView.legendHeader.isRefreshing)
        [_myListTableView.header beginRefreshing];
}

#pragma mark - UITabelViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataPage.mData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *myList = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myList];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:myList];
    }
    
    cell.textLabel.text = @"123";
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
