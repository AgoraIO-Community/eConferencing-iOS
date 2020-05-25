//
//  RoomEnum.h
//  AgoraRoom
//
//  Created by SRS on 2020/5/19.
//  Copyright © 2020 agora. All rights reserved.
//

typedef NS_ENUM(NSUInteger, ConfRoleType) {
    ConfRoleTypeHost = 1,
    ConfRoleTypeParticipant = 2,
};

typedef NS_ENUM(NSInteger, ConfEnableRoomSignalType) {
    ConfEnableRoomSignalTypeMuteAllChat,
    ConfEnableRoomSignalTypeMuteAllAudio,
    ConfEnableRoomSignalTypeState,
    ConfEnableRoomSignalTypeShareBoard,
};

typedef NS_ENUM(NSInteger, ConnectionState) {
    ConnectionStateReconnected,
    ConnectionStateReconnecting,
    ConnectionStateDisconnected,
    ConnectionStateAnotherLogged,
};

/** Client role in a live broadcast. */
typedef NS_ENUM(NSInteger, ClientRole) {
    ClientRoleBroadcaster   = 1,
    ClientRoleAudience      = 2,
};

typedef NS_ENUM(NSInteger, EnableSignalType) {
    EnableSignalTypeVideo,
    EnableSignalTypeAudio,
    EnableSignalTypeChat,
    EnableSignalTypeGrantBoard,
};

typedef NS_ENUM(NSInteger, SceneType) {
    SceneTypeEducation      = 1,
    SceneTypeConference     = 2,
};

/** Network type. */
typedef NS_ENUM(NSInteger, NetworkGrade) {
    NetworkGradeUnknown = -1,
    NetworkGradeHigh = 1,
    NetworkGradeMiddle = 2,
    NetworkGradeLow = 3,
};

typedef NS_ENUM(NSInteger, AudioOutputRouting) {
    /** Default. */
    AudioOutputRoutingDefault = -1,
    /** Headset.*/
    AudioOutputRoutingHeadset = 0,
    /** Earpiece. */
    AudioOutputRoutingEarpiece = 1,
    /** Headset with no microphone. */
    AudioOutputRoutingHeadsetNoMic = 2,
    /** Speakerphone. */
    AudioOutputRoutingSpeakerphone = 3,
    /** Loudspeaker. */
    AudioOutputRoutingLoudspeaker = 4,
    /** Bluetooth headset. */
    AudioOutputRoutingHeadsetBluetooth = 5
};
