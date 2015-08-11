//
//  QListDetail.m
//  HRClient
//
//  Created by ekoo on 14/12/11.
//  Copyright (c) 2014年 panyj. All rights reserved.
//

#import "QListDetail.h"
#import "QViewController.h"
#import "QHttpMessageManager.h"
#import "QMyListDetailModel.h"
#import "UIImageView+WebCache.h"


typedef enum{
    kCellNone,
    kCellProduct = 1,//商品详情
    kCellOrderStatus,//订单服务状态
    kCellOrderTotalPrice,//订单总价
    kCellOrderDetail,//订单详情
}OrderCellType;

@interface QListDetail ()<UITableViewDataSource,UITableViewDelegate>
{
    BOOL _isDataChanged;
    NSNumber *_orderID;
    QOrderDetailModel *_detailModel;
}
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation QListDetail

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setActiveWithParams:(NSDictionary *)params
{
    _orderID = [params objectForKey:@"orderListId"];
    _isDataChanged = YES;
    _detailModel = nil;
}

- (QCacheType)pageCacheType
{
    return kCacheTypeNone;
}

- (void)pageEvent:(QPageEventType)eventType
{
    if (eventType == kPageEventViewCreate)
    {
        _isDataChanged = YES;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(successGetOrderDetail:) name:kGetOrderDetail object:nil];
    }
    else if (eventType == kPageEventViewDispose)
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
    else if (eventType == kPageEventWillShow)
    {
        if (_isDataChanged)
        {
            [[QHttpMessageManager sharedHttpMessageManager] accessGetOrderDetail:_orderID];
            [ASRequestHUD show];
        }
    }
}

- (NSString *)title
{
    return @"订单详情";
}

- (UIView *)viewWithFrame:(CGRect)frame
{
    if ([super viewWithFrame:frame]) {
        
        _view.backgroundColor = [QTools colorWithRGB:240 :239 :237];
        _view.clipsToBounds = YES;
    }
    return _view;
}

- (UITableView*)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 0, _view.deFrameWidth - 2*10, _view.deFrameHeight - 10) style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.allowsSelection = NO;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.clipsToBounds = NO;
        [_view addSubview:_tableView];
    }
    return _tableView;
}

#pragma mark - Private

- (OrderCellType)cellTypeByIndex:(NSUInteger)index
{
    OrderCellType type = kCellNone;
    switch (index)
    {
        case 0:
            type = kCellProduct;
            break;
        case 1:
        {
            type = kCellOrderStatus;
        }
            break;
        case 2:
        {
            type = kCellOrderTotalPrice;
        }
            break;
        case 3:
        {
            type = kCellOrderDetail;
        }
            break;
        default:
            break;
    }
    return type;
}

- (CGFloat)heightofCell:(OrderCellType)type
{
    CGFloat height = 0;
    switch (type) {
        case kCellProduct:
            height = 90;
            break;
        case kCellOrderStatus:
            height = 40;
            break;
        case kCellOrderTotalPrice:
            height = ( 2 == [_detailModel.status intValue]) ? 40 : 80;
            break;
        case kCellOrderDetail:
            height = 250;
            break;
        default:
            break;
    }
    return height;
}

#pragma mark - Action


#pragma mark - Notification

