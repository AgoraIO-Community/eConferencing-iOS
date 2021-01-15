//
//  MeetingVM.m
//  VideoConference
//
//  Created by ZYP on 2021/1/12.
//  Copyright © 2021 agora. All rights reserved.
//

#import "MeetingVM.h"
#import <AgoraRoom/AgoraRoom.h>
#import <AgoraRte/AgoraRteEngine.h>

@interface MeetingVM ()<AgoraRteLocalUserDelegate, AgoraRteMediaStreamDelegate>

@property (nonatomic, strong)AgoraRteCameraVideoTrack *videoTrack;
@property (nonatomic, strong)AgoraRteMicrophoneAudioTrack *audioTrack;
@property (nonatomic, strong)AgoraRteEngine *engine;
@property (nonatomic, strong)AgoraRteLocalUser *localUser;

@end


@implementation MeetingVM

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)dealloc {
    [_engine destroy];
    _engine = nil;
}

- (void)setup {
    _engine = [ARConferenceManager getRteEngine];
    _localUser = [ARConferenceManager getLocalUser];
    _localUser.localUserDelegate = self;
    _localUser.mediaStreamDelegate = self;
}

- (void)start {
    ARConferenceEntryParams *entryParams = [ARConferenceManager getEntryParams];
    if (entryParams.enableVideo) { [self openVideoTrack]; }
    if (entryParams.enableAudio) { [self openAudioTrack]; }
}

- (void)openVideoTrack {
    if (_videoTrack != nil) { return; }
    AgoraRteMediaControl *mediaCtrl = [[ARConferenceManager getRteEngine] getAgoraMediaControl];
    _videoTrack = [mediaCtrl createCameraVideoTrack];
}

- (void)closeVideoTrack {
    [_videoTrack stop];
    _videoTrack = nil;
}

- (void)openAudioTrack {
    if (_audioTrack != nil) { return; }
    AgoraRteMediaControl *mediaCtrl = [[ARConferenceManager getRteEngine] getAgoraMediaControl];
    _audioTrack = [mediaCtrl createMicphoneAudioTrack];
}

- (void)closeAudioTrack {
    [_audioTrack stop];
    _audioTrack = nil;
}

#pragma AgoraRteLocalUserDelegate

- (void)localUser:(AgoraRteLocalUser *)user
didUpdateLocalUserInfo:(AgoraRteUserEvent *)userEvent {
    NSLog(@"");
}

- (void)localUser:(AgoraRteLocalUser *)user
didUpdateLocalUserProperties:(NSArray<NSString *> *)changedProperties
           remove:(BOOL)remove
            cause:(NSString * _Nullable)cause {
    NSLog(@"");
}

- (void)localUser:(AgoraRteLocalUser *)user
didChangeOfLocalStream:(AgoraRteMediaStreamEvent *)event
       withAction:(AgoraRteMediaStreamAction)action {
    NSLog(@"");
}

#pragma AgoraRteMediaStreamDelegate

- (void)localUser:(AgoraRteLocalUser *)user
didChangeOfLocalAudioStream:(NSString *)streamId
        withState:(AgoraRteStreamState)state {
    NSLog(@"");
}

- (void)localUser:(AgoraRteLocalUser *)user
didChangeOfLocalVideoStream:(NSString *)streamId
        withState:(AgoraRteStreamState)state {
    NSLog(@"");
}

- (void)localUser:(AgoraRteLocalUser *)user
didChangeOfRemoteAudioStream:(NSString *)streamId
        withState:(AgoraRteStreamState)state {
    NSLog(@"");
}

- (void)localUser:(AgoraRteLocalUser *)user
didChangeOfRemoteVideoStream:(NSString *)streamId
        withState:(AgoraRteStreamState)state {
    NSLog(@"");
}

- (void)localUser:(AgoraRteLocalUser *)user
audioVolumeIndicationOfStream:(NSString *)streamId
       withVolume:(NSUInteger)volume {
    NSLog(@"");
}

@end
