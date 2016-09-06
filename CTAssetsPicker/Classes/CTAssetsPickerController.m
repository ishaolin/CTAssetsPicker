//
//  CTAssetsPickerController.m
//  CTAssetsPicker
//
//  Created by wshaolin on 15/7/9.
//  Copyright © 2016年 wshaolin. All rights reserved.
//

#import "CTAssetsPickerController.h"
#import "CTAssetsGroupViewController.h"

@implementation CTAssetsPickerController

@dynamic delegate;

- (instancetype)init{
    if(self = [super initWithRootViewController:[[CTAssetsGroupViewController alloc] init]]){
        [self _init];
    }
    return self;
}

- (instancetype)initWithAssetsType:(CTAssetsPickerControllerAssetsType)assetsType{
    if(self = [super initWithRootViewController:[[CTAssetsGroupViewController alloc] init]]){
        [self _init];
        _assetsType = assetsType;
        switch (assetsType) {
            case CTAssetsPickerControllerAssetsTypePhoto:{
                _assetsFilter = [ALAssetsFilter allPhotos];
            }
                break;
            case CTAssetsPickerControllerAssetsTypeVideo:{
                _assetsFilter = [ALAssetsFilter allVideos];
            }
                break;
            case CTAssetsPickerControllerAssetsTypeAllAsset:{
                _assetsFilter = [ALAssetsFilter allAssets];
            }
                break;
            default:
                break;
        }
    }
    return self;
}

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController{
    if(self = [super initWithRootViewController:[[CTAssetsGroupViewController alloc] init]]){
        [self _init];
    }
    return self;
}

- (void)_init{
    _assetsType = CTAssetsPickerControllerAssetsTypePhoto;
    _assetsFilter = [ALAssetsFilter allPhotos];
    _finishDismissViewController = YES;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.navigationBar.hidden = NO;
}

- (NSArray *)selectedAssets{
    CTAssetsGroupViewController *assetsGroupViewController = (CTAssetsGroupViewController *)self.topViewController;
    return assetsGroupViewController.selectedAssets;
}

- (void)deselectAssetAtIndex:(NSUInteger)index{
    CTAssetsGroupViewController *assetsGroupViewController = (CTAssetsGroupViewController *)self.topViewController;
    [assetsGroupViewController deselectAssetAtIndex:index];
}

- (void)setToolbarItemBackgroundColor:(UIColor *)toolbarItemBackgroundColor{
    CTAssetsGroupViewController *assetsGroupViewController = (CTAssetsGroupViewController *)self.topViewController;
    [assetsGroupViewController setToolbarItemBackgroundColor:toolbarItemBackgroundColor];
}

- (void)setToolbarItemFontColor:(UIColor *)toolbarItemFontColor{
    CTAssetsGroupViewController *assetsGroupViewController = (CTAssetsGroupViewController *)self.topViewController;
    [assetsGroupViewController setToolbarItemFontColor:toolbarItemFontColor];
}

- (BOOL)shouldAutorotate{
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationPortrait;
}

@end