- (void)successGetOrderDetail:(NSNotification *)noti
{
    _detailModel = noti.object;
    [self.tableView reloadData];
    
    [ASRequestHUD dismiss];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (!_detailModel)
        return 0;

    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    //初始化
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if (!_detailModel) return cell;
    
    switch ([self cellTypeByIndex:indexPath.section]) {
        case kCellProduct:
        {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 90, 70)];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            [imageView sd_setImageWithURL:[NSURL URLWithString:PICTUREHTTP(_detailModel.photo)]
                         placeholderImage:[UIImage imageNamed:@"default_image"]
                                  options:SDWebImageRefreshCached];
            imageView.clipsToBounds = YES;
            [cell.contentView addSubview:imageView];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(imageView.deFrameRight + 10, 0, tableView.deFrameWidth - imageView.deFrameRight - 10, 50)];
            label.numberOfLines = 0;
            label.font = [UIFont systemFontOfSize:15];
            label.textColor = [UIColor blackColor];
            label.text = _detailModel.subject;
            [cell.contentView addSubview:label];
            
            //价格
            label = [[UILabel alloc] initWithFrame:CGRectMake(imageView.deFrameRight + 10, 50 + 10, tableView.deFrameWidth - imageView.deFrameRight - 10, 30)];
            label.font = [UIFont systemFontOfSize:13];
            label.textColor = ColorDarkGray;
            [cell.contentView addSubview:label];
            
            NSString *realPrice = [NSString stringWithFormat:@"%.2f", [_detailModel.unit_price doubleValue]];
            NSString *retailPrice = [NSString stringWithFormat:@"%.2f", [_detailModel.price doubleValue]];
            
            NSString *text = [NSString stringWithFormat:@"%@元   %@", realPrice, retailPrice];
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:text attributes:@{NSStrikethroughStyleAttributeName: @(NSUnderlineStyleNone)}];
            [string addAttributes:@{NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle)} range:NSMakeRange(text.length - retailPrice.length, retailPrice.length)];
            [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:[text rangeOfString:realPrice]];
            [string addAttribute:NSForegroundColorAttributeName value:ColorTheme range:[text rangeOfString:realPrice]];
            label.attributedText = string;
        }
            break;
        case kCellOrderStatus:
        {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, tableView.deFrameWidth - 2*10, 40)];
            label.backgroundColor = [UIColor clearColor];
            label.font = [UIFont systemFontOfSize:15];
            label.textColor = ColorDarkGray;
            label.text = @"订单状态";
            [cell.contentView addSubview:label];
            
            label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, tableView.deFrameWidth - 2*10, 40)];
            label.font = [UIFont systemFontOfSize:14];
            label.textAlignment = NSTextAlignmentRight;
            label.textColor = ColorTheme;
            label.text = @"已服务";
            if (7 == [_detailModel.status intValue])
                label.text = @"待确认";
            else if (2 == [_detailModel.status intValue])
                label.text = @"待服务";
            else if (8 == [_detailModel.status intValue])
                label.text = @"已成交";
            [cell.contentView addSubview:label];
        }
            break;
        case kCellOrderTotalPrice:
        {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, tableView.deFrameWidth - 2*10, 40)];
            label.backgroundColor = [UIColor clearColor];
            label.font = [UIFont systemFontOfSize:15];
            label.textColor = [UIColor blackColor];
            label.text = @"成交价";
            [cell.contentView addSubview:label];
            
            label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, tableView.deFrameWidth - 2*10, 40)];
            label.font = [UIFont systemFontOfSize:14];
            label.textAlignment = NSTextAlignmentRight;
            label.textColor = ColorTheme;
            label.text = [NSString stringWithFormat:@"%.2f元", [_detailModel.total doubleValue]];
            [cell.contentView addSubview:label];
            
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, 40, tableView.deFrameWidth - 2*10, .5f)];
            lineView.backgroundColor = ColorLine;
            [cell.contentView addSubview:lineView];
            
            cell.clipsToBounds = YES;
