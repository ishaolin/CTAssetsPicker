//
//  CTAssetsToolBarButtonItem.h
//  CTAssetsPicker
//
//  Created by wshaolin on 15/7/10.
//  Copyright (c) 2015年 神州锐达（北京）科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CTAssetsToolBarButtonItem : UIButton

@property (nonatomic, assign) NSUInteger barButtonItemFontSize;
@property (nonatomic, copy) NSString *barButtonItemTitle;

@property (nonatomic, assign, getter = isEnableHighlighted) BOOL enableHighlighted;
- (void)addTarget:(id)target action:(SEL)action;

@end
