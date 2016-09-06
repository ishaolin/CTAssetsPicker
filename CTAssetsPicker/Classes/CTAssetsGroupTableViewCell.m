//
//  CTAssetsGroupTableViewCell.m
//  Pods
//
//  Created by wshaolin on 15/7/9.
//  Copyright © 2016年 wshaolin. All rights reserved.
//

#import "CTAssetsGroupTableViewCell.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface CTAssetsGroupTableViewCell(){
    UIImageView *_displayImageView;
    UILabel *_displayTextLabel;
    
    UIView *_sectionTopLineView;
    UIView *_sectionBottomLineView;
    UIView *_cellDividingLineView;
}

@end

@implementation CTAssetsGroupTableViewCell

+ (instancetype)groupViewCellWithTableView:(UITableView *)tableView{
    static NSString *reuseIdentifier = @"CTAssetsGroupTableViewCell";
    CTAssetsGroupTableViewCell *groupViewCell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if(groupViewCell == nil){
        groupViewCell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    return groupViewCell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        _displayImageView = [[UIImageView alloc] init];
        _displayImageView.clipsToBounds = YES;
        _displayImageView.contentMode = UIViewContentModeScaleAspectFill;
        
        _displayTextLabel = [[UILabel alloc] init];
        _displayTextLabel.textAlignment = NSTextAlignmentLeft;
        _displayTextLabel.textColor = [UIColor blackColor];
        _displayTextLabel.font = [UIFont boldSystemFontOfSize:16.0];
        
        _sectionTopLineView = [[UIView alloc] init];
        _sectionBottomLineView = [[UIView alloc] init];
        _cellDividingLineView = [[UIView alloc] init];
        
        [self.contentView addSubview:_displayImageView];
        [self.contentView addSubview:_displayTextLabel];
        [self.contentView addSubview:_sectionTopLineView];
        [self.contentView addSubview:_sectionBottomLineView];
        [self.contentView addSubview:_cellDividingLineView];
        
        self.backgroundView = nil;
        self.backgroundColor = [UIColor whiteColor];
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        self.showDividingLine = YES;
        self.dividingLineColor = [UIColor colorWithWhite:0 alpha:0.1];
    }
    return self;
}

- (void)setAssetsGroup:(ALAssetsGroup *)assetsGroup{
    _assetsGroup = assetsGroup;
    
    _displayImageView.image = [UIImage imageWithCGImage:_assetsGroup.posterImage scale:1.0 orientation:UIImageOrientationUp];
    NSString *groupName = [_assetsGroup valueForProperty:ALAssetsGroupPropertyName];
    NSInteger groupCount = [_assetsGroup numberOfAssets];
    
    NSString *text = [NSString stringWithFormat:@"%@ (%ld)", groupName, (long)groupCount];
    text = NSLocalizedString(text, nil);
    
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text];
    [attributedText addAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:16.0], NSForegroundColorAttributeName : [UIColor blackColor]} range:NSMakeRange(0, groupName.length)];
    [attributedText addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16.0], NSForegroundColorAttributeName : [UIColor grayColor]} range:NSMakeRange(groupName.length,   text.length - groupName.length)];
    _displayTextLabel.attributedText = [attributedText copy];
}

- (void)setFirstRowInSection:(BOOL)firstRowInSection{
    _firstRowInSection = firstRowInSection;
    if(self.isShowDividingLine){
        _sectionTopLineView.hidden = !_firstRowInSection;
    }
}

- (void)setLastRowInSection:(BOOL)lastRowInSection{
    _lastRowInSection = lastRowInSection;
    if(self.isShowDividingLine){
        _sectionBottomLineView.hidden = !_lastRowInSection;
        _cellDividingLineView.hidden = _lastRowInSection;
    }
}

- (void)setDividingLineColor:(UIColor *)dividingLineColor{
    _dividingLineColor = dividingLineColor;
    
    _sectionTopLineView.backgroundColor = _dividingLineColor;
    _sectionBottomLineView.backgroundColor = _dividingLineColor;
    _cellDividingLineView.backgroundColor = _dividingLineColor;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat margin = 10.0;
    
    CGFloat displayImageView_X = margin;
    CGFloat displayImageView_Y = margin * 0.5;
    CGFloat displayImageView_H = self.bounds.size.height - displayImageView_Y * 2;
    CGFloat displayImageView_W = displayImageView_H;
    _displayImageView.frame = CGRectMake(displayImageView_X, displayImageView_Y, displayImageView_W, displayImageView_H);
    
    CGFloat displayTextLabel_X = CGRectGetMaxX(_displayImageView.frame) + margin;
    CGFloat displayTextLabel_Y = displayImageView_Y;
    CGFloat displayTextLabel_H = displayImageView_H;
    CGFloat displayTextLabel_W = self.bounds.size.width - displayTextLabel_X - 30.0;
    _displayTextLabel.frame = CGRectMake(displayTextLabel_X, displayTextLabel_Y, displayTextLabel_W, displayTextLabel_H);
    
    CGFloat lineViewHeight = 0.5;
    
    CGRect sectionTopLineViewFrame = self.bounds;
    sectionTopLineViewFrame.size.height = lineViewHeight;
    _sectionTopLineView.frame = sectionTopLineViewFrame;
    
    CGRect sectionBottomLineViewFrame = sectionTopLineViewFrame;
    sectionBottomLineViewFrame.origin.y = self.bounds.size.height - sectionBottomLineViewFrame.size.height;
    _sectionBottomLineView.frame = sectionBottomLineViewFrame;
    
    CGRect cellDividingLineViewFrame = sectionBottomLineViewFrame;
    cellDividingLineViewFrame.origin.x = displayImageView_X;
    cellDividingLineViewFrame.size.width -= cellDividingLineViewFrame.origin.x;
    _cellDividingLineView.frame = cellDividingLineViewFrame;
}

@end
