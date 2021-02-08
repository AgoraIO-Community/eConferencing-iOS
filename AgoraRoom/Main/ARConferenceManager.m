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
#import "HttpManager+Public.h"
#import "HMRequestParams+Category.h"
#import "HMResponeParams.h"


@implementation ARConferenceManager

/// jion or create a room
+ (void)entryRoomWithParams:(ARConferenceEntryParams *)params
               successBlock:(ARVoidBlock)successBlock
                  failBlock:(ARErrorBlock)failBlock {
    dispatch_queue_t queue = ARDataManager.share.requsetQueue;
    dispatch_async(queue, ^{
        dispatch_semaphore_t semp = dispatch_semaphore_create(0);
        __block NSError *error;
        __block HMResponeParamsAddRoom *resp;
        __block AgoraRteEngine *rteEngine;
        __block AgoraRteLocalUser *localUser;
        
        // 1. server join
        HMReqParamsAddRoom *reqParams = [HMReqParamsAddRoom instanceWithEntryParams:params];
        [HttpManager requestAddRoom:reqParams success:^(HMResponeParamsAddRoom *addRoomResp) {
             resp = addRoomResp;
            dispatch_semaphore_signal(semp);
        } failure:^(NSError *e) {
            error = e;
            dispatch_semaphore_signal(semp);
        }];
        dispatch_semaphore_wait(semp, -1);
        if(error != nil) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                failBlock(error);
            });
            return;
        }
        
        // 2. create RteEngine
        ARDataManager.share.entryParams = params;
        AgoraRteEngineConfig *config = [AgoraRteEngineConfig instanceWithEntryparams:params];
        [AgoraRteEngine createWithConfig:config success:^(AgoraRteEngine *engine) {
            rteEngine = engine;
            dispatch_semaphore_signal(semp);
        } fail:^(AgoraRteError *e) {
            ARError *arError = [ARError errorWithRteError:e];
            error = arError;
            dispatch_semaphore_signal(semp);
        }];
        dispatch_semaphore_wait(semp, -1);
        if(error != nil) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                failBlock(error);
            });
            return;
        }
        
        // 3. rte join
        AgoraRteSceneConfig *sceneConfig = [[AgoraRteSceneConfig alloc] initWithSceneId:params.roomUuid];
        AgoraRteScene *scene = [rteEngine createAgoraRteScene:sceneConfig];
        AgoraRteSceneJoinOptions *joinOptions = [[AgoraRteSceneJoinOptions alloc] initWithUserName:params.userName userRole:resp.userRole];
        
        [scene joinWithOptions:joinOptions success:^(AgoraRteLocalUser *user) {
            localUser = user;
            dispatch_semaphore_signal(semp);
        } fail:^(AgoraRteError *e) {
            ARError *arError = [ARError errorWithRteError:e];
            error = arError;
            dispatch_semaphore_signal(semp);
        }];
        dispatch_semaphore_wait(semp, -1);
        if(error != nil) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                failBlock(error);
            });
            return;
        }
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            ARDataManager.share.rteEngine = rteEngine;
            ARDataManager.share.scene = scene;
            ARDataManager.share.localuser = localUser;
            ARDataManager.share.entryParams = params;
            successBlock();
        });
    });
    
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
