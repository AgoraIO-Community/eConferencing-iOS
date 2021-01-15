//
//  VideoCell.h
//  VideoConference
//
//  Created by SRS on 2020/5/15.
//  Copyright © 2020 agora. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AgoraRoomManager.h"
@class VideoCellModel, VideoCell;

typedef NS_ENUM(NSUInteger, VideoCellTapType) {
    /** 置顶 */
    VideoCellTapTypeUpButton,
    /** 静音 */
    VideoCellTapTypeSilence,
    /** 关闭视频 */
    VideoCellTapTypeCloseVideo,
    /** 移除房间 */
    VideoCellTapTypeLeaveRoom,
    /** 设置为主持人 */
    VideoCellTapTypeSetHost,
};

@protocol VideoCellDelegate <NSObject>

- (void)videoCell:(VideoCell * _Nonnull)cell didTapType:(VideoCellTapType)type;

@end

NS_ASSUME_NONNULL_BEGIN

@interface VideoCell : UICollectionViewCell

@property (nonatomic, weak)id<VideoCellDelegate> delegate;

- (void)setModel:(VideoCellModel * _Nullable)userModel;
- (UIView *)getRenderView;
+ (instancetype)instanceFromNib;

@end

NS_ASSUME_NONNULL_END
