//
//  HomeViewController.m
//  EyesightDoctor
//
//  Created by Chonghua Yu on 2018/9/25.
//  Copyright © 2018年 Chonghua Yu. All rights reserved.
//

#import "HomeViewController.h"
#import "FaceStreamDetectorViewController.h"
#import "FaceDetechingViewController.h"
#import "ColorBlock.h"
#import "TestedHistoryView.h"
#import "TestNavigationController.h"
#import "UICKeyChainStore.h"
#import "TestHistoryViewController.h"

@interface HomeViewController ()<ColorBlockDelegate,TestedHistoryViewDelegate>

@property (nonatomic, strong) UIButton *startButton;
@property (nonatomic, strong) UILabel *distanceLabel;
@property (nonatomic, strong) UILabel *angleLabel;
@property (nonatomic, strong) ColorBlock *beginTestButton;
@property (nonatomic, strong) TestedHistoryView *historyView;

@end

@implementation HomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
//    self.tabBarController.tabBar.hidden =  YES;
    [self.view addSubview:self.distanceLabel];
    [self.view addSubview:self.angleLabel];
    [self.view addSubview:self.beginTestButton];
    
//    UIView *view = [[UIView alloc] initWithFrame:self.view.bounds];
//    NSMutableArray *transColors = [NSMutableArray array];
//    for (UIColor *color in @[[UIColor colorFromHexString:@"#30848f"],[UIColor colorFromHexString:@"#53b2f7"]]) {
//        [transColors addObject:(__bridge id)color.CGColor];
//    }
//    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
//    gradientLayer.colors = transColors;
//    gradientLayer.startPoint = CGPointMake(0, 1);
//    gradientLayer.endPoint = CGPointMake(1.0, 0);
//    gradientLayer.frame = view.bounds;
//    [view.layer insertSublayer:gradientLayer atIndex:0];
//    view.backgroundColor = [UIColor skyBlueColor];
////
//    UIImageView *eye = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
//    eye.center = CGPointMake(view.width/2.0, view.height/2.0);
//    eye.image = [UIImage imageNamed:@"gameboy"];
//    [view addSubview:eye];
//
//    [self.view addSubview:view];

//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, eye.bottom+30, self.view.width, 60)];
//    label.textAlignment = NSTextAlignmentCenter;
//    label.font = [UIFont fontWithName:@"Zapfino" size:30];
//    label.textColor = [UIColor whiteColor];
//    label.text = @"Eye Testing";
//    [view addSubview:label];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (_historyView) {
        [_historyView removeFromSuperview];
        _historyView = nil;
    }
    [self.view addSubview:self.historyView];
    
}
//- (BOOL)prefersStatusBarHidden
//{
//    return YES;
//}
#pragma mark -<TestedHistoryViewDelegate>
- (void)historyViewDidClikedMoreButton
{
    TestHistoryViewController *controller = [[TestHistoryViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}
#pragma mark -<ColorBlockDelegate>
- (void)colorBlockDidClikedStartButton
{
    UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithService:@"com.eyesighDoctor.geforceyu"];
    BOOL unLocked = [[keychain stringForKey:kIsUnLock] integerValue]==1;
    NSInteger useCount = [[keychain stringForKey:kTestedTimes] integerValue];

    if (unLocked || useCount<3) {
        TestNavigationController *vc = [[TestNavigationController alloc] init];
        [self presentViewController:vc animated:YES completion:nil];
    }else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:Local(@"提示") message:Local(@"免费测试次数已用完，是否购买解锁次数限制") preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:Local(@"购买") style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:Local(@"取消") style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];

    }

//    FaceStreamDetectorViewController *controller = [[FaceStreamDetectorViewController alloc] init];
//    [self presentViewController:controller animated:YES completion:nil];
    
    //    FaceDetechingViewController *controller = [[FaceDetechingViewController alloc] init];
    //    [self presentViewController:controller animated:YES completion:nil];
}

#pragma mark -Getter
- (UILabel *)distanceLabel
{
    if (!_distanceLabel) {
        _distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, self.startButton.bottom+20, self.view.width-20, 80)];
        _distanceLabel.numberOfLines = 0;
        _distanceLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _distanceLabel.textColor = [UIColor blackColor];
        _distanceLabel.font = [UIFont lightFontWithSize:15];
        _distanceLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _distanceLabel;
}
- (UILabel *)angleLabel
{
    if (!_angleLabel) {
        _angleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, self.distanceLabel.bottom+20, self.view.width-20, 30)];
        _angleLabel.textColor = [UIColor blackColor];
        _angleLabel.font = [UIFont lightFontWithSize:23];
        _angleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _angleLabel;
}
- (ColorBlock *)beginTestButton
{
    if (!_beginTestButton) {
        _beginTestButton = [[ColorBlock alloc] initWithFrame:CGRectMake(15, 80, self.view.width-30, 200) Title:Local(@"视力测试") colors:@[[UIColor colorFromHexString:@"#30848f"],[UIColor colorFromHexString:@"#53b2f7"]]];
        _beginTestButton.delegate = self;
    }
    return _beginTestButton;
}
- (TestedHistoryView *)historyView
{
    if (!_historyView) {
        _historyView = [[TestedHistoryView alloc] initWithFrame:CGRectMake(10, self.beginTestButton.bottom+30, self.view.width-20, self.view.height-44-10-self.beginTestButton.bottom-30)];
        _historyView.delegate = self;
    }
    return _historyView;
}
@end
