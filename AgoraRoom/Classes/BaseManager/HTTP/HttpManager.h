//
//  HttpManager.h
//  AgoraEdu
//
//  Created by SRS on 2020/5/3.
//  Copyright © 2020 agora. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConfigModel.h"
#import "EnterRoomAllModel.h"
#import "SignalEnum.h"
#import "EduRoomAllModel.h"
#import "ConfRoomAllModel.h"
#import "LogParamsModel.h"
#import "WhiteModel.h"
#import "ReplayModel.h"

#import "EduSaaSEntryParams.h"
#import "EduEntryParams.h"
#import "ConferenceEntryParams.h"
#import "RoomEnum.h"
#import "ConfUserListModel.h"

typedef NS_ENUM(NSUInteger, MessageType) {
    MessageTypeText = 1,
};

NS_ASSUME_NONNULL_BEGIN

@interface HttpManager : NSObject

+ (void)saveHttpHeader1:(EnterRoomInfoModel *)model;
+ (void)saveHttpHeader2:(NSString *)auth;
+ (void)saveSceneType:(SceneType)type;

+ (NSString *)appCode;
+ (SceneType)getSceneType;

+ (void)get:(NSString *)url
     params:(NSDictionary * _Nullable)params
    headers:(NSDictionary<NSString*, NSString*> * _Nullable)headers
 apiVersion:(NSString *)apiVersion
    success:(void (^)(id))success
    failure:(void (^)(NSError *))failure;

+ (void)post:(NSString *)url
      params:(NSDictionary * _Nullable)params
     headers:(NSDictionary<NSString*, NSString*> * _Nullable)headers
  apiVersion:(NSString *)apiVersion
     success:(void (^)(id responseObj))success
     failure:(void (^)(NSError *error))failure;

@end

NS_ASSUME_NONNULL_END
