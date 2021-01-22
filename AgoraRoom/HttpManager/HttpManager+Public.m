//
//  HttpManager+Public.m
//  AgoraRoom
//
//  Created by ZYP on 2021/1/11.
//  Copyright © 2021 agora. All rights reserved.
//

#import "HttpManager+Public.h"
#import "HMUserInfo.h"
#import "HMRequestParams.h"
#import "HMResponeParams.h"
#import "HttpManager+Url.h"
#import <YYModel/YYModel.h>
#import "HMRespone.h"

@implementation HttpManager (Public)

+ (void)requestAddRoom:(HMRequestParamsAddRoom * _Nonnull)request
               success:(HMSuccessAddRoom _Nullable)success
               failure:(HMFailBlock _Nullable)failure {
    NSString *url = [HttpManager urlAddRoomWitthRoomId:request.roomId];
    NSDictionary *params = [request yy_modelToJSONObject];
    [HttpManager post:url params:params headers:nil success:^(id responeObj) {
        HMRespone *resp = [HMRespone yy_modelWithDictionary:responeObj];
        if(resp.code != 0) {
            
            return;
        }
        HMResponeParamsAddRoom *params = [HMResponeParamsAddRoom yy_modelWithDictionary:resp.data];
        if(success) { success(params); }
    } failure:^(NSError *error) {
        if(error) { failure(error); }
    }];
}


@end
