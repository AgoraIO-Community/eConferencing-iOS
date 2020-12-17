//
//  HttpManager+HttpManager_Public.m
//  AgoraRoom
//
//  Created by ADMIN on 2020/12/10.
//  Copyright © 2020 agora. All rights reserved.
//

#import "HttpManager+Public.h"
#import "HttpManager.h"
#import "URL.h"
#import <YYModel.h>
#import "HttpClient.h"
#import "ConfigModel.h"
#import "CommonModel.h"
#import "RoomEnum.h"

@implementation HttpManager (Public)

+ (void)getConfigWithApiVersion:(NSString *)apiVersion
                   successBolck:(void (^ _Nullable) (ConfigAllInfoModel * model))successBlock
              completeFailBlock:(void (^ _Nullable) (NSError *error))failBlock {
    
    NSInteger deviceType = 0;
    if (UIUserInterfaceIdiomPhone == [UIDevice currentDevice].userInterfaceIdiom) {
        deviceType = 1;
    } else if(UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom) {
        deviceType = 2;
    }
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    
    NSDictionary *params = @{
        @"appCode" : [HttpManager appCode],//
        @"osType" : @(1),// 1.ios 2.android
        @"terminalType" : @(deviceType),//1.phone 2.pad
        @"appVersion" : app_Version
    };
    
    NSString *url = [NSString stringWithFormat:HTTP_GET_CONFIG, HTTP_BASE_URL];
    [HttpManager get:url params:params headers:nil apiVersion:apiVersion success:^(id responseObj) {
        
        ConfigModel *model = [ConfigModel yy_modelWithDictionary:responseObj];
        if(model.code == 0) {
            if(successBlock != nil){
                successBlock(model.data);
            }
        } else {
            if(failBlock != nil) {
                NSError *error = LocalError(model.code, model.msg);
                failBlock(error);
            }
        }
    } failure:^(NSError *error) {
        if(failBlock != nil) {
            failBlock(error);
        }
    }];
}

+ (void)enterRoomWithParams:(EntryParams *)params
                      appId:(NSString *)appId
                 apiVersion:(NSString *)apiVersion
               successBolck:(void (^ _Nullable) (EnterRoomInfoModel *model))successBlock
          completeFailBlock:(void (^ _Nullable) (NSError *error))failBlock {
    
    NSMutableDictionary *dicParams = [NSMutableDictionary dictionary];
    if ([params isKindOfClass:[EduSaaSEntryParams class]]){
        EduSaaSEntryParams *saasParams = (EduSaaSEntryParams*)params;
        dicParams[@"userName"] = saasParams.userName;
        dicParams[@"password"] = saasParams.password;
        // student
        dicParams[@"role"] = @(saasParams.role);
        dicParams[@"userUuid"] = [UIDevice currentDevice].identifierForVendor.UUIDString;
    } else if ([params isKindOfClass:[EduEntryParams class]]){
        EduEntryParams *eduParams = (EduEntryParams*)params;
        dicParams[@"userName"] = eduParams.userName;
        dicParams[@"roomName"] = eduParams.roomName;
        dicParams[@"type"] = @(eduParams.sceneType);
        dicParams[@"role"] = @(eduParams.role);
        dicParams[@"userUuid"] = eduParams.userUuid;
        dicParams[@"roomUuid"] = eduParams.roomUuid;
        
    } else if ([params isKindOfClass:[ConferenceEntryParams class]]){
        ConferenceEntryParams *cParams = (ConferenceEntryParams*)params;
        dicParams[@"userName"] = cParams.userName;
        dicParams[@"userUuid"] = cParams.userUuid;
        dicParams[@"roomName"] = cParams.roomName;
        dicParams[@"roomUuid"] = cParams.roomUuid;
        dicParams[@"password"] = cParams.password;
        dicParams[@"enableVideo"] = @(cParams.enableVideo).stringValue;
        dicParams[@"enableAudio"] = @(cParams.enableAudio).stringValue;
        dicParams[@"avatar"] = cParams.avatar;
    }
    
    NSString *url = [NSString stringWithFormat:HTTP_ENTER_ROOM1, HTTP_BASE_URL];
    SceneType sceneType = [HttpManager getSceneType];
    if(sceneType == SceneTypeEducation){
        url = [NSString stringWithFormat:HTTP_ENTER_ROOM2, HTTP_BASE_URL, appId];
    } else if(sceneType == SceneTypeConference){
        url = [NSString stringWithFormat:HTTP_ENTER_ROOM2, HTTP_BASE_URL, appId];
    }
    [HttpManager post:url params:dicParams headers:nil apiVersion:apiVersion success:^(id responseObj) {
        
        EnterRoomAllModel *model = [EnterRoomAllModel yy_modelWithDictionary:responseObj];
        if (model.code == 0) {
            
            [HttpManager saveHttpHeader1:model.data];
            
            if(successBlock != nil){
                successBlock(model.data);
            }
        } else {
            if(failBlock != nil) {
                NSError *error = LocalError(model.code, model.msg);
                failBlock(error);
            }
        }
        
    } failure:^(NSError *error) {
        if(failBlock != nil) {
            failBlock(error);
        }
    }];
}

