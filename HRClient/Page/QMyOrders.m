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
#import "UIColor+Styles.h"


@class QMyOrdersCell;

@protocol QMyOrdersCellDelegate <NSObject>
@optional
//确认订单
- (void)checkOrder:(QMyOrdersCell*)cell;

@end

@interface QMyOrdersCell : UIView

- (id)initWithDelegate:(id)delegate;

@property (nonatomic, weak) id<QMyOrdersCellDelegate> delegate;
@property (nonatomic, strong) QOrderModel *model;

@end

@implementation QMyOrdersCell

- (id)initWithDelegate:(id)delegate
{
    self = [super init];
    if (self) {
        self.backgroundColor = [QTools colorWithRGB:240 :239 :237];
        
        _delegate = delegate;
    }
    return self;
}

- (void)setModel:(QOrderModel *)model
{
    _model = model;
    
    self.frame = CGRectMake(0, 0, SCREEN_SIZE_WIDTH, 185);
    
    CGFloat x = 10;
    CGFloat y = 10;
    CGFloat titleWidth = 60;
    CGFloat subTitleWidth = self.deFrameWidth - titleWidth - 25;
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, y, self.deFrameWidth, self.deFrameHeight - 10)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:bgView];

    //1.
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, y, self.deFrameWidth, .5f)];
    lineView.backgroundColor = ColorLine;
    [self addSubview:lineView];

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x, y, titleWidth, 35)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = ColorDarkGray;
    label.text = @"用户";
    [self addSubview:label];
    
    x += label.deFrameWidth + 5;
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(x, y, subTitleWidth, 35)];
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor colorWithRed:150/255.0 green:150/255.0 blue:150/255.0 alpha:1.0];
    label.text = model.nick;
    [self addSubview:label];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(x, y, subTitleWidth, 35)];
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = ColorTheme;
    label.textAlignment = NSTextAlignmentRight;
    [self addSubview:label];
    if (7 == [model.status intValue])
        label.text = @"待确认";
    else if (2 == [model.status intValue])
        label.text = @"待服务";
    else if (8 == [model.status intValue])
        label.text = @"已成交";
    
    //2.
    x = 10;
    y = label.deFrameBottom;
    lineView = [[UIView alloc] initWithFrame:CGRectMake(10, y, self.deFrameWidth - 2*10, .5f)];
    lineView.backgroundColor = ColorLine;
    [self addSubview:lineView];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(x, y, titleWidth, 35)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = ColorDarkGray;
    label.text = @"服务名称";
    [self addSubview:label];
    
    x += label.deFrameWidth + 5;
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(x, y, subTitleWidth, 35)];
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor colorWithRed:150/255.0 green:150/255.0 blue:150/255.0 alpha:1.0];
    label.text = model.subject;
    [self addSubview:label];
    
    //结算金额
    label = [[UILabel alloc] initWithFrame:CGRectMake(x, y, subTitleWidth, 35)];
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = ColorTheme;
    label.textAlignment = NSTextAlignmentRight;
    label.text = [NSString stringWithFormat:@"成交价格%.2f元", [model.price doubleValue]];
    [self addSubview:label];
    
    //3.
    x = 10;
    y = label.deFrameBottom;
    lineView = [[UIView alloc] initWithFrame:CGRectMake(10, y, self.deFrameWidth - 2*10, .5f)];
    lineView.backgroundColor = ColorLine;
    [self addSubview:lineView];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(x, y, titleWidth, 35)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = ColorDarkGray;
    label.text = @"订单号";
    [self addSubview:label];
    
    x += label.deFrameWidth + 5;
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(x, y, 200, 35)];
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor colorWithRed:150/255.0 green:150/255.0 blue:150/255.0 alpha:1.0];
    label.text = NSString_No_Nil(model.orderListNo);
    [self addSubview:label];
    
    //4.
    x = 10;
    y = label.deFrameBottom;
    lineView = [[UIView alloc] initWithFrame:CGRectMake(10, y, self.deFrameWidth - 2*10, .5f)];
    lineView.backgroundColor = ColorLine;
    [self addSubview:lineView];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(x, y, titleWidth, 35)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = ColorDarkGray;
    label.text = @"下单时间";
    [self addSubview:label];
    
    x += label.deFrameWidth + 5;
    
    //购买时间
    NSDateFormatter *dateFormatter = [QTools sharedQTools].orderTimeFormatter;
    NSString *orderTime = [dateFormatter stringFromDate: [NSDate dateWithTimeIntervalSince1970:([model.gmtCreate unsignedLongLongValue]/1000)]];//毫秒->秒
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(x, y, 200, 35)];
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor colorWithRed:150/255.0 green:150/255.0 blue:150/255.0 alpha:1.0];
    label.text = NSString_No_Nil(orderTime);
    [self addSubview:label];
    
    //5.
    x = 10;
    y = label.deFrameBottom;
    lineView = [[UIView alloc] initWithFrame:CGRectMake(10, y, self.deFrameWidth - 2*10, .5f)];
    lineView.backgroundColor = ColorLine;
    [self addSubview:lineView];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 75, 30)];
    button.deFrameTop = y + 3;
    button.deFrameRight = self.deFrameWidth - 10;
    [button setTitle:@"订单详情" forState:UIControlStateNormal];
    [button setTitleColor:ColorTheme forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:13];
    button.layer.cornerRadius = 2.5f;
    button.layer.masksToBounds = YES;
    button.layer.borderWidth = .5f;
    button.layer.borderColor = ColorTheme.CGColor;
    [button addTarget:self action:@selector(onOrderDetail) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    
    if (7 == [model.status intValue])
    {
        button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 75, 30)];
        button.deFrameTop = y + 3;
        button.deFrameRight = self.deFrameWidth - 75 - 15;
        [button setTitle:@"确认订单" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setBackgroundImage:[QTools createImageWithColor:ColorTheme] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:13];
        button.layer.cornerRadius = 2.5f;
        button.layer.masksToBounds = YES;
        [button addTarget:self action:@selector(onCheckOrder) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
    
    x = 0;
    y += 35;
    lineView = [[UIView alloc] initWithFrame:CGRectMake(x, y, self.deFrameWidth, .5f)];
    lineView.backgroundColor = ColorLine;
    [self addSubview:lineView];
}

