//
//  JuziReadTool.h

//
//  Created by beyond on 16/10/5.
//  Copyright © 2016年 beyond. All rights reserved.
/*
 先检查,然后播放,没有就下载
 */

#import <Foundation/Foundation.h>
// 定义一个枚举
typedef enum {
    // 中文
    DownLoadTypeZhongWen,
    // english
    DownLoadTypeEnglish,
    // 韩语
    DownLoadTypeHanYu,
    // 日语
    DownLoadTypeRiYu
    
} DownLoadType;




@interface JuziReadTool : NSObject
// 播放和下载english句子
- (void)playAndDownloadEnglishJuzi:(NSString *)juzi;

// 播放和下载韩语句子
- (void)playAndDownloadHanYuJuzi:(NSString *)juzi loopNumber:(NSInteger)loopNumber;

// 播放和下载中文句子
- (void)playAndDownloadZhongWenJuzi:(NSString *)juzi loopNumber:(NSInteger)loopNumber;

- (void)playAndDownloadJuzi:(NSString *)juzi loopNumber:(NSInteger)loopNumber lanType:(NSString *)lanType;




- (void)playLocalMp3WithFilePath:(NSString *)filePath;
// 暂停当前播放的mp3
- (void)pauseCurrentMp3;

- (void)playMp3WithFullPath:(NSString *)fullPath loopNumber:(NSInteger)loopNumber isEncoded:(BOOL)isEncoded;
@end
