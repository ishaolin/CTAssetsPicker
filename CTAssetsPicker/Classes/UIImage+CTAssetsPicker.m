//
//  UIImage+CTAssetsPicker.m
//  Pods
//
//  Created by wshaolin on 16/7/7.
//  Copyright © 2016年 wshaolin. All rights reserved.
//

#import "UIImage+CTAssetsPicker.h"

@implementation UIImage (CTAssetsPicker)

+ (UIImage *)ctAssets_imageNamed:(NSString *)name{
    if(name != nil && name.length > 0){
        name = [@"Frameworks/CTAssetsPicker.framework/CTAssetsPicker.bundle" stringByAppendingPathComponent:name];
        return [UIImage imageNamed:name];
    }
    
    return nil;
}

@end