+ (void)sendMessageWithType:(MessageType)messageType
                      appId:(NSString *)appId
                     roomId:(NSString *)roomId
                    message:(NSString *)message
                 apiVersion:(NSString *)apiVersion
               successBolck:(void (^ _Nullable) (void))successBlock
          completeFailBlock:(void (^ _Nullable) (NSError *error))failBlock {
    
    NSString *url = [NSString stringWithFormat:HTTP_USER_INSTANT_MESSAGE, HTTP_BASE_URL, appId, roomId];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"type"] = @(messageType);
    params[@"message"] = message;
    
    [HttpManager post:url params:params headers:nil apiVersion:apiVersion success:^(id responseObj) {
        
        CommonModel *model = [CommonModel yy_modelWithDictionary:responseObj];
        if(model.code == 0){
            if(successBlock != nil){
                successBlock();
            }
        } else {
            if(failBlock != nil) {
                NSError *error = LocalError(model.code, model.msg);
                failBlock(error);
            }
        }
        
    } failure:^(NSError *error) {
        if(failBlock != nil) {
            failBlock(error);
        }
    }];
}

+ (void)sendCoVideoWithType:(SignalLinkState)linkState
                      appId:(NSString *)appId
                     roomId:(NSString *)roomId
                    userIds:(NSArray<NSString *> *)userIds
                 apiVersion:(NSString *)apiVersion
               successBolck:(void (^ _Nullable) (void))successBlock
          completeFailBlock:(void (^ _Nullable) (NSError *error))failBlock {
    
    if(linkState == SignalLinkStateIdle) {
        return;
    }
    
    NSString *url = [NSString stringWithFormat:HTTP_USER_COVIDEO, HTTP_BASE_URL, appId, roomId];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"type"] = @(linkState);
    if(userIds != nil && userIds.count > 0){
        params[@"userIds"] = userIds;
    }
    
    [HttpManager post:url params:params headers:nil apiVersion:apiVersion success:^(id responseObj) {
        
        CommonModel *model = [CommonModel yy_modelWithDictionary:responseObj];
        if(model.code == 0){
            if(successBlock != nil){
                successBlock();
            }
        } else {
            if(failBlock != nil) {
                NSError *error = LocalError(model.code, model.msg);
                failBlock(error);
            }
        }
        
    } failure:^(NSError *error) {
        if(failBlock != nil) {
            failBlock(error);
        }
    }];
}

