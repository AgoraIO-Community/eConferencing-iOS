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

@end

@implementation BottomItem

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
        [self addSubview:self.item];
        [self.item equalTo:self];
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
    } else {
        self.imageView.image = [UIImage imageNamed:self.imageName0];
    }
}

- (void)setTip:(NSString *)tip {
    _tip = tip;
    self.tipText.text = tip;
}
- (void)setCount:(NSInteger)count {
    _count = count;
    if(count > 0){
        [self.imageView showBadgeWithTopMagin:0];
        [self.imageView setBadgeCount:count];
    } else {
        [self.imageView hidenBadge];
    }
}

- (IBAction)onSelectBar:(UIButton *)sender {
    if(self.block != nil){
        self.block();
    }
}

@end
