//
//  MeetingBottomView.h
//  VideoConference
//
//  Created by ZYP on 2020/12/29.
//  Copyright © 2020 agora. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, MeetingBottomViewButtonType) {
    MeetingBottomViewButtonTypeMember,
    MeetingBottomViewButtonTypeChat,
    MeetingBottomViewButtonTypeMore,
};

@protocol MeetingBottomViewDelegate <NSObject>

- (void)MeetingBottomViewDidTapButtonWithType:(MeetingBottomViewButtonType)type;

@end

NS_ASSUME_NONNULL_BEGIN

@interface MeetingBottomView : UIView

@property (nonatomic, weak)id<MeetingBottomViewDelegate> delegate;

+ (instancetype)instanceFromNib;
@end

NS_ASSUME_NONNULL_END
