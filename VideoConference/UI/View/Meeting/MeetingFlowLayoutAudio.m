//
//  MeetingFlowLayoutAudio.m
//  VideoConference
//
//  Created by ZYP on 2021/1/4.
//  Copyright © 2021 agora. All rights reserved.
//

#import "MeetingFlowLayoutAudio.h"

@interface MeetingFlowLayoutAudio ()

@property (nonatomic, assign)CGFloat padding;

@end

@implementation MeetingFlowLayoutAudio

- (instancetype)init
{
    self = [super init];
    if (self) {
        _padding = 60;
    }
    return self;
}


- (CGFloat)minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10.0;
}

- (CGFloat)minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 2.0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size = collectionView.bounds.size;

    CGFloat width = (size.width - 2.0*10.0 - 2.0*_padding) / 3.0;
    CGFloat height = (size.height - 4.0*2 - 2.0*_padding) / 5.0;

    return CGSizeMake(width, height);
}

- (UIEdgeInsets)collectionViewContentInsets
{
    return UIEdgeInsetsZero;
}

- (NSInteger)numberOfItemsInSection:(NSInteger)section itemsCount:(NSInteger)itemsCount
{
    if (itemsCount >= (section+1)*15) { return 15; }
    else { return itemsCount%15; }
}

- (NSInteger)numberOfSectionsInItemsCount:(NSInteger)itemsCount
{
    NSInteger other = fmod(itemsCount, 15) > 0 ? 1 : 0;
    return itemsCount/15 + other;
}

- (UIEdgeInsets)insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(_padding, _padding, _padding, _padding);
}

@end
