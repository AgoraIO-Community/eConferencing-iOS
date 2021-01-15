//
//  HMEmtryParams.h
//  AgoraRoom
//
//  Created by ZYP on 2021/1/11.
//  Copyright © 2021 agora. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HMEmtryParams : NSObject

@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *userUuid;
@property (nonatomic, strong) NSString *roomName;
@property (nonatomic, strong) NSString *roomUuid;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, assign) BOOL enableVideo;
@property (nonatomic, assign) BOOL enableAudio;
@property (nonatomic, strong) NSString *avatar;

@end

NS_ASSUME_NONNULL_END
