//
//  ARHttpHeader1.h
//  AgoraRoom
//
//  Created by ZYP on 2021/1/11.
//  Copyright © 2021 agora. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HMHttpHeader1 : NSObject

@property (nonatomic, copy) NSString *userToken;
@property (nonatomic, copy) NSString *agoraToken;
@property (nonatomic, copy) NSString *agoraUId;

@end

NS_ASSUME_NONNULL_END
