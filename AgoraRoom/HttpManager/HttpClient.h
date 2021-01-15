//
//  HttpClient.h
//  AgoraRoom
//
//  Created by ZYP on 2021/1/11.
//  Copyright © 2021 agora. All rights reserved.
//

#import <Foundation/Foundation.h>

#define NOTICE_USER_TOKEN_EXPIRED @"NOTICE_USER_TOKEN_EXPIRED"

NS_ASSUME_NONNULL_BEGIN

@interface HttpClient : NSObject

+ (void)get:(NSString *)url
     params:(NSDictionary *)params
    headers:(NSDictionary<NSString*, NSString*> *)headers
    success:(void (^)(id))success
    failure:(void (^)(NSError *))failure;

+ (void)post:(NSString *)url
      params:(NSDictionary *)params
     headers:(NSDictionary<NSString*, NSString*> *)headers
     success:(void (^)(id responseObj))success
     failure:(void (^)(NSError *error))failure;

@end

NS_ASSUME_NONNULL_END
