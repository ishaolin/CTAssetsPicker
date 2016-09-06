//
//  CTAssetsPreviewCollectionViewCell.h
//  Pods
//
//  Created by wshaolin on 15/7/17.
//  Copyright © 2016年 wshaolin. All rights reserved.
//

#import <UIKit/UIKit.h>

#define CTAssetsPreviewCollectionViewCellImageRightIntervalSpacing 20.0

@class CTAssetsPreviewCollectionViewCell;
@class ALAsset;

@protocol CTAssetsPreviewCollectionViewCellDelegate <NSObject>

@optional
- (void)assetsPreviewCollectionViewCellDidSingleTouch:(CTAssetsPreviewCollectionViewCell *)collectionViewCell;

@end

@interface CTAssetsPreviewCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) ALAsset *asset;
@property (nonatomic, weak) id<CTAssetsPreviewCollectionViewCellDelegate> delegate;

+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView forIndexPath:(NSIndexPath *)indexPath;

@end
