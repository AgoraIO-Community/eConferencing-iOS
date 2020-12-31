//
//  VideoCell+Extension.m
//  VideoConference
//
//  Created by ZYP on 2020/12/28.
//  Copyright © 2020 agora. All rights reserved.
//

#import "VideoCell+Extension.h"
#import "ConfUserModel.h"
#import "VideoCellModel.h"
#import "VideoCellModel+Extension.h"

@implementation VideoCell (Extension)

- (void)setUserModel:(ConfUserModel * _Nullable)userModel {
    VideoCellModel *model = [VideoCellModel initWithUserModel:userModel];
    [self setModel:model];
}

@end
