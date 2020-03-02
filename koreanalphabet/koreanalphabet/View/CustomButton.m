//
//  CustomButton.m
//  SuJi
//
//  Created by beyond on 16/7/10.
//  Copyright © 2016年 beyond. All rights reserved.
//

#import "CustomButton.h"

@implementation CustomButton
#define kColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

- (instancetype)init
{
    if (self = [super init]) {
        [self setUp];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self setUp];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setUp];
    }
    return self;
}

- (void)setUp
{
    self.layer.borderWidth = 0.5;
    [self setTitleColor:kColor(162, 248, 48) forState:UIControlStateNormal];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [self setBackgroundImage:[SGViewTool createImageWithColor:[UIColor clearColor]] forState:UIControlStateHighlighted];
    self.showsTouchWhenHighlighted = YES;
    self.layer.borderColor = kColor(9, 68, 83).CGColor;
    self.layer.cornerRadius = 8;
    self.layer.masksToBounds = YES;
}
- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
}
- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(contentRect.origin.x, contentRect.origin.y - 1.5, contentRect.size.width, contentRect.size.height);
}
@end
