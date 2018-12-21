//
//  ColorBlock.m
//  EyesightDoctor
//
//  Created by Chonghua Yu on 2018/10/12.
//  Copyright © 2018 Chonghua Yu. All rights reserved.
//

#import "ColorBlock.h"
#import "UICKeyChainStore.h"

@implementation ColorBlock

- (instancetype)initWithFrame:(CGRect)frame Title:(NSString *)title colors:(NSArray *)colors
{
    self = [super initWithFrame:frame];
    if (self) {
        
        FAKIcon *eyeIcon = [FAKIonIcons iosEyeOutlineIconWithSize:60];
        [eyeIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
        
        UIImageView *logo = [[UIImageView alloc] initWithFrame:CGRectMake(self.width-40-60, 22, 60, 60)];
        logo.image = [eyeIcon imageWithSize:CGSizeMake(60, 60)];
        [self addSubview:logo];
        
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, logo.bottom+10, self.width-60, 30)];
        titleLabel.font = [UIFont systemFontOfSize:29];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.text = title;
        [self addSubview:titleLabel];
        
        UIButton *startButton = [[UIButton alloc] initWithFrame:CGRectMake(titleLabel.left, titleLabel.bottom+15, 100, 44)];
        startButton.layer.cornerRadius = 5.0;
        startButton.clipsToBounds = YES;
        [startButton setTitle:Local(@"开始") forState:UIControlStateNormal];
        [startButton setTitleColor:[UIColor colorFromHexString:@"#5eadb2"] forState:UIControlStateNormal];
        [startButton setBackgroundColor:[UIColor whiteColor]];
        [startButton addTarget:self action:@selector(didClikedStartButton) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:startButton];
        
        UILabel *freeCount = [[UILabel alloc] initWithFrame:CGRectMake(self.width-130-20, self.height-24, 130, 24)];
        freeCount.font = [UIFont systemFontOfSize:12];
        freeCount.textAlignment = NSTextAlignmentRight;
        freeCount.textColor = [UIColor whiteColor];
        
        NSString *freeText = nil;
        UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithService:@"com.eyesighDoctor.geforceyu"];
        BOOL unLocked = [[keychain stringForKey:kIsUnLock] integerValue]==1;
        if (!unLocked) {
            NSInteger useCount = [[keychain stringForKey:kTestedTimes] integerValue];
            freeText = [NSString stringWithFormat:@"%@: %ld",Local(@"剩余免费测试次数"),APP_FREE_TESTCOUNT-useCount];
        }else{
            freeText = Local(@"已解锁");
        }
        freeCount.text = freeText;
        [self addSubview:freeCount];
        
        [self setColors:colors];
        
        self.layer.cornerRadius = 10.0f;
        self.clipsToBounds = YES;
        
    }
    return self;
}
- (void)didClikedStartButton
{
    if ([self.delegate respondsToSelector:@selector(colorBlockDidClikedStartButton)]) {
        [self.delegate colorBlockDidClikedStartButton];
    }
}
- (void)setColors:(NSArray<UIColor *> *)colors
{
    NSMutableArray *transColors = [NSMutableArray array];
    for (UIColor *color in colors) {
        [transColors addObject:(__bridge id)color.CGColor];
    }
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = transColors;
    gradientLayer.startPoint = CGPointMake(0, 1);
    gradientLayer.endPoint = CGPointMake(1.0, 0);
    gradientLayer.frame = self.bounds;
    [self.layer insertSublayer:gradientLayer atIndex:0];
}

@end
