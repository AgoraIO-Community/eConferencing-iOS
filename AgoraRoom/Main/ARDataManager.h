//
//  ARDataManager.h
//  AgoraRoom
//
//  Created by ZYP on 2021/1/7.
//  Copyright © 2021 agora. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ARConferenceEntryParams;
@class AgoraRteEngine, AgoraRteScene;
@class AgoraRteCameraVideoTrack, AgoraRteMicrophoneAudioTrack;
@class AgoraRteLocalUser;

NS_ASSUME_NONNULL_BEGIN

@interface ARDataManager : NSObject

+ (instancetype)share;

@property (nonatomic, strong)ARConferenceEntryParams *entryParams;
@property (nonatomic, strong)AgoraRteEngine *rteEngine;
@property (nonatomic, strong)AgoraRteScene *scene;
@property (nonatomic, strong)AgoraRteLocalUser *localuser;
@property (nonatomic, strong)AgoraRteCameraVideoTrack *cameraVideoTrack;
@property (nonatomic, strong)AgoraRteMicrophoneAudioTrack *microphoneAudioTrack;

@property (nonatomic, strong)dispatch_queue_t requsetQueue;


@end

NS_ASSUME_NONNULL_END
