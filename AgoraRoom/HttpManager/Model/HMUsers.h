//
//  HMUserInfo.h
//  AgoraRoom
//
//  Created by ZYP on 2021/1/11.
//  Copyright © 2021 agora. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HMUser : NSObject

@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, assign) NSInteger role;
@property (nonatomic, assign) NSInteger enableChat;
@property (nonatomic, assign) NSInteger enableVideo;
@property (nonatomic, assign) NSInteger enableAudio;
@property (nonatomic, assign) NSInteger uid;
@property (nonatomic, assign) NSInteger screenId;
@property (nonatomic, assign) NSInteger grantBoard;
@property (nonatomic, assign) NSInteger grantScreen;
@property (nonatomic, assign) NSInteger state;

@property (nonatomic, strong) NSString *userUuid;
@property (nonatomic, strong) NSString *rtcToken;
@property (nonatomic, strong) NSString *rtmToken;
@property (nonatomic, strong) NSString *screenToken;

- (BOOL)isEqualToModel:(HMUser *)model;

@end

@interface HMUsers : NSObject

@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign) NSInteger total;
@property (nonatomic, strong) NSString *nextId;
@property (nonatomic, strong) NSArray<HMUser *> *list;

@end

NS_ASSUME_NONNULL_END
