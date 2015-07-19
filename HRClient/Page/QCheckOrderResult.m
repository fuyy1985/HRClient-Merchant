//
//  QCheckOrderResult.m
//  HRClient
//
//  Created by amy.fu on 15/7/19.
//  Copyright (c) 2015年 panyj. All rights reserved.
//

#import "QCheckOrderResult.h"
#import "QDataModel.h"
#import "QViewController.h"

@interface QCheckOrderResult ()<UITableViewDataSource, UITableViewDelegate>
{
    NSArray *_items;
    QScanModel *_model;
}

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation QCheckOrderResult

- (NSString*)title
{
    return _T(@"验单结果");
}

- (void)setActiveWithParams:(NSDictionary *)params
{
    _model = [params objectForKey:@"QScanModel"];
}

- (UIView *)viewWithFrame:(CGRect)frame
{
    if ([super viewWithFrame:frame]) {
        
        _items = @[@"订单号：", @"消费券密码：", @"商品名称：", @"可用数量：", @"实付金额："];
        
        _tableView = [[UITableView alloc] initWithFrame:_view.bounds style:UITableViewStylePlain];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.allowsSelection = NO;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_view addSubview:_tableView];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _tableView.deFrameWidth, 85)];
        _tableView.tableFooterView = view;
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, _tableView.deFrameWidth - 2*10, 45)];
        [button setImage:[UIImage imageNamed:@"icon_success_yandan@2x"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"icon_success_yandan@2x"] forState:UIControlStateHighlighted];
        [button setTitle:@"验单成功!" forState:UIControlStateNormal];
        [button setTitleColor:[QTools colorWithRGB:0x6c :0xba :0x07] forState:UIControlStateNormal];
        [button setTitleColor:[QTools colorWithRGB:0x6c :0xba :0x07] forState:UIControlStateHighlighted];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        [view addSubview:button];
        
        button = [[UIButton alloc] initWithFrame:CGRectMake(10, 45, _tableView.deFrameWidth - 2*10, 40)];
        [button setBackgroundImage:[QTools createImageWithColor:ColorTheme] forState:UIControlStateNormal];
        [button setTitle:@" 继续验单" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        button.layer.cornerRadius = 2.5f;
        button.layer.masksToBounds = YES;
        [button addTarget:self action:@selector(goOnCheckOrder:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
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
        
    }
    else if (eventType == kPageEventViewDispose)
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}

#pragma mark - Action
- (void)goOnCheckOrder:(id)sender
{
    [QViewController backPageWithParam:nil];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _items.count;
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
    
    cell.textLabel.text = _items[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    cell.textLabel.textColor = [QTools colorWithRGB:3 :3 :3];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(95, 0, 200, 40)];
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [QTools colorWithRGB:0x88 :0x88 :0x88];
    [cell.contentView addSubview:label];
    
    if (_model)
    {
        switch (indexPath.row)
        {
            case 0:
                label.text = _model.orderListNo;
                break;
            case 1:
                label.text = _model.verificationCode;
                break;
            case 2:
                label.text = _model.subject;
                break;
            case 3:
                label.text = [NSString stringWithFormat:@"%d", [_model.quantity intValue]];
                break;
            case 4:
                label.text = [NSString stringWithFormat:@"%.2f", [_model.total doubleValue]];
                break;
            default:
                break;
        }
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

@end
