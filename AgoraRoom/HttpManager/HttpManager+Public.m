//
//  HttpManager+Public.m
//  AgoraRoom
//
//  Created by ZYP on 2021/1/11.
//  Copyright © 2021 agora. All rights reserved.
//

#import "HttpManager+Public.h"
#import <YYModel/YYModel.h>
#import <UIKit/UIKit.h>
#import "URL.h"
#import "HMAppInfo.h"
#import "HMHttpResp.h"
#import "HMRoomInfo.h"
#import "HMEmtryParams.h"
#import "HMHttpHeader1.h"
#import "HMUsers.h"
#import "HMLogParams.h"
#import "HMWhiteInfo.h"

@implementation HttpManager (Public)

+ (void)getConfigWithApiVersion:(NSString *)apiVersion
                   successBolck:(void (^ _Nullable) (HMAppInfo *model))successBlock
                      failBlock:(void (^ _Nullable) (NSError *error))failBlock {
    
    NSInteger deviceType = 0;
    if (UIUserInterfaceIdiomPhone == [UIDevice currentDevice].userInterfaceIdiom) {
        deviceType = 1;
    } else if(UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom) {
        deviceType = 2;
    }
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    
    NSDictionary *params = @{
        @"appCode" : [HttpManager appCode],
        @"osType" : @(1),// 1.ios 2.android
        @"terminalType" : @(deviceType),//1.phone 2.pad
        @"appVersion" : app_Version
    };
    
    NSString *url = [NSString stringWithFormat:HTTP_GET_CONFIG, HTTP_BASE_URL];
    [HttpManager get:url
              params:params
             headers:nil
          apiVersion:apiVersion
             success:^(id responseObj) {
        
        HMHttpResp *resp = [HMHttpResp yy_modelWithDictionary:responseObj];
        HMAppInfo *appInfo = [HMAppInfo yy_modelWithDictionary:resp.data];
        
        if(resp.code == 0) {
            if(successBlock != nil){
                successBlock(appInfo);
            }
        } else {
            if(failBlock != nil) {
                NSError *error = LocalError(resp.code, resp.msg);
                failBlock(error);
            }
        }
    } failure:^(NSError *error) {
        if(failBlock != nil) {
            failBlock(error);
        }
    }];
}

+ (void)enterRoomWithAppId:(NSString *)appId
                apiVersion:(NSString *)apiVersion
                    params:(HMEmtryParams *)params
              successBolck:(void (^ _Nullable) (HMRoomInfo *model))successBlock
                 failBlock:(void (^ _Nullable) (NSError *error))failBlock {
    
    NSMutableDictionary *dicParams = [NSMutableDictionary dictionary];
    
    dicParams[@"userName"] = params.userName;
    dicParams[@"userUuid"] = params.userUuid;
    dicParams[@"roomName"] = params.roomName;
    dicParams[@"roomUuid"] = params.roomUuid;
    dicParams[@"password"] = params.password;
    dicParams[@"enableVideo"] = @(params.enableVideo).stringValue;
    dicParams[@"enableAudio"] = @(params.enableAudio).stringValue;
    dicParams[@"avatar"] = params.avatar;
    
    NSString *url = [NSString stringWithFormat:HTTP_ENTER_ROOM1, HTTP_BASE_URL];
    url = [NSString stringWithFormat:HTTP_ENTER_ROOM2, HTTP_BASE_URL, appId];
    
    [HttpManager post:url params:dicParams headers:nil apiVersion:apiVersion success:^(id responseObj) {
        
        HMHttpResp *resp = [HMHttpResp yy_modelWithDictionary:responseObj];
        HMRoomInfo *info = [HMRoomInfo yy_modelWithDictionary:resp.data];
        
        if (resp.code == 0) {
            HMHttpHeader1 *header1 = [HMHttpHeader1 new];
            header1.userToken = info.user.userToken;
            header1.agoraToken = info.user.rtmToken;
            header1.agoraUId = @(info.user.uid).stringValue;
            
            [HttpManager saveHttpHeader1:header1];
            
            if(successBlock != nil){
                successBlock(info);
            }
        } else {
            if(failBlock != nil) {
                NSError *error = LocalError(resp.code, resp.msg);
                failBlock(error);
            }
        }
        
    } failure:^(NSError *error) {
        if(failBlock != nil) {
            failBlock(error);
        }
    }];
}

