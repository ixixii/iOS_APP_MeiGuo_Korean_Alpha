//
//  HongBaoView.m

//
//  Created by beyond on 16/9/10.
//  Copyright © 2016年 beyond. All rights reserved.
//

#import "HongBaoView.h"
#import "AlphaModel.h"
//#import "NSString+URL.h"
//#import "SGTools.h"
//#import "KeyChainTool.h"
//#import "UIColor+CustomColors.h"
//#import "UIView+Extension.h"
//#import "WCAlertView.h"
//#import "UIAlertView+RWBlock.h"
//#import "UIAlertView+Block.h"


//#import "MBProgressHUD+NJ.h"
//#import "SVProgressHUD.h"
#import "MJExtension.h"
#import "UIView+Frame.h"
//#import "UIColor+Reverse.h"
//#import "NSString+Base64.h"

#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

#import "XHRealTimeBlur.h"



#import "POP.h"
//#import "GTMTool.h"



#define kColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]


@interface HongBaoView()
{
    UILabel *_topLabel;
    UILabel *_middleLabel;
    UILabel *_bottomLabel;
    
    UIImageView *_imgView;
}
@property (nonatomic, strong) XHRealTimeBlur *realTimeBlur;

@end

@implementation HongBaoView


- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}



- (void)setup
{
    typeof(self) __weak weakSelf = self;
    _realTimeBlur = [[XHRealTimeBlur alloc] initWithFrame:self.bounds];
    _realTimeBlur.showDuration = 0.3;
    _realTimeBlur.disMissDuration = 0.5;
    _realTimeBlur.willShowBlurViewcomplted = ^(void) {
        [weakSelf showButtons];
    };

    _realTimeBlur.willDismissBlurViewCompleted = ^(void) {
        [weakSelf hidenButtons];
    };
    _realTimeBlur.didDismissBlurViewCompleted = ^(BOOL finished) {
    };
    _realTimeBlur.hasTapGestureEnable = YES;
    
    [weakSelf showButtons];
}


