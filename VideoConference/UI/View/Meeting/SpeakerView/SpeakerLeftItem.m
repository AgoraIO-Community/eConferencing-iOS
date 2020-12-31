//
//  SpeakerLeftItem.m
//  VideoConference
//
//  Created by ZYP on 2020/12/30.
//  Copyright © 2020 agora. All rights reserved.
//

#import "SpeakerLeftItem.h"
#import "UIColor+AppColor.h"
#import "NibInitProtocol.h"

@interface SpeakerLeftItem()<NibInitProtocol>

@end

@implementation SpeakerLeftItem

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.layer.masksToBounds = true;
    self.layer.cornerRadius = 22/2;
}

+ (instancetype)instanceFromNib
{
    NSString *className = NSStringFromClass(SpeakerLeftItem.class);
    return [[NSBundle mainBundle] loadNibNamed:className owner:self options:nil].firstObject;
}

@end
