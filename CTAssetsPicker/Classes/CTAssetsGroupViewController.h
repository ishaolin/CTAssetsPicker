//
//  CTAssetsGroupViewController.h
//  CTAssetsPicker
//
//  Created by wshaolin on 15/7/9.
//  Copyright © 2016年 wshaolin. All rights reserved.
//

#import "CTAssetsPickerViewController.h"

@class ALAsset;

@interface CTAssetsGroupViewController : CTAssetsPickerViewController

@property (nonatomic, strong, readonly) NSArray<ALAsset *> *selectedAssets;

@property (nonatomic, strong) UIColor *toolbarItemBackgroundColor;
@property (nonatomic, strong) UIColor *toolbarItemFontColor;

- (void)deselectAssetAtIndex:(NSUInteger)index;

@end
