//
//  SongTool.m
//  NiHongGo
//
//  Created by xss on 15/7/7.
//  Copyright (c) 2015年 beyond. All rights reserved.
//
#import "SongTool.h"
//#import "SGTools.h"
#import "GTMTool.h"

#define kMainBundle [NSBundle mainBundle]
@implementation SongTool
// Dictionary, which stores all music players. The key is: music name. The value is the corresponding music player object audioplayer
// A song corresponds to a music player
static NSMutableDictionary *_audioPlayerDict;

#pragma mark - Life Cycle
+ (void)initialize
{
    // Dictionary, key is: music name, value is the corresponding music player object
    _audioPlayerDict = [NSMutableDictionary dictionary];
    [self sutupForBackgroundPlay];
}

+ (void)sutupForBackgroundPlay
{
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [session setActive:YES error:nil];
// Use avaudioplayer to play the sound. As a result, the sound comes out of the earpiece instead of the loudspeaker. When the earphone is plugged in, it comes out of the earphone.
//    ok，solution is :
//    add AudioToolbox Framework，then：
    UInt32 sessionCategory = kAudioSessionCategory_MediaPlayback;
    AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof(sessionCategory), &sessionCategory);
    UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
    AudioSessionSetProperty (kAudioSessionProperty_OverrideAudioRoute,sizeof (audioRouteOverride),&audioRouteOverride);
//    AVAudioSession * audioSession = [AVAudioSession sharedInstance];
//    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error: &error];
    AudioSessionSetProperty (kAudioSessionProperty_OverrideCategoryDefaultToSpeaker,sizeof (audioRouteOverride),&audioRouteOverride);
}

#pragma mark - 供外界调用
+ (AVAudioPlayer *)playMusic:(NSString *)filename
{
    if (!filename) return nil;
    AVAudioPlayer *audioPlayer = _audioPlayerDict[filename];
    if (!audioPlayer) {
        NSURL *url = [kMainBundle URLForResource:filename withExtension:nil];
        if (!url) return nil;
        audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        [audioPlayer prepareToPlay];
        audioPlayer.enableRate = YES;
        audioPlayer.rate = 1.0;
        _audioPlayerDict[filename] = audioPlayer;
    }
    if (!audioPlayer.isPlaying) {
        [audioPlayer play];
    }
    return audioPlayer;
}
+ (AVAudioPlayer *)playMusicWithFullPath:(NSString *)fullPath
{
    if (!fullPath) return nil;
    
    AVAudioPlayer *audioPlayer = nil;
    if (!audioPlayer) {
        NSURL *url = [[NSURL alloc] initFileURLWithPath:fullPath];
        if (!url) return nil;
        NSData *data = [NSData dataWithContentsOfFile:fullPath];
        NSError *err;
        audioPlayer = [[AVAudioPlayer alloc] initWithData:data error:&err];
        if(err){
        }
        [audioPlayer prepareToPlay];
        audioPlayer.enableRate = YES;
        audioPlayer.rate = 1.0;
        [audioPlayer setVolume:1];
        audioPlayer.numberOfLoops = -1;
        if (audioPlayer) {
//            _audioPlayerDict[fullPath] = audioPlayer;
        }

    }
    
    if (!audioPlayer.isPlaying) {
        [audioPlayer play];
    }
    return audioPlayer;
}
+ (AVAudioPlayer *)playMusicWithFullPath:(NSString *)fullPath loopNumber:(NSInteger)loopNumber
{
    if (!fullPath) return nil;
    AVAudioPlayer *audioPlayer = _audioPlayerDict[fullPath];
        NSURL *url = [[NSURL alloc] initFileURLWithPath:fullPath];
        if (!url) return nil;
        NSData *data = [NSData dataWithContentsOfFile:fullPath];
        NSError *err;
        audioPlayer = [[AVAudioPlayer alloc] initWithData:data error:&err];
        if(err){
            audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL URLWithString:fullPath] error:&err];
        }
        [audioPlayer prepareToPlay];
        audioPlayer.enableRate = YES;
        audioPlayer.rate = 1.0;
        [audioPlayer setVolume:1];
        audioPlayer.numberOfLoops = loopNumber;
    if (!audioPlayer.isPlaying) {
        [audioPlayer play];
    }
    return audioPlayer;
}

+ (AVAudioPlayer *)playMusicWithFullPath:(NSString *)fullPath loopNumber:(NSInteger)loopNumber isEncoded:(BOOL)isEncoded
{
    if (!fullPath) return nil;
    AVAudioPlayer *audioPlayer = _audioPlayerDict[fullPath];
    NSURL *url = [[NSURL alloc] initFileURLWithPath:fullPath];
    if (!url) return nil;
    NSData *data = [NSData dataWithContentsOfFile:fullPath];
    if (isEncoded) {
        data = [GTMTool decodeDataWithData:data];
    }
    NSError *err;
    audioPlayer = [[AVAudioPlayer alloc] initWithData:data error:&err];
    if(err){
        audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL URLWithString:fullPath] error:&err];
    }
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *initType = [userDefault objectForKey:@"userDefault_playInitMode"];
    if (!audioPlayer || [initType isEqualToString:@"url"]) {
        audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    }
    [audioPlayer prepareToPlay];
    audioPlayer.enableRate = YES;
    audioPlayer.rate = 1.0;
    [audioPlayer setVolume:1];
    audioPlayer.numberOfLoops = loopNumber;
    if (!audioPlayer.isPlaying) {
        [audioPlayer play];
    }
    return audioPlayer;
}
+ (AVAudioPlayer *)playMusic_container_WithFullPath:(NSString *)fullPath loopNumber:(NSInteger)loopNumber
{
    if (!fullPath) return nil;
    AVAudioPlayer *audioPlayer = _audioPlayerDict[fullPath];
    if (!audioPlayer) {
        NSURL *url = [[NSURL alloc] initFileURLWithPath:fullPath];
        if (!url) return nil;
        NSData *data = [NSData dataWithContentsOfFile:fullPath];
        NSError *err;
        audioPlayer = [[AVAudioPlayer alloc] initWithData:data error:&err];
        if(err){
        }
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        NSString *initType = [userDefault objectForKey:@"userDefault_playInitMode"];
        if ([initType isEqualToString:@"url"]) {
            audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        }
        [audioPlayer prepareToPlay];
        audioPlayer.enableRate = YES;
        audioPlayer.rate = 1.0;
        [audioPlayer setVolume:1];
        audioPlayer.numberOfLoops = loopNumber;
        _audioPlayerDict[fullPath] = audioPlayer;
    }
    if (!audioPlayer.isPlaying) {
        [audioPlayer play];
    }
    return audioPlayer;
}
+ (void)pauseMusic:(NSString *)filename
{
    if (!filename) return;
    AVAudioPlayer *audioPlayer = _audioPlayerDict[filename];
    if (audioPlayer.isPlaying) {
        [audioPlayer pause];
    }
}
+ (void)stopMusic:(NSString *)filename
{
    if (!filename) return;
    AVAudioPlayer *audioPlayer = _audioPlayerDict[filename];
    if (audioPlayer.isPlaying) {
        [audioPlayer stop];
        [_audioPlayerDict removeObjectForKey:filename];
    }
}

+ (AVAudioPlayer *)currentPlayingAudioPlayer
{
    for (NSString *filename in _audioPlayerDict) {
        AVAudioPlayer *audioPlayer = _audioPlayerDict[filename];
        
        if (audioPlayer.isPlaying) {
            return audioPlayer;
        }
    }
    return nil;
}
@end
