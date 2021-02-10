//
//  HMError.m
//  AgoraRoom
//
//  Created by ZYP on 2021/1/26.
//  Copyright © 2021 agora. All rights reserved.
//

#import "HMError.h"

@implementation HMError

+ (instancetype)errorWithCodeType:(HMErrorCodeType)type
                          extCode:(NSInteger)extCode
                              msg:(NSString *)msg
                             data:(nullable id)data {
    NSString *str = @"";
    if (data != nil) {
        str = (NSString *)data;
    }
    NSString *desc = [NSString stringWithFormat:@"%@（%ld）: %@", msg, extCode, str];
    NSDictionary *userInfo = @{NSLocalizedDescriptionKey: desc};
    return [[HMError alloc] initWithDomain:@"com.agora.meeting.hmerror" code:type userInfo:userInfo];
}

@end