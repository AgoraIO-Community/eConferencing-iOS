//
//  EduUserModel.m
//  AgoraEducation
//
//  Created by SRS on 2020/4/23.
//  Copyright © 2020 yangmoumou. All rights reserved.
//

#import "ConfUserModel.h"

@implementation ConfUserModel

- (BOOL)isEqual:(id)object {
  if (self == object) {
    return YES;
  }

  if (![object isKindOfClass:[ConfUserModel class]]) {
    return NO;
  }

  return [self isEqualToModel:(ConfUserModel *)object];
}

- (BOOL)isEqualToModel:(ConfUserModel *)model {
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
    BOOL equalScreenId = self.screenId == model.screenId;

  return equalUserId
    && equalUserUuid
    && equalUserName
    && equalRole
    && equalEnableChat
    && equalEnableVideo
    && equalEnableAudio
    && equalUid
    && equalGrantBoard
    && equalScreenId;

//    @property (nonatomic, strong) NSString *rtcToken;
//    @property (nonatomic, strong) NSString *rtmToken;
//    @property (nonatomic, strong) NSString *screenToken;
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
    ^ [@(self.screenId) hash];
}

@end
