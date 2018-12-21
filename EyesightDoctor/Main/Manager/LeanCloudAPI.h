//
//  LeanCloudAPI.h
//  LongWebviewScreenshot
//
//  Created by Chonghua Yu on 2018/10/25.
//  Copyright © 2018 geforecyu. All rights reserved.
//

#import "AFNetworking.h"


@interface LeanCloudAPI : AFHTTPSessionManager

+ (instancetype)sharedInstance;

- (void)postOpinion:(NSString *)text completion:(void(^)(BOOL success))completion;

@end

