//
//  MessageCell.m
//  VideoConference
//
//  Created by ZYP on 2021/1/5.
//  Copyright © 2021 agora. All rights reserved.
//

#import "MeetingMessageCell.h"
#import "UIColor+AppColor.h"
#import "MeetingMessageModel.h"

@interface MeetingMessageCell () {
    NSLayoutConstraint *_bgViewHeightConstraint;
    NSLayoutConstraint *_bgViewTrailingConstraint;
    
}

@property (nonatomic, strong)UILabel *nameLabel;
@property (nonatomic, strong)UILabel *infoLabel;
@property (nonatomic, strong)UIButton *button;
@property (nonatomic, strong)UIView *bgView;

@end

static const CGFloat bgViewHeightSmall = 24;
static const CGFloat bgViewHeightBig = 44;
static const CGFloat bgViewTrailingSmall = 0;
static const CGFloat bgViewTrailingBig = 67+5;

@implementation MeetingMessageCell

- (instancetype)init
{
    self = [super init];
    if (self) {
        _nameLabel = [UILabel new];
        _infoLabel = [UILabel new];
        _button = [UIButton new];
        _bgView = [UIView new];
        [self layout];
    }
    return self;
}

- (void)layout
{
    
    self.backgroundColor = UIColor.clearColor;
    
    UIFont *font = [UIFont systemFontOfSize:11];
    [_nameLabel setFont:font];
    [_infoLabel setFont:font];
    [_nameLabel setTextColor:UIColor.whiteColor];
    [_infoLabel setTextColor:UIColor.grayColor];
    [_button setBackgroundColor:UIColor.themColor];
    [_button setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [_button setTitleColor:UIColor.whiteColor forState:UIControlStateDisabled];
    _button.layer.masksToBounds = true;
    _button.layer.cornerRadius = 5;
    [_button.titleLabel setFont:[UIFont systemFontOfSize:12]];
    
    
    [_bgView setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.6]];
    _bgView.layer.masksToBounds = true;
    _bgView.layer.cornerRadius = 2;
    
    [self.contentView addSubview:_bgView];
    [self.contentView addSubview:_nameLabel];
    [self.contentView addSubview:_infoLabel];
    [self.contentView addSubview:_button];
    [self.contentView addSubview:_nameLabel];
    
    
    _nameLabel.translatesAutoresizingMaskIntoConstraints = false;
    _infoLabel.translatesAutoresizingMaskIntoConstraints = false;
    _button.translatesAutoresizingMaskIntoConstraints = false;
    _bgView.translatesAutoresizingMaskIntoConstraints = false;
    
    [NSLayoutConstraint activateConstraints:@[
        [_nameLabel.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:5],
        [_nameLabel.centerYAnchor constraintEqualToAnchor:self.centerYAnchor]
    ]];
    
    [NSLayoutConstraint activateConstraints:@[
        [_infoLabel.leadingAnchor constraintEqualToAnchor:_nameLabel.trailingAnchor],
        [_infoLabel.centerYAnchor constraintEqualToAnchor:self.centerYAnchor]
    ]];
    
    [NSLayoutConstraint activateConstraints:@[
        [_button.heightAnchor constraintEqualToConstant:24],
        [_button.widthAnchor constraintEqualToConstant:67],
        [_button.centerYAnchor constraintEqualToAnchor:self.centerYAnchor],
        [_button.leadingAnchor constraintEqualToAnchor:_infoLabel.trailingAnchor constant:5]
    ]];
    
    
    _bgViewHeightConstraint =  [_bgView.heightAnchor constraintEqualToConstant:bgViewHeightBig];
    _bgViewTrailingConstraint = [_bgView.trailingAnchor constraintEqualToAnchor:_button.leadingAnchor constant:bgViewTrailingSmall];
    [NSLayoutConstraint activateConstraints:@[
        [_bgView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        _bgViewTrailingConstraint,
        _bgViewHeightConstraint,
        [_bgView.centerYAnchor constraintEqualToAnchor:self.centerYAnchor]
    ]];
    
    self.contentView.transform = CGAffineTransformMakeScale(1, -1);
}

- (void)setModel:(MeetingMessageModel *)model {
    _nameLabel.text = [model.name stringByAppendingString:@"："];
    _infoLabel.text = model.info;
    [_button setHidden:!model.showButton];
    if (model.remianCount > 0) {
        [_button setTitle:[NSString stringWithFormat:@"允许（%ld）",model.remianCount] forState:UIControlStateDisabled];
    }
    else {
        [_button setTitle:@"允许" forState:UIControlStateNormal];
    }
    if (model.showButton) {
        _bgViewHeightConstraint.constant = bgViewHeightBig;
        _bgViewTrailingConstraint.constant = bgViewTrailingBig;
    }
    else {
        _bgViewHeightConstraint.constant = bgViewHeightSmall;
        _bgViewTrailingConstraint.constant = bgViewTrailingSmall;
    }
}

- (void)setIndex:(NSInteger)index {
    if (index >= 2) {
        self.nameLabel.alpha = 0.3;
        self.infoLabel.alpha = 0.3;
        self.button.alpha = 0.3;
        self.bgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    }
    else {
        self.nameLabel.alpha = 1;
        self.infoLabel.alpha = 1;
        self.button.alpha = 1;
        self.bgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    }
}

@end
