//
//  CTAssetsCollectionViewCell.h
//  CTAssetsPicker
//
//  Created by wshaolin on 15/7/9.
//  Copyright © 2016年 wshaolin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ALAsset+CTAssetEqual.h"

@class CTAssetsCollectionViewCell;

@protocol CTAssetsCollectionViewCellDelegate <NSObject>

@optional
- (void)assetsCollectionViewCell:(CTAssetsCollectionViewCell *)assetsCollectionViewCell didSelectedAsset:(BOOL)isSelected withIndexPath:(NSIndexPath *)indexPath;

- (BOOL)assetsCollectionViewCell:(CTAssetsCollectionViewCell *)assetsCollectionViewCell shouldSelectAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface CTAssetsCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) ALAsset *asset;
@property (nonatomic, weak) id<CTAssetsCollectionViewCellDelegate> delegate;

+ (instancetype)assetCellWithCollectionView:(UICollectionView *)collectionView forIndexPath:(NSIndexPath *)indexPath;

@end
