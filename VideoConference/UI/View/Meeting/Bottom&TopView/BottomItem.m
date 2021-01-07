//
//  BottomItem.m
//  VideoConference
//
//  Created by SRS on 2020/5/8.
//  Copyright © 2020 agora. All rights reserved.
//

#import "BottomItem.h"
#import "UIView+EEBadge.h"

@interface BottomItem()

@property (strong, nonatomic) IBOutlet BottomItem *item;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *tipText;
@property (weak, nonatomic) IBOutlet UIView *circlrView;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@end

@implementation BottomItem

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
        [self addSubview:self.item];
        [self.item equalTo:self];
        self.imageView.clipsToBounds = NO;
        [self.circlrView setBackgroundColor:UIColor.clearColor];
        self.circlrView.layer.masksToBounds = true;
        self.circlrView.layer.cornerRadius = 12;
        self.circlrView.layer.borderWidth = 1;
        self.circlrView.layer.borderColor = UIColor.whiteColor.CGColor;
        [self.imageView setHidden:true];
    }
    return self;
}

- (void)setImageName0:(NSString *)imageName0 {
    _imageName0 = imageName0;
    self.imageView.image = [UIImage imageNamed:imageName0];
}

- (void)setIsSelected:(BOOL)isSelected {
    _isSelected = isSelected;
    if(isSelected){
        self.imageView.image = [UIImage imageNamed:self.imageName1];
        self.tipText.textColor = [UIColor colorWithHexString:@"4DA1FF"];
    } else {
        self.imageView.image = [UIImage imageNamed:self.imageName0];
        self.tipText.textColor = [UIColor colorWithHexString:@"989898"];
    }
}

- (void)setTip:(NSString *)tip {
    _tip = tip;
    self.tipText.text = tip;
}
- (void)setCount:(NSInteger)count {
    _count = count;
    if(count > 0){
        [self.imageView showBadgeWithRightMagin:-8 topMagin:0];
        [self.imageView setBadgeCount:count];
    } else {
        [self.imageView hidenBadge];
    }
}

- (void)enableTimeMode:(BOOL)enable {
    [self.imageView setHidden:!enable];
    [self.circlrView setHidden:!enable];
}

- (void)setTimeCount:(NSUInteger)count {
    self.numberLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)count];
}


- (IBAction)onSelectBar:(BottomItem *)sender {
    
    self.tipText.textColor = sender.isSelected ? [UIColor colorWithHexString:@"4DA1FF"] : [UIColor colorWithHexString:@"989898"];
    if(self.block != nil){
        self.block();
    }
}

@end
