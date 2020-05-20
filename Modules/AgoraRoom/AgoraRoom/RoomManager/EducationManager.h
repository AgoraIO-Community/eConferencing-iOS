//
//  EducationManager.h
//  AgoraRoom
//
//  Created by SRS on 2020/5/19.
//  Copyright © 2020 agora. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RoomManagerDelegate.h"
#import "EduRoomAllModel.h"
#import "SignalShareScreenModel.h"
#import "RoomEnum.h"
#import "EduEntryParams.h"

NS_ASSUME_NONNULL_BEGIN

@interface EducationManager : NSObject
@property (nonatomic, weak) id<RoomManagerDelegate> delegate;

@property (nonatomic, strong) EduRoomModel * _Nullable roomModel;
@property (nonatomic, strong) NSArray<EduUserModel*> *coStudentModels;

@property (nonatomic, strong) EduUserModel * _Nullable hostModel;
@property (nonatomic, strong) EduUserModel * _Nullable ownModel;
@property (nonatomic, strong) SignalShareScreenInfoModel * _Nullable shareScreenInfoModel;

- (instancetype)initWithSceneType:(SceneType)type appId:(NSString *)appId authorization:(NSString *)authorization;

// entry room
- (void)entryEduRoomWithParams:(EduEntryParams *)params successBolck:(void (^ )(void))successBlock failBlock:(void (^ _Nullable) (NSError *error))failBlock;

// get room info
- (void)getEduRoomInfoWithSuccessBlock:(void (^)(EduRoomInfoModel *roomInfoModel))successBlock failBlock:(void (^ _Nullable) (NSError *error))failBlock;

// upload log
- (void)uploadLogWithSuccessBlock:(void (^ _Nullable) (NSString *uploadSerialNumber))successBlock failBlock:(void (^ _Nullable) (NSError *error))failBlock;

// send message
- (void)sendMessageWithText:(NSString *)message successBolck:(void (^ _Nullable) (void))successBlock completeFailBlock:(void (^ _Nullable) (NSError *error))failBlock;
    
- (void)leftRoomWithSuccessBolck:(void (^ _Nullable)(void))successBlock failBlock:(void (^ _Nullable) (NSError *error))failBlock;

- (void)releaseResource;
@end

NS_ASSUME_NONNULL_END
