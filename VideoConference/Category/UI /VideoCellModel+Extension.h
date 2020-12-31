//
//  VideoCellModel+Extension.h
//  VideoConference
//
//  Created by ZYP on 2020/12/28.
//  Copyright © 2020 agora. All rights reserved.
//

#import "VideoCellModel.h"
@class ConfUserModel;
NS_ASSUME_NONNULL_BEGIN

@interface VideoCellModel (Extension)

+ (instancetype)initWithUserModel:(ConfUserModel *)userMode;

@end

NS_ASSUME_NONNULL_END