/// 修改会议室信息
+ (void)updateRoomInfoWithValue:(NSInteger)value
               enableSignalType:(ConfEnableRoomSignalType)type
                          appId:(NSString *)appId
                         roomId:(NSString *)roomId
                     apiVersion:(NSString *)apiVersion
           completeSuccessBlock:(void (^ _Nullable) (void))successBlock
              completeFailBlock:(void (^ _Nullable) (NSError *error))failBlock {
    
    NSString *url = [NSString stringWithFormat:HTTP_UPDATE_ROOM_INFO, HTTP_BASE_URL, appId, roomId];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    switch (type) {
        case ConfEnableRoomSignalTypeMuteAllChat:
            params[@"muteAllChat"] = @(value);
            break;
        case ConfEnableRoomSignalTypeMuteAllAudio:
            params[@"muteAllAudio"] = @(value);
            break;
        case ConfEnableRoomSignalTypeState:
            params[@"state"] = @(value);
            break;
        case ConfEnableRoomSignalTypeShareBoard:
            params[@"shareBoard"] = @(value);
            break;
        default:
            break;
    }
    
    [HttpManager post:url params:params headers:nil apiVersion:apiVersion success:^(id responseObj) {
        
        CommonModel *model = [CommonModel yy_modelWithDictionary:responseObj];
        if(model.code == 0) {
            if(successBlock != nil){
                successBlock();
            }
        } else {
            if(failBlock != nil) {
                NSError *error = LocalError(model.code, model.msg);
                failBlock(error);
            }
        }
        
    } failure:^(NSError *error) {
        if(failBlock != nil) {
            failBlock(error);
        }
    }];
}

/// 查询观众列表
+ (void)getUserListWithRole:(ConfRoleType)role
                     nextId:(NSString *)nextId
                      count:(NSInteger)count
                      appId:(NSString *)appId
                     roomId:(NSString *)roomId
                 apiVersion:(NSString *)apiVersion
               successBlock:(void (^)(ConfUserListInfoModel *userListModel))successBlock failBlock:(void (^ _Nullable) (NSError *error))failBlock {
    
    NSString *url = [NSString stringWithFormat:HTTP_USER_LIST_INFO, HTTP_BASE_URL, appId, roomId];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"role"] = @(role);
    params[@"nextId"] = nextId;
    params[@"count"] = @(count);
    [HttpManager get:url params:params headers:nil apiVersion:apiVersion success:^(id responseObj) {
        
        ConfUserListModel *model = [ConfUserListModel yy_modelWithDictionary:responseObj];
        if(model.code == 0) {
            if(successBlock != nil){
                successBlock(model.data);
            }
        } else {
            if(failBlock != nil) {
                NSError *error = LocalError(model.code, model.msg);
                failBlock(error);
            }
        }
        
    } failure:^(NSError *error) {
        if(failBlock != nil) {
            failBlock(error);
        }
    }];
}

/// 修改会议室用户信息
+ (void)updateUserInfoWithValue:(BOOL)enable
               enableSignalType:(EnableSignalType)type
                          appId:(NSString *)appId
                         roomId:(NSString *)roomId
                         userId:(NSString *)userId
                     apiVersion:(NSString *)apiVersion
           completeSuccessBlock:(void (^ _Nullable) (void))successBlock
              completeFailBlock:(void (^ _Nullable) (NSError *error))failBlock {
    
    NSString *url = [NSString stringWithFormat:HTTP_UPDATE_USER_INFO, HTTP_BASE_URL, appId, roomId, userId];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    switch (type) {
        case EnableSignalTypeChat:
            params[@"enableChat"] = @(enable ? 1 : 0);
            break;
        case EnableSignalTypeAudio:
            params[@"enableAudio"] = @(enable ? 1 : 0);
            break;
        case EnableSignalTypeVideo:
            params[@"enableVideo"] = @(enable ? 1 : 0);
            break;
        case EnableSignalTypeGrantBoard:
            params[@"grantBoard"] = @(enable ? 1 : 0);
            break;
        default:
            break;
    }
    
    [HttpManager post:url params:params headers:nil apiVersion:apiVersion success:^(id responseObj) {
        
        CommonModel *model = [CommonModel yy_modelWithDictionary:responseObj];
        if(model.code == 0) {
            if(successBlock != nil){
                successBlock();
            }
        } else {
            if(failBlock != nil) {
                NSError *error = LocalError(model.code, model.msg);
                failBlock(error);
            }
        }
        
    } failure:^(NSError *error) {
        if(failBlock != nil) {
            failBlock(error);
        }
    }];
}

