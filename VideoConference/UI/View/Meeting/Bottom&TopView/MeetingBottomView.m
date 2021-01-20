//
//  MeetingBottomView.m
//  VideoConference
//
//  Created by ZYP on 2020/12/29.
//  Copyright © 2020 agora. All rights reserved.
//

#import "MeetingBottomView.h"
#import "BottomItem.h"
#import "NibInitProtocol.h"

@interface MeetingBottomView ()<NibInitProtocol>

@property (weak, nonatomic) IBOutlet BottomItem *audioItem;
@property (weak, nonatomic) IBOutlet BottomItem *videoItem;
@property (weak, nonatomic) IBOutlet BottomItem *memberItem;
@property (weak, nonatomic) IBOutlet BottomItem *imItem;
@property (weak, nonatomic) IBOutlet BottomItem *moreItem;

@end

@implementation MeetingBottomView


- (void)awakeFromNib {
    [super awakeFromNib];
    [self initItem];
}

- (void)initItem {
    self.audioItem.imageName0 = @"bar-speaker0";
    self.audioItem.imageName1 = @"bar-speaker1";
    self.audioItem.tip = Localized(@"Audio");
    
    self.videoItem.imageName0 = @"bar-camera0";
    self.videoItem.imageName1 = @"bar-camera1";
    self.videoItem.tip = Localized(@"Video");
    
    self.memberItem.imageName0 = @"bar_user0";
    self.memberItem.imageName1 = @"bar_user1";
    self.memberItem.tip = Localized(@"Member");
    
    self.imItem.imageName0 = @"bar_chat0";
    self.imItem.imageName1 = @"bar_chat1";
    self.imItem.tip = Localized(@"IM");
    
    self.moreItem.imageName0 = @"bar_more0";
    self.moreItem.imageName1 = @"bar_more1";
    self.moreItem.tip = Localized(@"More");
    
    WEAK(self);
    
    self.memberItem.block = ^{
        if([weakself.delegate respondsToSelector:@selector(MeetingBottomViewDidTapButtonWithType:)]) {
            [weakself.delegate MeetingBottomViewDidTapButtonWithType:MeetingBottomViewButtonTypeMember];
        }
    };
    self.imItem.block = ^{
        if([weakself.delegate respondsToSelector:@selector(MeetingBottomViewDidTapButtonWithType:)]) {
            [weakself.delegate MeetingBottomViewDidTapButtonWithType:MeetingBottomViewButtonTypeChat];
        }
    };
    self.moreItem.block = ^{
        if([weakself.delegate respondsToSelector:@selector(MeetingBottomViewDidTapButtonWithType:)]) {
            [weakself.delegate MeetingBottomViewDidTapButtonWithType:MeetingBottomViewButtonTypeMore];
        }
    };
    
}

+ (instancetype)instanceFromNib {
    NSString *className = NSStringFromClass(MeetingBottomView.class);
    return [[NSBundle mainBundle] loadNibNamed:className owner:self options:nil].firstObject;
}

@end
