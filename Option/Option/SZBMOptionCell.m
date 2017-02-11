//
//  SZBMOptionCell.m
//  Option
//
//  Created by Kerwin on 16/11/30.
//  Copyright © 2016年 Kerwin. All rights reserved.
//

#import "SZBMOptionCell.h"
#import "SZBMOptionView.h"

@interface SZBMOptionCell ()

@property(nonatomic,strong) SZBMOptionView          *optionView;
@property(nonatomic,strong) UIView                  *lineView;

@end

@implementation SZBMOptionCell


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self addSubview:self.optionView];
}


+ (instancetype)cellWithTableview:(UITableView *)tableView
{
    static NSString *cellId = @"SZBMOptionCell";
    SZBMOptionCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell)
    {
        cell = [[SZBMOptionCell alloc] initWithStyle:UITableViewCellStyleValue1
                                     reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self addSubview:self.optionView];
        [self addSubview:self.lineView];
        self.optionView.textViewWidth = [UIScreen mainScreen].bounds.size.width - 2 * kEdgeLeftAndRight;
        
        self.optionView.frame = CGRectMake(kEdgeLeftAndRight, kEdgeTopAndBottom, [UIScreen mainScreen].bounds.size.width - 2 *kEdgeLeftAndRight, [UIScreen mainScreen].bounds.size.width - 2 * kEdgeTopAndBottom);
    }
    return self;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    self.optionView.frame = CGRectMake(kEdgeLeftAndRight, kEdgeTopAndBottom, self.frame.size.width - 2 *kEdgeLeftAndRight, self.frame.size.height - 2 * kEdgeTopAndBottom);
    self.lineView.frame = CGRectMake(0, self.frame.size.height - 1, self.frame.size.width, 1);
}

- (SZBMOptionView *)optionView
{
    if (!_optionView)
    {
        _optionView = [[SZBMOptionView alloc] init];
    }
    return _optionView;
}

- (UIView *)lineView
{
    if (!_lineView)
    {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = SZBMOptionHexColor(0xf0f0f0, 1);
    }
    return _lineView;
}

- (void)setModel:(SZBMQuizzesModel *)model
{
    _model = model;
    self.optionView.model = model;
    _model.cellHeight = model.conHeight + kEdgeTopAndBottom * 2;
    
}


@end
