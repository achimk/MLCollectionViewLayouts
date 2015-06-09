//
//  MLColorsCollectionViewController.m
//  MLCollectionViewLayouts
//
//  Created by Joachim Kret on 09.06.2015.
//  Copyright (c) 2015 Joachim Kret. All rights reserved.
//

#import "MLColorsCollectionViewController.h"
#import "MLFlowLayout.h"
#import "MLUniformFlowLayout.h"
#import "MLCollectionReusableView.h"
#import "MLColorCollectionViewCell.h"
#import "MLColorModel.h"
#import <RZCollectionList/RZCollectionList.h>
#import <UIColor+MLPFlatColors/UIColor+MLPFlatColors.h>

#define NUMBER_OF_INITIAL_ITEMS     9

#pragma mark - MLColorsCollectionViewController

@interface MLColorsCollectionViewController ()

@property (nonatomic, readwrite, strong) RZArrayCollectionList * resultsController;

@end

#pragma mark -

@implementation MLColorsCollectionViewController

#pragma mark View

- (void)viewDidLoad {
    [super viewDidLoad];

    self.resultsController = [[RZArrayCollectionList alloc] initWithArray:@[] sectionNameKeyPath:nil];
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [MLColorCollectionViewCell registerCellWithCollectionView:self.collectionView];
    [self.collectionView registerClass:[MLCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    [self.collectionView registerClass:[MLCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer"];
    
    UIBarButtonItem * addItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addAction:)];
    UIBarButtonItem * clearItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(clearAction:)];
    UIBarButtonItem * randomItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(randomAction:)];
    self.navigationItem.rightBarButtonItems = @[clearItem, randomItem, addItem];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.appearsFirstTime) {
        [self randomAction:nil];
    }
}

#pragma mark Actions

- (IBAction)addAction:(id)sender {
    MLColorModel * model = [MLColorModel model];
    [self.resultsController addObject:model toSection:0];
    [self reloadData];
}

- (IBAction)clearAction:(id)sender {
    [self.resultsController removeAllObjects];
    [self reloadData];
}

- (IBAction)randomAction:(id)sender {
    [self.resultsController removeAllObjects];
    for (NSUInteger i = 0; i < NUMBER_OF_INITIAL_ITEMS; i++) {
        MLColorModel * model = [MLColorModel model];
        [self.resultsController addObject:model toSection:0];
    }
    [self reloadData];
}

#pragma mark MLUniformFlowLayoutDelegate

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(MLUniformFlowLayout *)layout itemHeightInSection:(NSInteger)section {
    return 44.0f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(MLUniformFlowLayout *)layout headerHeightInSection:(NSInteger)section; {
    return 44.0f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(MLUniformFlowLayout *)layout footerHeightInSection:(NSInteger)section {
    return 44.0f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView sectionSpacingForlayout:(MLUniformFlowLayout *)layout {
    return 10.0f;
}

- (NSUInteger)collectionView:(UICollectionView *)collectionView layout:(MLUniformFlowLayout *)layout numberOfColumnsInSection:(NSInteger)section {
    return 3;
}

#pragma mark UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
}

#pragma mark UICollectionViewDataSource

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MLColorCollectionViewCell * cell = [MLColorCollectionViewCell cellForCollectionView:collectionView indexPath:indexPath];
    id object = [self.resultsController objectAtIndexPath:indexPath];
    [cell configureWithObject:object context:indexPath];
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [self.resultsController.sections count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    id <RZCollectionListSectionInfo> sectionInfo = [self.resultsController.sections objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView * reusableView = nil;
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        MLCollectionReusableView * headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"header" forIndexPath:indexPath];
        headerView.backgroundColor = [UIColor randomFlatLightColor];
        reusableView = headerView;
    }
    else if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        MLCollectionReusableView * footerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"footer" forIndexPath:indexPath];
        footerView.backgroundColor = [UIColor randomFlatDarkColor];
        reusableView = footerView;
    }
    
    return reusableView;
}

@end
