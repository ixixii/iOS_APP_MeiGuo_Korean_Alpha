//
//  AlphaListCtrl.m

//
//  Created by beyond on 16/9/10.
//  Copyright © 2016年 beyond. All rights reserved.
//


#import "AlphaListCtrl.h"
#import "HanYuAlphaModel.h"

#import "MJExtension.h"

#import "CustomButton.h"
#import "HongBaoView.h"
#import "SongTool.h"


//#import "AudioEffectTool.h"


//#import "GTMBase64.h"
//#import "NSString+URL.h"
//#import "SGTools.h"
//#import "UIColor+CustomColors.h"
//#import "UIView+Extension.h"
//#import "WCAlertView.h"
//#import "UIAlertView+RWBlock.h"
//#import "UIAlertView+Block.h"
//#import "MBProgressHUD+NJ.h"
//#import "SVProgressHUD.h"


#import "UIView+Frame.h"

//#import "UIColor+Reverse.h"
//#import "NSString+Base64.h"

#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

#import "JuziReadTool.h"

#define kHScrollViewTag 2467
#define kVScrollTagBase 1000
#define kCustomBtnTagBase 2000
#define kDelBtnTagBase 3000
#define kShowBtnTagBase 4000

// 高辅
#define kHardAlphaColor kColor(91, 172, 226)
// 中辅
#define kMiddleFuAlphaColor kColor(28, 181, 152)
// 低辅
#define kLowFuAlphaColor kColor(255, 255, 255)

#define kColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define ScreenBounds [UIScreen mainScreen].bounds
#define ScreenWidth ScreenBounds.size.width
#define ScreenHeight ScreenBounds.size.height


#define kAppName @"Arab Alpha"
#define kMainBundle [NSBundle mainBundle]

#define kHintLabelDefaultFont 45.0

@interface AlphaListCtrl ()<UIScrollViewDelegate,UIScrollViewDelegate,AVAudioPlayerDelegate>
{
    NSArray *_alphaModelArr;
    UIScrollView *_hScrollView;
    
    CustomButton *_preBtn;
    UIColor *_preBtnColor;
    int _currentIndex;
    
    AlphaModel *_currentModel;
}
@property (nonatomic, strong) HongBaoView *hongbaoView;
@property (nonatomic, strong) AVAudioPlayer *currentPlayingAudioPlayer;
@property (nonatomic, strong) JuziReadTool *juziReadTool;
@end

@implementation AlphaListCtrl
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (_hScrollView == nil) {
        [self addBgImageView];
        [self addHScrollView];
        [self addHeaderView];
    }
}
#pragma mark - 横竖屏适配
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadDataFromPlist];
}
- (void)loadDataFromPlist
{
    // sg_bundle模板代码,1,获得.app主要的包;2,返回主要的包中某个文件的fullPath全路径
//    NSBundle *mainBundle = [NSBundle mainBundle];
//    NSString *fullPath = [mainBundle pathForResource:kAlphaPlistName ofType:@"plist"];
//    NSArray *classDictArr = [NSArray arrayWithContentsOfFile:fullPath];
    
    // 下面使用新的
//    NSArray *classDictArr = [SGTools arrFromEncodedPlistNameWithoutExtInBundle:kAlphaPlistName];
//    if ([kAppName isEqualToString:kLanguage_hanyu]){
//        _alphaModelArr = [HanYuAlphaModel objectArrayWithKeyValuesArray:classDictArr];
//    }
}

- (void)addBgImageView
{
    UIImageView *bgView = [[UIImageView alloc]init];
    bgView.frame = self.view.frame;
    UIImage *bgImage = [UIImage imageNamed:@"IMG_4397.JPG"];
    CGFloat top = 25; // 顶端盖高度
    CGFloat bottom = 25 ; // 底端盖高度
    CGFloat left = 10; // 左端盖宽度
    CGFloat right = 10; // 右端盖宽度
    UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
    // 指定为拉伸模式，伸缩后重新赋值
    bgImage = [bgImage resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    
    bgView.image = bgImage;
    [self.view addSubview:bgView];
}

- (void)addHScrollView
{
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:self.view.frame];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.tag = kHScrollViewTag;
    scrollView.delegate = self;
    scrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:scrollView];
    _hScrollView = scrollView;
    
    [self addSubViewToHScrollView];
}

