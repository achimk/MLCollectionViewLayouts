//
//  MLMenuTableViewController.m
//  MLReorderableCells
//
//  Created by Joachim Kret on 20.05.2015.
//  Copyright (c) 2015 Joachim Kret. All rights reserved.
//

#import "MLMenuTableViewController.h"
#import "MLColorsCollectionViewController.h"
#import "MLTableViewCell.h"
#import "MLFlowLayout.h"
#import "MLUniformFlowLayout.h"

typedef NS_ENUM(NSUInteger, MLMenuItem) {
    MLMenuItemFlowLayout,
    MLMenuItemUniformFlowLayout,
    MLMenuItemCount
};

#pragma mark - MLMenuTableViewController

@interface MLMenuTableViewController ()

@end

#pragma mark -

@implementation MLMenuTableViewController

#pragma mark View

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.clearsSelectionOnReloadData = NO;
    self.clearsSelectionOnViewWillAppear = NO;
    
    [MLTableViewCell registerCellWithTableView:self.tableView];
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayout * layout = nil;
    
    switch (indexPath.row) {
        case MLMenuItemFlowLayout: {
            MLFlowLayout * flowLayout = [[MLFlowLayout alloc] init];
            layout = flowLayout;
        } break;
        case MLMenuItemUniformFlowLayout: {
            MLUniformFlowLayout * uniformFlowLayout = [[MLUniformFlowLayout alloc] init];
            uniformFlowLayout.interItemSpacing = MLInterItemSpacingMake(10.0f, 10.0f);
            uniformFlowLayout.enableStickyHeader = YES;
            layout = uniformFlowLayout;
        } break;
    }
    
    if (layout) {
        UIViewController * viewController = [[MLColorsCollectionViewController alloc] initWithCollectionViewLayout:layout];
        UINavigationController * navigationController = self.splitViewController.viewControllers[1];
        [navigationController setViewControllers:@[viewController] animated:YES];
    }
}

#pragma mark UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MLTableViewCell * cell = [MLTableViewCell cellForTableView:tableView indexPath:indexPath];
    
    switch (indexPath.row) {
        case MLMenuItemFlowLayout: {
            cell.textLabel.text = @"Flow Layout";
        } break;
        case MLMenuItemUniformFlowLayout: {
            cell.textLabel.text = @"Uniform Layout";
        } break;
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return MLMenuItemCount;
}

@end
