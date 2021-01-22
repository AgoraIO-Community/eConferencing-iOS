//
//  HMRequestParams.h
//  AgoraRoom
//
//  Created by ZYP on 2021/1/21.
//  Copyright © 2021 agora. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 创建/加入房间 request
@interface HMRequestParamsAddRoom : NSObject

// md5(roomName), 32位小写
@property (nonatomic, copy)NSString *roomId;
@property (nonatomic, copy)NSString *roomName;
// md5(userName), 32位小写
@property (nonatomic, copy)NSString *userId;
@property (nonatomic, copy)NSString *userName;
@property (nonatomic, copy)NSString *password;
@property (nonatomic, assign)BOOL micAccess;
@property (nonatomic, assign)BOOL cameraAccess;

@end

NS_ASSUME_NONNULL_END
