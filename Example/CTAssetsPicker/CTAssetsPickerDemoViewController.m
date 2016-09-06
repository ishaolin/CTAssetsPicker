//
//  CTAssetsPickerDemoViewController.m
//  CTAssetsPicker
//
//  Created by wshaolin on 16/9/6.
//  Copyright © 2016年 wangshaolin. All rights reserved.
//

#import "CTAssetsPickerDemoViewController.h"
#import <CTAssetsPicker/CTAssetsPickerController.h>

@interface CTAssetsPickerDemoViewController ()<CTAssetsPickerControllerDelegate, UINavigationControllerDelegate>{
    UIButton *_openAlbumButton;
}

@end

@implementation CTAssetsPickerDemoViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]){
        self.title = @"CTAssetsPickerDemo";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _openAlbumButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_openAlbumButton setTitle:@"从相册选择照片" forState:UIControlStateNormal];
    [_openAlbumButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_openAlbumButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    _openAlbumButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [_openAlbumButton addTarget:self action:@selector(clickOpenAlbumButton:) forControlEvents:UIControlEventTouchUpInside];
    _openAlbumButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    _openAlbumButton.clipsToBounds = YES;
    _openAlbumButton.layer.borderWidth = 0.75;
    _openAlbumButton.layer.cornerRadius = 5.0;
    _openAlbumButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    CGFloat openAlbumButton_W = 150.0;
    CGFloat openAlbumButton_H = 36.0;
    CGFloat openAlbumButton_Y = 30.0 + (NSInteger)(self.navigationController.navigationBar.isTranslucent) * 64.0;
    CGFloat openAlbumButton_X = (self.view.bounds.size.width - openAlbumButton_W) * 0.5;
    
    _openAlbumButton.frame = CGRectMake(openAlbumButton_X, openAlbumButton_Y, openAlbumButton_W, openAlbumButton_H);
    [self.view addSubview:_openAlbumButton];
}

- (void)clickOpenAlbumButton:(UIButton *)button{
    CTAssetsPickerController *assetsPickerController = [[CTAssetsPickerController alloc] initWithAssetsType:CTAssetsPickerControllerAssetsTypeAllAsset];
    assetsPickerController.delegate = self;
    assetsPickerController.enableMaximumCount = 9;
    [self presentViewController:assetsPickerController animated:YES completion:NULL];
}

- (void)assetsPickerController:(CTAssetsPickerController *)assetsPickerController didFinishPickingAssets:(NSArray *)assets assetsType:(CTAssetsPickerControllerAssetsType)assetsType{
    NSLog(@"%@", NSStringFromSelector(@selector(assetsPickerController:didFinishPickingAssets:assetsType:)));
    switch (assetsType) {
        case CTAssetsPickerControllerAssetsTypePhoto:{
            
        }
            break;
        case CTAssetsPickerControllerAssetsTypeVideo:{
            
        }
            break;
        case CTAssetsPickerControllerAssetsTypeAllAsset:{
            
        }
            break;
        default:
            break;
    }
}

- (void)assetsPickerController:(CTAssetsPickerController *)assetsPickerController didDeselectAsset:(ALAsset *)asset{
    NSLog(@"%@", NSStringFromSelector(@selector(assetsPickerController:didDeselectAsset:)));
}

- (void)assetsPickerController:(CTAssetsPickerController *)assetsPickerController didSelectAsset:(ALAsset *)asset{
    NSLog(@"%@", NSStringFromSelector(@selector(assetsPickerController:didSelectAsset:)));
}

- (void)assetsPickerController:(CTAssetsPickerController *)assetsPickerController didSelectCountReachedEnableMaximumCount:(NSUInteger)enableMaximumCount{
    NSLog(@"%@", NSStringFromSelector(@selector(assetsPickerController:didSelectCountReachedEnableMaximumCount:)));
}

- (void)assetsPickerController:(CTAssetsPickerController *)assetsPickerController didSelectCountUnderEnableMinimumCount:(NSUInteger)enableMinimumCount{
    NSLog(@"%@", NSStringFromSelector(@selector(assetsPickerController:didSelectCountUnderEnableMinimumCount:)));
}

- (void)assetsPickerControllerDidCancel:(CTAssetsPickerController *)assetsPickerController{
    NSLog(@"%@", NSStringFromSelector(@selector(assetsPickerControllerDidCancel:)));
}

@end
