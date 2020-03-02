//
//  JuziReadTool.m

//
//  Created by beyond on 16/10/5.
//  Copyright © 2016年 beyond. All rights reserved.
//

#import "JuziReadTool.h"

// 核心框架,必须导入,锁屏显歌词
#import "SongTool.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>


#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"\n\n%s [Line %d] \n\n\t\t" fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define DLog(...)
#endif

@interface JuziReadTool()
{
    
    
    // 下载播放
    // 异步请求回来的音频Data
    NSMutableData *_mp3Data;
    // 请求时的汉字( %@ )( %@ )
    NSString *_requestJuzi;
    
    
    NSInteger _loopNumber;
}
@property (nonatomic, strong) AVAudioPlayer *currentPlayingAudioPlayer;
@end

@implementation JuziReadTool
- (void)playAndDownloadEnglishJuzi:(NSString *)juzi
{
    
    NSLog(@"sg_english__download:%@",juzi);
    
    _loopNumber = 3;
    juzi = [juzi stringByReplacingOccurrencesOfString:@"难," withString:@""];
    // 1.先检查本地
    _requestJuzi = [NSString stringWithFormat:@"%@  !%@  !%@  !%@  !%@  !",juzi,juzi,juzi,juzi,juzi];
    // 播放
    DLog(@"将要同步或异步下载和播放:%@",_requestJuzi);
    NSString *mp3FullPath = [self getFullPathFromMp3Name:_requestJuzi];
    
    NSLog(@"sg_english__mp3FullPath:%@",mp3FullPath);
    if ([self isFileExistByFullPath:mp3FullPath]) {
        
        NSLog(@"sg_english__已经存在!");
        // 直接播放，后台，循环
        // 如果下载成功，播放音乐
        // [self playLoopMp3WithFullPath:mp3FullPath];
        [self playMp3WithFullPath:mp3FullPath loopNumber:5];
    }else{
        // 不存在，则同步或异步下载
        // [self syncDownLoadMp3];
        
        // 保存时间戳
        [self abstract_saveDownloadTimeStamp:_requestJuzi];
        
        
        [self asyncDownLoadMp3WithDownLoadType:DownLoadTypeEnglish];
    }
    
    
}


