//
//  VideoCellModel+Extension.m
//  VideoConference
//
//  Created by ZYP on 2020/12/28.
//  Copyright © 2020 agora. All rights reserved.
//

#import "VideoCellModel+Extension.h"
#import "ConfUserModel.h"

@implementation VideoCellModel (Extension)

+ (instancetype)initWithUserModel:(ConfUserModel *)userMode {
    VideoCellModel *model =  [VideoCellModel new];
    model.enableAudio = userMode.enableAudio;
    model.enableVideo = userMode.enableVideo;
    model.enableChat = userMode.enableChat;
    model.grantBoard = userMode.grantBoard;
    model.grantScreen = userMode.grantScreen;
    model.role = userMode.role;
    model.rtcToken = userMode.rtcToken;
    model.rtmToken = userMode.rtmToken;
    model.screenId = userMode.screenId;
    model.screenToken = userMode.screenToken;
    model.state = userMode.state;
    model.uid = userMode.uid;
    model.userId = userMode.userId;
    model.userName = userMode.userName;
    model.userUuid = userMode.userId;
    return model;
}

@end
