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

typedef void (^HMSuccessBlockAddRoom)(HMResponeParamsAddRoom *_Nonnull);
typedef void (^HMSuccessBlockBool)(BOOL);


NS_ASSUME_NONNULL_BEGIN

@interface HttpManager (Public)

+ (void)requestAddRoom:(HMReqParamsAddRoom * _Nonnull)request
               success:(HMSuccessBlockAddRoom _Nullable)success
               failure:(HMFailBlock _Nullable)failure;


@end

NS_ASSUME_NONNULL_END
