//
//  MessageView.h
//  VideoConference
//
//  Created by ZYP on 2021/1/5.
//  Copyright © 2021 agora. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MeetingMessageModel;


@protocol MessageViewDelegate <NSObject>

- (void)messageViewDidTapButton:(MeetingMessageModel *_Nonnull)model;

@end

NS_ASSUME_NONNULL_BEGIN

@interface MessageView : UIView

@property (nonatomic, weak)id<MessageViewDelegate> delegate;

- (void)addModel:(MeetingMessageModel *)model;

@end

NS_ASSUME_NONNULL_END
