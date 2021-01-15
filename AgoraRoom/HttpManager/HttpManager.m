//
//  HttpManager.m
//  AgoraRoom
//
//  Created by ZYP on 2021/1/11.
//  Copyright © 2021 agora. All rights reserved.
//

#import "HttpManager.h"
#import "AFNetworking.h"
#import "HMHttpHeader1.h"
#import "URL.h"
#import "HttpClient.h"

static HMHttpHeader1 *httpHeader1;
static NSString *authorization;

@implementation HttpManager

+ (void)get:(NSString *)url
     params:(NSDictionary * _Nullable) params
    headers:(NSDictionary<NSString*, NSString*> * _Nullable)headers
 apiVersion:(NSString *)apiVersion
    success:(void (^)(id))success
    failure:(void (^)(NSError *))failure {
    
    // add header
    NSMutableDictionary *_headers = [NSMutableDictionary dictionaryWithDictionary:[HttpManager httpHeader]];
    if(headers != nil){
        [_headers addEntriesFromDictionary:headers];
    }
    
    NSString *_url = [url stringByReplacingOccurrencesOfString:@"v1" withString:apiVersion];
    _url = [_url stringByReplacingOccurrencesOfString:HTTP_EDU_HOST_URL withString:HTTP_MEET_HOST_URL];
    [HttpClient get:_url params:params headers:_headers success:success failure:failure];
}


+ (void)post:(NSString *)url
      params:(NSDictionary * _Nullable)params
     headers:(NSDictionary<NSString*, NSString*> * _Nullable)headers
  apiVersion:(NSString *)apiVersion
     success:(void (^)(id responseObj))success
     failure:(void (^)(NSError *error))failure {
    
    NSString *_url = [url stringByReplacingOccurrencesOfString:@"v1" withString:apiVersion];
    _url = [_url stringByReplacingOccurrencesOfString:HTTP_EDU_HOST_URL withString:HTTP_MEET_HOST_URL];
    
    // add header
    NSMutableDictionary *_headers = [NSMutableDictionary dictionaryWithDictionary:[HttpManager httpHeader]];
    if(headers != nil){
        [_headers addEntriesFromDictionary:headers];
    }
    
    [HttpClient post:_url params:params headers:_headers success:success failure:failure];
}



+ (NSDictionary *)httpHeader {
    NSMutableDictionary *headers = [NSMutableDictionary dictionary];
    if(httpHeader1.userToken) {
        headers[@"token"] = httpHeader1.userToken;
    }
    if(authorization != nil) {
        NSString *auth = [authorization stringByReplacingOccurrencesOfString:@"Basic " withString:@""];
        auth = [NSString stringWithFormat:@"Basic %@", auth];
        headers[@"Authorization"] = auth;
    } else {
        if(httpHeader1.agoraToken) {
            headers[@"x-agora-token"] = httpHeader1.agoraToken;
        }
        if(httpHeader1.agoraUId) {
            headers[@"x-agora-uid"] = httpHeader1.agoraUId;
        }
    }
    return headers;
}

+ (void)saveHttpHeader1:(HMHttpHeader1 *)header1 {
    httpHeader1 = header1;
}

+ (void)saveHttpHeader2:(NSString *)auth {
    authorization = auth;
}

+ (NSString *)appCode {
    return @"conf-demo";
}

@end
