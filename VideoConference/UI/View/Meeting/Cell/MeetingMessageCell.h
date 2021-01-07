//
//  MessageCell.h
//  VideoConference
//
//  Created by ZYP on 2021/1/5.
//  Copyright © 2021 agora. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MeetingMessageModel;

NS_ASSUME_NONNULL_BEGIN

@interface MeetingMessageCell : UITableViewCell

- (void)setModel:(MeetingMessageModel *)model;
- (void)setIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
