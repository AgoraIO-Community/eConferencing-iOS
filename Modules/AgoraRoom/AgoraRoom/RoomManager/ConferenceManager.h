//
//  ConferenceManager.h
//  AgoraRoom
//
//  Created by SRS on 2020/5/19.
//  Copyright © 2020 agora. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RoomManagerDelegate.h"
#import "ConfRoomAllModel.h"
#import "RoomEnum.h"
#import "ConferenceEntryParams.h"

NS_ASSUME_NONNULL_BEGIN

@interface ConferenceManager : NSObject
@property (nonatomic, weak) id<RoomManagerDelegate> delegate;

@property (nonatomic, strong) ConfRoomModel * _Nullable roomModel;
@property (nonatomic, strong) ConfUserModel * _Nullable ownModel;

- (instancetype)initWithSceneType:(SceneType)type appId:(NSString *)appId authorization:(NSString *)authorization;

// entry room
- (void)entryConfRoomWithParams:(ConferenceEntryParams *)params successBolck:(void (^ )(void))successBlock failBlock:(void (^ _Nullable) (NSError *error))failBlock;

// get room info
- (void)getConfRoomInfoWithSuccessBlock:(void (^)(ConfRoomInfoModel *roomInfoModel))successBlock failBlock:(void (^ _Nullable) (NSError *error))failBlock;

//  update room info
- (void)updateRoomInfoWithValue:(BOOL)enable enableSignalType:(ConfEnableRoomSignalType)type successBolck:(void (^)(void))successBlock failBlock:(void (^ _Nullable) (NSError *error))failBlock;

// send message
- (void)sendMessageWithText:(NSString *)message successBolck:(void (^ _Nullable) (void))successBlock completeFailBlock:(void (^ _Nullable) (NSError *error))failBlock;

// upload log
- (void)uploadLogWithSuccessBlock:(void (^ _Nullable) (NSString *uploadSerialNumber))successBlock failBlock:(void (^ _Nullable) (NSError *error))failBlock;

// left room
- (void)leftRoomWithSuccessBolck:(void (^ _Nullable)(void))successBlock failBlock:(void (^ _Nullable) (NSError *error))failBlock;

- (void)releaseResource;
@end

NS_ASSUME_NONNULL_END
