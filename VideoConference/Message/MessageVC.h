//
//  MessageVC.h
//  VideoConference
//
//  Created by SRS on 2020/5/8.
//  Copyright © 2020 agora. All rights reserved.
//

#import "BaseViewController.h"
#import "AgoraRoomManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface MessageVC : BaseViewController

@property (strong, nonatomic) NSMutableArray<MessageInfoModel *> *messageArray;

@end

NS_ASSUME_NONNULL_END
