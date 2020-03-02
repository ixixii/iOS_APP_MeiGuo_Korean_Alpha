//
//  SongTool.h
//  NiHongGo
//
//  Created by xss on 15/7/7.
//  Copyright (c) 2015年 beyond. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface SongTool : NSObject
+ (AVAudioPlayer *)playMusic:(NSString *)filename;
+ (AVAudioPlayer *)playMusicWithFullPath:(NSString *)fullPath;
+ (AVAudioPlayer *)playMusicWithFullPath:(NSString *)fullPath loopNumber:(NSInteger)loopNumber;
// @"a.mp3"
+ (void)pauseMusic:(NSString *)filename;
//@"a.mp3",Remember to remove it from the dictionary
+ (void)stopMusic:(NSString *)filename;
// Return to the currently playing music player for external control of fast forward, backward or other methods
+ (AVAudioPlayer *)currentPlayingAudioPlayer;
// Whether the full path, repetition times and audio are encrypted
+ (AVAudioPlayer *)playMusicWithFullPath:(NSString *)fullPath loopNumber:(NSInteger)loopNumber isEncoded:(BOOL)isEncoded;
@end