#pragma mark - 顶部的标题
- (void)addHeaderView
{
    UIView *headerView = [[UIView alloc]init];
    headerView.backgroundColor = [UIColor clearColor];
    UIView *bgView =  [[UIView alloc]init];
    bgView.backgroundColor = kColor(85, 92, 92);
    bgView.alpha = 0.75;
    bgView.frame = CGRectMake(0, 0, ScreenWidth, 65);
    [headerView addSubview:bgView];
    headerView.frame = CGRectMake(0, 0, ScreenWidth, 65);
    [self.view addSubview:headerView];

    // appName
    UILabel *classLable = [[UILabel alloc]init];
    // 添加tap手势
    UITapGestureRecognizer *tapReco = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissCtrl)];
    classLable.userInteractionEnabled = YES;
    [classLable addGestureRecognizer:tapReco];
    
    classLable.text = @"字母表";
    classLable.font = [UIFont boldSystemFontOfSize:24.0];
    classLable.textAlignment = NSTextAlignmentCenter;
    classLable.textColor = kColor(28, 181, 152);
    classLable.backgroundColor = [UIColor clearColor];
    classLable.frame = CGRectMake(40, 20, ScreenWidth - 80, 45);
    [headerView addSubview:classLable];
}

/** @programmer beyond@sg31.com
 *  @brief  横向多少课
 *  @param  <#无#>
 *  @return <#无#>
 */
