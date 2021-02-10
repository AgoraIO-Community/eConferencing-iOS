//
//  ARConferenceManager.h
//  AgoraRoom
//
//  Created by ZYP on 2021/1/7.
//  Copyright © 2021 agora. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ARBlockDefine.h"
@class AgoraRteEngine, AgoraRteScene, AgoraRteLocalUser, HMResponeParamsAddRoom;

/** Network type. */
typedef NS_ENUM(NSInteger, NetworkGrade) {
    NetworkGradeUnknown = -1,
    NetworkGradeHigh = 1,
    NetworkGradeMiddle = 2,
    NetworkGradeLow = 3,
};

@class ARConferenceEntryParams;

NS_ASSUME_NONNULL_BEGIN

@interface ARConferenceManager : NSObject

+ (void)entryRoomWithParams:(ARConferenceEntryParams *)params
                    successBlock:(ARVoidBlock)successBlock
                  failBlock:(ARErrorBlock)failBlock;

+ (AgoraRteEngine *)getRteEngine;
+ (AgoraRteScene *)getScene;
+ (ARConferenceEntryParams *)getEntryParams;
+ (AgoraRteLocalUser *)getLocalUser;
+ (HMResponeParamsAddRoom *)getAddRoomResp;

@end

NS_ASSUME_NONNULL_END
