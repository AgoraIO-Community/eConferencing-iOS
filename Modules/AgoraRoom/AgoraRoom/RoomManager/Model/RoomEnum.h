//
//  RoomEnum.h
//  AgoraRoom
//
//  Created by SRS on 2020/5/19.
//  Copyright © 2020 agora. All rights reserved.
//

/** Client role in a live broadcast. */
typedef NS_ENUM(NSInteger, ClientRole) {
    ClientRoleBroadcaster   = 1,
    ClientRoleAudience      = 2,
};

typedef NS_ENUM(NSInteger, SceneType) {
    SceneTypeEducation      = 1,
    SceneTypeConference     = 2,
};
