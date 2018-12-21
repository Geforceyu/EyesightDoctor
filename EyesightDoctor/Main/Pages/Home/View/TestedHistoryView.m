//
//  TestedHistoryView.m
//  EyesightDoctor
//
//  Created by Chonghua Yu on 2018/10/12.
//  Copyright © 2018 Chonghua Yu. All rights reserved.
//

#import "TestedHistoryView.h"
#import "PNChart.h"

@interface TestedHistoryView ()

@property (nonatomic, strong) UILabel *historyLabel;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *xLabels;
@property (nonatomic, strong) NSMutableArray *scoresData;
@property (nonatomic, strong) PNLineChart *lineChart;
@property (nonatomic, strong) UILabel *emptyLabel;
@property (nonatomic, strong) UIButton *moreButton;
@end

@implementation TestedHistoryView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _dataSource = [NSMutableArray array];
        _xLabels = [NSMutableArray array];
        _scoresData = [NSMutableArray array];
        [self queryData];
        [self setUp];
    }
    return self;
}
- (void)queryData
{
    NSArray *list = [[NSUserDefaults standardUserDefaults] arrayForKey:kTestHistory];
    NSInteger start = 0;
    if (list.count>6) start=list.count-6;
    for (NSInteger i=start; i<list.count;i++) {
        [_dataSource addObject:list[i]];
    }

    for (NSDictionary *item in _dataSource) {
        NSTimeInterval timeStamp = [item[@"timeStamp"] doubleValue];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeStamp];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MM.dd"];
        [_xLabels addObject:[formatter stringFromDate:date]];
        [_scoresData addObject:item[@"score"]];
    }
}
- (void)setUp
{
    [self addSubview:self.historyLabel];
    [self addSubview:self.moreButton];
    [self addSubview:self.emptyLabel];
    [self addSubview:self.lineChart];
    if (_dataSource&&_dataSource.count>0) {
        _emptyLabel.hidden = YES;
        _moreButton.hidden = NO;
        _lineChart.hidden = NO;
        [_lineChart setXLabels:_xLabels];
        _lineChart.chartData = @[[self getNewChartData]];
        [_lineChart strokeChart];
    }else{
        _moreButton.hidden = YES;
        _emptyLabel.hidden = NO;
        _lineChart.hidden = YES;
    }
}

- (PNLineChartData *)getNewChartData
{
    PNLineChartData *charData = [PNLineChartData new];
    charData.color = PNFreshGreen;
    charData.itemCount = _scoresData.count;
    charData.inflexionPointStyle = PNLineChartPointStyleCircle;
    charData.showPointLabel = YES;
    charData.pointLabelFont = [UIFont systemFontOfSize:12];
    weakify(self)
    charData.getData = ^(NSUInteger index) {
        strongify(self)
        CGFloat yValue = [self.scoresData[index] floatValue];
        return [PNLineChartDataItem dataItemWithY:yValue];
    };
    return charData;
}
- (void)didClikedMoreButton
{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(historyViewDidClikedMoreButton)]) {
        [self.delegate historyViewDidClikedMoreButton];
    }
}
#pragma mark -Getter
- (UILabel *)historyLabel
{
    if (!_historyLabel) {
        _historyLabel = [[UILabel alloc] initWithFrame:CGRectMake(20,0, self.width-30, 30)];
        _historyLabel.text = Local(@"历史检测");
        _historyLabel.font = [UIFont blodFontWithSize:29];
        _historyLabel.textColor = [UIColor blackColor];
        _historyLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _historyLabel;
}
- (UIButton *)moreButton
{
    if (!_moreButton) {
        _moreButton = [[UIButton alloc] initWithFrame:CGRectMake(self.width-10-80, self.historyLabel.top+8, 80, 21)];
        [_moreButton setTitle:Local(@"更多") forState:UIControlStateNormal];
        [_moreButton addTarget:self action:@selector(didClikedMoreButton) forControlEvents:UIControlEventTouchUpInside];
        [_moreButton setTitleColor:[UIColor colorFromHexString:@"30848f"] forState:UIControlStateNormal];
    }
    return _moreButton;
}
- (UILabel *)emptyLabel
{
    if (!_emptyLabel) {
        _emptyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width, 30)];
        _emptyLabel.center = CGPointMake(self.width/2.0, self.height/2.0);
        _emptyLabel.text = Local(@"无数据");
        _emptyLabel.font = [UIFont blodFontWithSize:29];
        _emptyLabel.textAlignment = NSTextAlignmentCenter;
        _emptyLabel.textColor = [UIColor colorFromHexString:@"#8e8e93"];
    }
    return _emptyLabel;
}
- (PNLineChart *)lineChart
{
    if (!_lineChart) {
        _lineChart = [[PNLineChart alloc] initWithFrame:CGRectMake(20, self.historyLabel.bottom+20, self.width-40, self.height-self.historyLabel.bottom-40)];
//        [_lineChart setYLabels:@[@"0",@"10",@"20",@"30",@"50",@"60",@"70",@"80",@"90",@"100"]];
        _lineChart.yFixedValueMax = 100;
        _lineChart.yFixedValueMin = 0;
        _lineChart.showSmoothLines = YES;
        _lineChart.showCoordinateAxis = YES;
    }
    return _lineChart;
}
@end
