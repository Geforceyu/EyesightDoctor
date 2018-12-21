//
//  TestResultsViewController.m
//  EyesightDoctor
//
//  Created by Chonghua Yu on 2018/10/19.
//  Copyright © 2018 Chonghua Yu. All rights reserved.
//

#import "TestResultsViewController.h"
#import "UICountingLabel.h"
#import "UICKeyChainStore.h"

@interface TestResultsViewController ()

@property (nonatomic, strong) UILabel *scoreTitle;
@property (nonatomic, strong) UICountingLabel *scoreLabel;
@property (nonatomic, strong) UILabel *infoLabel;

@end

@implementation TestResultsViewController
{
    NSInteger _score;
}
- (instancetype)initWithResults:(id)results
{
    self = [super init];
    if (self) {
        CGFloat theBest = 1;
        for (NSDictionary *dict in results) {
            if ([dict[@"scale"] floatValue]<theBest&&[dict[@"isCorrect"] boolValue]) {
                theBest = [dict[@"scale"] floatValue];
            }
        }
        _score = (1 - theBest) * 100;
        [self saveScore];
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.scoreTitle];
    [self.view addSubview:self.scoreLabel];
    [self.view addSubview:self.infoLabel];
    
    UIButton *nextButton = [[UIButton alloc] initWithFrame:CGRectMake((self.view.width-200)/2.0, self.view.height-100, 200, 50)];
    nextButton.clipsToBounds = YES;
    nextButton.layer.cornerRadius = 8;
    [nextButton themeColors];
    [nextButton setTitle:Local(@"完成") forState:UIControlStateNormal];
    [nextButton addTarget:self action:@selector(didClikedCompleteButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextButton];
    
    NSString *info = nil;
    if (_score>90) {
        info = Local(@"您的视力很棒哦，请继续保持~");
    }else if (_score>80){
        info = Local(@"您的视力还不错哦，请继续保持~");
    }else if (_score>70){
        info = Local(@"您的视力一般般哦，请注意用眼~");
    }else if (_score>60){
        info = Local(@"您有些近视哦，请注意用眼~");
    }else if (_score>50){
        info = Local(@"您的近视有些严重了，请注意用眼");
    }else{
        info = Local(@"您的眼镜厚度不薄了吧~");
    }
    weakify(self)
    [self.scoreLabel setCompletionBlock:^{
        strongify(self)
        self.infoLabel.text = info;
    }];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.scoreLabel countFrom:100 to:_score];
}
- (void)saveScore
{
    NSMutableArray *list = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] arrayForKey:kTestHistory]];
    [list addObject:@{@"timeStamp":@([[NSDate date] timeIntervalSince1970]),@"score":@(_score)}];
    [[NSUserDefaults standardUserDefaults] setObject:list forKey:kTestHistory];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithService:@"com.eyesighDoctor.geforceyu"];
    [keychain setString:[NSString stringWithFormat:@"%lu",(unsigned long)list.count] forKey:kTestedTimes];

}
#pragma mark -Action
- (void)didClikedCompleteButton
{
    [self.presentingViewController.presentingViewController dismissViewControllerAnimated:NO completion:nil];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark -Getter
- (UILabel *)scoreTitle
{
    if (!_scoreLabel) {
        _scoreTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.height/3.0, self.view.width, 40)];
        _scoreTitle.font = [UIFont lightFontWithSize:39];
        _scoreTitle.text = Local(@"评分");
        _scoreTitle.textAlignment = NSTextAlignmentCenter;
    }
    return _scoreTitle;
}
- (UICountingLabel *)scoreLabel
{
    if (!_scoreLabel) {
        _scoreLabel = [[UICountingLabel alloc] initWithFrame:CGRectMake(0, self.scoreTitle.bottom+35, self.view.width, 71)];
        _scoreLabel.font = [UIFont lightFontWithSize:70];
        _scoreLabel.textAlignment = NSTextAlignmentCenter;
        _scoreLabel.textColor = [UIColor goldenrodColor];
        _scoreLabel.format = @"%.f";
    }
    return _scoreLabel;
}
- (UILabel *)infoLabel
{
    if (!_infoLabel) {
        _infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, self.scoreLabel.bottom+40, self.view.width-40, 30)];
        _infoLabel.font = [UIFont lightFontWithSize:25];
        _infoLabel.textColor = [UIColor colorFromHexString:@"#30848f"];
        _infoLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _infoLabel;
}
@end
