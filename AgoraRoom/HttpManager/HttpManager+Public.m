//
//  HttpManager+Public.m
//  AgoraRoom
//
//  Created by ZYP on 2021/1/11.
//  Copyright © 2021 agora. All rights reserved.
//

#import "HttpManager+Public.h"
#import "HMUserInfo.h"
#import "HMRequestParams.h"
#import "HMResponeParams.h"
#import "HttpManager+Url.h"
#import <YYModel/YYModel.h>
#import "HMRespone.h"
#import "HMError.h"

@implementation HttpManager (Public)

/// 创建/加入房间
+ (void)requestAddRoom:(HMReqParamsAddRoom * _Nonnull)request
               success:(HMSuccessBlockAddRoom _Nullable)success
               failure:(HMFailBlock _Nullable)failure {
    NSString *url = [HttpManager urlAddRoomWitthRoomId:request.roomId];
    NSDictionary *params = [request yy_modelToJSONObject];
    [HttpManager post:url params:params headers:nil success:^(id responeObj) {
        HMRespone *resp = [HMRespone yy_modelWithDictionary:responeObj];
        if(![self checkResp:resp failure:failure]) { return; }
        HMResponeParamsAddRoom *respParams = [HMResponeParamsAddRoom yy_modelWithDictionary:resp.data];
        if(success) { success(respParams); }
    } failure:^(NSError *error) {
        if(error) { failure(error); }
    }];
}

/// 离开房间
+ (void)requestLeaveRoomWithRoomId:(NSString *)roomId
                            userId:(NSString *)userId
                           success:(HMSuccessBlockBool _Nullable)success
                           faulure:(HMFailBlock _Nullable)failure {
    NSString *url = [HttpManager urlLeaveRoomWitthRoomId:roomId userId:userId];
    NSDictionary *params = @{@"roomId": roomId,
                             @"userId": userId};
    [HttpManager post:url params:params headers:nil success:^(id responeObj) {
        HMRespone *resp = [HMRespone yy_modelWithDictionary:responeObj];
        if(![self checkResp:resp failure:failure]) { return; }
        HMResponeParamsBool *respParams  = [HMResponeParamsBool yy_modelWithDictionary:responeObj];
        if(success) { success(respParams.ok); }
    } failure:^(NSError * error) {
        if(error) { failure(error); }
    }];
}

/// 用户权限更新
+ (void)requestUserPermissionsUpdate:(HMReqParamsUserPermissionsAll * _Nonnull)request
                             success:(HMSuccessBlockBool _Nullable)success
                             failure:(HMFailBlock _Nullable)failure {
    NSString *url = [HttpManager urlUserPermissionsWitthRoomId:request.roomId userId:request.userId];
    NSDictionary *params = [request yy_modelToJSONObject];
    [HttpManager post:url params:params headers:nil success:^(id responeObj) {
        HMRespone *resp = [HMRespone yy_modelWithDictionary:responeObj];
        if(![self checkResp:resp failure:failure]) { return; }
        HMResponeParamsBool *respParams = [HMResponeParamsBool yy_modelWithDictionary:resp.data];
        if(success) { success(respParams.ok); }
    } failure:^(NSError *error) {
        if(error) { failure(error); }
    }];
}

/// 全员关闭摄像头/麦克风
+ (void)requestUserPermissionsCloseAll:(HMReqParamsUserPermissionsAll * _Nonnull)request
                               success:(HMSuccessBlockBool _Nullable)success
                               failure:(HMFailBlock _Nullable)failure {
    NSString *url = [HttpManager urlPermissionCLoseAllWitthRoomId:request.roomId userId:request.userId];
    NSDictionary *params = [request yy_modelToJSONObject];
    [HttpManager post:url params:params headers:nil success:^(id responeObj) {
        HMRespone *resp = [HMRespone yy_modelWithDictionary:responeObj];
        if(![self checkResp:resp failure:failure]) { return; }
        HMResponeParamsBool *respParams = [HMResponeParamsBool yy_modelWithDictionary:resp.data];
        if(success) { success(respParams.ok); }
    } failure:^(NSError *error) {
        if(error) { failure(error); }
    }];
}

