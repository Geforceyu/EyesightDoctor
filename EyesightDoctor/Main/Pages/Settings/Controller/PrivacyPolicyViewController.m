//
//  PrivacyPolicyViewController.m
//  LongWebviewScreenshot
//
//  Created by Chonghua Yu on 2018/10/15.
//  Copyright © 2018 geforecyu. All rights reserved.
//

#import "PrivacyPolicyViewController.h"

@interface PrivacyPolicyViewController ()

@end

@implementation PrivacyPolicyViewController

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
    self.title = Local(@"隐私政策");
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:webView];
    
    NSString *webString = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"PrivacyPolicy" ofType:@"txt"] encoding:NSUTF8StringEncoding error:nil];
    [webView loadHTMLString:webString baseURL:nil];
        
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
@end
