//
//  FaceDetechingViewController.m
//  EyesightDoctor
//
//  Created by Chonghua Yu on 2018/9/27.
//  Copyright © 2018年 Chonghua Yu. All rights reserved.
//

#import "FaceDetechingViewController.h"
#import "Detecher.h"
#import "SizeBorderView.h"

@interface FaceDetechingViewController ()<DetecherDelegate>

@property (nonatomic, strong) Detecher *detecher;
@property (nonatomic, strong) SizeBorderView *faceBorderView;
@property (nonatomic, strong) SizeBorderView *noseBorderView;
@property (nonatomic, strong) UILabel *glassesLabel;
@property (nonatomic, strong) UILabel *leftEyeLabel;
@property (nonatomic, strong) UILabel *rightEyeLabel;
@end

@implementation FaceDetechingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.detecher = [Detecher new];
    self.detecher.delegate = self;
    [self.detecher startDetecherWithView:self.view];

    self.faceBorderView = [[SizeBorderView alloc] init];
    self.faceBorderView.hidden = YES;
    [self.view addSubview:self.faceBorderView];
    
    self.noseBorderView = [[SizeBorderView alloc] init];
    self.noseBorderView.hidden = YES;
    [self.view addSubview:self.noseBorderView];
    
    _glassesLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetHeight(self.view.frame)-44, 120, 25)];
    
    _leftEyeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_glassesLabel.frame)+10, CGRectGetHeight(self.view.frame)-44, 100, 25)];
    
    _rightEyeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_leftEyeLabel.frame)+10, CGRectGetHeight(self.view.frame)-44, 100, 25)];
    
    _glassesLabel.textColor = _leftEyeLabel.textColor = _rightEyeLabel.textColor = [UIColor redColor];
    _glassesLabel.font = _leftEyeLabel.font = _rightEyeLabel.font = [UIFont systemFontOfSize:13];
    
    [self.view addSubview:_glassesLabel];
    [self.view addSubview:_leftEyeLabel];
    [self.view addSubview:_rightEyeLabel];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}
#pragma mark -<DetecherDelegate>
- (void)didnotDetechFace
{
    NSLog(@"未检测到人脸");
    dispatch_async(dispatch_get_main_queue(), ^{
        self.faceBorderView.hidden = YES;
        self.noseBorderView.hidden = YES;
    });
}
- (void)didDetechMultiFace
{
    NSLog(@"检测到多个人脸");
}
- (void)didDetechFaceRect:(CGRect)rect
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.faceBorderView.hidden = NO;
        [self.faceBorderView setInfoWithRect:rect];
    });
    NSLog(@"检测到人脸区域%@",NSStringFromCGRect(rect));
}
- (void)didDetechHasGlasses:(BOOL)has
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.glassesLabel.text = [NSString stringWithFormat:@"检测到眼镜:%@",has?@"有":@"无"];
    });
}
- (void)didDetechLeftEyeState:(int)state
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.leftEyeLabel.text = [NSString stringWithFormat:@"左眼:%@",state==0?@"闭着":@"睁着"];
    });
}
- (void)didDetechRightEyeState:(int)state
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.rightEyeLabel.text = [NSString stringWithFormat:@"右眼:%@",state==0?@"闭着":@"睁着"];
    });
}
- (void)didDetechNoseRect:(CGRect)rect
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.noseBorderView.hidden = NO;
        [self.noseBorderView setInfoWithRect:rect];
    });

}
@end
