//
//  HMEnterRoomInfo.h
//  AgoraRoom
//
//  Created by ZYP on 2021/1/11.
//  Copyright © 2021 agora. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HMRoom :NSObject

@property (nonatomic, copy) NSString *roomId;
@property (nonatomic, copy) NSString *appId;
@property (nonatomic, copy) NSString *roomName;
@property (nonatomic, assign) NSInteger type;

@end

@interface HMRoomUser :NSObject

@property (nonatomic, copy) NSString *userToken;
@property (nonatomic, assign) NSInteger uid;
@property (nonatomic, copy) NSString *rtmToken;

@end

@interface HMRoomInfo : NSObject

@property (nonatomic, strong) HMRoom *room;
@property (nonatomic, strong) HMRoomUser *user;

@end

/// 与HMRoomInfo唯一不同的是localUser名称
@interface HMRoomInfoLocal : NSObject

@property (nonatomic, strong) HMRoom *room;
@property (nonatomic, strong) HMRoomUser *localUser;

@end

NS_ASSUME_NONNULL_END