- (void)addSubViewToHScrollView
{
    // 创建N课的 竖向的scrollView
    UIScrollView *vScrollView = [[UIScrollView alloc]init];
    vScrollView.tag = kVScrollTagBase + 0;
    vScrollView.frame = CGRectMake(0 * ScreenWidth, 0, ScreenWidth*2, ScreenHeight);
    vScrollView.backgroundColor = [UIColor clearColor];
    
    [_hScrollView addSubview:vScrollView];
    _hScrollView.contentSize = CGSizeMake(ScreenWidth, ScreenHeight);
    
    _hScrollView.contentSize = CGSizeMake(ScreenWidth*2, ScreenHeight);
    
    for (int i = 0; i < _alphaModelArr.count; i++) {
        AlphaModel *alphaModel = [_alphaModelArr objectAtIndex:i];
        // 每个alpha按钮
            // 如果用户已经删除
            BOOL isDeleted = [self abstract_isAlreadyDelByUser:alphaModel.alpha];
            
            CustomButton *btn = [[CustomButton alloc]init];
            btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        
            btn.tag = kCustomBtnTagBase + i;
            [btn addTarget:self action:@selector(customBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            btn.showsTouchWhenHighlighted = YES;
            btn.titleLabel.font = [UIFont systemFontOfSize:50.0];
            if (isDeleted) {
                btn.hidden = YES;
            }
        
            if ([alphaModel.alpha_remark containsString:@"难"]) {
                [btn setTitleColor:kHardAlphaColor forState:UIControlStateNormal];
            }
            [btn setTitle:alphaModel.alpha forState:UIControlStateNormal];
        
        // 意大利语就是5列
        int colsNum = 12;
        // 第0个即排头的按钮的y
        int firstBtnY = 65 + 10;
        // 按钮之间的净间距
        int btnMargin = 0;
        
        CGFloat btnW = ((ScreenWidth - 10 - 10) - (colsNum - 1) * btnMargin) / colsNum;
        btnW = ((ScreenWidth*2 - 10 - 10) - (colsNum - 1) * btnMargin) / colsNum;
        CGFloat btnH = btnW;
        {
            
            // 第0个即排头的表情的x
            int firstBtnX = 10;
            
            // 第i个表情(这儿是按钮) 所在的行号
            int row = i/colsNum;
            // 第i个表情(这儿是按钮) 所在的列号
            int cols = i%colsNum;
            
            CGFloat btnX = cols * (btnW+btnMargin)+firstBtnX;
            CGFloat btnY = row * (btnH+btnMargin)+firstBtnY;
            
            btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
        }
        
        // 针对占位的sg进行处理
        if ([self abstract_isPlaceHolderEmpty:i roma:alphaModel.alpha]) {
            btn.hidden = YES;
        }
            [vScrollView addSubview:btn];
            vScrollView.contentSize = CGSizeMake(ScreenWidth, CGRectGetMaxY(btn.frame) + 10 + (true?0:50));
        
            // showBtn
            UIButton *showBtn = [[UIButton alloc]init];
            
            showBtn.hidden = !isDeleted;
        
            // 针对占空位的sg进行处理
            if ([self abstract_isPlaceHolderEmpty:i roma:alphaModel.alpha]) {
                showBtn.hidden = YES;
                
            }
            showBtn.tag = kShowBtnTagBase + i;
            showBtn.alpha = 0.1;
            showBtn.bounds = CGRectMake(0, 0, 32, 32);
            showBtn.center = btn.center;
            [showBtn setBackgroundImage:[UIImage imageNamed:@"showBtn.png"] forState:UIControlStateNormal];
            [showBtn addTarget:self action:@selector(showBtnClicked:) forControlEvents:UIControlEventTouchUpInside];

            [vScrollView addSubview:showBtn];
    }
}
/** @programmer beyond@sg31.com
 *  @brief  判断是不是占位的
 *  @param  <#无#>
 *  @return <#无#>
 */
- (BOOL)abstract_isPlaceHolderEmpty:(int )index roma:(NSString *)roma
{
    // 统一使用 sg作为占位符
    if ([roma isEqualToString:@"sg"]) {
        return YES;
    }
    return NO;
}


-(BOOL) canPerformAction:(SEL)action withSender:(id)sender{
    if (action == @selector(scrollViewWillBeginDragging:) ) {
        return YES;
    }
    if (action == @selector(detailItemClicked) ) {
        return YES;
    }
    if (action == @selector(hideItemClicked) ) {
        return YES;
    }
    // 非常重要 隐藏系统默认的菜单项
    return NO;
}
- (void)hideItemClicked
{
    [self delBtnClicked];
}
// 由于是从右往左书写,所以 左边的按钮点击后,才是下一个
- (void)hongBaoPreBtnClicked
{
    int preBtnIndex = _currentIndex - 1;
    if (preBtnIndex < 0) {
        preBtnIndex = _alphaModelArr.count - 1;
    }
    CustomButton *btn = [_hScrollView viewWithTag:kCustomBtnTagBase + preBtnIndex];
    
    // 如果显示的,则播放,否则,跳过 asdf
    AlphaModel *model = _alphaModelArr[preBtnIndex];
    BOOL isPreAlreadyHidden = [self abstract_isAlreadyDelByUser:model.alpha];
    if (isPreAlreadyHidden || [self abstract_isPlaceHolderEmpty:preBtnIndex roma:model.alpha]) {
        // 隐藏的,跳过
        _currentIndex--;
        [self hongBaoPreBtnClicked];
    } else {
        // 显示的
        [self customBtnClicked:btn];
    }
}
// 由于是从右往左书写,所以 右边的按钮点击后,才是上一个
- (void)hongBaoNextBtnClicked
{
    int nextBtnIndex = _currentIndex + 1;
    if (nextBtnIndex > _alphaModelArr.count - 1) {
        nextBtnIndex = 0;
    }
    CustomButton *btn = [_hScrollView viewWithTag:kCustomBtnTagBase + nextBtnIndex];
    
    // 如果显示的,则播放,否则,跳过 asdf
    AlphaModel *model = _alphaModelArr[nextBtnIndex];
    BOOL isNextAlreadyHidden = [self abstract_isAlreadyDelByUser:model.alpha];
    if (isNextAlreadyHidden || [self abstract_isPlaceHolderEmpty:nextBtnIndex roma:model.alpha] || btn.hidden == YES) {
        // 隐藏的,跳过
        _currentIndex++;
        [self hongBaoNextBtnClicked];
    } else {
        // 显示的
        [self customBtnClicked:btn];
    }
    
}
- (void)hongbaoViewContentViewTapped
{
    CustomButton *btn = [_hScrollView viewWithTag:kCustomBtnTagBase + _currentIndex];
    [self customBtnClicked:btn];
}

#pragma mark - 菜单点击事件---详情
- (void)detailItemClicked
{
    _hongbaoView = [[HongBaoView alloc] initWithFrame:self.view.bounds];
    _hongbaoView.model = _currentModel;
    [_hongbaoView showMenuAtView:self.view startPoint:CGPointMake(CGRectGetWidth(self.view.bounds) - 60, CGRectGetHeight(self.view.bounds)) endPoint:CGPointMake(60, CGRectGetHeight(self.view.bounds))];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 添加tap手势
        UITapGestureRecognizer *tapReco = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hongbaoViewContentViewTapped)];
        [_hongbaoView.contentView addGestureRecognizer:tapReco];
        
        [_hongbaoView.preBtn addTarget:self action:@selector(hongBaoPreBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [_hongbaoView.nextBtn addTarget:self action:@selector(hongBaoNextBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    });
}

- (void)resetBtnColor:(UIButton *)btn
{
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}
- (void)highlightBtnColor:(UIButton *)btn
{
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
}
- (void)diyHardBtnColor:(UIButton *)btn
{
    [btn setTitleColor:kHardAlphaColor forState:UIControlStateNormal];
}

// 只有泰语用到的方法
- (void)diyMiddleFuBtnColor:(UIButton *)btn
{
    [btn setTitleColor:kMiddleFuAlphaColor forState:UIControlStateNormal];
}

// UIMenuController requires that we can become first responder or it won't display
- (BOOL)canBecomeFirstResponder
{
    return YES;
}


#pragma mark - 音乐播放
// 指定mp3全路径，播放次数
- (void)playMp3WithFullPath:(NSString *)fullPath loopNumber:(NSInteger)loopNumber isEncoded:(BOOL)isEncoded
{
    if (self.currentPlayingAudioPlayer) {
        [self.currentPlayingAudioPlayer pause];
    }
    // 2.传递数据源模型 给工具类播放音乐
    AVAudioPlayer *audioPlayer ;
    if (isEncoded) {
        audioPlayer = [SongTool playMusicWithFullPath:fullPath loopNumber:loopNumber isEncoded:YES];
    }else{
        audioPlayer = [SongTool playMusicWithFullPath:fullPath loopNumber:loopNumber];
    }
    audioPlayer.delegate = self;
    self.currentPlayingAudioPlayer = audioPlayer;
    
    //     3.重要~~~在锁屏界面显示歌曲信息
    //    NewromaListCellModel *model = [[NewromaListCellModel alloc]init];
    //    [self showInfoInLockedScreen:model];
}

#pragma mark - 抽取的
- (BOOL)abstract_isAlreadyDelByUser:(NSString *)alpha
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *delKey = [NSString stringWithFormat:@"%@_%@",@"userDefault_roma",alpha];
    BOOL isDeleted = [userDefault boolForKey:delKey];
    return isDeleted || [alpha isEqualToString:@"sg"];
    
}
#pragma mark - 自动计算label的最大字体
/** @programmer beyond@sg31.com
 *  @brief  根据文字多少确定字体
 *  @param  默认字体,文本,文字显示宽度
 *  @return <#无#>
 */
- (CGFloat)abstract_adjustBtnTitleFontSize:(CGFloat )fontSize titleString:(NSString *)titleString textShowWidth:(CGFloat )textShowWidth
{
//    NSLog(@"sg__%@__%f",titleString,fontSize);
    
    // 先计算出当前默认字体45.0f 下文字所占的宽度
    CGFloat defaultWidth = [self abstract_widthForAllChar:titleString fnt:[UIFont systemFontOfSize:fontSize]];
    // 如果大于 屏幕宽度 - 2* margin - delBtn*2
    if (defaultWidth > textShowWidth) {
        return [self abstract_adjustBtnTitleFontSize:--fontSize titleString:titleString textShowWidth:textShowWidth];
    } else {
        return MIN(kHintLabelDefaultFont, fontSize);
    }
}
// 计算字串 在指定字体下的 全部字符所占的行高
- (CGFloat)abstract_widthForAllChar:(NSString *)str fnt:(UIFont *)fnt
{
    CGSize tmpSize ;
    
    // ios 7
    // tmpSize = [str sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:fnt,NSFontAttributeName, nil]];
    
    // iOS7中用以下方法替代过时的iOS6中的sizeWithFont:constrainedToSize:lineBreakMode:方法
    CGRect tmpRect = [str boundingRectWithSize:CGSizeMake(9999, 9999) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:fnt,NSFontAttributeName, nil] context:nil];
    tmpSize = CGSizeMake(tmpRect.size.width, tmpRect.size.height);
    // 全部字符的高度
    return tmpSize.width;
}

