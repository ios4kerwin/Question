//
//  ViewController.m
//  Option
//
//  Created by Kerwin on 16/11/30.
//  Copyright © 2016年 Kerwin. All rights reserved.
//

#import "ViewController.h"
#import "SZBMOptionCell.h"

@interface ViewController ()
<
   UITableViewDelegate,
   UITableViewDataSource
>

@property(nonatomic,strong) UITableView          *tableView;
@property(nonatomic,strong) NSMutableArray       *dataSource;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    [self.view addSubview:self.tableView];
    
    for (NSInteger i = 0; i < 1000; i++)
    {
        [self.dataSource addObject:[SZBMQuizzesModel testModel]];
    }
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SZBMQuizzesModel *model = self.dataSource[indexPath.row];
    SZBMOptionCell *cell = [SZBMOptionCell cellWithTableview:tableView];
    cell.model = model;
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SZBMQuizzesModel *model = self.dataSource[indexPath.row];
    return model.cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView  = [[UITableView alloc] init];
        _tableView.frame = CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 20);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 275;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[SZBMOptionCell class] forCellReuseIdentifier:@"SZBMOptionCell"];
        _tableView.allowsSelection = NO;

    }
    return _tableView;
}

- (NSMutableArray *)dataSource
{
    if (!_dataSource)
    {
        _dataSource = [NSMutableArray arrayWithCapacity:2];
    }
    return _dataSource;
}

@end
