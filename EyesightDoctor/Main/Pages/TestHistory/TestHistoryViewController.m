//
//  TestHistoryViewController.m
//  EyesightDoctor
//
//  Created by Chonghua Yu on 2018/10/26.
//  Copyright © 2018 Chonghua Yu. All rights reserved.
//

#import "TestHistoryViewController.h"
#import "HistoryTestCell.h"

static NSString * const kHistoryTestCell = @"kHistoryTestCell";

@interface TestHistoryViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation TestHistoryViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self dataFactory];
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setTitle:Local(@"测试历史")];
    [self.view addSubview:self.tableView];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = YES;
}
- (void)dataFactory
{
    _dataSource = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] arrayForKey:kTestHistory]];
}
#pragma mark -<UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HistoryTestCell *cell = [tableView dequeueReusableCellWithIdentifier:kHistoryTestCell];
    cell.info = _dataSource[indexPath.row];
    return cell;
}
#pragma mark -<UITableViewDelegate>
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}

#pragma mark -Getter
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.frame];
//        _tableView.layer.borderWidth = 2;
//        _tableView.layer.borderColor = [UIColor redColor].CGColor;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[HistoryTestCell class] forCellReuseIdentifier:kHistoryTestCell];
    }
    return _tableView;
}
@end
