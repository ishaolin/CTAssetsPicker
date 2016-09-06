//
//  ALAsset+CTAssetEqual.m
//  CTAssetsPickerDemo
//
//  Created by wshaolin on 15/7/13.
//  Copyright © 2016年 wshaolin. All rights reserved.
//

#import "ALAsset+CTAssetEqual.h"
#import <objc/runtime.h>

@implementation ALAsset (CTAssetEqual)

- (void)setSelected:(BOOL)selected{
    objc_setAssociatedObject(self, @selector(setSelected:), @(selected), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)isSelected{
    NSNumber *selected = objc_getAssociatedObject(self, @selector(setSelected:));
    return [selected boolValue];
}

- (CTAssetsPickerAssetDataType)assetDataType{
    NSString *assetPropertyType = [self valueForProperty:ALAssetPropertyType];
    if([assetPropertyType isEqualToString:ALAssetTypePhoto]){
        return CTAssetsPickerAssetDataTypePhoto;
    }else if ([assetPropertyType isEqualToString:ALAssetTypeVideo]){
        return CTAssetsPickerAssetDataTypeVideo;
    }else{
        return CTAssetsPickerAssetDataTypeUnknown;
    }
}

- (NSString *)videoDuration{
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

- (BOOL)isEquals:(ALAsset *)asset{
    if([asset isKindOfClass:[ALAsset class]]){
        NSURL *selfURL = [self valueForProperty:ALAssetPropertyAssetURL];
        NSURL *assetURL = [asset valueForProperty:ALAssetPropertyAssetURL];
        return [selfURL.absoluteString isEqualToString:assetURL.absoluteString];
    }
    
    return NO;
}

@end
