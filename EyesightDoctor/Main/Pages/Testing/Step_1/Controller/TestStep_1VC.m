//
//  TestStep_1VC.m
//  EyesightDoctor
//
//  Created by Chonghua Yu on 2018/10/15.
//  Copyright © 2018 Chonghua Yu. All rights reserved.
//

#import "TestStep_1VC.h"
#import "TestStep_2VC.h"
#import "SignView.h"
#import "Detecher.h"

@interface TestStep_1VC ()<DetecherDelegate>

@property (nonatomic, strong) Detecher *detecher;
@property (nonatomic, strong) SignView *signView;
@property (nonatomic, strong) UIView *videoView;
@end

@implementation TestStep_1VC

- (void)dealloc
{
    [_detecher stop];
    _detecher = nil;
}
- (void)stop
{
    [self.detecher stop];
    self.detecher = nil;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _videoView = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_signView];
    
    self.detecher = [[Detecher alloc] init];
    self.detecher.delegate = self;
    
    _signView = [[SignView alloc] initWithFrame:CGRectMake(20, 100, self.view.width-40, 0)];
    
    UIView *maskView = [[UIView alloc] initWithFrame:self.view.bounds];
    maskView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:maskView];
    [maskView addSubview:_signView];
    
    UIButton *nextButton = [[UIButton alloc] initWithFrame:CGRectMake((self.view.width-200)/2.0, self.view.height-100, 200, 50)];
    nextButton.clipsToBounds = YES;
    nextButton.layer.cornerRadius = 8;
    [nextButton themeColors];
    [nextButton setTitle:Local(@"继续") forState:UIControlStateNormal];
    [nextButton addTarget:self action:@selector(didClikedNextButton) forControlEvents:UIControlEventTouchUpInside];
    [maskView addSubview:nextButton];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.detecher startDetecherWithView:self.videoView];
    [self.videoView sendSubviewToBack:self.videoView];
}
#pragma mark -Action
- (void)didClikedNextButton
{
    [self.detecher stop];
    TestStep_2VC *vc = [[TestStep_2VC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark -<DetecherDelegate>
- (void)didnotDetechFace
{
//    NSLog(@"未检测到人脸");
    weakify(self)
    dispatch_async(dispatch_get_main_queue(), ^{
        strongify(self)
        [self.signView setInfo:Local(@"未检测到人脸")];
    });
}
- (void)didDetechMultiFace
{
//    NSLog(@"检测到多个人脸");
}
- (void)didDetechFaceRect:(CGRect)rect
{
    CGFloat width = rect.size.width;
//    NSLog(@"检测到人脸宽度 %.2f",width);
    weakify(self)
    dispatch_async(dispatch_get_main_queue(), ^{
        strongify(self)
        if (width>400) {
            [self.signView setDistanceRate:1];
        }else if (width>300){
            [self.signView setDistanceRate:2];
        }else if (width>250){
            [self.signView setDistanceRate:3];
        }else{
            [self.signView setDistanceRate:4];
        }
    });

}
- (void)didDetechHasGlasses:(BOOL)has
{
//    NSLog(@"检测到眼镜:%@",has?@"有":@"无");
}
- (void)didDetechLeftEyeState:(int)state
{
//    NSLog(@"左眼:%@",state==0?@"闭着":@"睁着");
}
- (void)didDetechRightEyeState:(int)state
{
//    NSLog(@"右眼:%@",state==0?@"闭着":@"睁着");
}
- (void)didDetechNoseRect:(CGRect)rect
{
    
}
@end
