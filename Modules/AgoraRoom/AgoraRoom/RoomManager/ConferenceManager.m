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
#import "JsonParseUtil.h"
#import <YYModel.h>

#import "ConfSignalChannelHostModel.h"

#define CONF_MESSAGE_VERSION 1
#define ConfNoNullString(x) ((x == nil) ? @"" : x)
#define ConfNoNullNumber(x) ((x == nil) ? @(0) : x)
#define ConfNoNullArray(x) ((x == nil) ? ([NSArray array]) : x)

@interface ConferenceManager ()<RoomManagerDelegate>

@property (nonatomic, strong) RoomManager *roomManager;
@property (nonatomic, assign) SceneType sceneType;
@property (nonatomic, copy) void (^ netWorkProbeTestBlock) (NetworkGrade grade);
@end

@implementation ConferenceManager
- (instancetype)init {
    NSAssert(1 == 0, @"init must use: initWithSceneType");
    return self;
}

- (instancetype)initWithSceneType:(SceneType)type appId:(NSString *)appId authorization:(NSString *)authorization {
    if (self = [super init]) {
        self.sceneType = type;
        ConfConfigModel.shareInstance.appId = appId;
        self.roomManager = [[RoomManager alloc] initWithSceneType:type appId:appId authorization:authorization configModel:ConfConfigModel.shareInstance];
        self.roomManager.delegate = self;
    }
    
    return self;
}

