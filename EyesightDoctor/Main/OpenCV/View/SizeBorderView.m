//
//  SizeBorderView.m
//  EyesightDoctor
//
//  Created by Chonghua Yu on 2018/9/28.
//  Copyright © 2018年 Chonghua Yu. All rights reserved.
//

#import "SizeBorderView.h"

@implementation SizeBorderView
{
    UILabel *_originLabel;
    UILabel *_widthLabel;
    UILabel *_heightLabel;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.layer.borderWidth = 2;
        self.layer.borderColor = [UIColor redColor].CGColor;
        
        _originLabel = [[UILabel alloc] init];
        _originLabel.textColor = [UIColor redColor];
        [self addSubview:_originLabel];
        
        _widthLabel = [[UILabel alloc] init];
        _widthLabel.textColor = [UIColor redColor];
        [self addSubview:_widthLabel];
        
        _heightLabel = [[UILabel alloc] init];
        _heightLabel.textColor = [UIColor redColor];
        [self addSubview:_heightLabel];
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    _originLabel.frame = CGRectMake(-50, -15, 100, 30);
    _widthLabel.frame = CGRectMake((self.frame.size.width/2.0)-50, 10, 100, 30);
    _heightLabel.frame = CGRectMake(self.frame.size.width+10, self.frame.size.height/2.0, 60, 30);
}
- (void)setInfoWithRect:(CGRect)rect
{
    self.frame = rect;
    _originLabel.text = [NSString stringWithFormat:@"(%.f,%.f)",rect.origin.x,rect.origin.y];
    _widthLabel.text = [NSString stringWithFormat:@"%.f",rect.size.width];
    _heightLabel.text = [NSString stringWithFormat:@"%.f",rect.size.height];
}
@end
