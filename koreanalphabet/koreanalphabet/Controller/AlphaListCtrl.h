//
//  AlphaListCtrl.h

//
//  Created by beyond on 16/9/10.
//  Copyright © 2016年 beyond. All rights reserved.
//

#import <UIKit/UIKit.h>
// headerView点击之后的block
typedef void (^HeaderViewBtnClickBlock)(void);

@interface AlphaListCtrl : UIViewController
//  headerView左侧的按钮图标
@property (nonatomic,copy) NSString *headerViewLeftBtnImg;
//  左侧按钮点击后执行的代码
@property (nonatomic,copy) HeaderViewBtnClickBlock leftBtnClickBlock;
@end
