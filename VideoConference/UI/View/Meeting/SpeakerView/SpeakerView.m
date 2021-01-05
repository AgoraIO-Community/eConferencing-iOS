//
//  SpeakerView.m
//  VideoConference
//
//  Created by ZYP on 2020/12/29.
//  Copyright © 2020 agora. All rights reserved.
//

#import "SpeakerView.h"
#import "SpeakerLeftItem.h"

/// 演讲者视图
@interface SpeakerView ()
@property (nonatomic, strong)SpeakerLeftItem *leftItem;

@end

@implementation SpeakerView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
        [self layout];
    }
    return self;
}

- (void)setup
{
    _leftItem = [SpeakerLeftItem instanceFromNib];
    _rightButton = [UIButton new];

    UIImage *image = [UIImage imageNamed:@"平铺视图"];
    [_rightButton setImage:image forState:UIControlStateNormal];
    
    [self addSubview:_leftItem];
    [self addSubview:_rightButton];
}

- (void)layout
{
    _leftItem.translatesAutoresizingMaskIntoConstraints = false;
    [NSLayoutConstraint activateConstraints:@[
        [_leftItem.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:15.0],
        [_leftItem.topAnchor constraintEqualToAnchor:self.topAnchor constant:10.0],
        [_leftItem.heightAnchor constraintEqualToConstant:22],
        [_leftItem.widthAnchor constraintEqualToConstant:100]
    ]];
    
    _rightButton.translatesAutoresizingMaskIntoConstraints = false;
    [NSLayoutConstraint activateConstraints:@[
        [_rightButton.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-20.0],
        [_rightButton.topAnchor constraintEqualToAnchor:self.topAnchor constant:10.0],
    ]];
}


@end