/// 移交主持人
+ (void)changeHostWithAppId:(NSString *)appId
                     roomId:(NSString *)roomId
                     userId:(NSString *)targetUserId
                 apiVersion:(NSString *)apiVersion
       completeSuccessBlock:(void (^ _Nullable) (void))successBlock
          completeFailBlock:(void (^ _Nullable) (NSError *error))failBlock {
    
    NSString *url = [NSString stringWithFormat:HTTP_CHANGE_HOST, HTTP_BASE_URL, appId, roomId, targetUserId];
    
    [HttpManager post:url params:nil headers:nil apiVersion:apiVersion success:^(id responseObj) {
        
        CommonModel *model = [CommonModel yy_modelWithDictionary:responseObj];
        if(model.code == 0) {
            if(successBlock != nil) {
                successBlock();
            }
        } else {
            if(failBlock != nil) {
                NSError *error = LocalError(model.code, model.msg);
                failBlock(error);
            }
        }
        
    } failure:^(NSError *error) {
        if(failBlock != nil) {
            failBlock(error);
        }
    }];
}

/// 白板共享
+ (void)whiteBoardStateWithValue:(NSInteger)value
                           appId:(NSString *)appId
                          roomId:(NSString *)roomId
                          userId:(NSString *)userId
                      apiVersion:(NSString *)apiVersion
            completeSuccessBlock:(void (^ _Nullable) (void))successBlock
               completeFailBlock:(void (^ _Nullable) (NSError *error))failBlock {
    
    NSString *url = [NSString stringWithFormat:HTTP_BOARD_STATE, HTTP_BASE_URL, appId, roomId, userId];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"state"] = @(value);
             
    [HttpManager post:url params:params headers:nil apiVersion:apiVersion success:^(id responseObj) {
        
        CommonModel *model = [CommonModel yy_modelWithDictionary:responseObj];
        if(model.code == 0) {
            if(successBlock != nil) {
                successBlock();
            }
        } else {
            if(failBlock != nil) {
                NSError *error = LocalError(model.code, model.msg);
                failBlock(error);
            }
        }
        
    } failure:^(NSError *error) {
        if(failBlock != nil) {
            failBlock(error);
        }
    }];
}

+ (void)hostActionWithType:(EnableSignalType)type
                     value:(NSInteger)value
                     appId:(NSString *)appId
                    roomId:(NSString *)roomId
                    userId:(NSString *)userId
                apiVersion:(NSString *)apiVersion
      completeSuccessBlock:(void (^ _Nullable) (void))successBlock
         completeFailBlock:(void (^ _Nullable) (NSError *error))failBlock {
    
    NSString *url = [NSString stringWithFormat:HTTP_HOTS_ACTION, HTTP_BASE_URL, appId, roomId, userId];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    switch (type) {
        case EnableSignalTypeAudio:
            params[@"type"] = @(1);
            break;
        case EnableSignalTypeVideo:
            params[@"type"] = @(2);
            break;
        case EnableSignalTypeGrantBoard:
            params[@"type"] = @(3);
            break;
        default:
            break;
    }
    params[@"action"] = @(value);
            
    [HttpManager post:url params:params headers:nil apiVersion:apiVersion success:^(id responseObj) {
        
        CommonModel *model = [CommonModel yy_modelWithDictionary:responseObj];
        if(model.code == 0) {
            if(successBlock != nil) {
                successBlock();
            }
        } else {
            if(failBlock != nil) {
                NSError *error = LocalError(model.code, model.msg);
                failBlock(error);
            }
        }
        
    } failure:^(NSError *error) {
        if(failBlock != nil) {
            failBlock(error);
        }
    }];
}

