//
//  CTAssetsViewController.m
//  Pods
//
//  Created by wshaolin on 15/7/9.
//  Copyright (c) 2015年 神州锐达（北京）科技有限公司. All rights reserved.
//

#import "CTAssetsViewController.h"
#import "CTAssetsCollectionViewCell.h"
#import "CTAssetsViewToolBar.h"
#import "CTAssetsPickerController.h"
#import "CTAssetsPickerCollectionView.h"
#import "CTAssetsPickerFlowLayout.h"
#import "CTAssetsPreviewController.h"
#import "ALAsset+CTAssetEqual.h"

@interface CTAssetsViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, CTAssetsViewToolBarDelegate, CTAssetsPreviewControllerDelegate, CTAssetsCollectionViewCellDelegate>{
    CTAssetsPickerCollectionView *_collectionView;
    NSMutableArray<ALAsset *> *_assets;
    NSMutableArray<ALAsset *> *_selectAssets;
    CTAssetsViewToolBar *_toolBar;
    
    __weak CTAssetsPickerController *_assetsPickerController;
}

@end

@implementation CTAssetsViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]){
        _assets = [NSMutableArray array];
        _selectAssets = [NSMutableArray array];
        
        _toolBar = [[CTAssetsViewToolBar alloc] init];
        _toolBar.delegate = self;
        
        _collectionView = [[CTAssetsPickerCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:[[CTAssetsPickerFlowLayout alloc] init]];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [_collectionView registerClass:[CTAssetsCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([CTAssetsCollectionViewCell class])];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"取消", nil) style:UIBarButtonItemStylePlain target:self action:@selector(didClickCancelBarButtonItem:)];
    
    _assetsPickerController = (CTAssetsPickerController *)self.navigationController;
    
    _toolBar.enableMaximumCount = _assetsPickerController.enableMaximumCount;
    _toolBar.frame = CGRectMake(0, self.view.bounds.size.height - _toolBar.frame.size.height, 0, 0);
    _toolBar.hidden = _assets.count == 0;
    _toolBar.translucent = self.navigationController.navigationBar.isTranslucent;
    
    _collectionView.frame = self.view.bounds;
    _collectionView.contentInsetBottom = _toolBar.frame.size.height;
    
    [self.view addSubview:_collectionView];
    [self.view addSubview:_toolBar];
}

- (void)didClickCancelBarButtonItem:(UIBarButtonItem *)barButtonItem{
    if(_assetsPickerController.delegate && [_assetsPickerController.delegate respondsToSelector:@selector(assetsPickerControllerDidCancel:)]){
        [_assetsPickerController.delegate assetsPickerControllerDidCancel:_assetsPickerController];
    }
    [_assetsPickerController dismissViewControllerAnimated:YES completion:NULL];
}

