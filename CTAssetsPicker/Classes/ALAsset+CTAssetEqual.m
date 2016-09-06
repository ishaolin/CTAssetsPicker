//
//  ALAsset+CTAssetEqual.m
//  Pods
//
//  Created by wshaolin on 15/7/13.
//  Copyright © 2016年 wshaolin. All rights reserved.
//

#import "ALAsset+CTAssetEqual.h"
#import <objc/runtime.h>

@implementation ALAsset (CTAssetEqual)

- (void)setCt_selected:(BOOL)ct_selected{
    objc_setAssociatedObject(self, @selector(isCt_selected), @(ct_selected), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)isCt_selected{
    return [objc_getAssociatedObject(self, @selector(isCt_selected)) boolValue];
}

- (CTAssetsPickerAssetDataType)ct_assetDataType{
    NSString *assetPropertyType = [self valueForProperty:ALAssetPropertyType];
    if([assetPropertyType isEqualToString:ALAssetTypePhoto]){
        return CTAssetsPickerAssetDataTypePhoto;
    }else if ([assetPropertyType isEqualToString:ALAssetTypeVideo]){
        return CTAssetsPickerAssetDataTypeVideo;
    }else{
        return CTAssetsPickerAssetDataTypeUnknown;
    }
}

- (NSString *)ct_videoDuration{
    NSTimeInterval timeInterval = [[self valueForProperty:ALAssetPropertyDuration] floatValue];
    int timeValue = (int)lroundf(timeInterval);
    
    if(timeValue > 0){
        int timeHour = 0; // 小时
        int timeMinute = 0; // 分钟
        int timeSecond = timeValue; // 秒
        int timeUnitValue = 60; // 时间单位值
        
        if(timeSecond >= timeUnitValue){
            timeMinute = timeValue / timeUnitValue;
            timeSecond = timeValue % timeUnitValue;
        }
        
        if (timeMinute >= timeUnitValue) {
            timeHour = timeMinute / timeUnitValue;
            timeMinute = timeMinute % timeUnitValue;
        }
        
        if(timeHour > 0){
            return [NSString stringWithFormat:@"%d:%.2d:%.2d", timeHour, timeMinute, timeSecond];
        }else{
            return [NSString stringWithFormat:@"%d:%.2d", timeMinute, timeSecond];
        }
    }
    
    return nil;
}

- (BOOL)ct_isEqual:(id)object{
    if([object isKindOfClass:[ALAsset class]]){
        ALAsset *asset = (ALAsset *)object;
        NSURL *selfURL = [self valueForProperty:ALAssetPropertyAssetURL];
        NSURL *assetURL = [asset valueForProperty:ALAssetPropertyAssetURL];
        return [selfURL.absoluteString isEqualToString:assetURL.absoluteString];
    }
    
    return NO;
}

@end
