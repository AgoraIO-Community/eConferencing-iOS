//
//  HMResponeParams.h
//  AgoraRoom
//
//  Created by ZYP on 2021/1/21.
//  Copyright © 2021 agora. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


/// 创建/加入房间 respone
@interface HMResponeParamsAddRoom : NSObject

@property (nonatomic, copy)NSString *streamId;
@property (nonatomic, copy)NSString *userRole;

@end


@interface HMResponeParamsBool : NSObject

@property (nonatomic, assign)BOOL ok;

@end

/// 离开房间
typedef HMResponeParamsBool HMResponeParamsLeaveRoom;
/// 其他
typedef HMResponeParamsBool HMResponeParamsUserPermissions;


NS_ASSUME_NONNULL_END
