//
//  QMyListCell.h
//  HRClient
//
//  Created by ekoo on 14/12/11.
//  Copyright (c) 2014年 panyj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QDataModel.h"

#define ListCellHeight      (120)

@class QMyListCell;

@protocol QMyListCellDelegate <NSObject>
@optional

- (void)didSelectOrder:(QOrderModel*)model;

@end
@interface QMyListCell : UITableViewCell
{
}

@property (nonatomic, weak) id<QMyListCellDelegate> delegate;

- (void)configureUIwithDataModel:(QOrderModel*)model;

@end
