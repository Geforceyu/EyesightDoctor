//
//  HistoryTestCell.m
//  EyesightDoctor
//
//  Created by Chonghua Yu on 2018/10/26.
//  Copyright © 2018 Chonghua Yu. All rights reserved.
//

#import "HistoryTestCell.h"

@implementation HistoryTestCell
{
    UIView *_bgView;
    UILabel *_scoreLabel;
    UILabel *_dateLabel;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUp];
    }
    return self;
}
- (void)setUp
{
    _bgView = [[UIView alloc] init];
    _bgView.layer.cornerRadius = 5;
    _bgView.clipsToBounds = YES;
    [self addSubview:_bgView];
    
    _scoreLabel = [[UILabel alloc] init];
    _scoreLabel.font = [UIFont lightFontWithSize:29];
    _scoreLabel.textAlignment = NSTextAlignmentLeft;
    _scoreLabel.textColor = [UIColor whiteColor];
    [_bgView addSubview:_scoreLabel];
    
    _dateLabel = [[UILabel alloc] init];
    _dateLabel.font = [UIFont lightFontWithSize:15];
    _dateLabel.textColor = [UIColor whiteColor];
    [_bgView addSubview:_dateLabel];
}
- (void)setInfo:(NSDictionary *)info
{
    _info = info;
    NSTimeInterval timeStamp = [info[@"timeStamp"] doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeStamp];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy.MM.dd HH:mm"];
    
    _scoreLabel.text = [NSString stringWithFormat:@"%@:%@",Local(@"评分"),[NSString stringWithFormat:@"%@",info[@"score"]]];
    _dateLabel.text = [formatter stringFromDate:date];
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    _bgView.frame = CGRectMake(20, 10, self.width-40, self.height-20);
    _scoreLabel.frame = CGRectMake(10, 20, _bgView.width-20, 30);
    _dateLabel.frame = CGRectMake(_bgView.width-10-120, _bgView.height-10-16, 120, 16);
    [_bgView themeColors];
}

@end
