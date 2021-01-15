//
//  HttpManager+Public.h
//  AgoraRoom
//
//  Created by ZYP on 2021/1/11.
//  Copyright © 2021 agora. All rights reserved.
//

#import "HttpManager.h"
#import "HMAppInfo.h"
#import "HMHttpResp.h"
#import "HMRoomInfo.h"
#import "HMEmtryParams.h"
#import "HMHttpHeader1.h"
#import "HMUsers.h"
#import "HMLogParams.h"
#import "HMWhiteInfo.h"

typedef NS_ENUM(NSUInteger, HMMessageType) {
    MessageTypeText = 1,
};

typedef NS_ENUM(NSInteger, HMSignalLinkState) {
    SignalLinkStateIdle             = 0,
    SignalLinkStateApply            = 1,
    SignalLinkStateTeaReject        = 2,
    SignalLinkStateStuCancel        = 3, // Cancel Apply
    SignalLinkStateTeaAccept        = 4, // linked
    SignalLinkStateTeaClose         = 5, // teacher close link
    SignalLinkStateStuClose         = 6, // student close link
};

typedef NS_ENUM(NSInteger, HMConfEnableRoomSignalType) {
    ConfEnableRoomSignalTypeMuteAllChat,
    ConfEnableRoomSignalTypeMuteAllAudio,
    ConfEnableRoomSignalTypeState,
    ConfEnableRoomSignalTypeShareBoard,
};

typedef NS_ENUM(NSUInteger, HMConfRoleType) {
    ConfRoleTypeHost = 1,
    ConfRoleTypeParticipant = 2,
};

typedef NS_ENUM(NSInteger, HMEnableSignalType) {
    EnableSignalTypeVideo,
    EnableSignalTypeAudio,
    EnableSignalTypeChat,
    EnableSignalTypeGrantBoard,
};

NS_ASSUME_NONNULL_BEGIN

@interface HttpManager (Public)

+ (void)getConfigWithApiVersion:(NSString *)apiVersion
                   successBolck:(void (^ _Nullable) (HMAppInfo *model))successBlock
                      failBlock:(void (^ _Nullable) (NSError *error))failBlock;

+ (void)enterRoomWithAppId:(NSString *)appId
                apiVersion:(NSString *)apiVersion
                    params:(HMEmtryParams *)params
              successBolck:(void (^ _Nullable) (HMRoomInfo *model))successBlock
                 failBlock:(void (^ _Nullable) (NSError *error))failBlock;

+ (void)sendMessageWithType:(HMMessageType)messageType
                      appId:(NSString *)appId
                     roomId:(NSString *)roomId
                    message:(NSString *)message
                 apiVersion:(NSString *)apiVersion
               successBolck:(void (^ _Nullable) (void))successBlock
                  failBlock:(void (^ _Nullable) (NSError *error))failBlock;

+ (void)sendCoVideoWithType:(HMSignalLinkState)linkState
                      appId:(NSString *)appId
                     roomId:(NSString *)roomId
                    userIds:(NSArray<NSString *> *)userIds
                 apiVersion:(NSString *)apiVersion
               successBolck:(void (^ _Nullable) (void))successBlock
                  failBlock:(void (^ _Nullable) (NSError *error))failBlock;

/// 修改会议室信息
+ (void)updateRoomInfoWithValue:(NSInteger)value
               enableSignalType:(HMConfEnableRoomSignalType)type
                          appId:(NSString *)appId
                         roomId:(NSString *)roomId
                     apiVersion:(NSString *)apiVersion
                   successBlock:(void (^ _Nullable) (void))successBlock
                      failBlock:(void (^ _Nullable) (NSError *error))failBlock;

/// 查询观众列表
+ (void)getUserListWithRole:(HMConfRoleType)role
                     nextId:(NSString *)nextId
                      count:(NSInteger)count
                      appId:(NSString *)appId
                     roomId:(NSString *)roomId
                 apiVersion:(NSString *)apiVersion
               successBlock:(void (^)(HMUsers *userListModel))successBlock
                  failBlock:(void (^ _Nullable) (NSError *error))failBlock;

/// 修改会议室用户信息
+ (void)updateUserInfoWithValue:(BOOL)enable
               enableSignalType:(HMEnableSignalType)type
                          appId:(NSString *)appId
                         roomId:(NSString *)roomId
                         userId:(NSString *)userId
                     apiVersion:(NSString *)apiVersion
                   successBlock:(void (^ _Nullable) (void))successBlock
                      failBlock:(void (^ _Nullable) (NSError *error))failBlock;

/// 移交主持人
+ (void)changeHostWithAppId:(NSString *)appId
                     roomId:(NSString *)roomId
                     userId:(NSString *)targetUserId
                 apiVersion:(NSString *)apiVersion
               successBlock:(void (^ _Nullable) (void))successBlock
                  failBlock:(void (^ _Nullable) (NSError *error))failBlock;

/// 白板共享
+ (void)whiteBoardStateWithValue:(NSInteger)value
                           appId:(NSString *)appId
                          roomId:(NSString *)roomId
                          userId:(NSString *)userId
                      apiVersion:(NSString *)apiVersion
                    successBlock:(void (^ _Nullable) (void))successBlock
                       failBlock:(void (^ _Nullable) (NSError *error))failBlock;

+ (void)hostActionWithType:(HMEnableSignalType)type
                     value:(NSInteger)value
                     appId:(NSString *)appId
                    roomId:(NSString *)roomId
                    userId:(NSString *)userId
                apiVersion:(NSString *)apiVersion
              successBlock:(void (^ _Nullable) (void))successBlock
                 failBlock:(void (^ _Nullable) (NSError *error))failBlock;

+ (void)audienceActionWithType:(HMEnableSignalType)type
                         value:(NSInteger)value
                         appId:(NSString *)appId
                        roomId:(NSString *)roomId
                        userId:(NSString *)userId
                    apiVersion:(NSString *)apiVersion
                  successBlock:(void (^ _Nullable) (void))successBlock
                     failBlock:(void (^ _Nullable) (NSError *error))failBlock;

/// 查询会议室信息
+ (void)getRoomInfoWithAppId:(NSString *)appId
                      roomId:(NSString *)roomId
                  apiVersion:(NSString *)apiVersion
                successBlock:(void (^ _Nullable) (id responseModel))successBlock
                   failBlock:(void (^ _Nullable) (NSError *error))failBlock;

/// 退出会议/主持人踢人
+ (void)leftRoomWithAppId:(NSString *)appId
                   roomId:(NSString *)roomId
                   userId:(NSString *)userId
               apiVersion:(NSString *)apiVersion
             successBolck:(void (^ _Nullable) (void))successBlock
                failBlock:(void (^ _Nullable) (NSError *error))failBlock;

/// 获取日志上报参数 （日志上传的第一步）
+ (void)getLogInfoWithAppId:(NSString *)appId
                     roomId:(NSString *)roomId
                 apiVersion:(NSString *)apiVersion
               successBlock:(void (^ _Nullable) (HMLogParams *model))successBlock
                  failBlock:(void (^ _Nullable) (NSError *error))failBlock;

/// 获取白板房间
+ (void)getWhiteInfoWithAppId:(NSString *)appId
                       roomId:(NSString *)roomId
                   apiVersion:(NSString *)apiVersion
                 successBlock:(void (^ _Nullable) (HMWhiteInfo *model))successBlock
                    failBlock:(void (^ _Nullable) (NSError *error))failBlock;

@end

NS_ASSUME_NONNULL_END
