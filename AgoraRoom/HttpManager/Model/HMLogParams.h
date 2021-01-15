//
//  HMLogParamsInfoModel.h
//  AgoraRoom
//
//  Created by ZYP on 2021/1/11.
//  Copyright © 2021 agora. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HMLogParams : NSObject

@property (nonatomic, strong) NSString *bucketName;
@property (nonatomic, strong) NSString *callbackBody;
@property (nonatomic, strong) NSString *callbackContentType;
@property (nonatomic, strong) NSString *ossKey;
@property (nonatomic, strong) NSString *accessKeyId;
@property (nonatomic, strong) NSString *accessKeySecret;
@property (nonatomic, strong) NSString *securityToken;
@property (nonatomic, strong) NSString *ossEndpoint;

@end

NS_ASSUME_NONNULL_END
