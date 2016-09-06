//
//  CTAssetsGroupTableViewCell.h
//  CTAssetsPicker
//
//  Created by wshaolin on 15/7/9.
//  Copyright © 2016年 wshaolin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ALAssetsGroup;

@interface CTAssetsGroupTableViewCell : UITableViewCell

@property (nonatomic, assign, getter = isShowDividingLine) BOOL showDividingLine;

@property (nonatomic, assign, getter = isFirstRowInSection) BOOL firstRowInSection;
@property (nonatomic, assign, getter = isLastRowInSection) BOOL lastRowInSection;

@property (nonatomic, strong) UIColor *dividingLineColor;

@property (nonatomic, strong) ALAssetsGroup *assetsGroup;

+ (instancetype)groupViewCellWithTableView:(UITableView *)tableView;

@end
