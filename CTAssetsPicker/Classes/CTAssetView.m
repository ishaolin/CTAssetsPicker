//
//  CTAssetView.m
//  CTAssetsPickerDemo
//
//  Created by wshaolin on 15/7/13.
//  Copyright (c) 2015年 神州锐达（北京）科技有限公司. All rights reserved.
//

#import "CTAssetView.h"
#import "ALAsset+CTAssetEqual.h"

@interface CTAssetView()<UIScrollViewDelegate>{
    UIImageView *_imageView;
    BOOL _isZoom;
}

@end

@implementation CTAssetView

- (id)initWithFrame:(CGRect)frame{
    if ((self = [super initWithFrame:frame])) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_imageView];
        
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor clearColor];
        self.delegate = self;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.decelerationRate = UIScrollViewDecelerationRateFast;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        // 单击
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        [self addGestureRecognizer:singleTap];
        
        // 双击
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
        doubleTap.numberOfTapsRequired = 2;
        [self addGestureRecognizer:doubleTap];
        
        // 很重要，不写会导致双击手势响应时会先响应一次单击手势
        [singleTap requireGestureRecognizerToFail:doubleTap];
        
        // 监听横竖屏的切换
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveApplicationDidChangeStatusBarOrientationNotification:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    }
    
    return self;
}

- (void)setAsset:(ALAsset *)asset{
    if(_asset != asset){
        _asset = asset;
        ALAssetRepresentation *assetRepresentation = _asset.defaultRepresentation;
        // 解决取高清图方向不正确的问题
        _imageView.image = [UIImage imageWithCGImage:[assetRepresentation fullResolutionImage] scale:[assetRepresentation scale] orientation:(UIImageOrientation)[assetRepresentation orientation]];
        
        _isZoom = NO;
        [self adjustFrame];
    }
}

- (void)adjustFrame{
    if(_imageView.image != nil && !CGSizeEqualToSize(self.bounds.size, CGSizeZero)){
        CGSize boundsSize = self.bounds.size;
        CGFloat boundsWidth = boundsSize.width;
        CGFloat boundsHeight = boundsSize.height;
        
        CGSize imageSize = _imageView.image.size;
        CGFloat imageWidth = imageSize.width;
        CGFloat imageHeight = imageSize.height;
        
        CGFloat height = imageHeight * boundsWidth / imageWidth;
        
        CGFloat maximumZoomScale = 3.0;
        // 保证放大之后至少占满屏幕，太小的图片最大只能放大2倍
        CGFloat maxValue = MAX(_imageView.image.size.width, _imageView.image.size.height);
        CGFloat minValue = MIN(_imageView.image.size.width, _imageView.image.size.height);
        if(maxValue > 100.0 && minValue > 0 && (maxValue / minValue) < 2.5){
            CGSize screenSize = [UIScreen mainScreen].bounds.size;
            if(maximumZoomScale < screenSize.height / height){
                maximumZoomScale = screenSize.height / height;
            }
            if(maximumZoomScale < screenSize.width / boundsWidth){
                maximumZoomScale = screenSize.width / boundsWidth;
            }
        }
        
        self.maximumZoomScale = maximumZoomScale;
        self.minimumZoomScale = 1.0;
        self.zoomScale = self.minimumZoomScale;
        
        CGRect imageFrame = CGRectMake(0, 0, boundsWidth, height);
        self.contentSize = CGSizeMake(0, height);
        if (imageFrame.size.height < boundsHeight) {
            imageFrame.origin.y = (boundsHeight - imageFrame.size.height) * 0.5;
        }
        _imageView.frame = imageFrame;
    }
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    if([self.asset assetDataType] == CTAssetsPickerAssetDataTypePhoto){
        return _imageView;
    }
    return nil;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView{ // 保证缩放过长中居中显示
    _isZoom = YES;
    CGRect imageViewFrame = _imageView.frame;
    imageViewFrame.origin.y = (self.bounds.size.height - _imageView.frame.size.height) * 0.5;
    imageViewFrame.origin.x = (self.bounds.size.width - _imageView.frame.size.width) * 0.5;
    
    if(imageViewFrame.origin.y < 0){
        imageViewFrame.origin.y = 0;
    }
    
    if(imageViewFrame.origin.x < 0){
        imageViewFrame.origin.x = 0;
    }
    
    if(!CGRectEqualToRect(_imageView.frame, imageViewFrame)){
        _imageView.frame = imageViewFrame;
    }
}

- (void)handleSingleTap:(UITapGestureRecognizer *)tapGestureRecognizer{
    if(self.customDelegate && [self.customDelegate respondsToSelector:@selector(assetViewDidSingleTouch:)]){
        [self.customDelegate assetViewDidSingleTouch:self];
    }
}

- (void)handleDoubleTap:(UITapGestureRecognizer *)tapGestureRecognizer{
    _isZoom = YES;
    if(self.zoomScale < (self.maximumZoomScale + self.minimumZoomScale) * 0.5){
        [self setZoomScale:self.maximumZoomScale animated:YES];
    }else{
        [self setZoomScale:self.minimumZoomScale animated:YES];
    }
}

- (void)didReceiveApplicationDidChangeStatusBarOrientationNotification:(NSNotification *)notification{
    // 横竖屏切换时居中显示
    _imageView.center = CGPointMake(self.bounds.size.width * 0.5, self.bounds.size.height * 0.5);
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    if(!_isZoom){
        [self adjustFrame];
    }
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
