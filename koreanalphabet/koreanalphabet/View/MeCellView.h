//
//  MeCellView.h
//  thaialpha
//
//  Created by beyond on 2020/03/01.
//  Copyright © 2020 Christine. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MeCellView : UIView
+ (MeCellView *)meCellView;
@property (nonatomic,weak) IBOutlet UILabel *label;
@property (nonatomic,weak) IBOutlet UIImageView *imgView;
@property (nonatomic,weak) IBOutlet UIButton *btn;
@end

NS_ASSUME_NONNULL_END
