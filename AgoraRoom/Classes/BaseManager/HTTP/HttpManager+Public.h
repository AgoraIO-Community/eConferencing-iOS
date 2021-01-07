//
//  HttpManager+Public.h
//  AgoraRoom
//
//  Created by ADMIN on 2020/12/10.
//  Copyright © 2020 agora. All rights reserved.
//

#import "HttpManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface HttpManager (Public)

/// 获取app版本配置
+ (void)getConfigWithApiVersion:(NSString *)apiVersion
                   successBolck:(void (^ _Nullable) (ConfigAllInfoModel * model))successBlock
              completeFailBlock:(void (^ _Nullable) (NSError *error))failBlock;

/// 进入会议室
+ (void)enterRoomWithParams:(EntryParams *)params
                      appId:(NSString *)appId
                 apiVersion:(NSString *)apiVersion
               successBolck:(void (^ _Nullable) (EnterRoomInfoModel *model))successBlock
          completeFailBlock:(void (^ _Nullable) (NSError *error))failBlock;

/// 即时聊天
+ (void)sendMessageWithType:(MessageType)messageType
                      appId:(NSString *)appId
                     roomId:(NSString *)roomId
                    message:(NSString *)message
                 apiVersion:(NSString *)apiVersion
               successBolck:(void (^ _Nullable) (void))successBlock
          completeFailBlock:(void (^ _Nullable) (NSError *error))failBlock;

/// 连麦操作 （教育场景）
+ (void)sendCoVideoWithType:(SignalLinkState)linkState
                      appId:(NSString *)appId
                     roomId:(NSString *)roomId
                    userIds:(NSArray<NSString *> *)userIds
                 apiVersion:(NSString *)apiVersion
               successBolck:(void (^ _Nullable) (void))successBlock
          completeFailBlock:(void (^ _Nullable) (NSError *error))failBlock;

/// 修改会议室信息
+ (void)updateRoomInfoWithValue:(NSInteger)value
               enableSignalType:(ConfEnableRoomSignalType)type
                          appId:(NSString *)appId
                         roomId:(NSString *)roomId
                     apiVersion:(NSString *)apiVersion
           completeSuccessBlock:(void (^ _Nullable) (void))successBlock
              completeFailBlock:(void (^ _Nullable) (NSError *error))failBlock;

/// 查询观众列表
+ (void)getUserListWithRole:(ConfRoleType)role
                     nextId:(NSString *)nextId
                      count:(NSInteger)count
                      appId:(NSString *)appId
                     roomId:(NSString *)roomId
                 apiVersion:(NSString *)apiVersion
               successBlock:(void (^)(ConfUserListInfoModel *userListModel))successBlock
                  failBlock:(void (^ _Nullable) (NSError *error))failBlock;

/// 修改会议室用户信息
+ (void)updateUserInfoWithValue:(BOOL)enable
               enableSignalType:(EnableSignalType)type
                          appId:(NSString *)appId
                         roomId:(NSString *)roomId
                         userId:(NSString *)byUserId
                     apiVersion:(NSString *)apiVersion
           completeSuccessBlock:(void (^ _Nullable) (void))successBlock
              completeFailBlock:(void (^ _Nullable) (NSError *error))failBlock;

/// 移交主持人
+ (void)changeHostWithAppId:(NSString *)appId
                     roomId:(NSString *)roomId
                     userId:(NSString *)userId
                 apiVersion:(NSString *)apiVersion
       completeSuccessBlock:(void (^ _Nullable) (void))successBlock
          completeFailBlock:(void (^ _Nullable) (NSError *error))failBlock;

/// 白板共享
+ (void)whiteBoardStateWithValue:(NSInteger)value
                           appId:(NSString *)appId
                          roomId:(NSString *)roomId
                          userId:(NSString *)targetUserId
                      apiVersion:(NSString *)apiVersion
            completeSuccessBlock:(void (^ _Nullable) (void))successBlock
               completeFailBlock:(void (^ _Nullable) (NSError *error))failBlock;


/// 审批人邀请/拒绝操作 value：1=邀请 2=拒绝
+ (void)hostActionWithType:(EnableSignalType)type
                     value:(NSInteger)value
                     appId:(NSString *)appId
                    roomId:(NSString *)roomId
                    userId:(NSString *)userId
                apiVersion:(NSString *)apiVersion
      completeSuccessBlock:(void (^ _Nullable) (void))successBlock
         completeFailBlock:(void (^ _Nullable) (NSError *error))failBlock;

/// 申请人申请/拒绝操作 value：1=申请 2=拒绝
+ (void)audienceActionWithType:(EnableSignalType)type
                         value:(NSInteger)value
                         appId:(NSString *)appId
                        roomId:(NSString *)roomId
                        userId:(NSString *)userId
                    apiVersion:(NSString *)apiVersion
          completeSuccessBlock:(void (^ _Nullable) (void))successBlock
             completeFailBlock:(void (^ _Nullable) (NSError *error))failBlock;

/// 查询会议室信息
+ (void)getRoomInfoWithAppId:(NSString *)appId
                      roomId:(NSString *)roomId
                  apiVersion:(NSString *)apiVersion
        completeSuccessBlock:(void (^ _Nullable) (id responseModel))successBlock
           completeFailBlock:(void (^ _Nullable) (NSError *error))failBlock;

/// 退出会议/主持人踢人
+ (void)leftRoomWithAppId:(NSString *)appId
                   roomId:(NSString *)roomId
                   userId:(NSString *)userId
               apiVersion:(NSString *)apiVersion
             successBolck:(void (^ _Nullable) (void))successBlock
        completeFailBlock:(void (^ _Nullable) (NSError *error))failBlock;

/// 获取日志上报参数 （日志上传的第一步）
+ (void)getLogInfoWithAppId:(NSString *)appId
                     roomId:(NSString *)roomId
                 apiVersion:(NSString *)apiVersion
       completeSuccessBlock:(void (^ _Nullable) (LogParamsInfoModel * model))successBlock
          completeFailBlock:(void (^ _Nullable) (NSError *error))failBlock;

/// 获取白板房间
+ (void)getWhiteInfoWithAppId:(NSString *)appId
                       roomId:(NSString *)roomId
                   apiVersion:(NSString *)apiVersion
         completeSuccessBlock:(void (^ _Nullable) (WhiteInfoModel *model))successBlock
            completeFailBlock:(void (^ _Nullable) (NSError *error))failBlock;

// repaly
+ (void)getReplayInfoWithAppId:(NSString *)appId
                        roomId:(NSString *)roomId
                      recordId:(NSString *)recordId
                    apiVersion:(NSString *)apiVersion
          completeSuccessBlock:(void (^)(ReplayInfoModel *model))successBlock
             completeFailBlock:(void (^)(NSError *error))failBlock;

@end

NS_ASSUME_NONNULL_END