- (void)playAndDownloadHanYuJuzi:(NSString *)juzi loopNumber:(NSInteger)loopNumber
{
    
    
//    juzi = [juzi stringByReplacingOccurrencesOfString:@"难," withString:@""];
    // 1.先检查本地
    _requestJuzi = [NSString stringWithFormat:@"%@  !%@  !%@  !",juzi,juzi,juzi,juzi,juzi];
    // 播放
    DLog(@"将要同步或异步下载和播放:%@",_requestJuzi);
    NSString *mp3FullPath = [self getFullPathFromMp3Name:_requestJuzi];
    if ([self isFileExistByFullPath:mp3FullPath]) {
        // 直接播放，后台，循环
        // 如果下载成功，播放音乐
        // [self playLoopMp3WithFullPath:mp3FullPath];
        [self playMp3WithFullPath:mp3FullPath loopNumber:loopNumber];
    }else{
        // 不存在，则同步或异步下载
        // [self syncDownLoadMp3];
        
        
        // 保存时间戳
//        [self abstract_saveDownloadTimeStamp:_requestJuzi];
        
        
        _loopNumber = loopNumber;
        [self asyncDownLoadMp3WithDownLoadType:DownLoadTypeHanYu];
    }
}
- (void)playAndDownloadZhongWenJuzi:(NSString *)juzi loopNumber:(NSInteger)loopNumber
{
    
    
    //    juzi = [juzi stringByReplacingOccurrencesOfString:@"难," withString:@""];
    // 1.先检查本地
    _requestJuzi = [NSString stringWithFormat:@"%@  !%@  !%@  !",juzi,juzi,juzi,juzi,juzi];
    // 播放
    DLog(@"将要同步或异步下载和播放:%@",_requestJuzi);
    NSString *mp3FullPath = [self getFullPathFromMp3Name:_requestJuzi];
    if ([self isFileExistByFullPath:mp3FullPath]) {
        // 直接播放，后台，循环
        // 如果下载成功，播放音乐
        // [self playLoopMp3WithFullPath:mp3FullPath];
        [self playMp3WithFullPath:mp3FullPath loopNumber:loopNumber];
    }else{
        // 不存在，则同步或异步下载
        // [self syncDownLoadMp3];
        
        
        // 保存时间戳
        [self abstract_saveDownloadTimeStamp:_requestJuzi];
        
        
        _loopNumber = loopNumber;
        [self asyncDownLoadMp3WithDownLoadType:DownLoadTypeZhongWen];
    }
}
- (void)playAndDownloadJuzi:(NSString *)juzi loopNumber:(NSInteger)loopNumber lanType:(NSString *)lanType
{
    _requestJuzi = [NSString stringWithFormat:@"%@  !%@  !%@  !",juzi,juzi,juzi];
    if ([lanType isEqualToString:@"wyw"] || [lanType isEqualToString:@"cht"]) {
        lanType = @"zh";
    }
    // 粤语
    if ([lanType isEqualToString:@"yue"]) {
        lanType = @"cte";
        _requestJuzi = [NSString stringWithFormat:@"%@,%@,%@,",juzi,juzi,juzi];
    }
    if ([lanType isEqualToString:@"th"]) {
        _requestJuzi = [NSString stringWithFormat:@"%@,%@,%@,",juzi,juzi,juzi];
    }
    if ([lanType isEqualToString:@"ara"] || [lanType isEqualToString:@"ru"])  {
        _requestJuzi = [NSString stringWithFormat:@"%@",juzi];
        loopNumber = 5;
    }
    if ([lanType isEqualToString:@"fra"] || [lanType isEqualToString:@"spa"] || [lanType isEqualToString:@"de"] || [lanType isEqualToString:@"pt"])  {
        _requestJuzi = [NSString stringWithFormat:@"%@ , , %@",juzi,juzi];
        loopNumber = 5;
    }//bonjour`,%20,%20`bonjour
    
    // 播放
    DLog(@"将要同步或异步下载和播放:%@",_requestJuzi);
    NSString *mp3FullPath = [self getFullPathFromMp3Name:_requestJuzi];
    if ([self isFileExistByFullPath:mp3FullPath]) {
        // 直接播放，后台，循环
        // 如果下载成功，播放音乐
        // [self playLoopMp3WithFullPath:mp3FullPath];
        [self playMp3WithFullPath:mp3FullPath loopNumber:loopNumber];
    }else{
        // 不存在，则同步或异步下载
        // [self syncDownLoadMp3];
        
        NSLog(@"sg__开始下载");
        
        // 保存时间戳
        [self abstract_saveDownloadTimeStamp:_requestJuzi];
        
        _loopNumber = loopNumber;
        NSString *fanyiUrlString = [NSString stringWithFormat:@"http://fanyi.baidu.com/gettts?lan=%@&text=",lanType];
        NSURL *url = [self urlFromBaseStr:fanyiUrlString queryStr:_requestJuzi];
        // 初始化请求
        NSMutableURLRequest  *request = [[NSMutableURLRequest alloc] init];
        // 设置
        [request setURL:url];
        [request setCachePolicy:NSURLRequestUseProtocolCachePolicy]; // 设置缓存策略 NSURLRequestReturnCacheDataElseLoad
        [request setTimeoutInterval:5.0]; // 设置超时
        _mp3Data = [[NSMutableData alloc] init];
        NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request     delegate:self];
        if (connection == nil) {
            // 创建请求失败
            return;
        }
    }
}
- (void)abstract_saveDownloadTimeStamp:(NSString *)requestJuzi
{
    // 根据用户上次选择的,展示
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSTimeInterval clientTimeStamp = [[NSDate date] timeIntervalSince1970];
    NSLog(@"sg__client:%f",clientTimeStamp);
    NSString *timestamp = [NSString stringWithFormat:@"%lf",clientTimeStamp];
    
    NSLog(@"sg__english__client:%@",timestamp);
    [userDefault setObject:timestamp forKey:requestJuzi];
    [userDefault synchronize];
}
#pragma mark - 工具方法
- (BOOL)isFileExistByFullPath:(NSString *)fullPath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL b = [fileManager fileExistsAtPath:fullPath];
    return b;
    
}
- (NSString *)getFullPathFromMp3Name:(NSString *)hanzi
{
    NSLog(@"sg_english__getFullPathFromMp3Name:%@",hanzi);
    // 根据hanzi,获取时间戳
    // 根据用户上次选择的,展示
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    NSString *timestamp = [userDefault objectForKey:hanzi];
    if (timestamp.length == 0 || !timestamp) {
        
        NSLog(@"sg_english__不存在!NULL_%@",hanzi);
        return @"";
    }
    NSString *fileName = [NSString stringWithFormat:@"%@.mp3",timestamp];// timestamp.mp3
    
    NSLog(@"sg_english__fileName:%@",fileName);
    
    
    NSString *fullPathInDocument = [self tool_fullPath_Document_FileName:fileName];
    return fullPathInDocument;
}
// 获取本地txt路径
-(NSString *)tool_fullPath_MainBundel_FileName:(NSString *)fileName
{
    // 本地
    NSString *mainBundle=[[NSBundle mainBundle] bundlePath];
    NSString *path=[mainBundle stringByAppendingPathComponent:fileName];
    return path;
}
// fileName如：a.mp3,1.txt
- (NSString *)tool_fullPath_Document_FileName:(NSString *)fileName
{
    NSString *subPath_fileName = [NSString stringWithFormat:@"Documents/sg31.com/%@",fileName];
    NSString *fullPathInDocument = [NSHomeDirectory() stringByAppendingPathComponent:subPath_fileName];
    return fullPathInDocument;
}

