//
//  CTAssetsCollectionViewCell.m
//  Pods
//
//  Created by wshaolin on 15/7/9.
//  Copyright © 2016年 wshaolin. All rights reserved.
//

#import "CTAssetsCollectionViewCell.h"
#import "CTAssetsToolBarButtonItem.h"
#import "UIImage+CTAssetsPicker.h"

@interface CTAssetsCollectionViewCell(){
    UIImageView *_displayImageView;
    UIImageView *_videoImageView;
    UIView *_selectedMask;
    CTAssetsToolBarButtonItem *_selectButton;
    UILabel *_videoDurationLabel;
}

@end

@implementation CTAssetsCollectionViewCell

+ (instancetype)assetCellWithCollectionView:(UICollectionView *)collectionView forIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"CTAssetsCollectionViewCell";
    return [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        _displayImageView = [[UIImageView alloc] init];
        _displayImageView.clipsToBounds = YES;
        _displayImageView.contentMode = UIViewContentModeScaleAspectFill;
        
        _selectedMask = [[UIView alloc] init];
        _selectedMask.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.4];
        _selectedMask.hidden = YES;
        
        _selectButton = [CTAssetsToolBarButtonItem buttonWithType:UIButtonTypeCustom];
        _selectButton.enableHighlighted = NO;
        _selectButton.backgroundColor = [UIColor clearColor];
        [_selectButton setImage:[UIImage ctAssets_imageNamed:@"assets_picker_select_button_normal"] forState:UIControlStateNormal];
        [_selectButton setImage:[UIImage ctAssets_imageNamed:@"assets_picker_select_button_selected"] forState:UIControlStateSelected];
        [_selectButton addTarget:self action:@selector(didClickSelectButton:)];
        
        _videoImageView = [[UIImageView alloc] init];
        _videoImageView.image = [UIImage ctAssets_imageNamed:@"assets_picker_video_icon"];
        _videoImageView.contentMode = UIViewContentModeCenter;
        _videoImageView.hidden = YES;
        
        _videoDurationLabel = [[UILabel alloc] init];
        _videoDurationLabel.textAlignment = NSTextAlignmentRight;
        _videoDurationLabel.textColor = [UIColor whiteColor];
        _videoDurationLabel.font = [UIFont systemFontOfSize:11.0];
        
        [self.contentView addSubview:_displayImageView];
        [self.contentView addSubview:_selectedMask];
        [self.contentView addSubview:_selectButton];
        [self.contentView addSubview:_videoImageView];
        [self.contentView addSubview:_videoDurationLabel];
        
        self.backgroundView = nil;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setAsset:(ALAsset *)asset{
    _asset = asset;
    
    _displayImageView.image = [UIImage imageWithCGImage:_asset.aspectRatioThumbnail];
    _selectedMask.hidden = !_asset.isCt_selected;
    _selectButton.selected = _asset.isCt_selected;
    _videoImageView.hidden = [_asset ct_assetDataType] != CTAssetsPickerAssetDataTypeVideo;
    _videoDurationLabel.hidden = _videoImageView.isHidden;
    _videoDurationLabel.text = [_asset ct_videoDuration];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    _displayImageView.frame = self.bounds;
    _selectedMask.frame = self.bounds;
    
    CGFloat selectButton_W = 30.0;
    CGFloat selectButton_H = selectButton_W;
    CGFloat selectButton_X = self.bounds.size.width - selectButton_W;
    CGFloat selectButton_Y = 0;
    _selectButton.frame = CGRectMake(selectButton_X, selectButton_Y, selectButton_W, selectButton_H);
    
    CGFloat video_M = 5.0;
    CGFloat videoImageView_W = 16.0;
    CGFloat videoImageView_H = 9.0;
    CGFloat videoImageView_X = video_M;
    CGFloat videoImageView_Y = self.bounds.size.height - videoImageView_H - video_M;
    _videoImageView.frame = CGRectMake(videoImageView_X, videoImageView_Y, videoImageView_W, videoImageView_H);
    
    CGFloat videoDurationLabel_X = CGRectGetMaxX(_videoImageView.frame) + video_M;
    CGFloat videoDurationLabel_H = 20.0;
    CGFloat videoDurationLabel_W = self.bounds.size.width - videoDurationLabel_X - video_M;
    CGFloat videoDurationLabel_Y = self.bounds.size.height - videoDurationLabel_H;
    _videoDurationLabel.frame = CGRectMake(videoDurationLabel_X, videoDurationLabel_Y, videoDurationLabel_W, videoDurationLabel_H);
}

- (void)didClickSelectButton:(UIButton *)button{
    BOOL shouldSelection = YES;
    if(!button.isSelected){
        if(self.delegate && [self.delegate respondsToSelector:@selector(assetsCollectionViewCell:shouldSelectAtIndexPath:)]){
            shouldSelection = [self.delegate assetsCollectionViewCell:self shouldSelectAtIndexPath:self.indexPath];
        }
    }
    
    if(shouldSelection){
        _asset.ct_selected = !_asset.isCt_selected;
        self.asset = _asset;
        
        if(self.delegate && [self.delegate respondsToSelector:@selector(assetsCollectionViewCell:didSelectedAsset:withIndexPath:)]){
            [self.delegate assetsCollectionViewCell:self didSelectedAsset:_asset.isCt_selected withIndexPath:self.indexPath];
        }
    }
}

@end
