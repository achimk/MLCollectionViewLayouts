//
//  MLAlignmentFlowLayout.h
//  MLReorderableCells
//
//  Created by Joachim Kret on 02.06.2015.
//  Copyright (c) 2015 Joachim Kret. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, MLAlignmentType) {
    MLAlignmentTypeDefault,
    MLAlignmentTypeCenter,
    MLAlignmentTypeCenterLeft
};

@interface MLAlignmentFlowLayout : UICollectionViewFlowLayout

@property (nonatomic, readwrite, assign) MLAlignmentType alignmentType;

@end