+ (void)audienceActionWithType:(EnableSignalType)type
                         value:(NSInteger)value
                         appId:(NSString *)appId
                        roomId:(NSString *)roomId
                        userId:(NSString *)userId
                    apiVersion:(NSString *)apiVersion
          completeSuccessBlock:(void (^ _Nullable) (void))successBlock
             completeFailBlock:(void (^ _Nullable) (NSError *error))failBlock {
    
    NSString *url = [NSString stringWithFormat:HTTP_AUDIENCE_ACTION, HTTP_BASE_URL, appId, roomId, userId];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    switch (type) {
        case EnableSignalTypeAudio:
            params[@"type"] = @(1);
            break;
        case EnableSignalTypeVideo:
            params[@"type"] = @(2);
            break;
        case EnableSignalTypeGrantBoard:
            params[@"type"] = @(3);
            break;
        default:
            break;
    }
    params[@"action"] = @(value);
            
    [HttpManager post:url params:params headers:nil apiVersion:apiVersion success:^(id responseObj) {
        
        CommonModel *model = [CommonModel yy_modelWithDictionary:responseObj];
        if(model.code == 0) {
            if(successBlock != nil) {
                successBlock();
            }
        } else {
            if(failBlock != nil) {
                NSError *error = LocalError(model.code, model.msg);
                failBlock(error);
            }
        }
        
    } failure:^(NSError *error) {
        if(failBlock != nil) {
            failBlock(error);
        }
    }];
}

/// 查询会议室信息
+ (void)getRoomInfoWithAppId:(NSString *)appId
                      roomId:(NSString *)roomId
                  apiVersion:(NSString *)apiVersion
        completeSuccessBlock:(void (^ _Nullable) (id responseModel))successBlock
           completeFailBlock:(void (^ _Nullable) (NSError *error))failBlock {
    
    NSString *url = [NSString stringWithFormat:HTTP_ROOM_INFO, HTTP_BASE_URL, appId, roomId];
    
    [HttpManager get:url params:nil headers:nil apiVersion:apiVersion success:^(id responseObj) {
        NSInteger code = 0;
        NSString *msg = @"";
        id responseModel = nil;
        SceneType sceneType = [HttpManager getSceneType];
        if(sceneType == SceneTypeEducation){
            EduRoomAllModel *model = [EduRoomAllModel yy_modelWithDictionary:responseObj];
            code = model.code;
            msg = model.msg;
            responseModel = model.data;
            
        } else if(sceneType == SceneTypeConference){
            ConfRoomAllModel *model = [ConfRoomAllModel yy_modelWithDictionary:responseObj];
            code = model.code;
            msg = model.msg;
            responseModel = model.data;
        }
        
        if(code == 0) {
            if(successBlock != nil) {
                successBlock(responseModel);
            }
        } else {
            if(failBlock != nil) {
                NSError *error = LocalError(code, msg);
                failBlock(error);
            }
        }
        
    } failure:^(NSError *error) {
        if(failBlock != nil) {
            failBlock(error);
        }
    }];
}

/// 退出会议/主持人踢人
+ (void)leftRoomWithAppId:(NSString *)appId
                   roomId:(NSString *)roomId
                   userId:(NSString *)userId
               apiVersion:(NSString *)apiVersion
             successBolck:(void (^ _Nullable) (void))successBlock
        completeFailBlock:(void (^ _Nullable) (NSError *error))failBlock {
    
    if(appId == nil || roomId == nil) {
        return;
    }
    
    NSString *url = @"";
    if(userId != nil) {
        url = [NSString stringWithFormat:HTTP_CONF_LEFT_ROOM, HTTP_BASE_URL, appId, roomId, userId];
    } else {
        url = [NSString stringWithFormat:HTTP_LEFT_ROOM, HTTP_BASE_URL, appId, roomId];
    }
    
    [HttpManager post:url params:nil headers:nil apiVersion:apiVersion success:^(id responseObj) {
        
        CommonModel *model = [CommonModel yy_modelWithDictionary:responseObj];
        if(model.code == 0){
            if(successBlock != nil){
                successBlock();
            }
        } else {
            if(failBlock != nil) {
                NSError *error = LocalError(model.code, model.msg);
                failBlock(error);
            }
        }
        
    } failure:^(NSError *error) {
        if(failBlock != nil) {
            failBlock(error);
        }
    }];
}

