//
//  CTAssetsPreviewCollectionViewCell.m
//  CTAssetsPickerDemo
//
//  Created by wshaolin on 15/7/17.
//  Copyright © 2016年 wshaolin. All rights reserved.
//

#import "CTAssetsPreviewCollectionViewCell.h"
#import "CTAssetView.h"

@interface CTAssetsPreviewCollectionViewCell()<CTAssetViewDelegate>{
    CTAssetView *_assetView;
}

@end

@implementation CTAssetsPreviewCollectionViewCell

+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView forIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"CTAssetsPreviewCollectionViewCell";
    return [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        _assetView = [[CTAssetView alloc] init];
        _assetView.customDelegate = self;
        
        [self.contentView addSubview:_assetView];
        self.backgroundView = nil;
        self.contentView.backgroundColor = [UIColor clearColor];
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    }
    
    return self;
}

- (void)setAsset:(ALAsset *)asset{
    if(_asset != asset){
        _asset = asset;
        
        _assetView.asset = asset;
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGRect assetViewFrame = self.bounds;
    assetViewFrame.size.width -= CTAssetsPreviewCollectionViewCellImageRightIntervalSpacing;
    _assetView.frame = assetViewFrame;
}

- (void)assetViewDidSingleTouch:(CTAssetView *)assetView{
    if(self.delegate && [self.delegate respondsToSelector:@selector(assetsPreviewCollectionViewCellDidSingleTouch:)]){
        [self.delegate assetsPreviewCollectionViewCellDidSingleTouch:self];
    }
}

@end