/// 关闭单人摄像头/麦克风
+ (void)requestUserPermissionsCloseSingle:(HMReqParamsUserPermissionsCloseSingle * _Nonnull)request
                                  success:(HMSuccessBlockBool _Nullable)success
                                  failure:(HMFailBlock _Nullable)failure {
    NSString *url = [HttpManager urlPermissionCLoseAllWitthRoomId:request.roomId userId:request.userId];
    NSDictionary *params = [request yy_modelToJSONObject];
    [HttpManager post:url params:params headers:nil success:^(id responeObj) {
        HMRespone *resp = [HMRespone yy_modelWithDictionary:responeObj];
        if(![self checkResp:resp failure:failure]) { return; }
        HMResponeParamsBool *respParams = [HMResponeParamsBool yy_modelWithDictionary:resp.data];
        if(success) { success(respParams.ok); }
    } failure:^(NSError *error) {
        if(error) { failure(error); }
    }];
}

/// 踢人
+ (void)requestKickout:(HMReqParamsKickout * _Nonnull)request
               success:(HMSuccessBlockBool _Nullable)success
               failure:(HMFailBlock _Nullable)failure {
    NSString *url = [HttpManager urlKickoutWitthRoomId:request.roomId userId:request.userId];
    NSDictionary *params = [request yy_modelToJSONObject];
    [HttpManager post:url params:params headers:nil success:^(id responeObj) {
        HMRespone *resp = [HMRespone yy_modelWithDictionary:responeObj];
        if(![self checkResp:resp failure:failure]) { return; }
        HMResponeParamsBool *respParams = [HMResponeParamsBool yy_modelWithDictionary:resp.data];
        if(success) { success(respParams.ok); }
    } failure:^(NSError *error) {
        if(error) { failure(error); }
    }];
}

/// 转交主持人
+ (void)requestHostTransferWithParam:(HMReqParamsHostTransfer * _Nonnull)param
                             success:(HMSuccessBlockBool _Nullable)success
                             failure:(HMFailBlock _Nullable)failure {
    NSString *url = [HttpManager urlTransferHostWitthRoomId:param.roomId userId:param.userId];
    NSDictionary *paramDict = [param yy_modelToJSONObject];
    [HttpManager post:url params:paramDict headers:nil success:^(id responeObj) {
        HMRespone *resp = [HMRespone yy_modelWithDictionary:responeObj];
        if(![self checkResp:resp failure:failure]) { return; }
        HMResponeParamsBool *respParams = [HMResponeParamsBool yy_modelWithDictionary:resp.data];
        if(success) { success(respParams.ok); }
    } failure:^(NSError *error) {
        if(error) { failure(error); }
    }];
}

/// 放弃主持人
+ (void)requestHostAbandonWithParam:(HMReqParamsHostAbondon * _Nonnull)param
                            success:(HMSuccessBlockBool _Nullable)success
                            failure:(HMFailBlock _Nullable)failure {
    NSString *url = [HttpManager urlAbandonHostWitthRoomId:param.roomId userId:param.userId];
    NSDictionary *paramDict = [param yy_modelToJSONObject];
    [HttpManager post:url params:paramDict headers:nil success:^(id responeObj) {
        HMRespone *resp = [HMRespone yy_modelWithDictionary:responeObj];
        if(![self checkResp:resp failure:failure]) { return; }
        HMResponeParamsBool *respParams = [HMResponeParamsBool yy_modelWithDictionary:resp.data];
        if(success) { success(respParams.ok); }
    } failure:^(NSError *error) {
        if(error) { failure(error); }
    }];
}

