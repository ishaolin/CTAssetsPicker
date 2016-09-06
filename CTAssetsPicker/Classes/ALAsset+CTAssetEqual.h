//
//  ALAsset+CTAssetEqual.h
//  CTAssetsPickerDemo
//
//  Created by wshaolin on 15/7/13.
//  Copyright © 2016年 wshaolin. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>

typedef NS_ENUM(NSInteger, CTAssetsPickerAssetDataType){
    CTAssetsPickerAssetDataTypePhoto,
    CTAssetsPickerAssetDataTypeVideo,
    CTAssetsPickerAssetDataTypeUnknown
};

@interface ALAsset (CTAssetEqual)

@property (nonatomic, assign, getter = isSelected) BOOL selected;

- (CTAssetsPickerAssetDataType)assetDataType;
- (NSString *)videoDuration;

- (BOOL)isEquals:(ALAsset *)asset;

@end
