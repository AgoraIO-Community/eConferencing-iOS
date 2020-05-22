//
//  URL.h
//  AgoraEdu
//
//  Created by SRS on 2020/5/3.
//  Copyright © 2020 agora. All rights reserved.
//

#import <Foundation/Foundation.h>

#define HTTP_BASE_URL @"https://api-solutions-dev.sh.agoralab.co/edu"

#define HTTP_GET_CONFIG @"%@/v1/app/version"

// http: get app config
#define HTTP_LOG_PARAMS @"%@/v1/log/params"
// http: get app config
#define HTTP_OSS_STS @"%@/v1/log/sts"
// http: get app config
#define HTTP_OSS_STS_CALLBACK @"%@/v1/log/sts/callback"

// /conf/v1/apps/{appId}/room/entry
#define HTTP_ENTER_ROOM1 @"%@/v1/room/entry"
#define HTTP_ENTER_ROOM2 @"%@/v1/apps/%@/room/entry"

// /edu/v1/apps/{appId}/room/exit
#define HTTP_LEFT_ROOM @"%@/v1/apps/%@/room/%@/exit"

// http: get or update global state
// /edu/v1/apps/{appId}/room/{roomId}
#define HTTP_ROOM_INFO @"%@/v1/apps/%@/room/%@"

#warning You need to use your own backend service API
// http: get white board keys in room
// /edu/v1/apps/{appId}/room/{roomId}
#define HTTP_WHITE_ROOM_INFO @"%@/v1/apps/%@/room/%@/board"

// http: update room info
// /edu/v1/apps/{appId}/room/{roomId}
#define HTTP_UPDATE_ROOM_INFO @"%@/v1/apps/%@/room/%@"

// http: update user info
// /edu/v1/apps/{appId}/room/{roomId}/user/{userId}
#define HTTP_UPDATE_USER_INFO @"%@/v1/apps/%@/room/%@/user/%@"

// http: get userlist info
// /conf/v1/apps/{appId}/room/{roomId}/user/page
#define HTTP_USER_LIST_INFO @"%@/v1/apps/%@/room/%@/user/page"

// http: im
// /edu/v1/apps/{appId}/room/{roomId}/chat
#define HTTP_USER_INSTANT_MESSAGE @"%@/v1/apps/%@/room/%@/chat"

// http: covideo
// /edu/v1/apps/{appId}/room/{roomId}/covideo
#define HTTP_USER_COVIDEO @"%@/v1/apps/%@/room/%@/covideo"

// http: get replay info
// /edu/v1/apps/{appId}/room/{roomId}/record/{recordId}
#define HTTP_GET_REPLAY_INFO @"%@/v1/apps/%@/room/%@/record/%@"

// Error
typedef NS_ENUM(NSInteger, LocalAgoraErrorCode) {
    LocalAgoraErrorCodeCommon = 999,
};
#define LocalErrorDomain @"io.agora.AgoraRoom"
#define LocalError(errCode,reason) ([NSError errorWithDomain:LocalErrorDomain \
    code:(errCode) \
userInfo:@{NSLocalizedDescriptionKey:(reason)}])

// Localized
#define Localized(des) NSLocalizedString(des, nil)

