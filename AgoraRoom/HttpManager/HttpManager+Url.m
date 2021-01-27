//
//  HttpManager+Url.m
//  AgoraRoom
//
//  Created by ZYP on 2021/1/21.
//  Copyright © 2021 agora. All rights reserved.
//

#import "HttpManager+Url.h"

static NSString *_appId = @"";

@implementation HttpManager (Url)

+ (NSString *)baseUrlString {
#if DEBUG
    return [NSString stringWithFormat:@"https://api-test.agora.io/scenario/meeting/apps/%@/v2/", _appId];
#else
    return [NSString stringWithFormat:@"https://api.agora.io/scenario/meeting/apps/%@/v2/", _appId];
#endif
}

/// 创建/加入房间
+ (NSString *)urlAddRoomWitthRoomId:(NSString *)roomId {
    return [NSString stringWithFormat:@"rooms/%@/join", roomId];
}

/// 离开房间
+ (NSString *)urlLeaveRoomWitthRoomId:(NSString *)roomId userId:(NSString *)userId {
    return [NSString stringWithFormat:@"rooms/%@/users/%@/leave", roomId, userId];
}

/// 用户权限更新
+ (NSString *)urlUserPermissionsWitthRoomId:(NSString *)roomId userId:(NSString *)userId {
    return [NSString stringWithFormat:@"rooms/%@/users/%@/userPermissions", roomId, userId];
}

/// 全员关闭摄像头/麦克风
+ (NSString *)urlPermissionCLoseAllWitthRoomId:(NSString *)roomId userId:(NSString *)userId {
    return [NSString stringWithFormat:@"rooms/%@/users/%@/userPermissions/close", roomId, userId];
}

/// 关闭单人摄像头/麦克风
+ (NSString *)urlPermissionCLoseSingleWitthRoomId:(NSString *)roomId userId:(NSString *)userId {
    return [self urlPermissionCLoseAllWitthRoomId:roomId userId:userId];
}

/// 踢人
+ (NSString *)urlKickoutWitthRoomId:(NSString *)roomId userId:(NSString *)userId {
    return [NSString stringWithFormat:@"rooms/%@/users/%@/kickout", roomId, userId];
}

/// 转交主持人
+ (NSString *)urlTransferHostWitthRoomId:(NSString *)roomId userId:(NSString *)userId {
    return [NSString stringWithFormat:@"rooms/%@/users/%@/hosts/transfer", roomId, userId];
}

/// 放弃主持人
+ (NSString *)urlAbandonHostWitthRoomId:(NSString *)roomId userId:(NSString *)userId {
    return [NSString stringWithFormat:@"rooms/%@/users/%@/hosts/bandon", roomId, userId];
}

/// 开始录制
+ (NSString *)urlRecordStartWitthRoomId:(NSString *)roomId userId:(NSString *)userId {
    return [NSString stringWithFormat:@"rooms/%@/users/%@/record/start", roomId, userId];
}

/// 关闭录制
+ (NSString *)urlRecordStopWitthRoomId:(NSString *)roomId userId:(NSString *)userId {
    return [NSString stringWithFormat:@"rooms/%@/users/%@/record/stop", roomId, userId];
}

/// 接受打开摄像头/麦克风的请求
+ (NSString *)urlPermissionAceptWitthRoomId:(NSString *)roomId
                                     userId:(NSString *)userId
                                  requestId:(NSString *)requestId {
    return [NSString stringWithFormat:@"rooms/%@/users/%@/requests/%@/accept", roomId, userId, requestId];
}

/// 拒绝打开摄像头/麦克风的请求
+ (NSString *)urlPermissionRejectWitthRoomId:(NSString *)roomId
                                     userId:(NSString *)userId
                                  requestId:(NSString *)requestId {
    return [NSString stringWithFormat:@"rooms/%@/users/%@/requests/%@/reject", roomId, userId, requestId];
}

/// 申请成为主持人
+ (NSString *)urlHostApplyWitthRoomId:(NSString *)roomId userId:(NSString *)userId {
    return [NSString stringWithFormat:@"rooms/%@/users/%@/hosts/apply", roomId, userId];
}

/// 请求打开摄像头/麦克风
+ (NSString *)urlPermissionApplyWitthRoomId:(NSString *)roomId userId:(NSString *)userId {
    return [NSString stringWithFormat:@"rooms/%@/users/%@/userPermissions/open", roomId, userId];
}

/// 更新会议内的房间信息
+ (NSString *)urlRoomInfoUpdateWithRoomId:(NSString *)roomId {
    return [NSString stringWithFormat:@"rooms/%@", roomId];
}

/// 更新房间内用户信息
+ (NSString *)urlUserInfoUpdateWithRoomId:(NSString *)roomId userId:(NSString *)userId {
    return [NSString stringWithFormat:@"rooms/%@/users/%@", roomId, userId];
}

/// 发起屏幕共享
+ (NSString *)urlShareScreenStartWitthRoomId:(NSString *)roomId userId:(NSString *)userId {
    return [NSString stringWithFormat:@"rooms/%@/users/%@/screen/start", roomId, userId];
}

/// 关闭屏幕共享
+ (NSString *)urlShareScreenStopWitthRoomId:(NSString *)roomId userId:(NSString *)userId {
    return [NSString stringWithFormat:@"rooms/%@/users/%@/screen/stop", roomId, userId];
}

/// 发起白板
+ (NSString *)urlWhiteBoardStartWitthRoomId:(NSString *)roomId userId:(NSString *)userId {
    return [NSString stringWithFormat:@"rooms/%@/users/%@/board/start", roomId, userId];
}

/// 关闭白板
+ (NSString *)urlWhiteBoardStopWitthRoomId:(NSString *)roomId userId:(NSString *)userId {
    return [NSString stringWithFormat:@"rooms/%@/users/%@/board/stop", roomId, userId];
}

/// 申请白板互动
+ (NSString *)urlWhiteBoardInteractWitthRoomId:(NSString *)roomId userId:(NSString *)userId {
    return [NSString stringWithFormat:@"rooms/%@/users/%@/board/interact", roomId, userId];
}

+ (void)setAppId:(NSString *)appId {
    _appId = appId;
}

@end
