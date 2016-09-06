//
//  CTAssetsPreviewController.m
//  Pods
//
//  Created by wshaolin on 15/7/13.
//  Copyright © 2016年 wshaolin. All rights reserved.
//

#import "CTAssetsPreviewController.h"
#import "CTAssetsViewToolBar.h"
#import "CTAssetView.h"
#import "CTAssetsPickerController.h"
#import "CTAssetsToolBarButtonItem.h"
#import "CTAssetsPreviewCollectionViewCell.h"
#import "CTAssetsPreviewCollectionView.h"
#import "ALAsset+CTAssetEqual.h"
#import "UIImage+CTAssetsPicker.h"

@interface CTAssetsPreviewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, CTAssetsPreviewCollectionViewCellDelegate, CTAssetsViewToolBarDelegate>{
    CTAssetsPreviewCollectionView *_collectionView;
    CTAssetsViewToolBar *_toolBar;
    CTAssetsToolBarButtonItem *_selectBarButtonItem;
    
    BOOL _isTranslucent;
    
    __weak CTAssetsPickerController *_assetsPickerController;
}

@end

@implementation CTAssetsPreviewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]){
        self.title = NSLocalizedString(@"预览", nil);
        self.automaticallyAdjustsScrollViewInsets = NO;
        
        _toolBar = [[CTAssetsViewToolBar alloc] init];
        _toolBar.hiddenPreviewItem = YES;
        _toolBar.delegate = self;
        _toolBar.translucent = YES;
        
        _selectBarButtonItem = [CTAssetsToolBarButtonItem buttonWithType:UIButtonTypeCustom];
        _selectBarButtonItem.enableHighlighted = NO;
        [_selectBarButtonItem setImage:[UIImage ctAssets_imageNamed:@"CTAssetsPickerSelectButtonNormal"] forState:UIControlStateNormal];
        [_selectBarButtonItem setImage:[UIImage ctAssets_imageNamed:@"CTAssetsPickerSelectButtonSelected"] forState:UIControlStateSelected];
        _selectBarButtonItem.backgroundColor = [UIColor clearColor];
        [_selectBarButtonItem addTarget:self action:@selector(didClickSelectBarButtonItem:)];
        _selectBarButtonItem.frame = CGRectMake(0, 0, 40.0, 40.0);
        
        _collectionView = [[CTAssetsPreviewCollectionView alloc] initWithDataSource:self delegate:self];
        [_collectionView registerClass:[CTAssetsPreviewCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([CTAssetsPreviewCollectionViewCell class])];
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.translucent = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.translucent = _isTranslucent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_selectBarButtonItem];
    
    _assetsPickerController = (CTAssetsPickerController *)self.navigationController;
    _isTranslucent = self.navigationController.navigationBar.isTranslucent;
    _toolBar.enableMaximumCount = _assetsPickerController.enableMaximumCount;
    
    CGRect collectionViewFrame = self.view.bounds;
    collectionViewFrame.size.width += CTAssetsPreviewCollectionViewCellImageRightIntervalSpacing;
    _collectionView.frame = collectionViewFrame;
    [self.view addSubview:_collectionView];
    
    _toolBar.translucent = YES;
    _toolBar.frame = CGRectMake(0, self.view.bounds.size.height - _toolBar.frame.size.height, 0, 0);
    [self.view addSubview:_toolBar];
    
    // 滚动到指定的row
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:_currentAssetIndex inSection:0];
    if(self.assetArray.count > 0 && _currentAssetIndex < self.assetArray.count){
        [_collectionView scrollToItemAtIndexPath:indexPath];
        ALAsset *asset = _assetArray[indexPath.row];
        _selectBarButtonItem.selected = asset.isSelected;
    }
}

- (void)setSeletedCount:(NSInteger)seletedCount{
    _seletedCount = seletedCount;
    _toolBar.selectedCount = seletedCount;
}

- (void)didClickSelectBarButtonItem:(CTAssetsToolBarButtonItem *)barButtonItem{
    BOOL shouldSelection = YES;
    if(!barButtonItem.isSelected){
        if(_assetsPickerController.enableMaximumCount > 0 && _seletedCount == _assetsPickerController.enableMaximumCount){
            if(_assetsPickerController.delegate && [_assetsPickerController.delegate respondsToSelector:@selector(assetsPickerController:didSelectCountReachedEnableMaximumCount:)]){
                [_assetsPickerController.delegate assetsPickerController:_assetsPickerController didSelectCountReachedEnableMaximumCount:_assetsPickerController.enableMaximumCount];
            }
            shouldSelection = NO;
        }
    }
    
    if(shouldSelection){
        if(_currentAssetIndex < _assetArray.count){
            barButtonItem.selected = !barButtonItem.isSelected;
            ALAsset *asset = _assetArray[_currentAssetIndex];
            asset.selected = barButtonItem.isSelected;
            if(self.delegate && [self.delegate respondsToSelector:@selector(assetsPreviewController:didSelectedAsset:)]){
                [self.delegate assetsPreviewController:self didSelectedAsset:asset];
            }
        }
    }
}

- (void)assetsPreviewCollectionViewCellDidSingleTouch:(CTAssetsPreviewCollectionViewCell *)collectionViewCell{
    BOOL isHidden = !self.navigationController.isNavigationBarHidden;
    [self.navigationController setNavigationBarHidden:isHidden animated:YES];
    
    __weak typeof(self) wself = self;
    [_toolBar setHidden:isHidden animated:YES completion:^(BOOL finished) {
        [wself setNeedsStatusBarAppearanceUpdate];
    }];
}

- (BOOL)prefersStatusBarHidden{
    return self.navigationController.isNavigationBarHidden;
}

- (void)assetsViewToolBarDidCompleted:(CTAssetsViewToolBar *)assetsViewToolBar{
    if(self.delegate && [self.delegate respondsToSelector:@selector(assetsPreviewControllerDidCompleted:)]){
        [self.delegate assetsPreviewControllerDidCompleted:self];
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _assetArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CTAssetsPreviewCollectionViewCell *cell = [CTAssetsPreviewCollectionViewCell cellWithCollectionView:collectionView forIndexPath:indexPath];
    cell.asset = _assetArray[indexPath.row];
    cell.delegate = self;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return collectionView.bounds.size;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    _currentAssetIndex = (NSUInteger)lroundf(scrollView.contentOffset.x / scrollView.frame.size.width);
    if(_currentAssetIndex >= _assetArray.count){
        _currentAssetIndex = _assetArray.count - 1;
    }
    
    ALAsset *asset = _assetArray[_currentAssetIndex];
    _selectBarButtonItem.selected = asset.isSelected;
}

- (BOOL)shouldAutorotate{
    return NO;
}

@end