/// 开始录制
+ (void)requestRecordStartWithParam:(HMReqParamsRecordStart * _Nonnull)param
                            success:(HMSuccessBlockBool _Nullable)success
                            failure:(HMFailBlock _Nullable)failure {
    NSString *url = [HttpManager urlRecordStartWitthRoomId:param.roomId userId:param.userId];
    NSDictionary *paramDict = [param yy_modelToJSONObject];
    [HttpManager post:url params:paramDict headers:nil success:^(id responeObj) {
        HMRespone *resp = [HMRespone yy_modelWithDictionary:responeObj];
        if(![self checkResp:resp failure:failure]) { return; }
        HMResponeParamsBool *respParams = [HMResponeParamsBool yy_modelWithDictionary:resp.data];
        if(success) { success(respParams.ok); }
    } failure:^(NSError *error) {
        if(error) { failure(error); }
    }];
}

/// 关闭录制
+ (void)requestRecordStopWithParam:(HMReqParamsRecordStop * _Nonnull)param
                           success:(HMSuccessBlockBool _Nullable)success
                           failure:(HMFailBlock _Nullable)failure {
    NSString *url = [HttpManager urlRecordStopWitthRoomId:param.roomId userId:param.userId];
    NSDictionary *paramDict = [param yy_modelToJSONObject];
    [HttpManager post:url params:paramDict headers:nil success:^(id responeObj) {
        HMRespone *resp = [HMRespone yy_modelWithDictionary:responeObj];
        if(![self checkResp:resp failure:failure]) { return; }
        HMResponeParamsBool *respParams = [HMResponeParamsBool yy_modelWithDictionary:resp.data];
        if(success) { success(respParams.ok); }
    } failure:^(NSError *error) {
        if(error) { failure(error); }
    }];
}

/// 接受打开摄像头/麦克风的请求
+ (void)requestUserPermissionsRequestAcceptWitthParam:(HMReqParamsUserPermissionsRequestAccept * _Nonnull)param
                                              success:(HMSuccessBlockBool _Nullable)success
                                              failure:(HMFailBlock _Nullable)failure {
    NSString *url = [HttpManager urlPermissionAceptWitthRoomId:param.roomId userId:param.userId requestId:param.requestId];
    NSDictionary *paramDict = [param yy_modelToJSONObject];
    [HttpManager post:url params:paramDict headers:nil success:^(id responeObj) {
        HMRespone *resp = [HMRespone yy_modelWithDictionary:responeObj];
        if(![self checkResp:resp failure:failure]) { return; }
        HMResponeParamsBool *respParams = [HMResponeParamsBool yy_modelWithDictionary:resp.data];
        if(success) { success(respParams.ok); }
    } failure:^(NSError *error) {
        if(error) { failure(error); }
    }];
}

/// 拒绝打开摄像头/麦克风的请求
+ (void)requestUserPermissionsRequestRejectWitthParam:(HMRequestParamsUserPermissionsRequestReject * _Nonnull)param
                                              success:(HMSuccessBlockBool _Nullable)success
                                              failure:(HMFailBlock _Nullable)failure {
    NSString *url = [HttpManager urlPermissionRejectWitthRoomId:param.roomId userId:param.userId requestId:param.requestId];
    NSDictionary *paramDict = [param yy_modelToJSONObject];
    [HttpManager post:url params:paramDict headers:nil success:^(id responeObj) {
        HMRespone *resp = [HMRespone yy_modelWithDictionary:responeObj];
        if(![self checkResp:resp failure:failure]) { return; }
        HMResponeParamsBool *respParams = [HMResponeParamsBool yy_modelWithDictionary:resp.data];
        if(success) { success(respParams.ok); }
    } failure:^(NSError *error) {
        if(error) { failure(error); }
    }];
}