- (void)showButtons
{
    CGFloat contentW = 280*2;
    CGFloat contentH = 375*2;
    CGFloat imgW = 280;
    CGFloat imgH = 375;
    
    CGRect contentRect = CGRectMake(0, 0, contentW, contentH);
    UIView *contentView = [[UIView alloc]initWithFrame:contentRect];
    contentView.userInteractionEnabled = YES;
    _contentView = contentView;
    
    contentView.centerX = self.centerX;
    contentView.centerY = self.centerY;
    [self addSubview:contentView];
    
    
    CGRect imgRect = CGRectMake(0, 0, imgW*2, imgH*2);
    UIImageView *hongbaoImgView = [[UIImageView alloc]initWithFrame:imgRect];
    hongbaoImgView.image = [UIImage imageNamed:@"newHongbao.png"];
    [contentView addSubview:hongbaoImgView];
    
    UILabel *topLabel = [[UILabel alloc]init];
    topLabel.text = self.model.hongBaoTopStr;
    topLabel.textColor = kColor(254, 219, 122);
    int topFontSize = 70;
    topLabel.font = [UIFont systemFontOfSize:topFontSize];
    topLabel.textAlignment = NSTextAlignmentCenter;
    topLabel.frame = CGRectMake(0, 35*2+10, 95*2, 110);
    topLabel.centerX = hongbaoImgView.centerX;
    
    [contentView addSubview:topLabel];
    _topLabel = topLabel;
    
    UIButton *preBtn = [[UIButton alloc]init];
    preBtn.frame = CGRectMake(0, 0, 0.3*contentView.width, contentView.height);
    preBtn.backgroundColor = [UIColor clearColor];
    [contentView addSubview:preBtn];
    _preBtn = preBtn;
    
    UIButton *nextBtn = [[UIButton alloc]init];
    
    nextBtn.frame = CGRectMake(0.7*contentView.width, 0, 0.3*contentView.width, contentView.height);
    nextBtn.backgroundColor = [UIColor clearColor];
    
    [contentView addSubview:nextBtn];
    _nextBtn = nextBtn;
    
    UIButton *closeBtn = [[UIButton alloc]init];
    closeBtn.frame = CGRectMake(contentView.width - 100, 0, 100, 100);
    [closeBtn addTarget:self action:@selector(hidenButtons) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:closeBtn];
    
    UILabel *middleLabel = [[UILabel alloc]init];
    middleLabel.text = self.model.hongBaoMiddleStr;
    
    middleLabel.textColor = kColor(255, 200, 210);
    
    int middleFontSize = 100;
    middleLabel.font = [UIFont systemFontOfSize:middleFontSize];
    middleLabel.textAlignment = NSTextAlignmentCenter;
    middleLabel.frame = CGRectMake(0, 80*2, contentW, 240);
    middleLabel.centerX = hongbaoImgView.centerX;
    [contentView addSubview:middleLabel];
    _middleLabel = middleLabel;
    
    UILabel *bottomLabel = [[UILabel alloc]init];
    
    NSString *readString = [[self.model.alpha_remark stringByReplacingOccurrencesOfString:@"[" withString:@"/"] stringByReplacingOccurrencesOfString:@"]" withString:@"/"];
    
    NSString *readString_new = self.model.hongBaoBottomStr;
    bottomLabel.text = readString_new;
    
    bottomLabel.textColor = kColor(148, 29, 44);
    int bottomFontSize = 60;
    
    bottomLabel.font = [UIFont systemFontOfSize:bottomFontSize];
    bottomLabel.textAlignment = NSTextAlignmentCenter;
    bottomLabel.frame = CGRectMake(0, (35+80+80)*2 + 240, contentW, 90);
    bottomLabel.centerX = hongbaoImgView.centerX;
    [contentView addSubview:bottomLabel];
    
    _bottomLabel = bottomLabel;
    [self scaleDownView:contentView];
}

#pragma mark - 点击事件
- (void)hidenButtons
{
    [self removeFromSuperview];
    
}
#pragma mark - 公开方法
- (void)showMenuAtView:(UIView *)containerView startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint {
    [containerView addSubview:self];
}

#pragma mark - Animation

- (void)initailzerAnimationWithToPostion:(CGRect)toRect formPostion:(CGRect)fromRect atView:(UIView *)view beginTime:(CFTimeInterval)beginTime {
    POPSpringAnimation *springAnimation = [POPSpringAnimation animation];
    springAnimation.property = [POPAnimatableProperty propertyWithName:kPOPViewFrame];
    springAnimation.removedOnCompletion = YES;
    springAnimation.beginTime = beginTime + CACurrentMediaTime();
    CGFloat springBounciness = 10 - beginTime * 2;
    springAnimation.springBounciness = springBounciness;    // value between 0-20
    
    CGFloat springSpeed = 12 - beginTime * 2;
    springAnimation.springSpeed = springSpeed;     // value between 0-20
    springAnimation.toValue = [NSValue valueWithCGRect:toRect];
    springAnimation.fromValue = [NSValue valueWithCGRect:fromRect];
    
    [view pop_addAnimation:springAnimation forKey:@"POPSpringAnimationKey"];
}

- (void)scaleDownView:(UIView *)view
{
    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(0.5, 0.5)];
    scaleAnimation.springBounciness = 20.f;
    [view.layer pop_addAnimation:scaleAnimation forKey:@"scaleAnimation"];
}

- (void)setModel:(AlphaModel *)model
{
    _model = model;
    _topLabel.text = model.hongBaoTopStr;
    _middleLabel.text = model.hongBaoMiddleStr;
    
    NSString *bottomString = model.hongBaoBottomStr;
    _bottomLabel.text = bottomString;
}
- (void)bottomLabelTapped:(UITapGestureRecognizer *)reco
{
}
@end
