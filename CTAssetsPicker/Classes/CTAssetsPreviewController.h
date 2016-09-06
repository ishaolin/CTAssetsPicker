//
//  CTAssetsPreviewController.h
//  CTAssetsPickerDemo
//
//  Created by wshaolin on 15/7/13.
//  Copyright © 2016年 wshaolin. All rights reserved.
//

#import "CTAssetsPickerViewController.h"

@class CTAssetsPreviewController;
@class ALAsset;

@protocol CTAssetsPreviewControllerDelegate <NSObject>

@optional
- (void)assetsPreviewController:(CTAssetsPreviewController *)assetsPreviewController didSelectedAsset:(ALAsset *)asset;
- (void)assetsPreviewControllerDidCompleted:(CTAssetsPreviewController *)assetsPreviewController;

@end

@interface CTAssetsPreviewController : CTAssetsPickerViewController

@property (nonatomic, strong) NSArray<ALAsset *> *assetArray;
@property (nonatomic, assign) NSUInteger currentAssetIndex;
@property (nonatomic, weak) id<CTAssetsPreviewControllerDelegate> delegate;

@property (nonatomic, assign) NSInteger seletedCount;

@end
