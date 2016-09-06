//
//  CTAssetsPickerController.h
//  Pods
//
//  Created by wshaolin on 15/7/9.
//  Copyright © 2016年 wshaolin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

typedef NS_ENUM(NSInteger, CTAssetsPickerControllerAssetsType){ // Assets type
    CTAssetsPickerControllerAssetsTypePhoto, // Photo
    CTAssetsPickerControllerAssetsTypeVideo, // Video
    CTAssetsPickerControllerAssetsTypeAllAsset // Photo and Video
};

@protocol CTAssetsPickerControllerDelegate;

@interface CTAssetsPickerController : UINavigationController

@property (nonatomic, weak) id<UINavigationControllerDelegate, CTAssetsPickerControllerDelegate> delegate;

@property (nonatomic, assign, readonly) CTAssetsPickerControllerAssetsType assetsType; // Default CTAssetsPickerControllerAssetsTypePhoto
@property (nonatomic, strong, readonly) ALAssetsFilter *assetsFilter;
@property (nonatomic, strong, readonly) NSArray *selectedAssets; // selected asset

@property (nonatomic, assign) NSUInteger enableMaximumCount; // Default 0，0 is not limited.
@property (nonatomic, assign) NSUInteger enableMinimumCount; // Default 0，0 is not limited.

@property (nonatomic, assign, getter = isShowEmptyGroups) BOOL showEmptyGroups; // Default NO
@property (nonatomic, assign, getter = isFinishDismissViewController) BOOL finishDismissViewController; // Default YES.

@property (nonatomic, strong, readwrite) UIColor *toolbarItemBackgroundColor; // Assets view bottom toolbar barButtonItem background color.
@property (nonatomic, strong, readwrite) UIColor *toolbarItemFontColor; // Assets view bottom toolbar barButtonItem font color.

- (instancetype)initWithAssetsType:(CTAssetsPickerControllerAssetsType)assetsType;

- (void)deselectAssetAtIndex:(NSUInteger)index; // Cancel select asset at index.

@end

@protocol CTAssetsPickerControllerDelegate <NSObject>

@required
- (void)assetsPickerController:(CTAssetsPickerController *)assetsPickerController didFinishPickingAssets:(NSArray *)assets assetsType:(CTAssetsPickerControllerAssetsType)assetsType;

@optional
- (void)assetsPickerControllerDidCancel:(CTAssetsPickerController *)assetsPickerController;

- (void)assetsPickerController:(CTAssetsPickerController *)assetsPickerController didSelectAsset:(ALAsset *)asset;
- (void)assetsPickerController:(CTAssetsPickerController *)assetsPickerController didDeselectAsset:(ALAsset *)asset;

- (void)assetsPickerController:(CTAssetsPickerController *)assetsPickerController didSelectCountReachedEnableMaximumCount:(NSUInteger)enableMaximumCount;
- (void)assetsPickerController:(CTAssetsPickerController *)assetsPickerController didSelectCountUnderEnableMinimumCount:(NSUInteger)enableMinimumCount;

@end
