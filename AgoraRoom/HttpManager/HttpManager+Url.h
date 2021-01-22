//
//  HttpManager+Url.h
//  AgoraRoom
//
//  Created by ZYP on 2021/1/21.
//  Copyright © 2021 agora. All rights reserved.
//

#import "HttpManager.h"





NS_ASSUME_NONNULL_BEGIN

@interface HttpManager (Url)
// 创建/加入房间
+ (NSString *)urlAddRoomWitthRoomId:(NSString *)roomId;

+ (void)setAppId:(NSString *)appId;

@end

NS_ASSUME_NONNULL_END
