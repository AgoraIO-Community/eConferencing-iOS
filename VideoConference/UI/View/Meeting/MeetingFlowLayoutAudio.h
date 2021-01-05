//
//  MeetingFlowLayoutAudio.h
//  VideoConference
//
//  Created by ZYP on 2021/1/4.
//  Copyright © 2021 agora. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MeetingFlowLayoutAudio : UICollectionViewFlowLayout

- (CGFloat)minimumLineSpacingForSectionAtIndex:(NSInteger)section;
- (CGFloat)minimumInteritemSpacingForSectionAtIndex:(NSInteger)section;
- (CGSize)collectionView:(UICollectionView *)collectionView sizeForItemAtIndexPath:(NSIndexPath *)indexPath;
- (UIEdgeInsets)collectionViewContentInsets;
- (NSInteger)numberOfItemsInSection:(NSInteger)section itemsCount:(NSInteger)itemsCount;
- (NSInteger)numberOfSectionsInItemsCount:(NSInteger)itemsCount;
- (UIEdgeInsets)insetForSectionAtIndex:(NSInteger)section;
@end

NS_ASSUME_NONNULL_END
