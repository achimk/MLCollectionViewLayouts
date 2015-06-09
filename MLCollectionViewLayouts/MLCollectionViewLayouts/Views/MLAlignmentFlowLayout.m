//
//  MLAlignmentFlowLayout.m
//  MLReorderableCells
//
//  Created by Joachim Kret on 02.06.2015.
//  Copyright (c) 2015 Joachim Kret. All rights reserved.
//

#import "MLAlignmentFlowLayout.h"

@implementation MLAlignmentFlowLayout

#pragma mark Init

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self finishInitialize];
    }
    
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        [self finishInitialize];
    }
    
    return self;
}

- (void)finishInitialize {
    _alignmentType = MLAlignmentTypeDefault;
    
#warning Setup for test purposes
    _alignmentType = MLAlignmentTypeCenter;
    self.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.minimumInteritemSpacing = 20.0f;
    self.minimumLineSpacing = 20.0f;
    self.itemSize = CGSizeMake(200.0f, 200.0f);
    self.sectionInset = UIEdgeInsetsMake(20.0f, 20.0f, 20.0f, 20.0f);
}

#pragma mark Accessors

- (void)setAlignmentType:(MLAlignmentType)alignmentType {
    _alignmentType = alignmentType;
    [self invalidateLayout];
}

- (NSInteger)numberOfSections {
    return [self.collectionView numberOfSections];
}

- (NSInteger)numberOfItemsInSection:(NSInteger)section {
    return [self.collectionView numberOfItemsInSection:section];
}

- (void)setScrollDirection:(UICollectionViewScrollDirection)scrollDirection {
#warning Force to vertical scroll only
    [super setScrollDirection:UICollectionViewScrollDirectionVertical];
}

#pragma mark Override Methods

- (CGSize)collectionViewContentSize {
    if (MLAlignmentTypeDefault == self.alignmentType) {
        return [super collectionViewContentSize];
    }
    
    CGRect frame = UIEdgeInsetsInsetRect(self.collectionView.bounds, self.collectionView.contentInset);
    CGSize frameSize = frame.size;
    CGSize contetSize = CGSizeZero;
    contetSize.width = [self calculateWidthOfContent];
    contetSize.height = [self calculateHeightOfContent];
    
    if (UICollectionViewScrollDirectionVertical == self.scrollDirection) {
        if (isgreater(frameSize.height, contetSize.height)) {
            contetSize.height = frameSize.height;
        }
    }
    else {
#warning Implement...
    }

    return contetSize;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray * arrayOfAttributes = [NSMutableArray array];
    NSInteger numberOfSections = [self numberOfSections];
    
    for (NSInteger section = 0; section < numberOfSections; section++) {
        NSInteger numberOfItems = [self numberOfItemsInSection:section];
        
        for (NSInteger item = 0; item < numberOfItems; item++) {
            NSIndexPath * indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            UICollectionViewLayoutAttributes * attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
            
            if (CGRectIntersectsRect(attributes.frame, rect)) {
                [arrayOfAttributes addObject:attributes];
            }
        }
    }
    
    return [NSArray arrayWithArray:arrayOfAttributes];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes * attributes = nil;
    switch (self.alignmentType) {
        case MLAlignmentTypeDefault: {
            attributes = [super layoutAttributesForItemAtIndexPath:indexPath];
        } break;
        case MLAlignmentTypeCenter:
        case MLAlignmentTypeCenterLeft: {
            attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            [self setupCenterLayoutAttributes:attributes forItemAtIndexPath:indexPath];

        } break;
    }
    
    return attributes;
}

#pragma mark Center Attributes

- (void)setupCenterLayoutAttributes:(UICollectionViewLayoutAttributes *)attributes forItemAtIndexPath:(NSIndexPath *)indexPath {
    NSParameterAssert(attributes);
    NSParameterAssert(indexPath);
 
    CGRect frame = attributes.frame;
    frame.origin = [self calculateOriginForItemAtIndexPath:indexPath];
    frame.size = [self calculateSizeForItemAtIndexPath:indexPath];
    attributes.frame = frame;
}

#pragma mark Columns / Rows