/// 获取日志上报参数 （日志上传的第一步）
+ (void)getLogInfoWithAppId:(NSString *)appId
                     roomId:(NSString *)roomId
                 apiVersion:(NSString *)apiVersion
       completeSuccessBlock:(void (^ _Nullable) (LogParamsInfoModel *model))successBlock
          completeFailBlock:(void (^ _Nullable) (NSError *error))failBlock {
    
    NSString *url = [NSString stringWithFormat:HTTP_LOG_PARAMS, HTTP_BASE_URL];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"appCode"] = [HttpManager appCode];
    params[@"osType"] = @(1);// ios
    
    NSInteger deviceType = 1;
    if (UIUserInterfaceIdiomPhone == [UIDevice currentDevice].userInterfaceIdiom) {
        deviceType = 1;
    } else if(UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom) {
        deviceType = 2;
    }
    params[@"terminalType"] = @(deviceType);
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    params[@"appVersion"] = app_Version;
    
    if(roomId == nil){
        params[@"roomId"] = @"0";
    } else {
        params[@"roomId"] = roomId;
    }
    
    if(appId != nil){
        params[@"appId"] = appId;
    }
    
    [HttpManager get:url params:params headers:nil apiVersion:apiVersion success:^(id responseObj) {
        LogParamsModel *model = [LogParamsModel yy_modelWithDictionary:responseObj];
        if(model.code == 0){
            if(successBlock != nil) {
                successBlock(model.data);
            }
        } else {
            if(failBlock != nil) {
                NSError *error = LocalError(model.code, model.msg);
                failBlock(error);
            }
        }
    } failure:^(NSError *error) {
        if(failBlock != nil) {
            failBlock(error);
        }
    }];
}

/// 获取白板房间
+ (void)getWhiteInfoWithAppId:(NSString *)appId
                       roomId:(NSString *)roomId
                   apiVersion:(NSString *)apiVersion
         completeSuccessBlock:(void (^ _Nullable) (WhiteInfoModel *model))successBlock
            completeFailBlock:(void (^ _Nullable) (NSError *error))failBlock {
    
    NSString *url = [NSString stringWithFormat:HTTP_WHITE_ROOM_INFO, HTTP_BASE_URL, appId, roomId];
    
    [HttpManager get:url params:nil headers:nil apiVersion:apiVersion success:^(id responseObj) {
        
        WhiteModel *model = [WhiteModel yy_modelWithDictionary:responseObj];
        if(model.code == 0) {
            
            if(successBlock != nil) {
                successBlock(model.data);
            }
        } else {
            if(failBlock != nil) {
                NSError *error = LocalError(model.code, model.msg);
                failBlock(error);
            }
        }
    } failure:^(NSError *error) {
        if(failBlock != nil) {
            failBlock(error);
        }
    }];
}

/// 录制 （没用上）
+ (void)getReplayInfoWithAppId:(NSString *)appId
                        roomId:(NSString *)roomId
                      recordId:(NSString *)recordId
                    apiVersion:(NSString *)apiVersion
          completeSuccessBlock:(void (^)(ReplayInfoModel *model))successBlock
             completeFailBlock:(void (^)(NSError *error))failBlock {
    
    NSString *url = [NSString stringWithFormat:HTTP_GET_REPLAY_INFO, HTTP_BASE_URL, appId, roomId, recordId];
    
    [HttpManager get:url params:nil headers:nil apiVersion:apiVersion success:^(id responseObj) {
        
        ReplayModel *model = [ReplayModel yy_modelWithDictionary:responseObj];
        if(model.code == 0) {
            if(successBlock != nil){
                successBlock(model.data);
            }
        } else {
            if(failBlock != nil) {
                NSError *error = LocalError(model.code, model.msg);
                failBlock(error);
            }
        }
    } failure:^(NSError *error) {
        if(failBlock != nil) {
            failBlock(error);
        }
    }];
}

@end
