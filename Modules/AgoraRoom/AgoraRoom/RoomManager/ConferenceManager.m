//
//  ConferenceManager.m
//  AgoraRoom
//
//  Created by SRS on 2020/5/19.
//  Copyright © 2020 agora. All rights reserved.
//

#import "ConferenceManager.h"
#import "RoomManager.h"
#import "ConfConfigModel.h"

@interface ConferenceManager ()

@property (nonatomic, strong) RoomManager *roomManager;
@property (nonatomic, assign) SceneType sceneType;

@end

@implementation ConferenceManager
- (instancetype)init {
    NSAssert(1 == 0, @"inti must use: initWithSceneType");
    return self;
}

- (instancetype)initWithSceneType:(SceneType)type appId:(NSString *)appId authorization:(NSString *)authorization {
    if (self = [super init]) {
        self.sceneType = type;
        
        ConfConfigModel.shareInstance.appId = appId;
        self.roomManager = [[RoomManager alloc] initWithSceneType:type appId:appId authorization:authorization configModel:ConfConfigModel.shareInstance];
    }
    return self;
}

- (void)entryConfRoomWithParams:(ConferenceEntryParams *)params successBolck:(void (^ )(void))successBlock failBlock:(void (^ _Nullable) (NSError *error))failBlock {
    
    ConfConfigModel.shareInstance.userName = params.userName;
    ConfConfigModel.shareInstance.roomName = params.roomName;
    ConfConfigModel.shareInstance.password = params.password;
    ConfConfigModel.shareInstance.enableVideo = params.enableVideo;
    ConfConfigModel.shareInstance.enableAudio = params.enableAudio;
    ConfConfigModel.shareInstance.avatar = params.avatar;
    
    WEAK(self);
    [self.roomManager enterRoomProcess:params configApiVersion:APIVersion1 entryApiVersion:APIVersion1 roomInfoApiVersion:APIVersion1 successBolck:^(id  _Nonnull roomInfoModel) {
        if([roomInfoModel isKindOfClass:[ConfRoomInfoModel class]]) {
            ConfRoomInfoModel *model = (ConfRoomInfoModel*)roomInfoModel;
            [weakself handelConfRoomInfoModel:model];
            if(successBlock != nil){
                successBlock();
            }
        }
    } failBlock:failBlock];
}

- (void)getConfRoomInfoWithSuccessBlock:(void (^)(ConfRoomInfoModel *roomInfoModel))successBlock failBlock:(void (^ _Nullable) (NSError *error))failBlock {
    
    WEAK(self);
    [self.roomManager getRoomInfoWithApiversion:APIVersion1 successBlock:^(id roomInfoModel) {
        
        if([roomInfoModel isKindOfClass:[ConfRoomInfoModel class]]) {
            ConfRoomInfoModel *model = (ConfRoomInfoModel*)roomInfoModel;
            [weakself handelConfRoomInfoModel:model];
            if(successBlock != nil){
                successBlock(model);
            }
        }
    } failBlock:failBlock];
}

- (void)uploadLogWithSuccessBlock:(void (^ _Nullable) (NSString *uploadSerialNumber))successBlock failBlock:(void (^ _Nullable) (NSError *error))failBlock {
    [self.roomManager uploadLogWithApiversion:APIVersion1 successBlock:successBlock failBlock:failBlock];
}

- (void)updateRoomInfoWithValue:(BOOL)enable enableSignalType:(ConfEnableRoomSignalType)type successBolck:(void (^)(void))successBlock failBlock:(void (^ _Nullable) (NSError *error))failBlock {
    
    WEAK(self);
    [self.roomManager updateRoomInfoWithValue:enable enableSignalType:type apiversion:APIVersion1 successBolck:^{
        
        switch (type) {
            case ConfEnableRoomSignalTypeMuteAllAudio:
                break;
            case ConfEnableRoomSignalTypeMuteAllChat:
                break;
            case ConfEnableRoomSignalTypeShareBoard:
                break;
            case ConfEnableRoomSignalTypeState:
                break;
            default:
                break;
        }
        
        if(successBlock != nil){
            successBlock();
        }

    } failBlock:failBlock];
}

// send message
- (void)sendMessageWithText:(NSString *)message successBolck:(void (^ _Nullable) (void))successBlock completeFailBlock:(void (^ _Nullable) (NSError *error))failBlock {
    [self.roomManager sendMessageWithText:message apiversion:APIVersion1 successBolck:successBlock completeFailBlock:failBlock];
}

- (void)leftRoomWithSuccessBolck:(void (^ _Nullable)(void))successBlock failBlock:(void (^ _Nullable) (NSError *error))failBlock {
    [self.roomManager leftRoomWithApiversion:APIVersion1 successBolck:successBlock failBlock:failBlock];
}

- (void)releaseResource {
    [self.roomManager leftRoomWithApiversion:APIVersion1 successBolck:nil failBlock:nil];
    [self.roomManager releaseResource];
    self.ownModel = nil;
    self.roomModel = nil;
}

#pragma mark private
- (void)handelConfRoomInfoModel:(ConfRoomInfoModel *)roomInfoModel {

    ConfConfigModel.shareInstance.uid = roomInfoModel.localUser.uid;
    ConfConfigModel.shareInstance.userId = roomInfoModel.localUser.userId;
    ConfConfigModel.shareInstance.roomName = roomInfoModel.room.roomName;
    ConfConfigModel.shareInstance.rtmToken = roomInfoModel.localUser.rtmToken;
    ConfConfigModel.shareInstance.channelName = roomInfoModel.room.channelName;
    
    self.roomModel = roomInfoModel.room;
    self.ownModel = roomInfoModel.localUser;
}

@end
