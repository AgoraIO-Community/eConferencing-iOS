//
//  RoomManager.h
//  AgoraEdu
//
//  Created by SRS on 2020/5/5.
//  Copyright © 2020 agora. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SignalShareScreenModel.h"
#import "RoomManagerDelegate.h"
#import "WhiteModel.h"
#import "ReplayModel.h"

#import "EduRoomAllModel.h"
#import "ConfRoomAllModel.h"

#import "EduSaaSEntryParams.h"
#import "EduEntryParams.h"
#import "ConferenceEntryParams.h"
#import "BaseConfigModel.h"
#import "RoomEnum.h"
#import "ConfUserListInfoModel.h"

#define WEAK(object) __weak typeof(object) weak##object = object

#define APIVersion1 @"v1"
#define APIVersion2 @"v2"

NS_ASSUME_NONNULL_BEGIN

@interface RoomManager : NSObject

@property (nonatomic, weak) id<RoomManagerDelegate> delegate;

@property (nonatomic, strong) EduRoomModel * _Nullable roomModel;
@property (nonatomic, strong) NSArray<EduUserModel*> *coUserModels;

@property (nonatomic, strong) EduUserModel * _Nullable hostModel;
@property (nonatomic, strong) EduUserModel * _Nullable ownModel;
@property (nonatomic, strong) SignalShareScreenInfoModel * _Nullable shareScreenInfoModel;

- (instancetype)initWithSceneType:(SceneType)type appId:(NSString *)appId authorization:(NSString *)authorization configModel:(BaseConfigModel *)configModel;

// entry room
- (void)enterRoomProcess:(EntryParams *)params configApiVersion:(NSString*)configApiVersion entryApiVersion:(NSString*)entryApiVersion roomInfoApiVersion:(NSString*)roomInfoApiVersion successBolck:(void (^)(id roomInfoModel))successBlock failBlock:(void (^ _Nullable) (NSError *error))failBlock;

// init media
- (void)initMediaWithClientRole:(ClientRole)role successBolck:(void (^)(void))successBlock failBlock:(void (^ _Nullable) (NSInteger errorCode))failBlock;

// get room info
- (void)getRoomInfoWithApiversion:(NSString *)apiversion successBlock:(void (^)(id roomInfoModel))successBlock failBlock:(void (^ _Nullable) (NSError *error))failBlock;

//  update room info
- (void)updateRoomInfoWithValue:(BOOL)enable enableSignalType:(ConfEnableRoomSignalType)type apiversion:(NSString *)apiversion successBolck:(void (^)(void))successBlock failBlock:(void (^ _Nullable) (NSError *error))failBlock;

// send message
- (void)sendMessageWithText:(NSString *)message apiversion:(NSString *)apiversion successBolck:(void (^ _Nullable) (void))successBlock completeFailBlock:(void (^ _Nullable) (NSError *error))failBlock;

- (void)getUserListWithNextId:(NSString *)nextId count:(NSInteger)count apiversion:(NSString *)apiversion successBlock:(void (^)(ConfUserListInfoModel *userListModel))successBlock failBlock:(void (^ _Nullable) (NSError *error))failBlock;

//  update users info
- (void)updateUserInfoWithUserId:(NSString*)userId  value:(BOOL)enable enableSignalType:(EnableSignalType)type apiversion:(NSString *)apiversion successBolck:(void (^)(void))successBlock failBlock:(void (^ _Nullable) (NSError *error))failBlock;

// apply/cancel/reject colink
- (void)sendCoVideoWithType:(SignalLinkState)linkState userIds:(NSArray<NSString *> *)userIds apiversion:(NSString *)apiversion successBolck:(void (^ _Nullable) (void))successBlock completeFailBlock:(void (^ _Nullable) (NSError *error))failBlock;

// upload log
- (void)uploadLogWithApiversion:(NSString *)apiversion successBlock:(void (^ _Nullable) (NSString *uploadSerialNumber))successBlock failBlock:(void (^ _Nullable) (NSError *error))failBlock;

// get white info
- (void)getWhiteInfoWithApiversion:(NSString *)apiversion successBlock:(void (^ _Nullable) (WhiteInfoModel * model))successBlock failBlock:(void (^ _Nullable) (NSError *error))failBlock;

// get replay info
- (void)getReplayInfoWithRecordId:(NSString*)recordId apiversion:(NSString *)apiversion successBlock:(void (^ _Nullable) (ReplayInfoModel * model))successBlock failBlock:(void (^ _Nullable) (NSError *error))failBlock;

// left room
- (void)leftRoomWithApiversion:(NSString *)apiversion successBolck:(void (^ _Nullable)(void))successBlock failBlock:(void (^ _Nullable) (NSError *error))failBlock;

- (int)submitRating:(NSInteger)rating;
- (int)switchCamera;

// Canvas
- (void)addVideoCanvasWithUId:(NSUInteger)uid inView:(UIView *)view;
- (void)removeVideoCanvasWithUId:(NSUInteger)uid;
- (void)removeVideoCanvasWithView:(UIView *)view;

- (void)muteLocalAudioStream:(NSNumber *)mute;
- (void)muteLocalVideoStream:(NSNumber *)mute;

- (void)releaseResource;

@end

NS_ASSUME_NONNULL_END
