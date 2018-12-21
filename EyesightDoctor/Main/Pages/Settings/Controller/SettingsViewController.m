//
//  SettingsViewController.m
//  EyesightDoctor
//
//  Created by Chonghua Yu on 2018/10/12.
//  Copyright © 2018 Chonghua Yu. All rights reserved.
//

#import "SettingsViewController.h"
#import "SettingCell.h"
#import "PrivacyPolicyViewController.h"
#import "UICKeyChainStore.h"
#import "IAPManager.h"
#import "OpinionViewController.h"
#import <UShareUI/UShareUI.h>

static NSString * const kSettingCell = @"kSettingCell";

@interface SettingsViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@end

@implementation SettingsViewController
{
    NSArray *_dataSource;
    UICKeyChainStore *_keychain;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorFromHexString:@"f6f6f6"];
    [self.navigationItem setTitle:Local(@"设置")];
    [self.view addSubview:self.tableView];
    _keychain = [UICKeyChainStore keyChainStoreWithService:@"com.eyesighDoctor.geforceyu"];

}
- (void)dataFactory
{
    NSString *freeText = @"";
    BOOL unLocked = [[_keychain stringForKey:kIsUnLock] integerValue]==1;
    
    if (!unLocked) {
        NSInteger useCount = [[_keychain stringForKey:kTestedTimes] integerValue];
        freeText = [NSString stringWithFormat:@"%@:(%ld/%ld)",Local(@"免费次数"),(long)useCount,APP_FREE_TESTCOUNT];
    }
    _dataSource = nil;
    _dataSource = @[
                    @[@{@"tag":@"1",@"name":unLocked?Local(@"已解锁无限测试次数"):Local(@"解锁无限测试次数"),@"iconCode":@"\uf4c9",@"tintColor":[UIColor successColor],@"subTitle":freeText},
                      @{@"tag":@"6",@"name":Local(@"恢复购买"),@"iconCode":@"\uf49b",@"tintColor":[UIColor successColor],@"subTitle":freeText},
                      @{@"tag":@"2",@"name":Local(@"赏个好评"),@"iconCode":@"\uf251",@"tintColor":[UIColor colorFromHexString:@"E06383"]},
                      @{@"tag":@"3",@"name":Local(@"意见反馈"),@"iconCode":@"\uf452",@"tintColor":[UIColor colorFromHexString:@"E7C353"]},
                      @{@"tag":@"4",@"name":Local(@"分享给朋友"),@"iconCode":@"\uf220",@"tintColor":[UIColor successColor]},
                      ],
                    @[@{@"tag":@"5",@"name":Local(@"隐私政策"),@"iconCode":@"\uf446",@"tintColor":[UIColor black50PercentColor]}]
                    ];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self dataFactory];
    [self.tableView reloadData];
}
#pragma mark -<UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataSource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataSource[section] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *info = _dataSource[indexPath.section][indexPath.row];
    SettingCell *cell = [tableView dequeueReusableCellWithIdentifier:kSettingCell];
    cell.info = info;
    return cell;
}
#pragma mark -<UITableViewDelegate>

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 47;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSDictionary *info = _dataSource[indexPath.section][indexPath.row];
    NSInteger tag = [info[@"tag"] integerValue];
    if (tag==1) {
        BOOL unLocked = [[_keychain stringForKey:kIsUnLock] integerValue]==1;
        if (unLocked) {
            [self.view showSuccessToast:Local(@"已解锁")];
            return;
        }
        [self.view showLoadingWithText:Local(@"购买中...") delay:5];
        [[IAPManager sharedInstance] startBuy];
        weakify(self)
        [[IAPManager sharedInstance] setCompletion:^(BOOL success) {
            strongify(self)
            if (success) {
                [_keychain setString:@"1" forKey:kIsUnLock];
                [self dataFactory];
                [self.tableView reloadData];
            }
        }];
    }
    else if (tag==2) {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_11_0
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:APP_OPEN_EVALUATE_AFTER_IOS11]];
#else
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:APP_OPEN_EVALUATE]];
#endif
    }
    else if (tag==3) {
        OpinionViewController *vc = [[OpinionViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (tag==4) {
        [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_WechatTimeLine),@(UMSocialPlatformType_QQ),@(UMSocialPlatformType_Sina)]];
        [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
            [self shareWebPageToPlatformType:platformType];
        }];
        
    }else if (tag==5) {
        PrivacyPolicyViewController *vc = [[PrivacyPolicyViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (tag==6) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:Local(@"提示") message:Local(@"恢复购买前请确保在AppStore中已登录之前购买此产品的AppleID") preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:Local(@"确定") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.view showLoadingWithText:Local(@"恢复中...")];

            [[IAPManager sharedInstance] restoreWithComplete:^(BOOL success) {
                [self.view dismissHUD];
                if (success) {
                    [_keychain setString:@"1" forKey:kIsUnLock];
                    [self dataFactory];
                    [self.tableView reloadData];
                }
            }];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:Local(@"取消") style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
}
- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
{
    UMShareWebpageObject *sharedObjc = [UMShareWebpageObject shareObjectWithTitle:Local(@"视力评测") descr:Local(@"快来测测您的视力值") thumImage:[UIImage imageNamed:@"appThumIcon"]];
    sharedObjc.webpageUrl = @"https://itunes.apple.com/cn/app/id1439861243";
    UMSocialMessageObject *messageObjc = [UMSocialMessageObject messageObjectWithMediaObject:sharedObjc];
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObjc currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            DEBUG_LOG(@"%@",error);
        }else{
            NSLog(@"suc");
        }
    }];
}
#pragma mark -Getter
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[SettingCell class] forCellReuseIdentifier:kSettingCell];
        _tableView.tableFooterView = [[UIView alloc] init];
        
    }
    return _tableView;
}
@end
