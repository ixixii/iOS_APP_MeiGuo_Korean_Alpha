//
//  HongBaoView.h

//
//  Created by beyond on 16/9/10.
//  Copyright © 2016年 beyond. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AlphaModel;
@interface HongBaoView : UIView

@property (nonatomic,strong)AlphaModel *model;
@property (nonatomic,strong)UIButton *preBtn;
@property (nonatomic,strong)UIButton *nextBtn;
@property (nonatomic,strong)UIView *contentView;

- (void)showMenuAtView:(UIView *)containerView startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint ;
@end