+ (void)sendMessageWithType:(HMMessageType)messageType
                      appId:(NSString *)appId
                     roomId:(NSString *)roomId
                    message:(NSString *)message
                 apiVersion:(NSString *)apiVersion
               successBolck:(void (^ _Nullable) (void))successBlock
                  failBlock:(void (^ _Nullable) (NSError *error))failBlock {
    NSString *url = [NSString stringWithFormat:HTTP_USER_INSTANT_MESSAGE, HTTP_BASE_URL, appId, roomId];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"type"] = @(messageType);
    params[@"message"] = message;
    
    [HttpManager post:url params:params headers:nil apiVersion:apiVersion success:^(id responseObj) {
        HMHttpResp *resp = [HMHttpResp yy_modelWithDictionary:responseObj];
        if(resp.code == 0){
            if(successBlock != nil){
                successBlock();
            }
        } else {
            if(failBlock != nil) {
                NSError *error = LocalError(resp.code, resp.msg);
                failBlock(error);
            }
        }
    } failure:^(NSError *error) {
        if(failBlock != nil) {
            failBlock(error);
        }
    }];
}

+ (void)sendCoVideoWithType:(HMSignalLinkState)linkState
                      appId:(NSString *)appId
                     roomId:(NSString *)roomId
                    userIds:(NSArray<NSString *> *)userIds
                 apiVersion:(NSString *)apiVersion
               successBolck:(void (^ _Nullable) (void))successBlock
                  failBlock:(void (^ _Nullable) (NSError *error))failBlock {
    
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
        HMHttpResp *resp = [HMHttpResp yy_modelWithDictionary:responseObj];
        if(resp.code == 0){
            if(successBlock != nil){
                successBlock();
            }
        } else {
            if(failBlock != nil) {
                NSError *error = LocalError(resp.code, resp.msg);
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
               enableSignalType:(HMConfEnableRoomSignalType)type
                          appId:(NSString *)appId
                         roomId:(NSString *)roomId
                     apiVersion:(NSString *)apiVersion
                   successBlock:(void (^ _Nullable) (void))successBlock
                      failBlock:(void (^ _Nullable) (NSError *error))failBlock {
    
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
    
    [HttpManager post:url
               params:params
              headers:nil
           apiVersion:apiVersion
              success:^(id responseObj) {
        HMHttpResp *resp = [HMHttpResp yy_modelWithDictionary:responseObj];
        if(resp.code == 0) {
            if(successBlock != nil) {
                successBlock();
            }
        } else {
            if(failBlock != nil) {
                NSError *error = LocalError(resp.code, resp.msg);
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
+ (void)getUserListWithRole:(HMConfRoleType)role
                     nextId:(NSString *)nextId
                      count:(NSInteger)count
                      appId:(NSString *)appId
                     roomId:(NSString *)roomId
                 apiVersion:(NSString *)apiVersion
               successBlock:(void (^)(HMUsers *userListModel))successBlock
                  failBlock:(void (^ _Nullable) (NSError *error))failBlock {
    
    NSString *url = [NSString stringWithFormat:HTTP_USER_LIST_INFO, HTTP_BASE_URL, appId, roomId];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"role"] = @(role);
    params[@"nextId"] = nextId;
    params[@"count"] = @(count);
    [HttpManager get:url params:params headers:nil apiVersion:apiVersion success:^(id responseObj) {
        HMHttpResp *resp = [HMHttpResp yy_modelWithDictionary:responseObj];
        HMUsers *info = [HMUsers yy_modelWithDictionary:resp.data];
        if(resp.code == 0) {
            if(successBlock != nil){
                successBlock(info);
            }
        } else {
            if(failBlock != nil) {
                NSError *error = LocalError(resp.code, resp.msg);
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
               enableSignalType:(HMEnableSignalType)type
                          appId:(NSString *)appId
                         roomId:(NSString *)roomId
                         userId:(NSString *)userId
                     apiVersion:(NSString *)apiVersion
                   successBlock:(void (^ _Nullable) (void))successBlock
                      failBlock:(void (^ _Nullable) (NSError *error))failBlock {
    
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
        HMHttpResp *resp = [HMHttpResp yy_modelWithDictionary:responseObj];
        if(resp.code == 0) {
            if(successBlock != nil){
                successBlock();
            }
        } else {
            if(failBlock != nil) {
                NSError *error = LocalError(resp.code, resp.msg);
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
               successBlock:(void (^ _Nullable) (void))successBlock
                  failBlock:(void (^ _Nullable) (NSError *error))failBlock {
    
    NSString *url = [NSString stringWithFormat:HTTP_CHANGE_HOST, HTTP_BASE_URL, appId, roomId, targetUserId];
    
    [HttpManager post:url params:nil headers:nil apiVersion:apiVersion success:^(id responseObj) {
        
        HMHttpResp *resp = [HMHttpResp yy_modelWithDictionary:responseObj];
        if(resp.code == 0) {
            if(successBlock != nil) {
                successBlock();
            }
        } else {
            if(failBlock != nil) {
                NSError *error = LocalError(resp.code, resp.msg);
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
                    successBlock:(void (^ _Nullable) (void))successBlock
                       failBlock:(void (^ _Nullable) (NSError *error))failBlock {
    
    NSString *url = [NSString stringWithFormat:HTTP_BOARD_STATE, HTTP_BASE_URL, appId, roomId, userId];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"state"] = @(value);
             
    [HttpManager post:url params:params headers:nil apiVersion:apiVersion success:^(id responseObj) {
        HMHttpResp *resp = [HMHttpResp yy_modelWithDictionary:responseObj];
        if(resp.code == 0) {
            if(successBlock != nil) {
                successBlock();
            }
        } else {
            if(failBlock != nil) {
                NSError *error = LocalError(resp.code, resp.msg);
                failBlock(error);
            }
        }
        
    } failure:^(NSError *error) {
        if(failBlock != nil) {
            failBlock(error);
        }
    }];
}

+ (void)hostActionWithType:(HMEnableSignalType)type
                     value:(NSInteger)value
                     appId:(NSString *)appId
                    roomId:(NSString *)roomId
                    userId:(NSString *)userId
                apiVersion:(NSString *)apiVersion
              successBlock:(void (^ _Nullable) (void))successBlock
                 failBlock:(void (^ _Nullable) (NSError *error))failBlock {
    
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
        HMHttpResp *resp = [HMHttpResp yy_modelWithDictionary:responseObj];
        if(resp.code == 0) {
            if(successBlock != nil) {
                successBlock();
            }
        } else {
            if(failBlock != nil) {
                NSError *error = LocalError(resp.code, resp.msg);
                failBlock(error);
            }
        }
    } failure:^(NSError *error) {
        if(failBlock != nil) {
            failBlock(error);
        }
    }];
}

+ (void)audienceActionWithType:(HMEnableSignalType)type
                         value:(NSInteger)value
                         appId:(NSString *)appId
                        roomId:(NSString *)roomId
                        userId:(NSString *)userId
                    apiVersion:(NSString *)apiVersion
                  successBlock:(void (^ _Nullable) (void))successBlock
                     failBlock:(void (^ _Nullable) (NSError *error))failBlock {
    
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
        HMHttpResp *resp = [HMHttpResp yy_modelWithDictionary:responseObj];
        if(resp.code == 0) {
            if(successBlock != nil) {
                successBlock();
            }
        } else {
            if(failBlock != nil) {
                NSError *error = LocalError(resp.code, resp.msg);
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
                successBlock:(void (^ _Nullable) (id responseModel))successBlock
                   failBlock:(void (^ _Nullable) (NSError *error))failBlock {
    
    NSString *url = [NSString stringWithFormat:HTTP_ROOM_INFO, HTTP_BASE_URL, appId, roomId];
    
    [HttpManager get:url params:nil headers:nil apiVersion:apiVersion success:^(id responseObj) {
        HMHttpResp *resp = [HMHttpResp yy_modelWithDictionary:responseObj];
        HMRoomInfoLocal *info = [HMRoomInfoLocal yy_modelWithDictionary:resp.data];
        if(resp.code == 0) {
            if(successBlock != nil) {
                successBlock(info);
            }
        } else {
            if(failBlock != nil) {
                NSError *error = LocalError(resp.code, resp.msg);
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
                failBlock:(void (^ _Nullable) (NSError *error))failBlock {
    
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
        HMHttpResp *resp = [HMHttpResp yy_modelWithDictionary:responseObj];
        if(resp.code == 0){
            if(successBlock != nil){
                successBlock();
            }
        } else {
            if(failBlock != nil) {
                NSError *error = LocalError(resp.code, resp.msg);
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
               successBlock:(void (^ _Nullable) (HMLogParams *model))successBlock
                  failBlock:(void (^ _Nullable) (NSError *error))failBlock {
    
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
        HMHttpResp *resp = [HMHttpResp yy_modelWithDictionary:responseObj];
        if(resp.code == 0){
            if(successBlock != nil) {
                successBlock(resp.data);
            }
        } else {
            if(failBlock != nil) {
                NSError *error = LocalError(resp.code, resp.msg);
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
                 successBlock:(void (^ _Nullable) (HMWhiteInfo *model))successBlock
                    failBlock:(void (^ _Nullable) (NSError *error))failBlock {
    
    NSString *url = [NSString stringWithFormat:HTTP_WHITE_ROOM_INFO, HTTP_BASE_URL, appId, roomId];
    
    [HttpManager get:url params:nil headers:nil apiVersion:apiVersion success:^(id responseObj) {
        HMHttpResp *resp = [HMHttpResp yy_modelWithDictionary:responseObj];
        HMWhiteInfo *info = [HMWhiteInfo yy_modelWithDictionary:resp.data];
        if(resp.code == 0) {
            if(successBlock != nil) {
                successBlock(info);
            }
        } else {
            if(failBlock != nil) {
                NSError *error = LocalError(resp.code, resp.msg);
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
