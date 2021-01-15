//
//  LoginVMDelegate.h
//  VideoConference
//
//  Created by ADMIN on 2020/12/17.
//  Copyright © 2020 agora. All rights reserved.
//

#ifndef LoginVMDelegate_h
#define LoginVMDelegate_h
#import <AgoraRoom/AgoraRoom.h>
#import <Foundation/Foundation.h>


#endif /* LoginVMDelegate_h */

@protocol NetworkDelegate <NSObject>

/// 当网络变化时调用 emit when network states change
- (void)networkImageNameDidChange:(NSString *)imageName;

@end


@protocol LoginVMDelegate <NSObject>

/// 当error=nil时，表示加入房间成功，反之失败。
- (void)LoginVMDidEndEntryRoomWithError:(NSError *)error;

@end