#pragma mark - Action

- (void)onOrderDetail
{
    if (!_model || !_model.orderListId)
        return ;

    [QViewController gotoPage:@"QListDetail" withParam:[[NSDictionary alloc] initWithObjectsAndKeys:_model.orderListId, @"orderListId", nil]];
}

- (void)onCheckOrder
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(checkOrder:)])
    {
        [self.delegate checkOrder:self];
    }
}

@end

@interface QMyOrders ()<UITableViewDataSource, UITableViewDelegate>
{
    QDataPaging *_dataPage;
    NSArray *_tableData;
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
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(successOrderNo:) name:kOrderNotarize object:nil];
    }
    else if (eventType == kPageEventWillHide)
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:GetOrderList object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:kOrderNotarize object:nil];
        [ASRequestHUD dismiss];
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
        _segmentControl = [[UISegmentedControl alloc] initWithItems:@[@"全部", @"待确认", @"待服务", @"已成交"]];
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
        _myListTableView.allowsSelection = NO;
        [_view addSubview:_myListTableView];
        
        [_myListTableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
    }
    
    return _view;
}

#pragma mark - Private

- (void)headerRereshing
{
    _dataPage.nextPage = 1;
    if (_myListTableView.legendFooter.isRefreshing) {
        [_myListTableView.legendFooter endRefreshing];
    }
    
    [[QHttpMessageManager sharedHttpMessageManager] accessGetOrderList:_dataPage.nextPage];
}

- (void)footerLoadMore
{
    if (_myListTableView.legendHeader.isRefreshing) return;
    [[QHttpMessageManager sharedHttpMessageManager] accessGetOrderList:_dataPage.nextPage];
}