- (void)setAssetsGroup:(ALAssetsGroup *)assetsGroup{
    self.title = [assetsGroup valueForProperty:ALAssetsGroupPropertyName];
    
    [assetsGroup enumerateAssetsUsingBlock:^(ALAsset *asset, NSUInteger index, BOOL *stop) {
        if(asset != nil){
            [_assets addObject:asset];
        }else{
            *stop = YES;
            [_collectionView reloadData];
        }
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _assets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CTAssetsCollectionViewCell *cell = [CTAssetsCollectionViewCell assetCellWithCollectionView:collectionView forIndexPath:indexPath];
    cell.indexPath = indexPath;
    cell.delegate = self;
    cell.asset = _assets[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    CTAssetsPreviewController *assetsPreviewController = [[CTAssetsPreviewController alloc] init];
    assetsPreviewController.assetArray = [_assets copy];
    assetsPreviewController.currentAssetIndex = indexPath.row;
    assetsPreviewController.delegate = self;
    assetsPreviewController.seletedCount = _selectAssets.count;
    [self.navigationController pushViewController:assetsPreviewController animated:YES];
}

- (void)assetsCollectionViewCell:(CTAssetsCollectionViewCell *)assetsCollectionViewCell didSelectedAsset:(BOOL)isSelected withIndexPath:(NSIndexPath *)indexPath{
    ALAsset *asset = _assets[indexPath.row];
    asset.ct_selected = isSelected;
    if(asset.isCt_selected){
        [_collectionView reloadItemsAtIndexPaths:@[indexPath]];
        [_selectAssets addObject:asset];
        _toolBar.selectedCount = _selectAssets.count;
        
        if(_assetsPickerController.delegate && [_assetsPickerController.delegate respondsToSelector:@selector(assetsPickerController:didSelectAsset:)]){
            [_assetsPickerController.delegate assetsPickerController:_assetsPickerController didSelectAsset:asset];
        }
    }else{ // 移除选择
        [_collectionView reloadItemsAtIndexPaths:@[indexPath]];
        
        if([_selectAssets containsObject:asset]){
            [_selectAssets removeObject:asset];
        }
        
        if(_assetsPickerController.delegate && [_assetsPickerController.delegate respondsToSelector:@selector(assetsPickerController:didDeselectAsset:)]){
            [_assetsPickerController.delegate assetsPickerController:_assetsPickerController didDeselectAsset:asset];
        }
        
        _toolBar.selectedCount = _selectAssets.count;
    }
}

- (BOOL)assetsCollectionViewCell:(CTAssetsCollectionViewCell *)assetsCollectionViewCell shouldSelectAtIndexPath:(NSIndexPath *)indexPath{
    if(_assetsPickerController.enableMaximumCount > 0 && _selectAssets.count >= _assetsPickerController.enableMaximumCount){
        if(_assetsPickerController.delegate && [_assetsPickerController.delegate respondsToSelector:@selector(assetsPickerController:didSelectCountReachedEnableMaximumCount:)]){
            [_assetsPickerController.delegate assetsPickerController:_assetsPickerController didSelectCountReachedEnableMaximumCount:_assetsPickerController.enableMaximumCount];
        }
        return NO;
    }
    return YES;
}

- (void)assetsViewToolBarDidCompleted:(CTAssetsViewToolBar *)assetsViewToolBar{
    if(_assetsPickerController.enableMinimumCount > 0 && _selectAssets.count < _assetsPickerController.enableMinimumCount){
        if(_assetsPickerController.delegate && [_assetsPickerController.delegate respondsToSelector:@selector(assetsPickerController:didSelectCountUnderEnableMinimumCount:)]){
            [_assetsPickerController.delegate assetsPickerController:_assetsPickerController didSelectCountUnderEnableMinimumCount:_assetsPickerController.enableMinimumCount];
        }
    }else{
        if(_assetsPickerController.delegate){
            [_assetsPickerController.delegate assetsPickerController:_assetsPickerController didFinishPickingAssets:[_selectAssets copy] assetsType:_assetsPickerController.assetsType];
        }
        
        if(_assetsPickerController.isFinishDismissViewController){
            [_assetsPickerController dismissViewControllerAnimated:YES completion:NULL];
        }
    }
}

- (void)assetsViewToolBarDidPreviewed:(CTAssetsViewToolBar *)assetsViewToolBar{
    CTAssetsPreviewController *assetsPreviewController = [[CTAssetsPreviewController alloc] init];
    assetsPreviewController.assetArray = [_selectAssets copy];
    assetsPreviewController.currentAssetIndex = 0;
    assetsPreviewController.delegate = self;
    assetsPreviewController.seletedCount = _selectAssets.count;
    [self.navigationController pushViewController:assetsPreviewController animated:YES];
}

- (NSArray<ALAsset *> *)selectedAssets{
    return [_selectAssets copy];
}

- (void)deselectAssetAtIndex:(NSUInteger)index{
    if(index < _selectAssets.count){
        for(NSInteger i = 0; i < _assets.count; i ++){
            ALAsset *asset = _assets[i];
            if([asset ct_isEqual:_selectAssets[index]]){
                asset.ct_selected = NO;
                
                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
                [_collectionView reloadItemsAtIndexPaths:@[indexPath]];
                break;
            }
        }
        
        [_selectAssets removeObjectAtIndex:index];
        _toolBar.selectedCount = _selectAssets.count;
    }
}

- (void)setToolbarItemBackgroundColor:(UIColor *)toolbarItemBackgroundColor{
    [_toolBar setBarButtonItemBackgroundColor:toolbarItemBackgroundColor];
}

- (void)setToolbarItemFontColor:(UIColor *)toolbarItemFontColor{
    [_toolBar setBarButtonItemFontColor:toolbarItemFontColor];
}

- (void)assetsPreviewControllerDidCompleted:(CTAssetsPreviewController *)assetsPreviewController{
    [self assetsViewToolBarDidCompleted:_toolBar];
}

- (void)assetsPreviewController:(CTAssetsPreviewController *)assetsPreviewController didSelectedAsset:(ALAsset *)asset{
    for(NSInteger index = 0; index < _assets.count; index ++){
        ALAsset *asset1 = _assets[index];
        if([asset1 ct_isEqual:asset]){
            asset1.ct_selected = asset.isCt_selected;
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
            [_collectionView reloadItemsAtIndexPaths:@[indexPath]];
            
            break;
        }
    }
    
    if(asset.isCt_selected){
        [_selectAssets addObject:asset];
        if(_assetsPickerController.delegate && [_assetsPickerController.delegate respondsToSelector:@selector(assetsPickerController:didSelectAsset:)]){
            [_assetsPickerController.delegate assetsPickerController:_assetsPickerController didSelectAsset:asset];
        }
    }else{
        [_selectAssets removeObject:asset];
        if(_assetsPickerController.delegate && [_assetsPickerController.delegate respondsToSelector:@selector(assetsPickerController:didDeselectAsset:)]){
            [_assetsPickerController.delegate assetsPickerController:_assetsPickerController didDeselectAsset:asset];
        }
    }
    _toolBar.selectedCount = _selectAssets.count;
    assetsPreviewController.seletedCount = _selectAssets.count;
}

@end
