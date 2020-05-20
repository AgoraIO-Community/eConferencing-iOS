//
//  LoginVC.m
//  VideoConference
//
//  Created by SRS on 2020/5/9.
//  Copyright © 2020 agora. All rights reserved.
//

#import "LoginVC.h"
#import "VCManager.h"
#import "SetVC.h"
#import "UserDefaults.h"
#import "MeetingVC.h"
#import "AllMuteAlertVC.h"
#import "ScoreAlertVC.h"
#import <IQKeyboardManager/IQKeyboardManager.h>
#import "AgoraRoomManager.h"

@interface LoginVC ()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *textFieldBgView;
@property (weak, nonatomic) IBOutlet UISwitch *cameraSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *micSwitch;
@property (weak, nonatomic) IBOutlet UIView *tipView;
@property (weak, nonatomic) IBOutlet UIButton *joinButton;

@property (weak, nonatomic) IBOutlet UITextField *roomName;
@property (weak, nonatomic) IBOutlet UITextField *roomPsd;
@property (weak, nonatomic) IBOutlet UITextField *userName;

@property (nonatomic, weak) UIActivityIndicatorView *activityIndicator;

@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    [self initView];
    
    IQKeyboardManager.sharedManager.enableAutoToolbar = NO;
//    IQKeyboardManager.sharedManager.keyboardDistanceFromTextField = 50
    IQKeyboardManager.sharedManager.shouldResignOnTouchOutside = YES;

//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            MeetingVC *vc = [[MeetingVC alloc] initWithNibName:@"MeetingVC" bundle:nil];
//        [VCManager pushToVC:vc];
//    });

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.cameraSwitch.on = [UserDefaults getOpenCamera];
    self.micSwitch.on = [UserDefaults getOpenMic];
    self.userName.text = [UserDefaults getUserName];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [UserDefaults setUserName:self.userName.text];
}

- (void)initView {
    
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleWhiteLarge)];
    self.activityIndicator.frame= CGRectMake((kScreenWidth -100)/2, (kScreenHeight - 100)/2, 100, 100);
    self.activityIndicator.color = [UIColor grayColor];
    self.activityIndicator.backgroundColor = [UIColor whiteColor];
    self.activityIndicator.hidesWhenStopped = YES;
    [self.view addSubview:activityIndicator];
    self.activityIndicator = activityIndicator;

    self.textFieldBgView.layer.borderWidth = 1;
    self.textFieldBgView.layer.borderColor = [UIColor colorWithHexString:@"E9EFF4"].CGColor;
    self.textFieldBgView.layer.cornerRadius = 5;
}

- (IBAction)onClickSet:(id)sender {
    
    [self.view endEditing:YES];
    self.tipView.hidden = YES;
    
    SetVC *vc = [[SetVC alloc] initWithNibName:@"SetVC" bundle:nil];
    [VCManager pushToVC:vc];
    

//    AllMuteAlertVC *vc = [[AllMuteAlertVC alloc] initWithNibName:@"AllMuteAlertVC" bundle:nil];
//    [VCManager presentToVC:vc];
//    
//    ScoreAlertVC *vc = [[ScoreAlertVC alloc] initWithNibName:@"ScoreAlertVC" bundle:nil];
//    [VCManager presentToVC:vc];
}

- (IBAction)onSwitchCamera:(id)sender {
    [UserDefaults setOpenCamera:self.cameraSwitch.on];
    self.tipView.hidden = YES;
}

- (IBAction)onSwitchMic:(id)sender {
    [UserDefaults setOpenMic:self.micSwitch.on];
    self.tipView.hidden = YES;
}

- (IBAction)onClickJoin:(UIButton *)sender {
    [self.view endEditing:YES];
    self.tipView.hidden = YES;
    
    self.roomName.text = @"哈哈2";
    self.roomPsd.text = @"1234";
    
    NSString *userName = self.userName.text;
    NSString *roomPsd = self.roomPsd.text;
    NSString *roomName = self.roomName.text;
    if (userName.length <= 0 || roomName.length <= 0) {
        [self showToast:NSLocalizedString(@"UserNameVerifyEmptyText", nil)];
        return;
    }
    if(![self checkFieldText:userName] || ![self checkFieldText:roomName]) {
        [self showToast:NSLocalizedString(@"UserNameVerifyText", nil)];
        return;
    }
    
    ConferenceEntryParams *params = [ConferenceEntryParams new];
    params.userName = userName;
    params.userUuid = [UIDevice currentDevice].identifierForVendor.UUIDString;
    params.roomName = roomName;
    params.roomUuid = roomName;
    params.password = roomPsd;
    params.enableVideo = self.cameraSwitch.on;
    params.enableAudio = self.micSwitch.on;
    params.avatar = @"";
    
    [self setLoadingVisible:YES];
    WEAK(self);
    [AgoraRoomManager.shareManager.conferenceManager entryConfRoomWithParams:params successBolck:^{
        
        [UserDefaults setUserName: userName];
        [UserDefaults setOpenCamera: params.enableVideo];
        [UserDefaults setOpenMic: params.enableAudio];

        [weakself setLoadingVisible:NO];
        MeetingVC *vc = [[MeetingVC alloc] initWithNibName:@"MeetingVC" bundle:nil];
        [VCManager pushToVC:vc];
        
    } failBlock:^(NSError * _Nonnull error) {
        [weakself setLoadingVisible:NO];
        [weakself showToast:error.localizedDescription];
    }];
}

- (BOOL)checkFieldText:(NSString *)text {
    int strlength = 0;
    char *p = (char *)[text cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i = 0; i < [text lengthOfBytesUsingEncoding:NSUnicodeStringEncoding]; i++) {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
    }
    if(strlength <= 20){
        return YES;
    } else {
       return NO;
    }
}
- (void)setLoadingVisible:(BOOL)show {
    if(show) {
        [self.activityIndicator startAnimating];
        [self.joinButton setEnabled:NO];
    } else {
        [self.activityIndicator stopAnimating];
        [self.joinButton setEnabled:YES];
    }
}

- (IBAction)onClickTip:(id)sender {
    BOOL hidden = self.tipView.hidden;
    self.tipView.hidden = !hidden;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.tipView.hidden = YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    self.tipView.hidden = YES;
    return YES;
}

@end
