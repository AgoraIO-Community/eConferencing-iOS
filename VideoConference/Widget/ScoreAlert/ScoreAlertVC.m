//
//  ScoreAlertVC.m
//  VideoConference
//
//  Created by SRS on 2020/5/15.
//  Copyright © 2020 agora. All rights reserved.
//

#import "ScoreAlertVC.h"

@interface ScoreAlertVC ()

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *scoreBtn0;
@property (weak, nonatomic) IBOutlet UIButton *scoreBtn1;
@property (weak, nonatomic) IBOutlet UIButton *scoreBtn2;
@property (weak, nonatomic) IBOutlet UIButton *scoreBtn3;
@property (weak, nonatomic) IBOutlet UIButton *scoreBtn4;

@end

@implementation ScoreAlertVC

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.modalPresentationStyle = UIModalPresentationCustom;
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.bgView.layer.cornerRadius = 4;
    self.bgView.layer.masksToBounds = YES;
}

- (IBAction)onScoreClick:(UIButton *)sender {
    BOOL isSelected = YES;
    
    [self.scoreBtn0 setSelected:NO];
    [self.scoreBtn1 setSelected:NO];
    [self.scoreBtn2 setSelected:NO];
    [self.scoreBtn3 setSelected:NO];
    [self.scoreBtn4 setSelected:NO];
    
    if(sender == self.scoreBtn0) {
        [self.scoreBtn0 setSelected:isSelected];
    } else if(sender == self.scoreBtn1) {
        [self.scoreBtn0 setSelected:isSelected];
        [self.scoreBtn1 setSelected:isSelected];
    } else if(sender == self.scoreBtn2) {
        [self.scoreBtn0 setSelected:isSelected];
        [self.scoreBtn1 setSelected:isSelected];
        [self.scoreBtn2 setSelected:isSelected];
    } else if(sender == self.scoreBtn3) {
        [self.scoreBtn0 setSelected:isSelected];
        [self.scoreBtn1 setSelected:isSelected];
        [self.scoreBtn2 setSelected:isSelected];
        [self.scoreBtn3 setSelected:isSelected];
    }
    else if(sender == self.scoreBtn4) {
        [self.scoreBtn0 setSelected:isSelected];
        [self.scoreBtn1 setSelected:isSelected];
        [self.scoreBtn2 setSelected:isSelected];
        [self.scoreBtn3 setSelected:isSelected];
        [self.scoreBtn4 setSelected:isSelected];
    }
}

- (IBAction)onSumbit:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

@end