- (void)updateSegmentCtrlTitle:(NSArray*)titles
{
    for (int i = 0; i < titles.count; i++)
    {
        [_segmentControl setTitle:titles[i] forSegmentAtIndex:i];
    }
}

- (void)updateTableViewList:(NSArray*)array
{
    NSMutableArray *mArray = [[NSMutableArray alloc] initWithCapacity:0];
    if (0 == _segmentControl.selectedSegmentIndex)
    {
        [mArray addObjectsFromArray:array];
    }
    else
    {
        for (QOrderModel *model in array)
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
    
    _tableData = mArray;
    
    if (_tableData.count < 10) {
        [_myListTableView removeFooter];
    }
    else {
        [_myListTableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(footerLoadMore)];
    }
    
    if (_dataPage.mData.count
        && !(_dataPage.mData.count%_dataPage.pageSize)) //订单列表没有全部取完
    {
        if (_tableData.count < _dataPage.pageSize) //该类型订单未满一页,再取一次
        {
            [[QHttpMessageManager sharedHttpMessageManager] accessGetOrderList:_dataPage.nextPage];
            return;
        }
            
    }
    
    [_myListTableView reloadData];
    if (_myListTableView.legendHeader.isRefreshing)
        [_myListTableView.legendHeader endRefreshing];
    if (_myListTableView.legendFooter.isRefreshing)
        [_myListTableView.legendFooter endRefreshing];
    
    /*
    int allCount = 0;
    int seg1Count = 0;
    int seg2Count = 0;
    int seg3Count = 0;
    for (QOrderModel *model in _ordersArray)
    {
        allCount++;
        if ([model.status intValue] == 7) seg1Count++;
        else if ([model.status intValue] == 2) seg2Count++;
        else if ([model.status intValue] == 8) seg3Count++;
    }

    [self updateSegmentCtrlTitle:@[[NSString stringWithFormat:@"全部(%d)",allCount],
                                   [NSString stringWithFormat:@"待确认(%d)",seg1Count],
                                   [NSString stringWithFormat:@"待服务(%d)",seg2Count],
                                   [NSString stringWithFormat:@"已成交(%d)",seg3Count]]];
    */
}

#pragma mark - Notification

- (void)successGetOrderList:(NSNotification*)noti
{
    [_dataPage setMData:noti.object];
    _dataPage.nextPage++;
    [self updateTableViewList:_dataPage.mData];
}

- (void)failedGetOrderList:(NSNotification*)noti
{
    RequestType type = [noti.object intValue];
    if (kGetOrderList == type)//网络原因,接口失败
    {
        if (_myListTableView.legendHeader.isRefreshing)
            [_myListTableView.legendHeader endRefreshing];
        if (_myListTableView.legendFooter.isRefreshing)
            [_myListTableView.legendFooter endRefreshing];
    }
}

- (void)successOrderNo:(NSNotification*)noti
{
    [ASRequestHUD dismiss];
    [_myListTableView.legendHeader beginRefreshing];
}

#pragma mark - UISegmentedControl Delegate
- (void)segmentedControl:(UISegmentedControl*)segmentedControl
{
    [_myListTableView.legendHeader beginRefreshing];
}

#pragma mark - UITabelViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _tableData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QMyOrdersCell *contentView = [[QMyOrdersCell alloc] init];
    contentView.model = [_tableData objectAtIndex:indexPath.row];
    
    return contentView.deFrameHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *myList = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myList];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:myList];
        cell.backgroundColor = [UIColor clearColor];
    }
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    if (_tableData.count > indexPath.row)
    {
        QMyOrdersCell *contentView = [[QMyOrdersCell alloc] initWithDelegate:self];
        contentView.model = [_tableData objectAtIndex:indexPath.row];
        [cell.contentView addSubview:contentView];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - QMyOrdersCellDelegate
- (void)checkOrder:(QMyOrdersCell*)cell
{
    [[QHttpMessageManager sharedHttpMessageManager] accessOrderNotarize:cell.model.receiptOrdLstId];
    [ASRequestHUD show];
}

@end