- (NSInteger)columnForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSParameterAssert(indexPath);
    NSInteger numberOfColumns = [self numberOfColumnsInSection:indexPath.section];
    NSInteger column = (indexPath.item < numberOfColumns) ? indexPath.item : (indexPath.item % numberOfColumns);
    
    return column;
}

- (NSInteger)rowForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSParameterAssert(indexPath);
    NSInteger numberOfColumns = [self numberOfColumnsInSection:indexPath.section];
    NSInteger row = (NSInteger)(indexPath.item / numberOfColumns);
    
    return row;
}

- (NSInteger)numberOfColumnsInSection:(NSInteger)section {
    NSInteger numberOfColumns = 0;
    CGFloat interitemSpacing = self.minimumInteritemSpacing;
    CGFloat itemWidth = self.itemSize.width;
    
    if (UICollectionViewScrollDirectionVertical == self.scrollDirection) {
        CGFloat width = [self calculateWidthForSection:section];
        CGFloat currentWidth = 0.0f;

        if (isgreaterequal(itemWidth, width)) {
            numberOfColumns = 1;
        }
        else {
            for (;;) {
                currentWidth += itemWidth;
                if (isgreaterequal(currentWidth, width)) {
                    break;
                }
                
                currentWidth += interitemSpacing;
                numberOfColumns++;
            }
        }
    }
    else {
#warning Implement...
    }
    
    return numberOfColumns;
}

- (NSInteger)numberOfColumnsInSection:(NSInteger)section atRow:(NSInteger)row {
    NSInteger numberOfColumnsAtRow = 0;
    NSInteger numberOfItems = [self numberOfItemsInSection:section];
    NSInteger numberOfColumns = [self numberOfColumnsInSection:section];
    
    if (numberOfItems <= numberOfColumns) {
        numberOfColumnsAtRow = numberOfItems;
    }
    else {
        NSInteger numberOfRows = [self numberOfRowsInSection:section];
        
        if (row == (numberOfRows - 1)) {
            NSInteger moduloItems = (numberOfItems % numberOfColumns);
            numberOfColumnsAtRow = (0 < moduloItems) ? moduloItems : numberOfColumns;
        }
        else {
            numberOfColumnsAtRow = numberOfColumns;
        }
    }
    
    return numberOfColumnsAtRow;
}

- (NSInteger)numberOfRowsInSection:(NSInteger)section {
    NSInteger numberOfRows = 0;
    if (UICollectionViewScrollDirectionVertical == self.scrollDirection) {
        NSInteger numberOfItems = [self numberOfItemsInSection:section];
        NSInteger numberOfColumns = [self numberOfColumnsInSection:section];
        numberOfRows = ceilf(numberOfItems / (numberOfColumns * 1.0f));
    }
    else {
#warning Implement...
    }
    
    return numberOfRows;
}

- (NSInteger)numberOfRowsInSection:(NSInteger)section atColumn:(NSInteger)column {
    NSInteger numberOfRowsAtColumn = 0;
    NSInteger numberOfItems = [self numberOfItemsInSection:section];
    
    if (numberOfItems < (column + 1)) {
        numberOfRowsAtColumn = 0;
    }
    else if (numberOfItems == (column + 1)) {
        numberOfRowsAtColumn = 1;
    }
    else {
        NSInteger numberOfColumns = [self numberOfColumnsInSection:section];
        NSInteger numberOfRows = [self numberOfRowsInSection:section];
        NSInteger moduloItems = (numberOfItems % numberOfColumns);
        numberOfRowsAtColumn = numberOfRows;
        
        if (0 < moduloItems && (moduloItems - 1) < column) {
            numberOfRowsAtColumn = numberOfRowsAtColumn - 1;
        }
    }
    
    return numberOfRowsAtColumn;
}

#pragma mark Size Calculations

- (CGSize)calculateSizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.itemSize;
}

#pragma mark Origin / Offset Calculations

