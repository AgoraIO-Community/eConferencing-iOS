//
//  HttpManager.m
//  AgoraRoom
//
//  Created by ZYP on 2021/1/11.
//  Copyright © 2021 agora. All rights reserved.
//

#import "HttpManager.h"
#import "AFNetworking.h"
#import "URL.h"
#import "HttpClient.h"
#import "LogManager.h"

static HMHttpHeader1 *httpHeader1;
static NSString *authorization;

@implementation HttpManager

+ (void)get:(NSString *)url
     params:(NSDictionary * _Nullable) params
    headers:(NSDictionary<NSString*, NSString*> * _Nullable)headers
    success:(HMSuccessBlock _Nullable)success
    failure:(HMFailBlock _Nullable)failure {
    
    [self logWithUrl:url headers:headers params:params];
    
    [HttpClient.share.sessionManager GET:url parameters:params headers:headers progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self logWithUrl:url response:responseObject];
        if(success) { success(responseObject); }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self logWithUrl:url error:error];
        if(failure) { failure(error); }
    }];
}


+ (void)post:(NSString *)url
      params:(NSDictionary * _Nullable)params
     headers:(NSDictionary<NSString*, NSString*> * _Nullable)headers
     success:(HMSuccessBlock _Nullable)success
     failure:(HMFailBlock _Nullable)failure {
    
    [self logWithUrl:url headers:headers params:params];
    
    [HttpClient.share.sessionManager POST:url parameters:params headers:headers constructingBodyWithBlock:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self logWithUrl:url response:responseObject];
        if(success) { success(responseObject); }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self logWithUrl:url error:error];
        if(failure) { failure(error); }
    }];
}

+ (void)logWithUrl:(NSString *)url
           headers:(NSDictionary<NSString*, NSString*> * _Nullable)headers
            params:(NSDictionary * _Nullable) params  {
    AgoraLogInfo(@"\n============>Get HTTP Start<============\n\
                 \nurl==>\n%@\n\
                 \nheaders==>\n%@\n\
                 \nparams==>\n%@\n\
                 ", url, headers, params);
}

+ (void)logWithUrl:(NSString *)url
          response:(id)responseObject {
    AgoraLogInfo(@"\n============>Get HTTP Success<============\n\
                 \nurl==>\n%@\n\
                 \nResult==>\n%@\n\
                 ", url, responseObject);
}

+ (void)logWithUrl:(NSString *)url
             error:(NSError *)error {
    AgoraLogInfo(@"\n============>Get HTTP Error<============\n\
                 \nurl==>\n%@\n\
                 \nError==>\n%@\n\
                 ", url, error.description);
}


@end
