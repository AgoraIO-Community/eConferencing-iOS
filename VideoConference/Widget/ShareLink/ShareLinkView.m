//
//  ShareLinkView.m
//  VideoConference
//
//  Created by SRS on 2020/5/14.
//  Copyright © 2020 agora. All rights reserved.
//

#import "ShareLinkView.h"

@interface ShareLinkView()<UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIView *animateView;
@property (weak, nonatomic) IBOutlet UILabel *meetName;
@property (weak, nonatomic) IBOutlet UILabel *invitationName;
@property (weak, nonatomic) IBOutlet UILabel *psd;
@property (weak, nonatomic) IBOutlet UILabel *link;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *animateBottomConstraint;
@end

@implementation ShareLinkView

+ (instancetype)createViewWithXib {
    
    ShareLinkView *vv = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil].firstObject;
    vv.backgroundColor = UIColor.clearColor;
    
    [vv initView];
    return vv;
}

- (void)initView {
    UITapGestureRecognizer *tapRecognize = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];
    tapRecognize.numberOfTapsRequired = 1;
    tapRecognize.delegate = self;
    [self.bgView addGestureRecognizer:tapRecognize];
}

#pragma UIGestureRecognizer Handles
-(void) handleTap:(UITapGestureRecognizer *)recognizer {
    [self onCancelBtnClick:nil];
}

- (void)showShareLinkViewInView:(UIView *)inView {
    [self removeFromSuperview];
//    self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    [inView addSubview:self];
    [self equalTo:inView];
    
    self.bgView.hidden = NO;

//    [self.animateView layoutIfNeeded];
//    [UIView animateWithDuration:0.35 delay:5 usingSpringWithDamping:0.8 initialSpringVelocity:20 options:UIViewAnimationOptionCurveLinear animations:^{
//        self.animateBottomConstraint.constant = 0;
//        [self.animateView layoutIfNeeded];
//    } completion:^(BOOL finished) {
//
//    }];
}

- (void)hiddenShareLinkView {
    self.animateBottomConstraint.constant = 0;
    [UIView animateWithDuration:0.35 animations:^{
        self.animateBottomConstraint.constant = -379;
        [self.animateView layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.bgView.hidden = YES;
        [self removeFromSuperview];
    }];
}

- (IBAction)onCopyBtnClick:(id)sender {
    
    // show toast
}

- (IBAction)onCancelBtnClick:(id)sender {
    [self hiddenShareLinkView];
}
@end
