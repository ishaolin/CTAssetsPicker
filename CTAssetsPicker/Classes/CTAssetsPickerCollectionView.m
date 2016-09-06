//
//  CTAssetsPickerCollectionView.m
//  CTAssetsPickerDemo
//
//  Created by wshaolin on 15/7/10.
//  Copyright © 2016年 wshaolin. All rights reserved.
//

#import "CTAssetsPickerCollectionView.h"

@interface CTAssetsPickerCollectionView(){
    BOOL _isNeedAutoScrollToBottom;
}

@end

@implementation CTAssetsPickerCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{
    if(self = [super initWithFrame:frame collectionViewLayout:layout]){
        self.showsHorizontalScrollIndicator = NO;
        self.alwaysBounceVertical = YES;
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        self.backgroundView = nil;
        self.backgroundColor = [UIColor whiteColor];
        
        _isNeedAutoScrollToBottom = YES;
    }
    return self;
}

- (void)setContentInsetTop:(CGFloat)contentInsetTop{
    UIEdgeInsets contentInset = self.contentInset;
    contentInset.top = contentInsetTop;
    self.contentInset = contentInset;
}

- (void)setContentInsetBottom:(CGFloat)contentInsetBottom{
    UIEdgeInsets contentInset = self.contentInset;
    contentInset.bottom = contentInsetBottom;
    self.contentInset = contentInset;
}

- (void)setContentInsetLeft:(CGFloat)contentInsetLeft{
    UIEdgeInsets contentInset = self.contentInset;
    contentInset.left = contentInsetLeft;
    self.contentInset = contentInset;
}

- (void)setContentInsetRight:(CGFloat)contentInsetRight{
    UIEdgeInsets contentInset = self.contentInset;
    contentInset.right = contentInsetRight;
    self.contentInset = contentInset;
}

- (CGFloat)contentInsetTop{
    return self.contentInset.top;
}

- (CGFloat)contentInsetBottom{
    return self.contentInset.bottom;
}

- (CGFloat)contentInsetLeft{
    return self.contentInset.left;
}

- (CGFloat)contentInsetRight{
    return self.contentInset.right;
}

- (void)setContentSize:(CGSize)contentSize{
    [super setContentSize:contentSize];
    
    if(_isNeedAutoScrollToBottom && contentSize.height > self.frame.size.height){
        [self scrollToBottom];
        _isNeedAutoScrollToBottom = NO;
    }
}

- (void)scrollToBottom{
    CGFloat offsetY = self.contentSize.height - self.frame.size.height + self.contentInsetBottom;
    if(offsetY > 0){
        [self setContentOffset:CGPointMake(0, offsetY) animated:NO];
    }
}

@end
