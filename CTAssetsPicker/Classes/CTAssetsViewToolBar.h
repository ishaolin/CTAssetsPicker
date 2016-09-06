//
//  CTAssetsViewToolBar.h
//  CTAssetsPicker
//
//  Created by wshaolin on 15/7/9.
//  Copyright (c) 2015年 神州锐达（北京）科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CTAssetsViewToolBar;

@protocol CTAssetsViewToolBarDelegate <NSObject>

@optional
- (void)assetsViewToolBarDidCompleted:(CTAssetsViewToolBar *)assetsViewToolBar;
- (void)assetsViewToolBarDidPreviewed:(CTAssetsViewToolBar *)assetsViewToolBar;

@end

@interface CTAssetsViewToolBar : UIView

@property (nonatomic, weak) id<CTAssetsViewToolBarDelegate> delegate;

@property (nonatomic, assign) NSInteger selectedCount;
@property (nonatomic, assign) NSInteger enableMaximumCount;
@property (nonatomic, assign, getter = isHiddenPreviewItem) BOOL hiddenPreviewItem;

@property (nonatomic, assign, getter = isTranslucent) BOOL translucent;

@property (nonatomic, strong, readwrite) UIColor *barButtonItemBackgroundColor;
@property (nonatomic, strong, readwrite) UIColor *barButtonItemFontColor;

- (void)setHidden:(BOOL)hidden animated:(BOOL)animated;

- (void)setHidden:(BOOL)hidden animated:(BOOL)animated completion:(void (^)(BOOL finished))completion;

@end
