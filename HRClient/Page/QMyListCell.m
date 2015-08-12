//
//  QMyListCell.m
//  HRClient
//
//  Created by ekoo on 14/12/11.
//  Copyright (c) 2014年 panyj. All rights reserved.
//

#import "QMyListCell.h"
#import "UIImageView+WebCache.h"
#import "QMyListDetailModel.h"

@interface QMyListCell ()

@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UILabel *totalLabel;
@property (nonatomic,strong)UILabel *timeLabel;
@property (nonatomic,strong)QOrderModel *dataModel;
@end

@implementation QMyListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code

        CGFloat left = 10.0;
        CGFloat topH = 10.0;
        
        self.contentView.backgroundColor = [QTools colorWithRGB:238 :238 :238];
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, topH, self.deFrameWidth, ListCellHeight - topH)];
        bgView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:bgView];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, topH, self.deFrameWidth, .5f)];
        lineView.backgroundColor = ColorLine;
        [self.contentView addSubview:lineView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(left, lineView.deFrameTop, lineView.deFrameWidth, 35)];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:_titleLabel];
        
        _totalLabel = [[UILabel alloc] initWithFrame:CGRectMake(left, lineView.deFrameTop, lineView.deFrameWidth, 35)];
        _totalLabel.font = [UIFont systemFontOfSize:14];
        _totalLabel.textColor = ColorTheme;
        _totalLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_totalLabel];
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(left, _titleLabel.deFrameBottom + 10, _titleLabel.deFrameWidth, 25)];
        _timeLabel.font = [UIFont systemFontOfSize:12];
        _timeLabel.textColor = ColorDarkGray;
        _timeLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_timeLabel];
        
        lineView = [[UIView alloc] initWithFrame:CGRectMake(left, _timeLabel.deFrameBottom + 5, _timeLabel.deFrameWidth - 2*left, .5f)];
        lineView.backgroundColor = ColorLine;
        [self.contentView addSubview:lineView];
        /*
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(self.deFrameWidth - 85 - 15, ListCellHeight - 30, 85, 25)];
        [button setBackgroundImage:[QTools createImageWithColor:ColorTheme] forState:UIControlStateNormal];
        [button setTitle:@"确认订单" forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:16];
        [button addTarget:self action:@selector(onOrder:) forControlEvents:UIControlEventTouchUpInside];
        button.layer.cornerRadius = 2.5f;
        button.layer.masksToBounds = YES;
        [self.contentView addSubview:button];
        */
        //查看订单详情
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(left, ListCellHeight - 35, self.deFrameWidth - 2*left, 35)];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:15];
        label.textAlignment = NSTextAlignmentRight;
        label.textColor = ColorDarkGray;
        label.text = @"查看订单详情>>";
        [self.contentView addSubview:label];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onDetail:)];
        [label addGestureRecognizer:tap];
        
        lineView = [[UIView alloc] initWithFrame:CGRectMake(left, ListCellHeight - .5f, self.deFrameWidth, .5f)];
        lineView.backgroundColor = ColorLine;
        [self.contentView addSubview:lineView];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)configureUIwithDataModel:(QOrderModel*)model
{
    _dataModel = model;
    
    _titleLabel.text = model.subject;
    _totalLabel.text = [NSString stringWithFormat:@"实际结算%.2f元", [model.price doubleValue]];
    
    [_totalLabel sizeToFit];
    _totalLabel.deFrameRight = self.deFrameWidth - 10;
    _totalLabel.deFrameHeight = 35;
    
    _titleLabel.deFrameWidth = self.deFrameWidth - _totalLabel.deFrameLeft;
    
    //购买时间
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *orderTime = [dateFormatter stringFromDate: [NSDate dateWithTimeIntervalSince1970:([model.gmtCreate unsignedLongLongValue]/1000)]];//毫秒->秒
    _timeLabel.text = [NSString stringWithFormat:@"下单时间：%@", orderTime];
    
    _timeLabel.deFrameRight = self.deFrameWidth - 10;
}

- (void)onOrder:(id)sender
{
    
}

- (void)onDetail:(id)sender
{

}

@end
