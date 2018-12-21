//
//  EView.m
//  EyesightDoctor
//
//  Created by Chonghua Yu on 2018/10/16.
//  Copyright © 2018 Chonghua Yu. All rights reserved.
//

#import "EView.h"

const static CGFloat width = 3.8;

@implementation EView

- (instancetype)init
{
    self = [super initWithFrame:CGRectMake(0, 0, width*5, width*5)];
    if (self) {
        [self setUp];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, width*5, width*5)];
    if (self) {
        //0.438mm
        //3倍 1.314
        //139.7mm 2202.91px
       //68.49mm 1080
        [self setUp];
    }
    return self;
}
- (void)setUp
{
    _direction = UISwipeGestureRecognizerDirectionRight;
    _scale = 1;
    self.layer.anchorPoint = CGPointMake(0.5, 0.5);
    
    EViewStro *hen1 = [[EViewStro alloc] initWithFrame:CGRectMake(0, 0, 5*width, width)];
    EViewStro *hen2 = [[EViewStro alloc] initWithFrame:CGRectMake(0, 2*width, 5*width, width)];
    EViewStro *hen3 = [[EViewStro alloc] initWithFrame:CGRectMake(0, self.height-width, 5*width, width)];
    EViewStro *ver  = [[EViewStro alloc] initWithFrame:CGRectMake(0, 0, width, 5*width)];
    
    [self addSubview:hen1];
    [self addSubview:hen2];
    [self addSubview:hen3];
    [self addSubview:ver];
}
- (void)setScale:(float)scale andDirection:(UISwipeGestureRecognizerDirection)direction
{
    self.transform = CGAffineTransformIdentity;
    if (direction==UISwipeGestureRecognizerDirectionUp) {
        self.transform = CGAffineTransformMakeRotation(-M_PI_2);
    }else if (direction==UISwipeGestureRecognizerDirectionDown){
        self.transform = CGAffineTransformMakeRotation(M_PI_2);
    }else if (direction==UISwipeGestureRecognizerDirectionLeft){
        self.transform = CGAffineTransformMakeRotation(M_PI);
    }
    self.transform = CGAffineTransformScale(self.transform, scale, scale);
    _scale = scale;
    _direction = direction;
}
@end

@implementation EViewStro

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setUp];
    }
    return self;
}
- (void)setUp
{
    self.backgroundColor = [UIColor blackColor];
}
@end
