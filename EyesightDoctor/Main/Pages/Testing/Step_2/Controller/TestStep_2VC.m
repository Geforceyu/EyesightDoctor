//
//  TestStep_2VC.m
//  EyesightDoctor
//
//  Created by Chonghua Yu on 2018/10/16.
//  Copyright © 2018 Chonghua Yu. All rights reserved.
//

#import "TestStep_2VC.h"
#import "EView.h"
#import "TestResultsViewController.h"

@interface TestStep_2VC ()

@property (nonatomic, strong)EView *eview;
@property (nonatomic, strong)UILabel *currentIndex;

@end

@implementation TestStep_2VC
{
    NSMutableArray *_testResults;
    NSInteger _index;
    float _scale;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        _testResults = [NSMutableArray array];
        _index = 1;
        _scale = 1;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel *tip = [[UILabel alloc] initWithFrame:CGRectMake(0, GAP20+60, self.view.width, 50)];
    tip.text = Local(@"请往 E 开口方向滑动");
    tip.textAlignment = NSTextAlignmentCenter;
    tip.font = [UIFont lightFontWithSize:39];
    tip.adjustsFontSizeToFitWidth = YES;
    [tip setMinimumScaleFactor:0.675];
    [self.view addSubview:tip];
    
    _currentIndex = [[UILabel alloc] initWithFrame:CGRectMake(0, tip.bottom+30, self.view.width, 80)];
    _currentIndex.textAlignment = NSTextAlignmentCenter;
    _currentIndex.text = @"1";
    _currentIndex.font = [UIFont boldSystemFontOfSize:79];
    _currentIndex.textColor = [UIColor colorFromHexString:@"#30848f"];
    [self.view addSubview:_currentIndex];
    
    _eview = [[EView alloc] init];
    _eview.center = CGPointMake(self.view.width/2.0, self.view.height/2.0+60);
    [self.view addSubview:_eview];
    
    UISwipeGestureRecognizer *upGes = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipe:)];
    upGes.direction = UISwipeGestureRecognizerDirectionUp;
    
    UISwipeGestureRecognizer *downGes = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipe:)];
    downGes.direction = UISwipeGestureRecognizerDirectionDown;
    
    UISwipeGestureRecognizer *leftGes = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipe:)];
    leftGes.direction = UISwipeGestureRecognizerDirectionLeft;
    
    UISwipeGestureRecognizer *rightGes = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipe:)];
    rightGes.direction = UISwipeGestureRecognizerDirectionRight;
    
    [self.view addGestureRecognizer:upGes];
    [self.view addGestureRecognizer:downGes];
    [self.view addGestureRecognizer:leftGes];
    [self.view addGestureRecognizer:rightGes];
    
    UIButton *cantSee = [[UIButton alloc] initWithFrame:CGRectMake(0, self.view.height-90, self.view.width, 90)];
    [cantSee setTitle:Local(@"看不清楚") forState:UIControlStateNormal];
    cantSee.titleLabel.font = [UIFont blodFontWithSize:30];
    [cantSee setColors:@[[UIColor easterPinkColor],[UIColor grapefruitColor]]];
    [self.view addSubview:cantSee];
    [cantSee addTarget:self action:@selector(didClikeCantSeeButton) forControlEvents:UIControlEventTouchUpInside];
    
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self indexLabelAnimation];
}
- (void)didSwipe:(UISwipeGestureRecognizer *)gesture
{
    if (gesture.state==UIGestureRecognizerStateEnded) {
        NSMutableDictionary *test = [NSMutableDictionary dictionary];
        test[@"index"] = @(_index);
        test[@"scale"] = @(_scale);
        [_testResults addObject:test];
        
        if (gesture.direction==_eview.direction) {
            if (_scale-0.05>=0.05) {
                _scale-=0.05;
            }else{
                [self gotoResults];
                return;
            }
            test[@"isCorrect"] = @(YES);
        }else{
            if (_scale+0.05<=1.0) {
                _scale+=0.05;
            }else{
                [self gotoResults];
                return;
            }
            test[@"isCorrect"] = @(NO);
        }

        [self nextEview];
    }
}
- (void)gotoResults
{
    TestResultsViewController *results = [[TestResultsViewController alloc] initWithResults:_testResults];
    [self presentViewController:results animated:YES completion:nil];
}
- (void)nextEview
{
    if (_testResults.count>=20) {
        [self gotoResults];
        return;
    }
//    _scale = [self getRandomScale];
    
    [_eview setScale:_scale andDirection:[self getRandomDirection]];
    _index ++;
    _currentIndex.text = [NSString stringWithFormat:@"%ld",(long)_index];
    [self indexLabelAnimation];
}

- (float)getRandomScale
{
    int i = [self getRandomNumber:1 to:10];
    float scale = i/10.0;
    scale = [[NSString stringWithFormat:@"%.1f",scale] floatValue];
    return scale;
}
- (UISwipeGestureRecognizerDirection)getRandomDirection
{
    NSInteger i = [self getRandomNumber:0 to:3];
    UISwipeGestureRecognizerDirection direction = UISwipeGestureRecognizerDirectionUp;
    switch (i) {
        case 0:
            direction = UISwipeGestureRecognizerDirectionUp;
            break;
        case 1:
            direction = UISwipeGestureRecognizerDirectionDown;
            break;
        case 2:
            direction = UISwipeGestureRecognizerDirectionLeft;
            break;
        case 3:
            direction = UISwipeGestureRecognizerDirectionRight;
            break;
        default:
            break;
    }
    return direction;
}
- (int)getRandomNumber:(int)from to:(int)to
{
    return (int)(from + (arc4random() % (to - from + 1)));
}
- (void)indexLabelAnimation
{
    self.currentIndex.transform = CGAffineTransformMakeScale(0.7, 0.7);
    weakify(self)
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.3 initialSpringVelocity:0.3 options:0 animations:^{
        strongify(self)
        self.currentIndex.transform = CGAffineTransformMakeScale(1, 1);
    } completion:^(BOOL finished) {
    
    }];
}
- (void)didClikeCantSeeButton
{
    [_testResults addObject:@{@"isCorrect":@(NO),@"index":@(_index),@"scale":@(_scale)}];
    [self nextEview];
}
@end
