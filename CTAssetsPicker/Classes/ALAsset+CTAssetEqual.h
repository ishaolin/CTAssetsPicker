//
//  ALAsset+CTAssetEqual.h
//  Pods
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

@property (nonatomic, assign, getter = isCt_selected) BOOL ct_selected;

- (CTAssetsPickerAssetDataType)ct_assetDataType;
- (NSString *)ct_videoDuration;

- (BOOL)ct_isEqual:(id)object;

@end
