//
//  HMUserInfo.m
//  AgoraRoom
//
//  Created by ZYP on 2021/1/11.
//  Copyright © 2021 agora. All rights reserved.
//

#import "HMUsers.h"

@implementation HMUser

- (BOOL)isEqual:(id)object {
  if (self == object) {
    return YES;
  }

  if (![object isKindOfClass:[HMUser class]]) {
    return NO;
  }

  return [self isEqualToModel:(HMUser *)object];
}

- (BOOL)isEqualToModel:(HMUser *)model {
    if (!model) {
        return NO;
    }

    BOOL equalUserId = (!self.userId && !model.userId) || [self.userId isEqualToString:model.userId];
    BOOL equalUserUuid = (!self.userUuid && !model.userUuid) || [self.userUuid isEqualToString:model.userUuid];
    BOOL equalUserName = (!self.userName && !model.userName) || [self.userName isEqualToString:model.userName];
    BOOL equalRole = self.role == model.role;
    BOOL equalEnableChat = self.enableChat == model.enableChat;
    BOOL equalEnableVideo = self.enableVideo == model.enableVideo;
    BOOL equalEnableAudio = self.enableAudio == model.enableAudio;
    BOOL equalUid = self.uid == model.uid;
    BOOL equalGrantBoard = self.grantBoard == model.grantBoard;
    BOOL equalGrantScreen = self.grantScreen == model.grantScreen;
    BOOL equalScreenId = self.screenId == model.screenId;
    BOOL equalState = self.state == model.state;

  return equalUserId
    && equalUserUuid
    && equalUserName
    && equalRole
    && equalEnableChat
    && equalEnableVideo
    && equalEnableAudio
    && equalUid
    && equalGrantBoard
    && equalGrantScreen
    && equalScreenId
    && equalState;
}

- (NSUInteger)hash {
  return [self.userId hash]
    ^ [self.userUuid hash]
    ^ [self.userName hash]
    ^ [@(self.role) hash]
    ^ [@(self.enableChat) hash]
    ^ [@(self.enableVideo) hash]
    ^ [@(self.enableAudio) hash]
    ^ [@(self.uid) hash]
    ^ [@(self.grantBoard) hash]
    ^ [@(self.grantScreen) hash]
    ^ [@(self.screenId) hash]
    ^ [@(self.state) hash];
}

@end

@implementation HMUsers

@end
