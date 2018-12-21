//
//  IAPManager.m
//  EyesightDoctor
//
//  Created by Chonghua Yu on 2018/10/23.
//  Copyright © 2018 Chonghua Yu. All rights reserved.
//

#import "IAPManager.h"
#import <StoreKit/StoreKit.h>

static NSString * const kUnlimitedTestTimes = @"UnlimitedTestTimes";
@interface IAPManager ()<SKProductsRequestDelegate,SKPaymentTransactionObserver>

@end

@implementation IAPManager
{
    void(^_restoreComplete)(BOOL success);
}
+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static IAPManager *manager = nil;
    dispatch_once(&onceToken, ^{
        manager = [[IAPManager alloc] init];
    });
    return manager;
}
-  (instancetype)init
{
    self = [super init];
    if (self) {
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    }
    return self;
}
- (void)startBuy
{
    if ([SKPaymentQueue canMakePayments]) {
        SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:kUnlimitedTestTimes]];
        request.delegate = self;
        [request start];
    }else{
        //to do
        UIAlertView *alerView =  [[UIAlertView alloc] initWithTitle:Local(@"提示")
                                                            message:Local(@"您的手机没有打开程序内付费购买")
                                                           delegate:nil cancelButtonTitle:Local(@"取消") otherButtonTitles:nil];
        
        [alerView show];
        if(self.completion)self.completion(NO);

    }
}
- (void)restoreWithComplete:(void (^)(BOOL))complete
{
    _restoreComplete = complete;
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];

}
#pragma mark -<SKProductsRequestDelegate>
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    NSArray *products = response.products;
    if (products&&products.count>0) {
        SKPayment *payment = [SKPayment paymentWithProduct:products.firstObject];
        [[SKPaymentQueue defaultQueue] addPayment:payment];
    }else{
        UIAlertView *alerView =  [[UIAlertView alloc] initWithTitle:Local(@"提示") message:Local(@"没有可供购买的商品")
                                                           delegate:nil cancelButtonTitle:Local(@"取消") otherButtonTitles:nil];
        [alerView show];
        if(self.completion)self.completion(NO);

    }
}
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error
{
    UIAlertView *alerView =  [[UIAlertView alloc] initWithTitle:Local(@"提示") message:[error localizedDescription]
                                                       delegate:nil cancelButtonTitle:Local(@"取消") otherButtonTitles:nil];
    [alerView show];
    if(self.completion)self.completion(NO);

}
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray<SKPaymentTransaction *> *)transactions
{
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
                //交易完成
            case SKPaymentTransactionStatePurchased:
                //发送购买凭证到服务器验证是否有效
                [self completeTransaction:transaction];
                break;
                //交易失败
            case SKPaymentTransactionStateFailed:
//                [self faildWithMessage:Local(@"交易失败")];
                break;
                //已经购买过该商品
            case SKPaymentTransactionStateRestored:
//                [self faildWithMessage:Local(@"已经购买过")];
                if(_restoreComplete)_restoreComplete(YES);
                _restoreComplete = nil;
                break;
                //商品添加进列表
            case SKPaymentTransactionStatePurchasing:
                break;
            default:
                break;
        }
    }
}
//
- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
{
    NSMutableArray *purchasedItemIDs = [[NSMutableArray alloc] init];
    for (SKPaymentTransaction *transaction in queue.transactions)
    {
        NSString *productID = transaction.payment.productIdentifier;
        [purchasedItemIDs addObject:productID];
    }
    if ([purchasedItemIDs containsObject:kUnlimitedTestTimes]) {
        
    }
    
}
- (void)faildWithMessage:(NSString *)message
{
    UIAlertView *alerView =  [[UIAlertView alloc] initWithTitle:Local(@"提示")
                                                        message:message
                                                       delegate:nil cancelButtonTitle:Local(@"确定") otherButtonTitles:nil];
    
    [alerView show];
    if(self.completion)self.completion(NO);
}
//交易成功，与服务器比对传输货单号
- (void)completeTransaction:(SKPaymentTransaction *)transaction
{
//    NSURL *receiptUrl = [[NSBundle mainBundle] appStoreReceiptURL];
//    NSData *receiptData = [NSData dataWithContentsOfURL:receiptUrl];
//    NSString * transactionReceiptString = [receiptData base64EncodedStringWithOptions:0];
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:Local(@"购买成功") preferredStyle:UIAlertControllerStyleAlert];
//    weakify(self)
//    [alert addAction:[UIAlertAction actionWithTitle:Local(@"确定") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//        strongify(self)
        if(self.completion)self.completion(YES);
//    }]];

    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

@end
