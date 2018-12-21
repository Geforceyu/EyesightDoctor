//
//  SignView.m
//  EyesightDoctor
//
//  Created by Chonghua Yu on 2018/10/15.
//  Copyright © 2018 Chonghua Yu. All rights reserved.
//

#import "SignView.h"

@implementation SignView
{
    UIImageView *_leftImageView;
    UIImageView *_rightImageView;
    UILabel *_infoLabel;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    CGFloat width = frame.size.width;
    CGFloat height = width/3.0/1115.0*1525.0;
    self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, width, height)];
    if (self) {
        
        CGFloat imageViewWidth = width/3.0;
        
        _leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,imageViewWidth, height)];
        [self addSubview:_leftImageView];
        

        _rightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(width-imageViewWidth, 0, imageViewWidth, height)];
        _rightImageView.layer.anchorPoint = CGPointMake(0.5, 0.5);
        _rightImageView.transform = CGAffineTransformMakeRotation(M_PI);
        [self addSubview:_rightImageView];
        
        UIImageView *face = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        face.image = [UIImage imageNamed:@"face.png"];
        face.center = CGPointMake(width/2.0, height/2.0);
        [self addSubview:face];
        
        _infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, imageViewWidth*2.0, 30)];
        _infoLabel.center = CGPointMake(width/2.0, height-10);
        _infoLabel.textAlignment = NSTextAlignmentCenter;
        _infoLabel.font = [UIFont blodFontWithSize:26];
        _infoLabel.textColor = [UIColor colorFromHexString:@"#30848f"];
        _infoLabel.text = Local(@"请保持合适距离");
        [self addSubview:_infoLabel];
    }
    return self;
}
- (void)setDistanceRate:(NSInteger)distanceRate
{
    _distanceRate = distanceRate;
    NSString *imageNamed = nil;
    NSString *info = nil;
    switch (distanceRate) {
        case 1:
            imageNamed = @"sign_4";
            info = Local(@"太近了！");
            break;
        case 2:
            imageNamed = @"sign_3";
            info = Local(@"离远一点点");
            break;
        case 3:
            imageNamed = @"sign_2";
            info = @"OK";
            break;
        case 4:
            imageNamed = @"sign_1";
            info = Local(@"靠近一点点");
            break;
        default:
            break;
    }
    _infoLabel.text = info;
    _leftImageView.image = _rightImageView.image = [UIImage imageNamed:imageNamed];
}
- (void)setInfo:(NSString *)info
{
    _info = info;
    _infoLabel.text = info;
}
@end