- (CGPoint)calculateOriginForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSParameterAssert(indexPath);
    
    MLAlignmentType alignmentType = self.alignmentType;
    NSInteger section = indexPath.section;
    NSInteger item = indexPath.item;
    NSInteger numberOfItems = [self numberOfItemsInSection:section];
    NSInteger numberOfColumns = [self numberOfColumnsInSection:section];
    NSInteger numberOfRows = [self numberOfRowsInSection:section];
    NSInteger column = [self columnForItemAtIndexPath:indexPath];
    NSInteger row = [self rowForItemAtIndexPath:indexPath];
    CGFloat sectionOffsetX = [self calculateHorizontalOffsetForSection:section];
    CGFloat sectionOffsetY = [self calculateVerticalOffsetForSection:section];
    CGFloat itemOffsetX = [self calculateHorizontalItemsOffsetForItemAtColumn:column];
    CGFloat itemOffsetY = [self calculateVerticalItemsOffsetForItemAtRow:row];
    CGFloat itemsWidth = [self calculateItemsWidthForSection:section];
    CGFloat itemsHeight = [self calculateItemsHeightForSection:section];
    CGFloat sectionWidth = [self calculateWidthForSection:section];
    CGFloat sectionHeight = [self calculateHeightForSection:section];
    CGPoint origin = CGPointZero;
    
    switch (alignmentType) {
        case MLAlignmentTypeCenter:
        case MLAlignmentTypeCenterLeft: {
            CGFloat offsetX = 0.0f;
            CGFloat offsetY = 0.0f;
            
            if (UICollectionViewScrollDirectionVertical == self.scrollDirection) {
                if (alignmentType == MLAlignmentTypeCenter) {
#warning Compute offset for current items in row
                    itemsWidth = [self calculateItemsWidthForSection:section atRow:row];
                    offsetX = floorf((sectionWidth - itemsWidth) * 0.5f);
                }
                else {
                    offsetX = floorf((sectionWidth - itemsWidth) * 0.5f);
                }

                CGRect frame = UIEdgeInsetsInsetRect(self.collectionView.bounds, self.collectionView.contentInset);
                CGSize frameSize = frame.size;
                CGSize contetSize = CGSizeZero;
                contetSize.height = [self calculateHeightOfContent];
                
                if (isgreater(frameSize.height, contetSize.height)) {
                    offsetY = floorf((frameSize.height - contetSize.height) * 0.5f + self.sectionInset.top);
                }
                else {
                    offsetY = self.sectionInset.top;
                }
            }
            else {
#warning Implement...
            }
            
            origin.x = sectionOffsetX + offsetX + itemOffsetX;
            origin.y = sectionOffsetY + offsetY + itemOffsetY;
        } break;
        default: break;
    }
    
    
    return origin;
}

- (CGFloat)calculateHorizontalItemsOffsetForItemAtColumn:(NSInteger)column {
    CGFloat interitemSpacing = self.minimumInteritemSpacing;
    CGFloat itemWidth = self.itemSize.width;
    CGFloat offset = (itemWidth + interitemSpacing) * column;
    
    return offset;
}

- (CGFloat)calculateVerticalItemsOffsetForItemAtRow:(NSInteger)row {
    CGFloat lineSpacing = self.minimumLineSpacing;
    CGFloat itemHeight = self.itemSize.height;
    CGFloat offset = (itemHeight + lineSpacing) * row;
    
    return offset;
}

- (CGFloat)calculateHorizontalOffsetForSection:(NSInteger)section {
    CGFloat offset = 0.0f;
    
    if (UICollectionViewScrollDirectionVertical == self.scrollDirection) {
        offset = 0.0f;
    }
    else {
#warning Implement...
    }
    
    return offset;
}

- (CGFloat)calculateVerticalOffsetForSection:(NSInteger)section {
    CGFloat offset = 0.0f;
    
    if (UICollectionViewScrollDirectionVertical == self.scrollDirection) {
        CGFloat sectionsHeight = 0.0f;
        for (NSInteger i = 0; i < section; i++) {
            sectionsHeight += [self calculateHeightForSection:i];
        }
        
        offset = sectionsHeight;
    }
    else {
#warning Implement...
    }
    
    return offset;
}

#pragma mark Width / Height Calculations

- (CGFloat)calculateWidthOfContent {
    CGFloat width = 0.0f;
    if (UICollectionViewScrollDirectionVertical == self.scrollDirection) {
        CGFloat collectionViewWidth = self.collectionView.bounds.size.width;
        width = collectionViewWidth;
    }
    else {
#warning Implement...
    }
    
    return width;
}

