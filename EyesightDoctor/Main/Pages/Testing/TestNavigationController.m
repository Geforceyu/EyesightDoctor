//
//  TestNavigationController.m
//  EyesightDoctor
//
//  Created by Chonghua Yu on 2018/10/18.
//  Copyright © 2018 Chonghua Yu. All rights reserved.
//

#import "TestNavigationController.h"
#import "TestStep_1VC.h"

@interface TestNavigationController ()

@end

@implementation TestNavigationController
{
//    TestStep_1VC *_setp1;
}
- (instancetype)init
{
    TestStep_1VC *_setp1 = [[TestStep_1VC alloc] init];
    self = [super initWithRootViewController:_setp1];
    if (self) {
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUp];
    self.navigationBar.hidden = YES;
    self.interactivePopGestureRecognizer.enabled = NO;
}
- (void)setUp
{
    FAKIonIcons *closeIcon = [FAKIonIcons iosCloseEmptyIconWithSize:40];
    
    UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, GAP20, 40, 40)];
    [closeButton setImage:[closeIcon imageWithSize:CGSizeMake(40, 40)] forState:UIControlStateNormal];
    [self.view addSubview:closeButton];
    [closeButton addTarget:self action:@selector(didClikedCloseButton) forControlEvents:UIControlEventTouchUpInside];
    

}
- (void)didClikedCloseButton
{
    weakify(self)
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:Local(@"提示") message:Local(@"是否退出测试？") preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:Local(@"确定") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:Local(@"取消") style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}
@end