//            if (2 != [_detailModel.status intValue]
            {
                label = [[UILabel alloc] initWithFrame:CGRectMake(10, 40, tableView.deFrameWidth - 2*10, 40)];
                label.backgroundColor = [UIColor clearColor];
                label.font = [UIFont systemFontOfSize:15];
                label.textColor = [UIColor blackColor];
                label.text = @"实际结算";
                [cell.contentView addSubview:label];
                
                label = [[UILabel alloc] initWithFrame:CGRectMake(10, 40, tableView.deFrameWidth - 2*10, 40)];
                label.font = [UIFont systemFontOfSize:14];
                label.textAlignment = NSTextAlignmentRight;
                label.textColor = ColorTheme;
                label.text = [NSString stringWithFormat:@"%.2f元", [_detailModel.actualSettlement doubleValue]];
                [cell.contentView addSubview:label];
            }
        }
            break;
        case kCellOrderDetail:
        {
            CGFloat orginY = 0;
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, orginY, tableView.deFrameWidth - 2*10, 40)];
            label.backgroundColor = [UIColor clearColor];
            label.font = [UIFont systemFontOfSize:15];
            label.textColor = [UIColor blackColor];
            label.text = @"订单信息";
            [cell.contentView addSubview:label];
            
            orginY = label.deFrameBottom;
            
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, orginY - .5f, tableView.deFrameWidth - 2*10, .5f)];
            lineView.backgroundColor = ColorLine;
            [cell.contentView addSubview:lineView];
            
            label = [[UILabel alloc] initWithFrame:CGRectMake(15, orginY, 90, 35)];
            label.font = [UIFont systemFontOfSize:14];
            label.textColor = ColorDarkGray;
            label.text = @"订单号：";
            [cell.contentView addSubview:label];
            
            label = [[UILabel alloc] initWithFrame:CGRectMake(90, orginY, 200, 35)];
            label.font = [UIFont systemFontOfSize:13];
            label.textColor = ColorLightGray;
            label.text = _detailModel.orderListNo;
            [cell.contentView addSubview:label];
            
            orginY = label.deFrameBottom;
            
            lineView = [[UIView alloc] initWithFrame:CGRectMake(10, orginY - .5f, tableView.deFrameWidth - 2*10, .5f)];
            lineView.backgroundColor = ColorLine;
            [cell.contentView addSubview:lineView];
            
            label = [[UILabel alloc] initWithFrame:CGRectMake(15, orginY, 90, 35)];
            label.font = [UIFont systemFontOfSize:14];
            label.textColor = ColorLightGray;
            label.text = @"购买手机号：";
            [cell.contentView addSubview:label];
            
            label = [[UILabel alloc] initWithFrame:CGRectMake(90, orginY, 200, 35)];
            label.font = [UIFont systemFontOfSize:13];
            label.textColor = ColorLightGray;
            label.text = _detailModel.phone;
            [cell.contentView addSubview:label];
            
            orginY = label.deFrameBottom;
            
            lineView = [[UIView alloc] initWithFrame:CGRectMake(10, orginY - .5f, tableView.deFrameWidth - 2*10, .5f)];
            lineView.backgroundColor = ColorLine;
            [cell.contentView addSubview:lineView];
            
            label = [[UILabel alloc] initWithFrame:CGRectMake(15, orginY, 90, 35)];
            label.font = [UIFont systemFontOfSize:14];
            label.textColor = ColorDarkGray;
            label.text = @"下单时间：";
            [cell.contentView addSubview:label];
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
            NSString *orderTime = [dateFormatter stringFromDate: [NSDate dateWithTimeIntervalSince1970:([_detailModel.gmtCreate unsignedLongLongValue]/1000)]];//毫秒->秒
            
            label = [[UILabel alloc] initWithFrame:CGRectMake(90, orginY, 200, 35)];
            label.font = [UIFont systemFontOfSize:13];

            label.textColor = ColorLightGray;
            label.text = orderTime;
            [cell.contentView addSubview:label];
            
            orginY = label.deFrameBottom;
            
            lineView = [[UIView alloc] initWithFrame:CGRectMake(10, orginY - .5f, tableView.deFrameWidth - 2*10, .5f)];
            lineView.backgroundColor = ColorLine;
            [cell.contentView addSubview:lineView];
            
            label = [[UILabel alloc] initWithFrame:CGRectMake(15, orginY, 90, 35)];
            label.font = [UIFont systemFontOfSize:14];
            label.textColor = ColorDarkGray;
            label.text = @"有效期：";
            [cell.contentView addSubview:label];
            
            orderTime = [dateFormatter stringFromDate: [NSDate dateWithTimeIntervalSince1970:([_detailModel.expireDate unsignedLongLongValue]/1000)]];//毫秒->秒
            label = [[UILabel alloc] initWithFrame:CGRectMake(90, orginY, 200, 35)];
            label.font = [UIFont systemFontOfSize:13];
            label.textColor = ColorLightGray;
            label.text = orderTime;
            [cell.contentView addSubview:label];
            
            orginY = label.deFrameBottom;
            
            lineView = [[UIView alloc] initWithFrame:CGRectMake(10, orginY - .5f, tableView.deFrameWidth - 2*10, .5f)];
            lineView.backgroundColor = ColorLine;
            [cell.contentView addSubview:lineView];
            
            label = [[UILabel alloc] initWithFrame:CGRectMake(15, orginY, 90, 35)];
            label.font = [UIFont systemFontOfSize:14];
            label.textColor = ColorDarkGray;
            label.text = @"消费密码：";
            [cell.contentView addSubview:label];
            
            label = [[UILabel alloc] initWithFrame:CGRectMake(90, orginY, 200, 35)];
            label.font = [UIFont systemFontOfSize:13];
            label.textColor = ColorLightGray;
            label.text = _detailModel.verificationCode;
            [cell.contentView addSubview:label];
            
            orginY = label.deFrameBottom;
            
            lineView = [[UIView alloc] initWithFrame:CGRectMake(10, orginY - .5f, tableView.deFrameWidth - 2*10, .5f)];
            lineView.backgroundColor = ColorLine;
            [cell.contentView addSubview:lineView];
            
            label = [[UILabel alloc] initWithFrame:CGRectMake(15, orginY, 90, 35)];
            label.font = [UIFont systemFontOfSize:14];
            label.textColor = ColorDarkGray;
            label.text = @"数量：";
            [cell.contentView addSubview:label];
            
            label = [[UILabel alloc] initWithFrame:CGRectMake(90, orginY, 200, 35)];
            label.font = [UIFont systemFontOfSize:13];
            label.textColor = ColorLightGray;
            label.text = [_detailModel.quantity stringValue];
            [cell.contentView addSubview:label];
            
            orginY = label.deFrameBottom;
        }
            break;
        default:
            break;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self heightofCell:[self cellTypeByIndex:indexPath.section]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

@end
