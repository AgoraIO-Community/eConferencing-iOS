//
//  HttpManager+Public.h
//  AgoraRoom
//
//  Created by ZYP on 2021/1/11.
//  Copyright © 2021 agora. All rights reserved.
//

#import "HttpManager.h"
#import "HMResponeParams.h"
#import "HMRequestParams.h"

typedef void (^HMSuccessAddRoom)(HMResponeParamsAddRoom *_Nonnull);


NS_ASSUME_NONNULL_BEGIN

@interface HttpManager (Public)

+ (void)requestAddRoom:(HMRequestParamsAddRoom * _Nonnull)request
               success:(HMSuccessAddRoom _Nullable)success
               failure:(HMFailBlock _Nullable)failure;


@end

NS_ASSUME_NONNULL_END
