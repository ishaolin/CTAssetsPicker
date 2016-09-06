//
//  CTAssetsToolBarButtonItem.m
//  CTAssetsPicker
//
//  Created by wshaolin on 15/7/10.
//  Copyright (c) 2015年 神州锐达（北京）科技有限公司. All rights reserved.
//

#import "CTAssetsToolBarButtonItem.h"

@implementation CTAssetsToolBarButtonItem

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self _init];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    if(self = [super initWithCoder:aDecoder]){
        [self _init];
    }
    return self;
}

- (void)_init{
    self.barButtonItemFontSize = 15.0;
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 3.0;
    
    self.backgroundColor = [UIColor colorWithRed:26.0 / 255.0 green:178.0 / 255.0 blue:10.0 / 255.0 alpha:1.0];
    self.enableHighlighted = YES;
}

- (void)setBarButtonItemFontSize:(NSUInteger)barButtonItemFontSize{
    _barButtonItemFontSize = barButtonItemFontSize;
    self.titleLabel.font = [UIFont systemFontOfSize:_barButtonItemFontSize];
}

- (void)setBarButtonItemTitle:(NSString *)barButtonItemTitle{
    _barButtonItemTitle = barButtonItemTitle;
    [self setTitle:_barButtonItemTitle forState:UIControlStateNormal];
}

- (void)addTarget:(id)target action:(SEL)action{
    [self addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

- (void)setHighlighted:(BOOL)highlighted{
    if(highlighted){
        self.alpha = 0.5;
    }else{
        self.alpha = 1.0;
    }
    if(self.enableHighlighted){
        [super setHighlighted:highlighted];
    }
}

- (void)setEnabled:(BOOL)enabled{
    if(enabled){
        self.alpha = 1.0;
    }else{
        self.alpha = 0.5;
    }
    [super setEnabled:enabled];
}

- (void)setSelected:(BOOL)selected{
    if(selected != self.isSelected){
        [super setSelected:selected];
    
        if(selected && [self imageForState:UIControlStateSelected] != nil){
            [self executeAnimationWithDuration:0.25];
        }
    }
}

- (void)executeAnimationWithDuration:(CFTimeInterval)duration{
    [self.layer removeAnimationForKey:@"AnimationForTransform"];
    CAKeyframeAnimation *keyframeAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    NSValue *value0 = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)];
    NSValue *value1 = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.3, 1.3, 1.3)];
    NSValue *value2 = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)];
    NSArray *values = @[value0, value1, value2];
    keyframeAnimation.values = values;
    keyframeAnimation.duration = duration;
    keyframeAnimation.repeatCount = 0;
    [self.layer addAnimation:keyframeAnimation forKey:@"AnimationForTransform"];
}

@end
