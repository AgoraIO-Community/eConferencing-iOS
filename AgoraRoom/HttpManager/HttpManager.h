//
//  HttpManager.h
//  AgoraRoom
//
//  Created by ZYP on 2021/1/11.
//  Copyright © 2021 agora. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^HMSuccessBlock)(id _Nullable);
typedef void (^HMFailBlock)(NSError *_Nonnull);

@class HMHttpHeader1, AFHTTPSessionManager;

NS_ASSUME_NONNULL_BEGIN

@interface HttpManager : NSObject

+ (void)get:(NSString *)url
     params:(NSDictionary * _Nullable) params
    headers:(NSDictionary<NSString*, NSString*> * _Nullable)headers
    success:(HMSuccessBlock _Nullable)success
    failure:(HMFailBlock _Nullable)failure;

+ (void)post:(NSString *)url
      params:(NSDictionary * _Nullable)params
     headers:(NSDictionary<NSString*, NSString*> * _Nullable)headers
     success:(HMSuccessBlock _Nullable)success
     failure:(HMFailBlock _Nullable)failure;

@end

NS_ASSUME_NONNULL_END
