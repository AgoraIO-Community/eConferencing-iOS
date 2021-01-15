//
//  MeetingTopView.m
//  VideoConference
//
//  Created by SRS on 2020/5/8.
//  Copyright © 2020 agora. All rights reserved.
//

#import "MeetingTopView.h"
#import "MeetingTopViewDelegate.h"
#import "NibInitProtocol.h"

@interface MeetingTopView() <NibInitProtocol> {
    dispatch_source_t timer;
}

@property (weak, nonatomic) IBOutlet UIButton *speakerBtn;
@property (weak, nonatomic) IBOutlet UIButton *directionBtn;
@property (nonatomic,assign) NSInteger timeCount;

@end

@implementation MeetingTopView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.speakerBtn.userInteractionEnabled = NO;
}

- (void)setAudioRouting:(MeetingTopViewAudioType)type {
    NSString *imageName = type == typeOpen ? @"speaker-ear" : @"speaker-open";
    UIImage *image = [UIImage imageNamed:imageName];
    [self.speakerBtn setImage:image forState:UIControlStateNormal];
}

- (IBAction)onSpeakerClick:(id)sender {}

- (IBAction)onSwitchCamera:(id)sender {
    if ([self.delegate respondsToSelector:@selector(MeetingTopViewDidTapCameraButton)]) {
        [self.delegate MeetingTopViewDidTapCameraButton];
    }
}

- (IBAction)onLeftMeeting:(id)sender {
    if ([self.delegate respondsToSelector:@selector(MeetingTopViewDidTapLeaveButton)]) {
        [self.delegate MeetingTopViewDidTapLeaveButton];
    }
}

- (void)startTimerWithCount:(NSInteger)timeCount
{
    NSDate *currentDate = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval currenTimeInterval = [currentDate timeIntervalSince1970];
    self.timeCount = (NSInteger)((currenTimeInterval * 1000 - timeCount) * 0.001);
    
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, globalQueue);
    
    WEAK(self);
    dispatch_source_set_timer(timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(timer, ^{
        NSInteger hours = weakself.timeCount / 3600;
        NSInteger minutes = (weakself.timeCount - (3600 * hours)) / 60;
        NSInteger seconds = weakself.timeCount % 60;
        NSString *strTime = [NSString stringWithFormat:@"%.2ld:%.2ld:%.2ld", (long)hours, (long)minutes, (long)seconds];
        dispatch_async(dispatch_get_main_queue(), ^{
            weakself.time.text = strTime;
        });
        self.timeCount++;
    });
    dispatch_resume(timer);
}

- (void)stopTimer
{
    if (timer) {
        dispatch_source_cancel(timer);
    }
}

- (void)dealloc
{
    [self stopTimer];
}

+ (instancetype)instanceFromNib
{
    NSString *className = NSStringFromClass(MeetingTopView.class);
    return [[NSBundle mainBundle] loadNibNamed:className owner:self options:nil].firstObject;
}

@end
