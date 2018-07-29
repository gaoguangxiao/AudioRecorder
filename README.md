# AudioRecorder


一、音频相关的iOS类库
一、AVAudioSession
二、AVSpeechSynthesizer
三、AVSpeechUtterance
四、音频理论知识
一、基础知识：
一、音频相关的iOS类库

使用AVAudioSession负责调解APP和iOS系统里面的行为，比如其他APP播放声音的时候，闹钟、电话中断，耳机插拔。
使用AVSpeechSynthesizer演讲播放器播放语音，比如某一段文字，用于地图语音导航，文字转声音
使用AVSpeechUtterance，将一段文字准备成一段可供硬件理解，设置语音的停顿，语速，语音种类等方法

一、AVAudioSession
引入链接
iOS音频AVAudioSession：https://www.jianshu.com/p/fb0e5fb71b3c
由AVFoundation框架引入，每个iOS应用都有一个音频会话，用来管理多个APP对音频硬件设备的资源使用，其在APP启动的时候会自动帮忙激活它，这个会话可以被AVAudioSession类sharedInstance类方法访问，如下：
AVAudioSession*audioSession = [AVAudioSession sharedInstance];
1、作用
设置自己的APP是否和其他APP音频同时存在，还是中断其他APP的声音。
手机静音模式，自己APP是否还可以发出声音
电话或者其他APP中断自己的APP的音频处理
指定音频输入和输出的设备（比如是听筒输出声音还是扬声器输出声音）
是否支持录音，录音的同时是否支持音频播放

在获得一个AVAudioSession类的实例后，你就能通过调用音频会话对象的setCategory:error:实例方法，来从IOS应用可用的不同类别中作出选择。下面列出了可供使用的音频会话类别

其中Category分别有四种方法，是否打断不支持混音播放的APP，
是否会相应手机静音模式的开关
是否支持音频录制
是否支持音频播放

Category用于用于大方向
mode用于定制Cagegory的行为，录制视频，视频播放，视频通话
options用于微调和其他APP的关系，比如压制其他APP音调的响度

音频中断处理：
中断开始：记录此时APP状态，如播放状态，界面状态
中断结束：恢复APP的状态

二、AVSpeechSynthesizer
借用这个类，可以很方便实现从文本到语音播报的功能，演讲合成器。可以控制语音播放，暂停，继续，停止。
self.speechSynthesizer = [[AVSpeechSynthesizer alloc] init];

//    AVSpeechBoundaryImmediate 立即停止
//    AVSpeechBoundaryWord  说完一个词语在停止

- (void)speakUtterance:(AVSpeechUtterance *)utterance;

/* These methods will operate on the speech utterance that is speaking. Returns YES if it succeeds, NO for failure. */

/* Call stopSpeakingAtBoundary: to interrupt current speech and clear the queue. */
- (BOOL)stopSpeakingAtBoundary:(AVSpeechBoundary)boundary;
- (BOOL)pauseSpeakingAtBoundary:(AVSpeechBoundary)boundary;
- (BOOL)continueSpeaking;

三、AVSpeechUtterance
这个类可以是被播放的一段语音文字，可以理解为一段需要播放的文字，用于演讲合成器所需的前一步资源整合，解决了语音播报的文字，语速，语言种类，音量大小，延迟播放等特性
NS_CLASS_AVAILABLE_IOS(7_0)
@interface AVSpeechUtterance : NSObject<NSCopying, NSSecureCoding>

+ (instancetype)speechUtteranceWithString:(NSString *)string;
+ (instancetype)speechUtteranceWithAttributedString:(NSAttributedString *)string API_AVAILABLE(ios(10.0), watchos(3.0), tvos(10.0));

- (instancetype)initWithString:(NSString *)string;
- (instancetype)initWithAttributedString:(NSAttributedString *)string API_AVAILABLE(ios(10.0), watchos(3.0), tvos(10.0));

/* If no voice is specified, the system's default will be used. */
@property(nonatomic, retain, nullable) AVSpeechSynthesisVoice *voice;

@property(nonatomic, readonly) NSString *speechString;
@property(nonatomic, readonly) NSAttributedString *attributedSpeechString API_AVAILABLE(ios(10.0), watchos(3.0), tvos(10.0));

/* Setting these values after a speech utterance has been enqueued will have no effect. */

@property(nonatomic) float rate;             // Values are pinned between AVSpeechUtteranceMinimumSpeechRate and AVSpeechUtteranceMaximumSpeechRate.
@property(nonatomic) float pitchMultiplier;  // [0.5 - 2] Default = 1
@property(nonatomic) float volume;           // [0-1] Default = 1

@property(nonatomic) NSTimeInterval preUtteranceDelay;    // Default is 0.0
@property(nonatomic) NSTimeInterval postUtteranceDelay;   // Default is 0.0

@end

四、音频理论知识
一、基础概念：
采样频率：指每秒钟取得声音样本的次数，采样频率越高，包含的声音信息自然就越多，声音也就越好，频率越高，保存所需要的空间也会高，所以不一定越高越好，看实际需求。
采样位宽：级采样数值，一般分为8位和16位，可以表示的范围分别是2的八次方和2的十六次方，区间越大，分辨率也就越大，发出声音大能力也就越强，同样的，位宽越大，需要的空间也就越大。
声道数：分为单声道和双声道，双声道即立体声。

CADisplayLink的刷新和屏幕的刷新频率一秒60次刷新。
分贝：通常表示两个声音信号或电力信号在功率或强度方面的相对差别的单位，相当于两个水平的比率的常用对数的十倍。
声音的响度是指在单位时间内通过指定大小的面积内的能量的总和。
