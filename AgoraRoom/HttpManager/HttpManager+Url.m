//
//  HttpManager+Url.m
//  AgoraRoom
//
//  Created by ZYP on 2021/1/21.
//  Copyright © 2021 agora. All rights reserved.
//

#import "HttpManager+Url.h"

static NSString *_appId = @"";

@implementation HttpManager (Url)

+ (NSString *)baseUrlString {
#if DEBUG
    return [NSString stringWithFormat:@"https://api-test.agora.io/scenario/meeting/apps/%@/v2/", _appId];
#else
    return [NSString stringWithFormat:@"https://api.agora.io/scenario/meeting/apps/%@/v2/", _appId];
#endif
}

+ (NSString *)urlAddRoomWitthRoomId:(NSString *)roomId {
    return [NSString stringWithFormat:@"rooms/%@/join", roomId];
}

+ (void)setAppId:(NSString *)appId {
    _appId = appId;
}

@end
