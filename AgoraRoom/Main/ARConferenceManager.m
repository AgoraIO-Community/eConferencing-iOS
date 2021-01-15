//
//  ARConferenceManager.m
//  AgoraRoom
//
//  Created by ZYP on 2021/1/7.
//  Copyright © 2021 agora. All rights reserved.
//

#import "ARConferenceManager.h"
#import "ARConferenceEntryParams.h"
#import "ARBlockDefine.h"
#import "ARDataManager.h"
#import <AgoraRte/AgoraRteEngine.h>
#import "AgoraRteEngineConfig+Extension.h"
#import "ARError.h"
#import <AgoraRte/AgoraRteObjects.h>

@implementation ARConferenceManager

+ (void)entryRoomWithParams:(ARConferenceEntryParams *)params
               successBlock:(ARVoidBlock)successBlock
                  failBlock:(ARErrorBlock)failBlock {
    
    ARDataManager.share.entryParams = params;
    AgoraRteEngineConfig *config = [AgoraRteEngineConfig instanceWithEntryparams:params];
    
    [AgoraRteEngine createWithConfig:config success:^(AgoraRteEngine *engine) {
        AgoraRteSceneConfig *sceneConfig = [[AgoraRteSceneConfig alloc] initWithSceneId:params.roomUuid];
        AgoraRteScene *scene = [engine createAgoraRteScene:sceneConfig];
        
        AgoraRteSceneJoinOptions *joinOptions = [[AgoraRteSceneJoinOptions alloc] initWithUserName:params.userName userRole:@""];
        [scene joinWithOptions:joinOptions success:^(AgoraRteLocalUser *user) {
            ARDataManager.share.rteEngine = engine;
            ARDataManager.share.scene = scene;
            successBlock();
        } fail:^(AgoraRteError *error) {
            ARError *arError = [ARError errorWithRteError:error];
            failBlock(arError);
        }];
    } fail:^(AgoraRteError *error) {
        ARError *arError = [ARError errorWithRteError:error];
        failBlock(arError);
    }];
}

+ (AgoraRteEngine *)getRteEngine {
    return ARDataManager.share.rteEngine;
}

+ (AgoraRteScene *)getScene {
    return ARDataManager.share.scene;
}

+ (ARConferenceEntryParams *)getEntryParams {
    return ARDataManager.share.entryParams;
}

+ (AgoraRteLocalUser *)getLocalUser {
    return ARDataManager.share.localuser;
}


@end
