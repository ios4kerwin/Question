//
//  SZBMOptionCell.h
//  Option
//
//  Created by Kerwin on 16/11/30.
//  Copyright © 2016年 Kerwin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SZBMQuizzesModel.h"

#define kEdgeTopAndBottom   10
#define kEdgeLeftAndRight   10

@interface SZBMOptionCell : UITableViewCell

@property(nonatomic,strong) SZBMQuizzesModel          *model;

+ (instancetype)cellWithTableview:(UITableView *)tableView;

@end