#pragma mark - 新增判断条件
- (void)customBtnClicked:(UIButton *)btn
{
    
    int index = btn.tag - kCustomBtnTagBase;
    _currentIndex = index;
    
    AlphaModel *model_tmp = _alphaModelArr[index];
    [self abstract_playMp3WithModel:model_tmp];
    [self performSelectorOnMainThread:@selector(resetBtnColor:) withObject:_preBtn waitUntilDone:YES];
    
    AlphaModel *preModel;
    if (_preBtn) {
        preModel = _alphaModelArr[_preBtn.tag - kCustomBtnTagBase];
    }
    
    if ([preModel.alpha_remark containsString:@"难"]) {
        [self performSelectorOnMainThread:@selector(diyHardBtnColor:) withObject:_preBtn waitUntilDone:YES];
    }
    
    if (_preBtn != btn) {
        _preBtn = btn;
    }
    if (btn.titleLabel && _preBtn) {
        // 这里会崩溃
        _preBtnColor = btn.titleLabel.textColor;
    }
    
    [self performSelectorOnMainThread:@selector(highlightBtnColor:) withObject:btn waitUntilDone:YES];
    AlphaModel *model = _alphaModelArr[index];
    _currentModel = model;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        _hongbaoView.model = _currentModel;
    });
    
    [self becomeFirstResponder];
    
    // 隐藏
    UIMenuItem *hideItem = [[UIMenuItem alloc] initWithTitle:@"隐藏" action:@selector(hideItemClicked)];
    
    // item1
    UIMenuItem *menuItem1 = [[UIMenuItem alloc] initWithTitle:model.menuItem1 action:@selector(detailItemClicked)];
    
    // item2
    UIMenuItem *menuItem2 = [[UIMenuItem alloc] initWithTitle:model.menuItem2 action:@selector(detailItemClicked)];
    
    // item3
    UIMenuItem *menuItem3 = [[UIMenuItem alloc] initWithTitle:model.menuItem3 action:@selector(detailItemClicked)];
    
    // item4
    UIMenuItem *menuItem4 = [[UIMenuItem alloc] initWithTitle:model.menuItem4 action:@selector(detailItemClicked)];
    
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    
    
    [menuController setMenuItems:@[menuItem1,hideItem]];
    
    
    CGRect menuLocation = CGRectMake(btn.centerX, btn.y + 5, 0, 65);
    [menuController setTargetRect:menuLocation inView:btn.superview];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (![_hongbaoView superview]) {
            [menuController setMenuVisible:YES animated:YES];
        }
    });
    
}
#pragma mark -抽取的播放声音
- (void)abstract_playMp3WithModel:(AlphaModel *)model
{
    
    NSString *encodeMp3 ;
    if ([model.alpha_mp3 hasPrefix:@"encode_"]) {
        encodeMp3 = model.alpha_mp3;
    } else {
        encodeMp3 = [NSString stringWithFormat:@"encode_%@",model.alpha_mp3];
    }
    NSString *fullPath = [kMainBundle pathForResource:encodeMp3 ofType:nil];
    
    {
        [_juziReadTool playAndDownloadHanYuJuzi:model.alpha loopNumber:3];
    }
}
- (void)showBtnClicked:(UIButton *)showBtn
{
    int index = showBtn.tag - kShowBtnTagBase;
    AlphaModel *model = _alphaModelArr[index];
    [self abstract_playMp3WithModel:model];
    CustomButton *alphaBtn = [_hScrollView viewWithTag:index + kCustomBtnTagBase];
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *delKey = [NSString stringWithFormat:@"%@_%@",@"userDefault_roma",model.alpha];
    [userDefault setBool:NO forKey:delKey];
    [userDefault synchronize];
    
    [alphaBtn setHidden:NO];
    [UIView animateWithDuration:0.3 animations:^{
        showBtn.alpha = 0;
        // 动画显示alphaBtn
        alphaBtn.alpha = 1;
    } completion:^(BOOL finished) {
        [showBtn setHidden:YES];
    }];
}
// 隐藏按钮点击事件
- (void)delBtnClicked
{
    // 先获取classModel
    CustomButton *btn = [_hScrollView viewWithTag:_currentIndex + kCustomBtnTagBase];
    
    AlphaModel *model = _alphaModelArr[_currentIndex];
    
    // 根据用户上次选择的,展示
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *delKey = [NSString stringWithFormat:@"%@_%@",@"userDefault_roma",model.alpha];
    [userDefault setBool:YES forKey:delKey];
    [userDefault synchronize];
    
    // showBtn显示
    UIButton *showBtn = [_hScrollView viewWithTag:kShowBtnTagBase + _currentIndex];
    showBtn.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        showBtn.alpha = 0.1;
        [btn setAlpha:0];
    } completion:^(BOOL finished) {
        [btn setHidden:YES];
    }];
}


@end
