//
//  ARHttpResp.h
//  AgoraRoom
//
//  Created by ZYP on 2021/1/11.
//  Copyright © 2021 agora. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HMHttpResp : NSObject

@property (nonatomic, copy) NSString *msg;
@property (nonatomic, assign) NSInteger code;
@property (nonatomic, strong) id data;

@end

NS_ASSUME_NONNULL_END
