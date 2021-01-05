//
//  MeetingFlowLayout.m
//  VideoConference
//
//  Created by ZYP on 2020/12/31.
//  Copyright © 2020 agora. All rights reserved.
//

#import "MeetingFlowLayoutVideo.h"

@implementation MeetingFlowLayoutVideo

- (CGFloat)minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 2;
}

- (CGFloat)minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 2;
}

- (CGSize)collectionView:(UICollectionView *)collectionView sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
     
    CGSize size = collectionView.bounds.size;
    
    NSInteger width = (size.width - 2) * 0.5;
    NSInteger height = (size.height - 2) * 0.5;
    
    return CGSizeMake(width, height);
}

- (UIEdgeInsets)collectionViewContentInsets
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (NSInteger)numberOfItemsInSection:(NSInteger)section itemsCount:(NSInteger)itemsCount
{
    if (itemsCount >= section*4) { return 4; }
    else { return itemsCount-section*4; }
}

- (NSInteger)numberOfSectionsInItemsCount:(NSInteger)itemsCount
{
    return itemsCount/4 + (fmod(itemsCount, 4) > 0.0 ? 1 : 0);
}

- (UIEdgeInsets)insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsZero;
}

@end