#pragma mark - 播放mp3
// 指定mp3全路径，播放次数
- (void)playMp3WithFullPath:(NSString *)fullPath loopNumber:(NSInteger)loopNumber
{
    if (self.currentPlayingAudioPlayer) {
        [self.currentPlayingAudioPlayer pause];
    }
    // 2.传递数据源模型 给工具类播放音乐
    AVAudioPlayer *audioPlayer = [SongTool playMusicWithFullPath:fullPath loopNumber:loopNumber];
    audioPlayer.delegate = self;
    self.currentPlayingAudioPlayer = audioPlayer;
}

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

#pragma mark 异步请求下载mp3音频
- (void)asyncDownLoadMp3WithDownLoadType:(DownLoadType)type
{
    NSString *fanyiUrlString = @"";
    switch (type) {
        case DownLoadTypeZhongWen:
            fanyiUrlString = @"http://fanyi.baidu.com/gettts?lan=zh&text=";
            break;
        case DownLoadTypeEnglish:
            fanyiUrlString = @"http://fanyi.baidu.com/gettts?lan=en&text=";
            break;
            
        case DownLoadTypeHanYu:
            fanyiUrlString = @"http://fanyi.baidu.com/gettts?lan=kor&text=";
            
        default:
            break;
    }
    NSURL *url = [self urlFromBaseStr:fanyiUrlString queryStr:_requestJuzi];
    // 初始化请求
    NSMutableURLRequest  *request = [[NSMutableURLRequest alloc] init];
    
    // 设置
    [request setURL:url];
    [request setCachePolicy:NSURLRequestUseProtocolCachePolicy]; // 设置缓存策略 NSURLRequestReturnCacheDataElseLoad
    [request setTimeoutInterval:5.0]; // 设置超时
    
    //......
    _mp3Data = [[NSMutableData alloc] init];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request     delegate:self];
    if (connection == nil) {
        // 创建请求失败
        return;
    }
}
#pragma mark - 异步请求代理
//异步发送使用代理的方式, 需要实现以下delegate接口:
// 收到回应
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    DLog(@"receive the response");
    // 注意这里将NSURLResponse对象转换成NSHTTPURLResponse对象才能去
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
    if ([response respondsToSelector:@selector(allHeaderFields)]) {
        NSDictionary *dictionary = [httpResponse allHeaderFields];
        DLog(@"allHeaderFields: %@",dictionary);
    }
    [_mp3Data setLength:0];
}

// 接收数据
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    DLog(@"get some data");
    [_mp3Data appendData:data];
}

// 数据接收完毕
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    //NSString *results = [[NSString alloc]
    //                         initWithBytes:[_mp3Data bytes]
    //                         length:[_mp3Data length]
    //                         encoding:NSUTF8StringEncoding];
    
    //DLog(@"connectionDidFinishLoading: %@",results);
    
    
    // 将Data,进行下一步的处理....
    if (_mp3Data.length == 42) {
        _mp3Data = [NSData dataWithContentsOfFile:[self tool_fullPath_MainBundel_FileName:@"sorry.mp3"]];
        
        
    }
    NSString *fullPath = [self getFullPathFromMp3Name:_requestJuzi];
    BOOL isSuccess = [_mp3Data writeToFile:fullPath atomically:YES];
    if (isSuccess) {
        // 如果下载成功，播放音乐
        //[self playLoopMp3WithFullPath:fullPath];
        [self playMp3WithFullPath:fullPath loopNumber:_loopNumber ];
    }else{
        // 播放抱歉,继续下一条
        fullPath = [self tool_fullPath_MainBundel_FileName:@"sorry.mp3"];
        [self playMp3WithFullPath:fullPath loopNumber:3 ];
    }
    
}

// 返回错误
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    DLog(@"Connection failed: %@", error);
}
- (NSURL *)urlFromBaseStr:(NSString *)baseStr queryStr:(NSString *)queryStr
{
    NSString *str = [NSString stringWithFormat:@"%@%@",baseStr,queryStr];
    str =[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"sg__%@",str);
    return [NSURL URLWithString:str];
}


#pragma mark - 播放本地的音频
- (void)playLocalMp3WithFilePath:(NSString *)filePath
{
    [self playMp3WithFullPath:filePath loopNumber:-1 ];
}
- (void)pauseCurrentMp3
{
    [_currentPlayingAudioPlayer pause];
}
@end
