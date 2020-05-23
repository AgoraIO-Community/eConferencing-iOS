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

// init media
- (void)initMediaWithClientRole:(ClientRole)role successBolck:(void (^)(void))successBlock failBlock:(void (^ _Nullable) (NSInteger errorCode))failBlock {
    
    [self.roomManager initMediaWithClientRole:role successBolck:successBlock failBlock:failBlock];
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

- (void)audienceApplyWithType:(EnableSignalType)type completeSuccessBlock:(void (^ _Nullable) (void))successBlock completeFailBlock:(void (^ _Nullable) (NSError *error))failBlock {

    [self.roomManager audienceActionWithType:type value:1 userId:self.ownModel.userId apiVersion:APIVersion1 completeSuccessBlock:successBlock completeFailBlock:failBlock];
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

// get user list info
- (void)getUserListWithSuccessBlock:(void (^)(void))successBlock failBlock:(void (^ _Nullable) (NSError *error))failBlock {
    
    WEAK(self);
    [self getUserListWithNextId:@"0" userModelList:@[] successBlock:^(NSArray<ConfUserModel *> *models) {
        
        NSMutableArray<ConfUserModel *> *allUserListModel = [NSMutableArray arrayWithObject:weakself.ownModel];
        for(ConfUserModel *userModel in self.roomModel.hosts) {
            if(userModel.uid != weakself.ownModel.uid){
                [allUserListModel addObject:userModel];
            }
        }
        [allUserListModel addObjectsFromArray:models];
        weakself.userListModels = [NSArray arrayWithArray:allUserListModel];
        if (successBlock != nil) {
            successBlock();
        }
    } failBlock:failBlock];
}
- (void)getUserListWithNextId:(NSString *)nextId userModelList:(NSArray<ConfUserModel*>*)userModelList successBlock:(void (^)(NSArray<ConfUserModel*> *models))successBlock failBlock:(void (^ _Nullable) (NSError *error))failBlock {
    
    WEAK(self);
    [self.roomManager getUserListWithNextId:nextId count:100 apiversion:APIVersion1 successBlock:^(ConfUserListInfoModel * _Nonnull userListInfoModel) {
    
        NSMutableArray<ConfUserModel*> *userList = [NSMutableArray array];
        [userList addObjectsFromArray:userModelList];
        [userList addObjectsFromArray:userListInfoModel.list];
        
        if(userListInfoModel.total > userList.count){
            [weakself getUserListWithNextId:userListInfoModel.nextId userModelList:userList successBlock:successBlock failBlock:failBlock];
        } else {
            successBlock(userList);
        }
        
    } failBlock:failBlock];
}

//  update users info
- (void)updateUserInfoWithUserId:(NSString*)userId value:(BOOL)enable enableSignalType:(EnableSignalType)type successBolck:(void (^)(void))successBlock failBlock:(void (^ _Nullable) (NSError *error))failBlock {
    
    WEAK(self);
    [self.roomManager updateUserInfoWithUserId:userId value:enable enableSignalType:type apiversion:APIVersion1 successBolck:^{
        
        for(ConfUserModel *model in weakself.userListModels) {
            if([model.userId isEqualToString:userId]){
                // 更新数据
                if(type == EnableSignalTypeChat){
                    model.enableChat = enable;
                } else if(type == EnableSignalTypeAudio){
                    model.enableAudio = enable;
                    if([model.userId isEqualToString:weakself.ownModel.userId]) {
                       [weakself.roomManager muteLocalAudioStream:@(!enable)];
                    }
                } else if(type == EnableSignalTypeVideo){
                    model.enableVideo = enable;
                    if([model.userId isEqualToString:weakself.ownModel.userId]) {
                       [weakself.roomManager muteLocalVideoStream:@(!enable)];
                    }
                }
                break;
            }
        }
        if (successBlock != nil) {
            successBlock();
        }
        
    } failBlock:failBlock];
}

- (void)changeHostWithUserId:(NSString *)userId completeSuccessBlock:(void (^ _Nullable) (void))successBlock completeFailBlock:(void (^ _Nullable) (NSError *error))failBlock {
    
    WEAK(self);
    [self.roomManager changeHostWithUserId:userId completeSuccessBlock:^{
        
        weakself.ownModel.role = ConfRoleTypeParticipant;
        NSMutableArray<ConfUserModel *> *participantModels = [NSMutableArray array];
        
        ConfUserModel *targetModel;
        for(ConfUserModel *model in weakself.userListModels) {
            if([model.userId isEqualToString:userId]){
                // 更新数据
                model.role = ConfRoleTypeHost;
                model.grantBoard = 1;
                model.grantScreen = 1;

                targetModel = model;
                continue;
            }
            
            // no self and no host
            if(model.userId != weakself.ownModel.userId &&
               model.role == ConfRoleTypeParticipant) {
                [participantModels addObject:model];
            }
        }
        
        // reset hosts
        NSMutableArray<ConfUserModel *> *hosts = [NSMutableArray array];
        for (ConfUserModel *model in  weakself.roomModel.hosts) {
            if(model.role == ConfRoleTypeHost) {
                [hosts addObject:model];
            }
        }
        if(targetModel) {
            [hosts addObject:targetModel];
        }
        weakself.roomModel.hosts = [NSArray arrayWithArray:hosts];
        
        // reset all users
        NSMutableArray<ConfUserModel *> *allUserListModels = [NSMutableArray arrayWithObject:weakself.ownModel];
        [allUserListModels addObjectsFromArray:weakself.roomModel.hosts];
        [allUserListModels addObjectsFromArray:participantModels];
        weakself.userListModels = [NSArray arrayWithArray:allUserListModels];
        
        if (successBlock != nil) {
            successBlock();
        }
    } completeFailBlock:failBlock];
}

//  update white state
- (void)whiteBoardStateWithValue:(BOOL)enable userId:(NSString *)userId  completeSuccessBlock:(void (^ _Nullable) (void))successBlock completeFailBlock:(void (^ _Nullable) (NSError *error))failBlock {
    
    WEAK(self);
    [self.roomManager whiteBoardStateWithValue:enable userId:userId apiVersion:APIVersion1 completeSuccessBlock:^{
        
        for(ConfUserModel *model in weakself.userListModels) {
            if([model.userId isEqualToString:userId]){
                model.grantBoard = enable;
                break;
            }
        }
        
        if (successBlock != nil) {
            successBlock();
        }
        
    } completeFailBlock:failBlock];
}

// send message
- (void)sendMessageWithText:(NSString *)message successBolck:(void (^ _Nullable) (void))successBlock completeFailBlock:(void (^ _Nullable) (NSError *error))failBlock {
    [self.roomManager sendMessageWithText:message apiversion:APIVersion1 successBolck:successBlock completeFailBlock:failBlock];
}

- (void)leftRoomWithUserId:(NSString *)userId successBolck:(void (^ _Nullable)(void))successBlock failBlock:(void (^ _Nullable) (NSError *error))failBlock {
    
    WEAK(self);
    [self.roomManager leftRoomWithUserId:userId apiversion:APIVersion1 successBolck:^{
        
        NSMutableArray<ConfUserModel *> *_userListModels = [NSMutableArray array];
        
        if(![userId isEqualToString: weakself.ownModel.userId]) {
            
            for(ConfUserModel *model in weakself.userListModels) {
                if([model.userId isEqualToString:userId]){
                    continue;
                }
                
                [_userListModels addObject:model];
            }
        }
        weakself.userListModels = [NSArray arrayWithArray:_userListModels];
        
        if (successBlock != nil) {
            successBlock();
        }
        
    } failBlock:failBlock];
}

- (void)getWhiteInfoWithSuccessBlock:(void (^ _Nullable) (WhiteInfoModel * model))successBlock failBlock:(void (^ _Nullable) (NSError *error))failBlock {
    
    [self.roomManager getWhiteInfoWithApiversion:APIVersion1 successBlock:successBlock failBlock:failBlock];
}

- (NSInteger)submitRating:(NSInteger)rating {
    return [self.roomManager submitRating:rating];
}

- (NSInteger)switchCamera {
    return [self.roomManager switchCamera];
}

- (void)releaseResource {
    [self.roomManager leftRoomWithUserId:self.ownModel.userId apiversion:APIVersion1 successBolck:nil failBlock:nil];
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
    ConfConfigModel.shareInstance.rtcToken = roomInfoModel.localUser.rtcToken;
    ConfConfigModel.shareInstance.channelName = roomInfoModel.room.channelName;
    
    self.roomModel = roomInfoModel.room;
    self.ownModel = roomInfoModel.localUser;
}

// Canvas
- (void)addVideoCanvasWithUId:(NSUInteger)uid inView:(UIView *)view {
    [self.roomManager addVideoCanvasWithUId:uid inView:view];
}
- (void)removeVideoCanvasWithUId:(NSUInteger)uid {
    [self.roomManager removeVideoCanvasWithUId:uid];
}
- (void)removeVideoCanvasWithView:(UIView *)view {
    [self.roomManager removeVideoCanvasWithView:view];
}

@end
