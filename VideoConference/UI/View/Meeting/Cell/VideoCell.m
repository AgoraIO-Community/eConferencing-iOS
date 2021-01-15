//
//  VideoCell.m
//  VideoConference
//
//  Created by SRS on 2020/5/15.
//  Copyright © 2020 agora. All rights reserved.
//

#import "VideoCell.h"
#import "UIImage+Circle.h"
#import "VideoCellModel.h"
#import "NibInitProtocol.h"

@interface VideoCell ()<NibInitProtocol>

@property (weak, nonatomic) IBOutlet UIView *renderView;
@property (weak, nonatomic) IBOutlet UIImageView *headImgView;

@property (weak, nonatomic) IBOutlet UIImageView *hostView;
@property (weak, nonatomic) IBOutlet UIImageView *shareView;
@property (weak, nonatomic) IBOutlet UIImageView *audioView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hostWConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shareWConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *audioWConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shareLConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *audioLConstraint;

@property (weak, nonatomic) IBOutlet UIButton *upButton;
@property (weak, nonatomic) IBOutlet UIButton *menuButton;
@property (weak, nonatomic) IBOutlet UIView *actionView;
@property (weak, nonatomic) IBOutlet UIButton *actionButtonSlience;
@property (weak, nonatomic) IBOutlet UIButton *actionButtonCloseVideo;
@property (weak, nonatomic) IBOutlet UIButton *actionButtonLeaveRoom;
@property (weak, nonatomic) IBOutlet UIButton *actionButtonSetHost;

@end


@implementation VideoCell
- (void)awakeFromNib {
    [super awakeFromNib];
    UIImage *image = [UIImage generateImageWithSize:CGSizeMake(32, 32)];
    image = [UIImage circleImageWithOriginalImage:image];
    self.headImgView.image = image;
    _actionView.alpha = 0;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    [_menuButton setSelected:false];
    _actionView.hidden = true;
    _actionView.alpha = 1;
    
}

- (void)setModel:(VideoCellModel * _Nullable)userModel {
    if(userModel == nil){
        self.hidden = YES;
        return;
    }
     self.hidden = NO;

    if (userModel.enableVideo) {
        self.renderView.hidden = NO;
        self.headImgView.hidden = YES;
    } else {
        self.headImgView.hidden = NO;
        self.renderView.hidden = YES;
    }

    self.nameLabel.text = userModel.userName;
//    if(userModel.role == ConfRoleTypeHost) {
//        self.hostView.hidden = NO;
//        self.hostWConstraint.constant = 17;
//        self.shareLConstraint.constant = 3;
//    } else {
//        self.hostView.hidden = YES;
//        self.hostWConstraint.constant = 0;
//        self.shareLConstraint.constant = 0;
//    }

    if(userModel.grantBoard || userModel.grantScreen) {
        self.shareView.hidden = NO;
        self.shareWConstraint.constant = 17;
        self.audioLConstraint.constant = 3;
    } else {
        self.shareView.hidden = YES;
        self.shareWConstraint.constant = 0;
        self.shareLConstraint.constant = 0;
        self.audioLConstraint.constant = 0;
    }

    self.audioView.hidden = NO;
    if(userModel.enableAudio) {
        self.audioView.image = [UIImage imageNamed:@"state-unmute"];
    } else {
        self.audioView.image = [UIImage imageNamed:@"state-mute"];
    }
}

- (UIView *)getRenderView {
    return _renderView;
}

+ (instancetype)instanceFromNib {
    NSString *className = NSStringFromClass(VideoCell.class);
    return [[NSBundle mainBundle] loadNibNamed:className owner:self options:nil].firstObject;
}

- (void)setActionViewHidden:(BOOL)hidden {
    if(hidden) {
        [UIView animateWithDuration:0.25 animations:^{
            self.actionView.alpha = 0;
            [self.actionView layoutIfNeeded];
        } completion:^(BOOL finished) {
            self.actionView.hidden = true;
        }];
    }
    else {
        self.actionView.hidden = false;;
        [UIView animateWithDuration:0.25 animations:^{
            self.actionView.alpha = 1;
            [self.actionView layoutIfNeeded];
        }];
    }
}

- (IBAction)buttonTap:(UIButton *)sender {
    if(sender == _menuButton) {
        [_menuButton setSelected:!_menuButton.isSelected];
        BOOL isHidden = !_menuButton.isSelected;
        [self setActionViewHidden:isHidden];
    }
    
    VideoCellTapType tapType = VideoCellTapTypeSilence;
    if(sender == _upButton) {
        tapType = VideoCellTapTypeUpButton;
    }
    else if(sender == _actionButtonSlience)  {
        tapType = VideoCellTapTypeSilence;
    }
    else if(sender == _actionButtonCloseVideo)  {
        tapType = VideoCellTapTypeCloseVideo;
    }
    else if(sender == _actionButtonLeaveRoom)  {
        tapType = VideoCellTapTypeLeaveRoom;
    }
    else {
        tapType = VideoCellTapTypeSetHost;
    }
    
    if([_delegate respondsToSelector:@selector(videoCell:didTapType:)]) {
        [_delegate videoCell:self didTapType:tapType];
    }
}

@end

