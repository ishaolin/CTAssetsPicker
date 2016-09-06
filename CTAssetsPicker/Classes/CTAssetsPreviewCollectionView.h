//
//  CTAssetsPreviewCollectionView.h
//  Pods
//
//  Created by wshaolin on 15/7/27.
//  Copyright © 2016年 wshaolin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CTAssetsPreviewCollectionView : UICollectionView

- (instancetype)initWithDataSource:(id<UICollectionViewDataSource>)dataSource delegate:(id<UICollectionViewDelegate>)delegate;

- (void)scrollToItemAtIndexPath:(NSIndexPath *)indexPath;

@end
