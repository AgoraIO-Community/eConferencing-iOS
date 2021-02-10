//
//  MeetingFlowLayoutAudio.m
//  VideoConference
//
//  Created by ZYP on 2021/1/4.
//  Copyright © 2021 agora. All rights reserved.
//

#import "MeetingFlowLayoutAudio.h"
#import "UIScreen+Extension.h"

@interface MeetingFlowLayoutAudio (){
    CGFloat _padding;
}

@property (nonatomic, assign)CGFloat padding;

@property (nonatomic,strong) NSMutableArray *attrs;
@property (nonatomic,strong) NSMutableDictionary *pageDict;
/** 每行item数量*/
@property (nonatomic,assign) NSInteger rowCount;
/** 每列item数量*/
@property (nonatomic,assign) NSInteger columCount;

@end

@implementation MeetingFlowLayoutAudio

#pragma mark - life cycle
- (instancetype)init {
    if (self = [super init]) {
        _padding = 40.0;
        
        CGFloat screenWidth = UIScreen.mainScreen.bounds.size.width;
        CGFloat screenHeight = UIScreen.mainScreen.bounds.size.height;
        CGFloat topSafeAreaHeight = UIScreen.topSafeAreaHeight;
        CGFloat bottomSafeAreaHeight = UIScreen.bottomSafeAreaHeight;
        CGFloat contentHeigh = screenHeight - topSafeAreaHeight - bottomSafeAreaHeight;
        CGFloat topBarHeight = 64.0;
        CGFloat bottomBarHeight = 55.0;
        CGFloat gap = 5.0;
        self.itemSize = CGSizeMake((screenWidth - 4.0*gap - 2.0*_padding)/3.0, (contentHeigh - topBarHeight - bottomBarHeight - 6.0*gap - 2*_padding)/5.0);
        self.rowCount = 3;
        self.columCount = 5;
        self.minimumLineSpacing = gap;
        self.minimumInteritemSpacing = gap;
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return self;
}

- (void)prepareLayout {
    [super prepareLayout];
    // 获取section数量
    NSInteger section = [self.collectionView numberOfSections];
    for (int i = 0; i < section; i++) {
        // 获取当前分区的item数量
        NSInteger items = [self.collectionView numberOfItemsInSection:i];
        for (int j = 0; j < items; j++) {
            // 设置item位置
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:j inSection:i];
            UICollectionViewLayoutAttributes *attr = [self layoutAttributesForItemAtIndexPath:indexPath];
            [self.attrs addObject:attr];
        }
    }
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attr = [super layoutAttributesForItemAtIndexPath:indexPath].copy;
    [self resetItemLocation:attr];
    return attr;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    return self.attrs;
}

- (CGSize)collectionViewContentSize {
    // 将所有section页面数量相加
    NSInteger allPagesCount = 0;
    for (NSString *page in [self.pageDict allKeys]) {
        allPagesCount += allPagesCount + [self.pageDict[page] integerValue];
    }
    CGFloat width = allPagesCount * self.collectionView.bounds.size.width;
    CGFloat hegith = self.collectionView.bounds.size.height;
    return CGSizeMake(width, hegith);
}

#pragma mark - private method
// 设置item布局属性
- (void)resetItemLocation:(UICollectionViewLayoutAttributes *)attr {
    if(attr.representedElementKind != nil) {
        return;
    }
    // 获取当前item的大小
    CGFloat itemW = self.itemSize.width;
    CGFloat itemH = self.itemSize.height;
    // 获取当前section的item数量
    NSInteger itemCount = [self.collectionView numberOfItemsInSection:attr.indexPath.section];
    // 获取横排item数量
    CGFloat width = self.collectionView.bounds.size.width;
    // 获取行间距和item最小间距
    CGFloat lineDis = self.minimumLineSpacing;
    CGFloat itemDis = self.minimumInteritemSpacing;
    // 获取当前item的索引index
    NSInteger index = attr.indexPath.item;
    // 获取每页item数量
    NSInteger allCount = self.rowCount * self.columCount;
    // 获取item在当前section的页码
    NSInteger page = index / allCount;
    // 获取item x y方向偏移量
    NSInteger xIndex = index % self.rowCount;
    NSInteger yIndex = (index - page * allCount)/self.rowCount;
    // 获取x y方向偏移距离
    CGFloat xOffset = xIndex * (itemW + lineDis) + _padding;
    CGFloat yOffset = yIndex * (itemH + itemDis) + _padding;
    // 获取每个item占了几页
    NSInteger sectionPage = (itemCount % allCount == 0) ? itemCount/allCount : (itemCount/allCount + 1);
    // 保存每个section的page数量
    [self.pageDict setObject:@(sectionPage) forKey:[NSString stringWithFormat:@"%lu",attr.indexPath.section]];
    // 将所有section页面数量相加
    NSInteger allPagesCount = 0;
    for (NSString *page in [self.pageDict allKeys]) {
        allPagesCount += allPagesCount + [self.pageDict[page] integerValue];
    }
    // 获取到的数减去最后一页的页码数
    NSInteger lastIndex = self.pageDict.allKeys.count - 1;
    allPagesCount -= [self.pageDict[[NSString stringWithFormat:@"%lu",lastIndex]] integerValue];
    xOffset += page * width + allPagesCount * width;
    
    attr.frame = CGRectMake(xOffset, yOffset, itemW, itemH);
}
#pragma mark - getter and setter
- (NSMutableArray *)attrs {
    if (!_attrs) {
        _attrs = [NSMutableArray array];
    }
    return _attrs;
}

- (NSMutableDictionary *)pageDict {
    if (!_pageDict) {
        _pageDict = [NSMutableDictionary dictionary];
    }
    return _pageDict;
}

@end