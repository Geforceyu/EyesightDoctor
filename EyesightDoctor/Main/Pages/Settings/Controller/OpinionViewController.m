//
//  OpinionViewController.m
//  LongWebviewScreenshot
//
//  Created by Chonghua Yu on 2018/10/25.
//  Copyright © 2018 geforecyu. All rights reserved.
//

#import "OpinionViewController.h"
#import "UITextView+JKPlaceHolder.h"
#import "LeanCloudAPI.h"

@interface OpinionViewController ()

@end

@implementation OpinionViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorFromHexString:@"f6f6f6"];

    [self.navigationItem setTitle:Local(@"意见反馈")];
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(20, GAP20+44+20, self.view.width-40, 120)];
    textView.layer.cornerRadius = 5.0;
    textView.clipsToBounds = YES;
    [textView jk_addPlaceHolder:Local(@"我希望得到您的建议")];
    textView.tag = 1;
    textView.backgroundColor = [UIColor whiteColor];
    textView.layer.borderWidth = 1;
    textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [self.view addSubview:textView];
    
    UIButton *commitButton = [[UIButton alloc] initWithFrame:CGRectMake(20, textView.bottom+100, self.view.width-40, 40)];
    [commitButton themeColors];
    commitButton.layer.cornerRadius = 5;
    commitButton.clipsToBounds = YES;
    [commitButton setTitle:Local(@"提交反馈") forState:UIControlStateNormal];
    [commitButton addTarget:self action:@selector(didClikedCommitButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:commitButton];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didClikedCommitButton
{
    UITextView *textView = (UITextView *)[self.view viewWithTag:1];
    [textView endEditing:YES];
    
    NSString *text = [(UITextView *)[self.view viewWithTag:1] text];
    if (text.length<=0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Local(@"提示") message:Local(@"请填写后提交") delegate:nil cancelButtonTitle:Local(@"确定") otherButtonTitles:nil,nil];
        [alert show];
        return;
    }
    
    [self.view showLoadingWithText:nil];
    [[LeanCloudAPI sharedInstance] postOpinion:text completion:^(BOOL success) {
        [self.view dismissHUD];
        if (success) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:Local(@"提示") message:Local(@"提交成功") preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:Local(@"确定") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self.navigationController popViewControllerAnimated:YES];
            }]];
            [self presentViewController:alert animated:YES completion:nil];
        }else{
            [self.view showErrorToast:Local(@"提交失败，请重试")];
        }
    }];
}



@end
