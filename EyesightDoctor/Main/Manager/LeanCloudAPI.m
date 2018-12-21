//
//  LeanCloudAPI.m
//  LongWebviewScreenshot
//
//  Created by Chonghua Yu on 2018/10/25.
//  Copyright © 2018 geforecyu. All rights reserved.
//

#import "LeanCloudAPI.h"

@implementation LeanCloudAPI

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static LeanCloudAPI *api = nil;
    dispatch_once(&onceToken, ^{
        api =[[LeanCloudAPI alloc] init];
    });
    return api;
}
- (NSURL *)baseURL
{
    return [NSURL URLWithString:@"https://ufenovwf.api.lncld.net"];
}
- (AFHTTPRequestSerializer<AFURLRequestSerialization> *)requestSerializer
{
    AFJSONRequestSerializer *serializer = [AFJSONRequestSerializer serializer];
    [serializer setValue:@"UFeNOVWFYVcuEe90sif9VaLf-gzGzoHsz" forHTTPHeaderField:@"X-LC-Id"];
    [serializer setValue:@"cfs4YzHuDVmuYeThrwmzkrp0" forHTTPHeaderField:@"X-LC-Key"];
    [serializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    return serializer;
}
- (AFHTTPResponseSerializer<AFURLResponseSerialization> *)responseSerializer
{
    AFJSONResponseSerializer *response = [AFJSONResponseSerializer serializer];
    return response;
}
- (void)postOpinion:(NSString *)text completion:(void(^)(BOOL success))completion
{
    [self POST:@"/1.1/classes/opinion" parameters:@{@"text":text,@"appType":@"EyeTest"} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (responseObject[@"objectId"]) {
            completion(YES);
        }else{
            completion(NO);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if(completion)completion(NO);
    }];
}
@end
