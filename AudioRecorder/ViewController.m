//
//  ViewController.m
//  AudioRecorder
//
//  Created by gaoguangxiao on 2018/7/29.
//  Copyright © 2018年 gaoguangxiao. All rights reserved.
//

#import "ViewController.h"
#import "JHAudioRecorder.h"

//#import "WaveView.h"
#import "ShowView.h"
@interface ViewController ()<JHAudioRecordDelegate>
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UILabel *MeterLabel;

@property (strong, nonatomic) ShowView *waveView;
@property (strong, nonatomic) NSTimer *timer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.waveView = [[ShowView alloc] initWithFrame:CGRectMake(0, 64, 375, 250)];
    self.waveView.backgroundColor = [UIColor darkGrayColor];
//    self.waveView.delegate = self;
//    self.waveView.playDuration = 5;
    [self.view addSubview:self.waveView];
}
- (IBAction)StartRecord:(id)sender {
    
    [[JHAudioRecorder shareAudioRecorder]startRecording];
    
    //5S之后停止录制
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[JHAudioRecorder shareAudioRecorder]stopRecording];
    });
    
}
- (IBAction)PlayRecord:(id)sender {
    JHAudioRecorder *audio = [JHAudioRecorder shareAudioRecorder];
    audio.delegate = self;
    [audio playRecordingWith:@""];
}
- (IBAction)PlayMusic:(id)sender {
    NSString *pathStr = [[NSBundle mainBundle] pathForResource:@"张学友-你好毒" ofType:@"mp3"];
    JHAudioRecorder *audio = [JHAudioRecorder shareAudioRecorder];
    audio.delegate = self;
    [audio playRecordingWith:pathStr];
    
}
- (IBAction)StopMusic:(id)sender {
    [[JHAudioRecorder shareAudioRecorder]stopPlaying];
}

#pragma mark - JHAudioRecorder delegate
-(void)reloadPlayTime:(AVAudioPlayer *)audioPlay{
    float progress = audioPlay.currentTime/audioPlay.duration;
    
    [self.progressView setProgress:progress animated:YES];
    
    self.progressLabel.text =  [NSString stringWithFormat:@"%.2f%%",progress * 100];
    
}
-(void)reloadMeterValue:(float)meter{
    
    self.MeterLabel.text = [NSString stringWithFormat:@"Meter的数值：%f",meter];
    
//    NSLog(@"%f",meter);
}
-(void)reloadValueWithArr:(NSArray *)valueArr{
    
//    self.waveView.pointArr = [valueArr copy];
    
//    self.waveView
}
//#pragma mark - 定时器，造数据
//- (void)removeTimer
//{
//    [_timer invalidate];
//    _timer = nil;
//}
//
//- (void)addTimer{
//    //添加定时器
//    _timer = [NSTimer scheduledTimerWithTimeInterval:.1f target:self selector:@selector(addPoint:) userInfo:nil repeats:YES];
//
//    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
//}
//
//- (void)addPoint:(NSTimer *)t{
////    if (self.pointArr) {
////
////    }
//    [self.waveView setNeedsDisplay];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