/// 申请成为主持人 应该叫设为主持人
+ (void)requestHostApplyWithParam:(HMReqParamsHostApply * _Nonnull)param
                          success:(HMSuccessBlockBool _Nullable)success
                          failure:(HMFailBlock _Nullable)failure {
    NSString *url = [HttpManager urlHostApplyWitthRoomId:param.roomId userId:param.userId];
    NSDictionary *paramDict = [param yy_modelToJSONObject];
    [HttpManager post:url params:paramDict headers:nil success:^(id responeObj) {
        HMRespone *resp = [HMRespone yy_modelWithDictionary:responeObj];
        if(![self checkResp:resp failure:failure]) { return; }
        HMResponeParamsBool *respParams = [HMResponeParamsBool yy_modelWithDictionary:resp.data];
        if(success) { success(respParams.ok); }
    } failure:^(NSError *error) {
        if(error) { failure(error); }
    }];
}

/// 请求打开摄像头/麦克风
+ (void)requestPermissionApplyWithParam:(HMRequestParamsPermissionsApply * _Nonnull)param
                                success:(HMSuccessBlockBool _Nullable)success
                                failure:(HMFailBlock _Nullable)failure {
    NSString *url = [HttpManager urlPermissionApplyWitthRoomId:param.roomId userId:param.userId];
    NSDictionary *paramDict = [param yy_modelToJSONObject];
    [HttpManager post:url params:paramDict headers:nil success:^(id responeObj) {
        HMRespone *resp = [HMRespone yy_modelWithDictionary:responeObj];
        if(![self checkResp:resp failure:failure]) { return; }
        HMResponeParamsBool *respParams = [HMResponeParamsBool yy_modelWithDictionary:resp.data];
        if(success) { success(respParams.ok); }
    } failure:^(NSError *error) {
        if(error) { failure(error); }
    }];
}

/// 更新会议内的房间信息
+ (void)requestRoomInfoUpdateWithParam:(HMReqParamsRoomInfoUpdate * _Nonnull)param
                               success:(HMSuccessBlockBool _Nullable)success
                               failure:(HMFailBlock _Nullable)failure {
    NSString *url = [HttpManager urlRoomInfoUpdateWithRoomId:param.roomId];
    NSDictionary *paramDict = [param yy_modelToJSONObject];
    [HttpManager post:url params:paramDict headers:nil success:^(id responeObj) {
        HMRespone *resp = [HMRespone yy_modelWithDictionary:responeObj];
        if(![self checkResp:resp failure:failure]) { return; }
        HMResponeParamsBool *respParams = [HMResponeParamsBool yy_modelWithDictionary:resp.data];
        if(success) { success(respParams.ok); }
    } failure:^(NSError *error) {
        if(error) { failure(error); }
    }];
}

/// 更新房间内用户信息
+ (void)requestUserInfoWithParam:(HMReqParamsUserInfoUpdate * _Nonnull)param
                         success:(HMSuccessBlockBool _Nullable)success
                         failure:(HMFailBlock _Nullable)failure {
    NSString *url = [HttpManager urlUserInfoUpdateWithRoomId:param.roomId userId:param.userId];
    NSDictionary *paramDict = [param yy_modelToJSONObject];
    [HttpManager post:url params:paramDict headers:nil success:^(id responeObj) {
        HMRespone *resp = [HMRespone yy_modelWithDictionary:responeObj];
        if(![self checkResp:resp failure:failure]) { return; }
        HMResponeParamsBool *respParams = [HMResponeParamsBool yy_modelWithDictionary:resp.data];
        if(success) { success(respParams.ok); }
    } failure:^(NSError *error) {
        if(error) { failure(error); }
    }];
}

/// 发起屏幕共享
+ (void)requestScreenShareStartWithParam:(HMReqParamsScreenShareSatrt * _Nonnull)param
                                 success:(HMSuccessBlockBool _Nullable)success
                                 failure:(HMFailBlock _Nullable)failure {
    NSString *url = [HttpManager urlShareScreenStartWitthRoomId:param.roomId userId:param.userId];
    NSDictionary *paramDict = [param yy_modelToJSONObject];
    [HttpManager post:url params:paramDict headers:nil success:^(id responeObj) {
        HMRespone *resp = [HMRespone yy_modelWithDictionary:responeObj];
        if(![self checkResp:resp failure:failure]) { return; }
        HMResponeParamsBool *respParams = [HMResponeParamsBool yy_modelWithDictionary:resp.data];
        if(success) { success(respParams.ok); }
    } failure:^(NSError *error) {
        if(error) { failure(error); }
    }];
}