- (void)netWorkProbeTestCompleteBlock:(void (^ _Nullable) (NetworkGrade grade))block {
    NSAssert(ConfConfigModel.shareInstance.appId != nil, @"initWithSceneType fisrt");
    [self.roomManager startNetWorkProbeTest:ConfConfigModel.shareInstance.appId];
    self.netWorkProbeTestBlock = block;
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

- (void)updateRoomInfoWithValue:(NSInteger)value enableSignalType:(ConfEnableRoomSignalType)type successBolck:(void (^)(void))successBlock failBlock:(void (^ _Nullable) (NSError *error))failBlock {
    
    WEAK(self);
    [self.roomManager updateRoomInfoWithValue:value enableSignalType:type apiversion:APIVersion1 successBolck:^{
        
        switch (type) {
            case ConfEnableRoomSignalTypeMuteAllAudio:
                weakself.roomModel.muteAllAudio = value;
                if(value != MuteAllAudioStateUnmute) {
                    for(ConfUserModel *userModel in self.userListModels){
                        userModel.enableAudio = NO;
                    }
                }
                break;
            case ConfEnableRoomSignalTypeMuteAllChat:
                weakself.roomModel.muteAllChat = value;
                break;
            case ConfEnableRoomSignalTypeShareBoard:
                weakself.roomModel.shareBoard = value;
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
        
        // reset share screen
        for (ConfShareScreenUserModel *model in weakself.roomModel.shareScreenUsers) {
            if(model.uid == weakself.ownModel.uid) {
                model.role = ConfRoleTypeParticipant;
            } else if([model.userId isEqualToString:userId]) {
                model.role = ConfRoleTypeHost;
            }
        }
        // reset share board
        for (ConfShareBoardUserModel *model in weakself.roomModel.shareBoardUsers) {
            if(model.uid == weakself.ownModel.uid) {
                model.role = ConfRoleTypeParticipant;
            } else if([model.userId isEqualToString:userId]) {
                model.role = ConfRoleTypeHost;
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

#pragma mark RoomManagerDelegate
- (void)didReceivedSignal:(NSString *)signalText fromPeer:(NSString *)peer {
    NSDictionary *dict = [JsonParseUtil dictionaryWithJsonString:signalText];
    ConfSignalP2PInfoModel *model = [ConfSignalP2PModel yy_modelWithDictionary:dict].data;
    if([self.delegate respondsToSelector:@selector(didReceivedPeerSignal:)]) {
        [self.delegate didReceivedPeerSignal:model];
    }
}
- (void)didReceivedSignal:(NSString *)signalText {
    
    NSDictionary *dict = [JsonParseUtil dictionaryWithJsonString:signalText];
    NSInteger cmd = [dict[@"cmd"] integerValue];
    NSInteger version = [dict[@"version"] integerValue];
    if(version != CONF_MESSAGE_VERSION) {
        return;
    }
    
    if(cmd == ChannelMessageTypeChat) {
        
        [self messageChat:dict];
        
    } else if(cmd == ChannelMessageTypeInOut) {
        
        [self messageInOut:dict];
        
    } else if(cmd == ChannelMessageTypeRoomInfo) {
        
        [self messageRoomInfo:dict];
        
    } else if(cmd == ChannelMessageTypeUserInfo) {
        
        [self messageUserInfo:dict];
        
    } else if(cmd == ChannelMessageTypeShareBoard) {
        
        [self messageShareBoard:dict];
        
    } else if(cmd == ChannelMessageTypeShareScreen) {
        
        [self messageShareScreen:dict];
        
    } else if(cmd == ChannelMessageTypeHostChange) {
        
        [self messageHostChange:dict];
        
    } else if(cmd == ChannelMessageTypeKickoff) {
        
        [self messageKickoff:dict];
    }
}

- (void)didReceivedMessage:(MessageInfoModel * _Nonnull)model {
    if([self.delegate respondsToSelector:@selector(didReceivedMessage:)]) {
        [self.delegate didReceivedMessage:model];
    }
}
- (void)didReceivedConnectionStateChanged:(ConnectionState)state {
    if([self.delegate respondsToSelector:@selector(didReceivedConnectionStateChanged:)]) {
        [self.delegate didReceivedConnectionStateChanged:ConnectionStateReconnected];
    }
}
- (void)didAudioRouteChanged:(AudioOutputRouting)routing {
    if([self.delegate respondsToSelector:@selector(didAudioRouteChanged:)]) {
        [self.delegate didAudioRouteChanged: routing];
    }
}
- (void)networkLastmileTypeGrade:(NetworkGrade)grade {
    if(self.netWorkProbeTestBlock != nil){
        self.netWorkProbeTestBlock(grade);
    }
}
- (void)networkTypeGrade:(NetworkGrade)grade uid:(NSInteger)uid {
    if([self.delegate respondsToSelector:@selector(networkTypeGrade:uid:)]) {
        [self.delegate networkTypeGrade:grade uid: uid];
    }
}

#pragma mark Handle message
- (void)messageChat:(NSDictionary *)dict {
    
    MessageInfoModel *model = [MessageModel yy_modelWithDictionary:dict].data;
    if(![model.userId isEqualToString:self.ownModel.userId]) {
        model.isSelfSend = NO;
        NSNumber *timestamp = dict[@"timestamp"];
        model.timestamp = ConfNoNullNumber(timestamp).integerValue;
        
        if([self.delegate respondsToSelector:@selector(didReceivedMessage:)]) {
            [self.delegate didReceivedMessage:model];
        }
    }
}
- (void)messageInOut:(NSDictionary *)dict {
    
    NSDictionary *dataDic = dict[@"data"];
    if(dataDic == nil){
        return;
    }
    
    ConfSignalChannelInOutModel *inOutModel = [ConfSignalChannelInOutModel yy_modelWithDictionary:dataDic];
    
    self.roomModel.onlineUsers = inOutModel.total;
    
    NSArray<ConfSignalChannelInOutInfoModel*> *list = inOutModel.list;
    for (ConfSignalChannelInOutInfoModel *model in list){
        if(model.state == 0) { // out
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid != %d", model.uid];
            
            NSArray<ConfUserModel *> *filteredHostArray = [self.roomModel.hosts filteredArrayUsingPredicate:predicate];
            self.roomModel.hosts = [NSArray arrayWithArray:filteredHostArray];
            
            NSArray<ConfUserModel *> *filteredArray = [self.userListModels filteredArrayUsingPredicate:predicate];
            self.userListModels = [NSArray arrayWithArray:filteredArray];
            
        } else { // add
            if(model.uid == self.ownModel.uid){
                continue;
            }
            
            if(model.role == ConfRoleTypeHost) {
                
                NSMutableArray<ConfUserModel *> *hosts = [NSMutableArray arrayWithArray:self.roomModel.hosts];
                [hosts addObject:model];
                self.roomModel.hosts = [NSArray arrayWithArray:hosts];
                
                NSMutableArray<ConfUserModel *> *userListModels = [NSMutableArray arrayWithArray:self.userListModels];
                if(self.ownModel.role == ConfRoleTypeHost){
                    [userListModels insertObject:model atIndex:self.roomModel.hosts.count - 1];
                } else {
                    [userListModels insertObject:model atIndex:self.roomModel.hosts.count];
                }
                self.userListModels = [NSArray arrayWithArray:userListModels];
                
            } else {
                
                NSMutableArray<ConfUserModel *> *userListModels = [NSMutableArray arrayWithArray:self.userListModels];
                [userListModels addObject:model];
                self.userListModels = [NSArray arrayWithArray:userListModels];
            }
        }
    }
    
    if([self.delegate respondsToSelector:@selector(didReceivedSignalInOut:)]) {
        [self.delegate didReceivedSignalInOut: list];
    }
}
- (void)messageUserInfo:(NSDictionary *)dict {
    NSDictionary *dataDic = dict[@"data"];
    if(dataDic == nil){
        return;
    }
    
    ConfUserModel *userModel = [ConfUserModel yy_modelWithDictionary:dataDic];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid == %d", userModel.uid];
    NSArray<ConfUserModel *> *filteredArray = [self.userListModels filteredArrayUsingPredicate:predicate];
    if(filteredArray > 0){
        filteredArray.firstObject.userName = userModel.userName;
        filteredArray.firstObject.role = userModel.role;
        filteredArray.firstObject.enableChat = userModel.enableChat;
        filteredArray.firstObject.enableVideo = userModel.enableVideo;
        filteredArray.firstObject.enableAudio = userModel.enableAudio;
    }
    
    if([self.delegate respondsToSelector:@selector(didReceivedSignalUserInfo:)]) {
        [self.delegate didReceivedSignalUserInfo: userModel];
    }
}
- (void)messageRoomInfo:(NSDictionary *)dict {
    
    NSDictionary *dataDic = dict[@"data"];
    if(dataDic == nil) {
        return;
    }
    
    ConfSignalChannelRoomModel *model = [ConfSignalChannelRoomModel yy_modelWithDictionary:dataDic];
    self.roomModel.muteAllAudio = model.muteAllChat;
    if(model.muteAllChat != MuteAllAudioStateUnmute){
        for(ConfUserModel *userModel in self.userListModels){
            userModel.enableAudio = NO;
        }
    }
    
    if([self.delegate respondsToSelector:@selector(didReceivedSignalRoomInfo:)]) {
        [self.delegate didReceivedSignalRoomInfo:model];
    }
}
- (void)messageShareBoard:(NSDictionary *)dict {
    
    NSDictionary *dataDic = dict[@"data"];
    if(dataDic == nil) {
        return;
    }
    
    ConfSignalChannelBoardModel *boardModel = [ConfSignalChannelBoardModel yy_modelWithDictionary:dataDic];
    self.roomModel.shareBoard = boardModel.shareBoard;
    self.roomModel.createBoardUserId = boardModel.createBoardUserId;
    if (boardModel.shareBoard == 0) {
        self.roomModel.shareBoardUsers = @[];
    } else {
        self.roomModel.shareBoardUsers = [NSArray arrayWithArray: boardModel.shareBoardUsers];
    }
    if([self.delegate respondsToSelector:@selector(didReceivedSignalShareBoard:)]) {
        [self.delegate didReceivedSignalShareBoard:boardModel];
    }
}
- (void)messageShareScreen:(NSDictionary *)dict {
    NSDictionary *dataDic = dict[@"data"];
    if(dataDic == nil) {
        return;
    }
    
    ConfSignalChannelScreenModel *screenModel = [ConfSignalChannelScreenModel yy_modelWithDictionary:dataDic];
    self.roomModel.shareScreen = screenModel.shareScreen;
    
    if (screenModel.shareScreen == 0) {
        
        self.roomModel.shareScreenUsers = @[];
        
    } else {
        
        self.roomModel.shareScreenUsers = [NSArray arrayWithArray: screenModel.shareScreenUsers];
    }
    if([self.delegate respondsToSelector:@selector(didReceivedSignalShareScreen:)]) {
        [self.delegate didReceivedSignalShareScreen:screenModel];
    }
}
- (void)messageHostChange:(NSDictionary *)dict {
    
    NSArray<ConfUserModel*> *hostModels = [ConfSignalChannelHostModel yy_modelWithDictionary:dict].data;
    
    NSMutableArray<ConfUserModel*> *allParticipantModels = [NSMutableArray arrayWithArray:self.userListModels];
    [allParticipantModels removeObjectAtIndex:0];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"role != %d", ConfRoleTypeHost];
    NSArray<ConfUserModel*> *participantModels = [allParticipantModels filteredArrayUsingPredicate:predicate];
    
    self.roomModel.hosts = [NSArray arrayWithArray:hostModels];
    NSPredicate *hostPredicate = [NSPredicate predicateWithFormat:@"uid != %d", self.ownModel.uid];
    NSArray<ConfUserModel*> *hostFilteredModels = [self.roomModel.hosts filteredArrayUsingPredicate:hostPredicate];
    
    NSPredicate *ownPredicate = [NSPredicate predicateWithFormat:@"uid == %d", self.ownModel.uid];
    NSArray<ConfUserModel*> *ownFilteredModels = [self.roomModel.hosts filteredArrayUsingPredicate:ownPredicate];
    if(ownFilteredModels > 0){
        self.ownModel.role = ConfRoleTypeHost;
        self.ownModel.grantBoard = 1;
    }
    
    NSMutableArray<ConfUserModel*> *allModels = [NSMutableArray array];
    [allModels addObject:self.ownModel];
    [allModels addObjectsFromArray:hostFilteredModels];
    [allModels addObjectsFromArray:participantModels];
    self.userListModels = [NSArray arrayWithArray:allModels];
    
    if([self.delegate respondsToSelector:@selector(didReceivedSignalHostChange:)]) {
        [self.delegate didReceivedSignalHostChange:hostModels];
    }
}

- (void)messageKickoff:(NSDictionary *)dict {
    
    NSDictionary *dataDic = dict[@"data"];
    if(dataDic == nil) {
        return;
    }
    
    ConfSignalChannelKickoutModel *model = [ConfSignalChannelKickoutModel yy_modelWithDictionary:dataDic];
    if(![model.userId isEqualToString:self.ownModel.userId]) {
        return;
    }
    
    [self.roomManager leftRoomWithUserId:model.userId apiversion:APIVersion1 successBolck:nil failBlock:nil];
    
    if([self.delegate respondsToSelector:@selector(didReceivedSignalKickoutChange:)]) {
        [self.delegate didReceivedSignalKickoutChange:model];
    }
}

@end
