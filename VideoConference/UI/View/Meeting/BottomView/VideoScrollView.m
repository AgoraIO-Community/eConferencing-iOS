//
//  VideoScrollView.m
//  VideoConference
//
//  Created by ZYP on 2020/12/30.
//  Copyright © 2020 agora. All rights reserved.
//

#import "VideoScrollView.h"
#import "PageCtrlView.h"

@interface VideoScrollView ()

@property (nonatomic, strong)UICollectionViewFlowLayout *collectionLayout;

@end

@implementation VideoScrollView

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
    _collectionLayout = [UICollectionViewFlowLayout new];
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero
                                         collectionViewLayout:_collectionLayout];
    _pageCtrlView = [PageCtrlView instanceFromNib];
    [self addSubview:_collectionView];
    [self addSubview:_pageCtrlView];
}

- (void)layout
{
    _collectionView.backgroundColor = UIColor.whiteColor;
    _collectionView.translatesAutoresizingMaskIntoConstraints = false;
    [NSLayoutConstraint activateConstraints:@[
        [_collectionView.topAnchor constraintEqualToAnchor:self.topAnchor],
        [_collectionView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [_collectionView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [_collectionView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-40]
    ]];
    
    _pageCtrlView.translatesAutoresizingMaskIntoConstraints = false;
    [NSLayoutConstraint activateConstraints:@[
        [_pageCtrlView.centerXAnchor constraintEqualToAnchor:self.centerXAnchor],
        [_pageCtrlView.heightAnchor constraintEqualToConstant:20],
        [_pageCtrlView.widthAnchor constraintEqualToConstant: 60],
        [_pageCtrlView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-7]
    ]];
}



@end