- (CGFloat)calculateHeightOfContent {
    CGFloat height = 0.0f;
    if (UICollectionViewScrollDirectionVertical == self.scrollDirection) {
        NSInteger numberOfSections = [self numberOfSections];
        CGFloat sectionsHeight = 0.0f;
        
        for (NSInteger section = 0; section < numberOfSections; section++) {
            sectionsHeight += [self calculateHeightForSection:section];
        }
        
        height = sectionsHeight;
    }
    else {
        
    }
    
    return height;
}

- (CGFloat)calculateItemsWidthForSection:(NSInteger)section {
    NSInteger numberOfColumns = [self numberOfColumnsInSection:section];
    CGFloat itemWidth = self.itemSize.width;
    CGFloat interitemSpacing = self.minimumInteritemSpacing;
    CGFloat itemsWidth = itemWidth * numberOfColumns;
    CGFloat interitemSpacingWidth = interitemSpacing * ((1 < numberOfColumns) ? (numberOfColumns - 1) : 0);
    
    return itemsWidth + interitemSpacingWidth;
}

- (CGFloat)calculateItemsWidthForSection:(NSInteger)section atRow:(NSInteger)row {
    NSInteger numberOfColumns = [self numberOfColumnsInSection:section atRow:row];
    CGFloat itemWidth = self.itemSize.width;
    CGFloat interitemSpacing = self.minimumInteritemSpacing;
    CGFloat itemsWidth = itemWidth * numberOfColumns;
    CGFloat interitemSpacingWidth = interitemSpacing * ((1 < numberOfColumns) ? (numberOfColumns - 1) : 0);
    
    return itemsWidth + interitemSpacingWidth;
}

- (CGFloat)calculateItemsHeightForSection:(NSInteger)section {
    NSInteger numberOfRows = [self numberOfRowsInSection:section];
    CGFloat itemHeight = self.itemSize.height;
    CGFloat lineSpacing = self.minimumLineSpacing;
    CGFloat itemsHeight = itemHeight * numberOfRows;
    CGFloat lineSpacingHeight = lineSpacing * ((1 < numberOfRows) ? (numberOfRows - 1) : 0);
    
    return itemsHeight + lineSpacingHeight;
}

- (CGFloat)calculateItemsHeightForSection:(NSInteger)section atColumn:(NSInteger)column {
    NSInteger numberOfRows = [self numberOfRowsInSection:section atColumn:column];
    CGFloat itemHeight = self.itemSize.height;
    CGFloat lineSpacing = self.minimumLineSpacing;
    CGFloat itemsHeight = itemHeight * numberOfRows;
    CGFloat lineSpacingHeight = lineSpacing * ((1 < numberOfRows) ? (numberOfRows - 1) : 0);
    
    return itemsHeight + lineSpacingHeight;
}

- (CGFloat)calculateWidthForSection:(NSInteger)section {
    CGFloat width = 0.0f;
    if (UICollectionViewScrollDirectionVertical == self.scrollDirection) {
        CGRect frame = UIEdgeInsetsInsetRect(self.collectionView.bounds, self.collectionView.contentInset);
        width = frame.size.width;
    }
    else {
#warning Implement...
    }
    
    return width;
}

- (CGFloat)calculateHeightForSection:(NSInteger)section {
    CGFloat height = 0.0f;
    if (UICollectionViewScrollDirectionVertical == self.scrollDirection) {
        NSInteger numberOfRows = [self numberOfRowsInSection:section];
        CGFloat lineSpacing = self.minimumLineSpacing;
        CGFloat itemHeight = self.itemSize.height;
        UIEdgeInsets insets = self.sectionInset;
        
        CGFloat rowsHeight = itemHeight * numberOfRows;
        CGFloat lineSpacingHeight = lineSpacing * ((1 < numberOfRows) ? numberOfRows - 1 : 0);
        CGFloat insetsHeight = insets.top + insets.bottom;
        
        height = rowsHeight + lineSpacingHeight + insetsHeight;
    }
    else {
#warning Implement...
    }
    
    return height;
}

@end