/// 关闭屏幕共享
+ (void)requestScreenShareStopWithParam:(HMReqScreenShareStop * _Nonnull)param
                                success:(HMSuccessBlockBool _Nullable)success
                                failure:(HMFailBlock _Nullable)failure {
    NSString *url = [HttpManager urlShareScreenStopWitthRoomId:param.roomId userId:param.userId];
    NSDictionary *paramDict = [param yy_modelToJSONObject];
    [HttpManager post:url params:paramDict headers:nil success:^(id responeObj) {
        HMRespone *resp = [HMRespone yy_modelWithDictionary:responeObj];
        if(![self checkResp:resp failure:failure]) { return; }
        HMResponeParamsBool *respParams = [HMResponeParamsBool yy_modelWithDictionary:resp.data];
        if(success) { success(respParams.ok); }
    } failure:^(NSError *error) {
        if(error) { failure(error); }
    }];
}

/// 发起白板
+ (void)requestWhiteBoardStartWithParam:(HMReqParamsParamsWihleBoardStart * _Nonnull)param
                                success:(HMSuccessBlockBool _Nullable)success
                                failure:(HMFailBlock _Nullable)failure {
    NSString *url = [HttpManager urlWhiteBoardStartWitthRoomId:param.roomId userId:param.userId];
    NSDictionary *paramDict = [param yy_modelToJSONObject];
    [HttpManager post:url params:paramDict headers:nil success:^(id responeObj) {
        HMRespone *resp = [HMRespone yy_modelWithDictionary:responeObj];
        if(![self checkResp:resp failure:failure]) { return; }
        HMResponeParamsBool *respParams = [HMResponeParamsBool yy_modelWithDictionary:resp.data];
        if(success) { success(respParams.ok); }
    } failure:^(NSError *error) {
        if(error) { failure(error); }
    }];
}

/// 关闭白板
+ (void)requestWhiteBoardStopWithParam:(HMReqParamsWihleBoardStop * _Nonnull)param
                               success:(HMSuccessBlockBool _Nullable)success
                               failure:(HMFailBlock _Nullable)failure {
    NSString *url = [HttpManager urlWhiteBoardStopWitthRoomId:param.roomId userId:param.userId];
    NSDictionary *paramDict = [param yy_modelToJSONObject];
    [HttpManager post:url params:paramDict headers:nil success:^(id responeObj) {
        HMRespone *resp = [HMRespone yy_modelWithDictionary:responeObj];
        if(![self checkResp:resp failure:failure]) { return; }
        HMResponeParamsBool *respParams = [HMResponeParamsBool yy_modelWithDictionary:resp.data];
        if(success) { success(respParams.ok); }
    } failure:^(NSError *error) {
        if(error) { failure(error); }
    }];
}

/// 申请白板互动
+ (void)requestWhiteBoardInteractWithParam:(HMReqParamsWihleBoardInteract * _Nonnull)param
                                   success:(HMSuccessBlockBool _Nullable)success
                                   failure:(HMFailBlock _Nullable)failure {
    NSString *url = [HttpManager urlWhiteBoardInteractWitthRoomId:param.roomId userId:param.userId];
    NSDictionary *paramDict = [param yy_modelToJSONObject];
    [HttpManager post:url params:paramDict headers:nil success:^(id responeObj) {
        HMRespone *resp = [HMRespone yy_modelWithDictionary:responeObj];
        if(![self checkResp:resp failure:failure]) { return; }
        HMResponeParamsBool *respParams = [HMResponeParamsBool yy_modelWithDictionary:resp.data];
        if(success) { success(respParams.ok); }
    } failure:^(NSError *error) {
        if(error) { failure(error); }
    }];
}


/// 获取RTMToken (私有)

@end
