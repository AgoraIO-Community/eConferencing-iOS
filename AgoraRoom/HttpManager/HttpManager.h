//
//  HttpManager.h
//  AgoraRoom
//
//  Created by ZYP on 2021/1/11.
//  Copyright © 2021 agora. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HMHttpHeader1;

NS_ASSUME_NONNULL_BEGIN

@interface HttpManager : NSObject

+ (void)get:(NSString *)url
     params:(NSDictionary * _Nullable) params
    headers:(NSDictionary<NSString*, NSString*> * _Nullable)headers
 apiVersion:(NSString *)apiVersion
    success:(void (^)(id))success
    failure:(void (^)(NSError *))failure;

+ (void)post:(NSString *)url
      params:(NSDictionary * _Nullable)params
     headers:(NSDictionary<NSString*, NSString*> * _Nullable)headers
  apiVersion:(NSString *)apiVersion
     success:(void (^)(id responseObj))success
     failure:(void (^)(NSError *error))failur;

+ (NSDictionary *)httpHeader;
+ (NSString *)appCode;

+ (void)saveHttpHeader1:(HMHttpHeader1 *)header1;
+ (void)saveHttpHeader2:(NSString *)auth;


@end

NS_ASSUME_NONNULL_END
