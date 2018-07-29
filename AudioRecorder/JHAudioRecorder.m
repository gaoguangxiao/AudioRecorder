//
//  JHAudioRecorder.m
//  AudioRecorder
//
//  Created by gaoguangxiao on 2018/7/29.
//  Copyright © 2018年 gaoguangxiao. All rights reserved.
//

#import "JHAudioRecorder.h"

@interface JHAudioRecorder ()<AVCaptureAudioDataOutputSampleBufferDelegate,AVAudioPlayerDelegate>{
    
    NSString*  nowTempPath;
    
    NSTimer *checkTime;//获取音乐声道的定时器
    
    NSMutableArray *pointArr;
    float viewWidth;
    float viewHeight;
}

@property (nonatomic, strong) AVAudioRecorder *audioRecorder;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@end


@implementation JHAudioRecorder
//static JHAudioRecorder *shareAudioRecorder = nil;
static JHAudioRecorder *_instance;
//+ (JHAudioRecorder *)shareAudioRecorder{
//
//    @synchronized(self)
//    {
//        if (shareAudioRecorder == nil)
//        {
//            shareAudioRecorder = [[self alloc] init];
//        }
//    }
//
//    return shareAudioRecorder;
//}
+(instancetype)shareAudioRecorder{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc]init];
    });
    return _instance;
}
+(instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}
-(id)copyWithZone:(NSZone *)zone{
    return _instance;
}

- (BOOL)startRecording{
    
    NSLog(@"startRecording");
    
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];//设置可录制 和播放
    [audioSession setActive:YES error:nil];
    
    NSMutableDictionary *recordSettings = [[NSMutableDictionary alloc] initWithCapacity:10];
    [recordSettings setObject:[NSNumber numberWithInt: kAudioFormatLinearPCM] forKey: AVFormatIDKey];//ID
    [recordSettings setObject:[NSNumber numberWithFloat:11025.0] forKey: AVSampleRateKey];//采样率
    [recordSettings setObject:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];//通道的数目,1单声道,2立体声
    [recordSettings setObject:[NSNumber numberWithInt: AVAudioQualityMin] forKey: AVEncoderAudioQualityKey];
    
    nowTempPath = [self filePathWithName:@"recordTemp" andType:[NSString stringWithFormat:@"%d",(int )[[NSDate date] timeIntervalSince1970]]];
    NSLog(@"nowTempPath:%@",nowTempPath);
    NSURL *url = [NSURL fileURLWithPath:nowTempPath];
    NSError *error = nil;
    
    if (self.audioRecorder) {
        if ([self.audioRecorder isRecording]) {
            [self.audioRecorder stop];
        }
        self.audioRecorder = nil;
    }
    self.audioRecorder = [[AVAudioRecorder alloc] initWithURL:url settings:recordSettings error:&error];
    
    if ([self .audioRecorder prepareToRecord]){
        
        self.audioRecorder.meteringEnabled = YES;
        
        self.audioRecorder.delegate = self;
        
        return [self.audioRecorder record];
    }else{
        
        int errorCode = CFSwapInt32HostToBig ([error code]);
        NSLog( @"Error: %@ [%4.4s])" , [error localizedDescription], (char*)&errorCode);
        
        return NO;
    }
}
- (void)stopRecording{
    [self.audioRecorder stop];
}

- (void)playRecordingWith:(NSString *)filePath{
    
    NSLog(@"playRecording");
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    [audioSession setActive:YES error:nil];
    
    NSURL *url = [NSURL URLWithString:nowTempPath];;
    if (filePath.length > 0) {
       url = [NSURL fileURLWithPath:filePath];
    }
    
    NSError *error;
    

    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    
    if (!error&&self.audioPlayer) {
        self.audioPlayer.numberOfLoops = 0;
        self.audioPlayer.meteringEnabled = YES;
        self.audioPlayer.delegate = self;
        //设置播放速率， 前提设置为YES
        //    self.audioPlayer.enableRate = YES;
        //    self.audioPlayer.rate = ;
        
        [self.audioPlayer play];
    }

    
    
//    [self startCheck];
}
- (void)stopPlaying{
    NSLog(@"stopPlaying");
    if (self.audioPlayer) {
        [self.audioPlayer stop];
//        [self.audioPlayer pause];
//        [self.audioPlayer play];
    }
    [self stopCheck];
}
- (void)stopCheck{
    if (checkTime) {
        [checkTime invalidate];
        checkTime = nil;
    }
}
- (void)startCheck{
    if (!checkTime) {
        pointArr = [[NSMutableArray alloc]init];
        checkTime = [NSTimer scheduledTimerWithTimeInterval:1.0/5000.0 target:self selector:@selector(checkRecordValueWithTime:) userInfo:nil repeats:YES];
    }
}
- (void)checkRecordValueWithTime:(NSTimer *)time{
    
    [self.audioPlayer updateMeters];
    float peakPower = [self.audioPlayer averagePowerForChannel:1];//获得指定声道的分贝平均值，注意如果要获得分贝平均值必须在此之前调用updateMeters方法
    
//    pow(x,y) 计算X的Y次方根
//    double peakPowerForChannel = pow(10, (0.05 * peakPower));
    
//    [pointArr addObject:[NSNumber numberWithDouble:peakPower]];
//    NSLog(@"peakPowerForChannel : %f",peakPowerForChannel);
    
    //将suoy
    if ([pointArr count] >= 15) {
        [pointArr removeObjectAtIndex:0];
    }
    
    if (self.delegate&&[self.delegate respondsToSelector:@selector(reloadPlayTime:)]) {
//        [self.delegate reloadPlayTime:self.audioPlayer];
    }
    
    if (self.delegate&&[self.delegate respondsToSelector:@selector(reloadValueWithArr:)]) {
        [self.delegate reloadValueWithArr:[pointArr copy]];
    }
    
    if ([self.delegate respondsToSelector:@selector(reloadMeterValue:)]) {
        [self.delegate reloadMeterValue:peakPower];
    }
//    }
    
    
}
- (NSString *)filePathWithName:(NSString *)recorderName andType:(NSString *)type{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path = [paths  objectAtIndex:0];
    NSString *account = @"yinyue";
    NSString *filePath = [path stringByAppendingPathComponent:[NSString stringWithFormat: @"/sens/%@/recorder/",account]];
    NSFileManager* fm = [NSFileManager defaultManager];
    
    if(![fm fileExistsAtPath:filePath]) {
            [fm createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *filename = [filePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@",recorderName,type]];
    return filename;
}
#pragma mark - AVAudioPlayer Delegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    [self stopPlaying];
}

-(void)dealloc{
//    [audioPlayer.url release];
    if (self.audioPlayer && [self.audioPlayer isPlaying]) {
        [self.audioPlayer stop];
    }
    self.audioPlayer = nil;
//    [audioPlayer release];
//    audioPlayer = nil;/
//    [super dealloc];
}
@end
