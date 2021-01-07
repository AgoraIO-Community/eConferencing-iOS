//
//  HttpManager.m
//  AgoraEdu
//
//  Created by SRS on 2020/5/3.
//  Copyright © 2020 agora. All rights reserved.
//

#import "HttpManager.h"
#import <UIKit/UIKit.h>
#import <YYModel/YYModel.h>
#import "URL.h"
#import "HttpClient.h"
#import "ConfigModel.h"
#import "CommonModel.h"
#import "RoomEnum.h"

static SceneType sceneType;

static NSString *authorization;

static NSString *userToken;
static NSString *agoraToken;
static NSString *agoraUId;

@implementation HttpManager

#pragma mark private
+ (void)get:(NSString *)url
     params:(NSDictionary * ) params
    headers:(NSDictionary<NSString*, NSString*> *)headers
 apiVersion:(NSString *)apiVersion
    success:(void (^)(id))success
    failure:(void (^)(NSError *))failure {
    
    // add header
    NSMutableDictionary *_headers = [NSMutableDictionary dictionaryWithDictionary:[HttpManager httpHeader]];
    if(headers != nil){
        [_headers addEntriesFromDictionary:headers];
    }
    
    NSString *_url = [url stringByReplacingOccurrencesOfString:@"v1" withString:apiVersion];
    if(sceneType == SceneTypeConference){
        _url = [_url stringByReplacingOccurrencesOfString:HTTP_EDU_HOST_URL withString:HTTP_MEET_HOST_URL];
    }
    
    [HttpClient get:_url params:params headers:_headers success:success failure:failure];
}

+ (void)post:(NSString *)url
      params:(NSDictionary *)params
     headers:(NSDictionary<NSString*, NSString*> *)headers
  apiVersion:(NSString *)apiVersion
     success:(void (^)(id responseObj))success
     failure:(void (^)(NSError *error))failure {
    
    NSString *_url = [url stringByReplacingOccurrencesOfString:@"v1" withString:apiVersion];
    if(sceneType == SceneTypeConference){
        _url = [_url stringByReplacingOccurrencesOfString:HTTP_EDU_HOST_URL withString:HTTP_MEET_HOST_URL];
    }
    
    // add header
    NSMutableDictionary *_headers = [NSMutableDictionary dictionaryWithDictionary:[HttpManager httpHeader]];
    if(headers != nil){
        [_headers addEntriesFromDictionary:headers];
    }
    
    [HttpClient post:_url params:params headers:_headers success:success failure:failure];
}

+ (NSString *)appCode {
    NSString *code = @"edu-saas";
    if(sceneType == SceneTypeEducation){
        code = @"edu-demo";
    } else if(sceneType == SceneTypeConference){
        code = @"conf-demo";
    }
    return code;
}

+ (NSDictionary *)httpHeader {
    NSMutableDictionary *headers = [NSMutableDictionary dictionary];
    if(userToken) {
        headers[@"token"] = userToken;
    }
    
    if(authorization != nil) {
        NSString *auth = [authorization stringByReplacingOccurrencesOfString:@"Basic " withString:@""];
        auth = [NSString stringWithFormat:@"Basic %@", auth];
        headers[@"Authorization"] = auth;
    } else {
        if(agoraToken) {
            headers[@"x-agora-token"] = agoraToken;
        }
        if(agoraUId) {
            headers[@"x-agora-uid"] = agoraUId;
        }
    }
    return headers;
}

+ (void)saveHttpHeader1:(EnterRoomInfoModel *)model {
    if(sceneType == SceneTypeEducation || sceneType == SceneTypeConference) {
        userToken = model.userToken;
    } else {
        userToken = model.user.userToken;
    }
    agoraToken = model.user.rtmToken;
    agoraUId = @(model.user.uid).stringValue;
}

+ (void)saveHttpHeader2:(NSString *)auth {
    authorization = auth;
}

+ (void)saveSceneType:(SceneType)type {
    sceneType = type;
}

+ (SceneType)getSceneType {
    return sceneType;
}

@end
