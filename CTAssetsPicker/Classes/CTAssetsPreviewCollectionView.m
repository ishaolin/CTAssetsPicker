//
//  CTAssetsPreviewCollectionView.m
//  CTAssetsPickerDemo
//
//  Created by wshaolin on 15/7/27.
//  Copyright © 2016年 wshaolin. All rights reserved.
//

#import "CTAssetsPreviewCollectionView.h"

@interface CTAssetsPreviewCollectionView(){
    NSIndexPath *_scrollToIndexPath;
    BOOL _isScrollToIndexPath;
}

@end

@implementation CTAssetsPreviewCollectionView

- (instancetype)initWithDataSource:(id<UICollectionViewDataSource>)dataSource delegate:(id<UICollectionViewDelegate>)delegate{
    UICollectionViewFlowLayout *collectionViewFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    collectionViewFlowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    collectionViewFlowLayout.sectionInset = UIEdgeInsetsZero;
    collectionViewFlowLayout.minimumInteritemSpacing = 0.0;
    collectionViewFlowLayout.minimumLineSpacing = 0.0;
    collectionViewFlowLayout.headerReferenceSize = CGSizeZero;
    collectionViewFlowLayout.footerReferenceSize = CGSizeZero;
    
    if(self = [super initWithFrame:CGRectZero collectionViewLayout:collectionViewFlowLayout]){
        self.dataSource = dataSource;
        self.delegate = delegate;
        
        self.pagingEnabled = YES;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.backgroundView = nil;
        self.backgroundColor = [UIColor clearColor];
        self.autoresizesSubviews = YES;
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _isScrollToIndexPath = YES;
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{
    if(self = [super initWithFrame:frame collectionViewLayout:layout]){
        _isScrollToIndexPath = YES;
    }
    return self;
}

- (void)scrollToItemAtIndexPath:(NSIndexPath *)indexPath{
    _scrollToIndexPath = indexPath;
}

- (void)setContentSize:(CGSize)contentSize{
    if(!CGSizeEqualToSize(contentSize, self.contentSize)){
        [super setContentSize:contentSize];
        
        if(_isScrollToIndexPath && _scrollToIndexPath != nil){
            [self scrollToItemAtIndexPath:_scrollToIndexPath atScrollPosition:UICollectionViewScrollPositionRight animated:NO];
            _isScrollToIndexPath = NO;
        }
    }
}

@end
