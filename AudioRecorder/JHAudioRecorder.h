//
//  JHAudioRecorder.h
//  AudioRecorder
//
//  Created by gaoguangxiao on 2018/7/29.
//  Copyright © 2018年 gaoguangxiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@protocol JHAudioRecordDelegate <NSObject>

@optional
- (void)reloadValueWithArr:(NSArray *)valueArr;
- (void)reloadOutValueWithArr:(NSArray *)valueArr;

/**
 更新播放进度

 @param audioPlay <#audioPlay description#>
 */
-(void)reloadPlayTime:(AVAudioPlayer *)audioPlay;

-(void)reloadMeterValue:(float)meter;

-(void)reloadPatCount:(NSInteger)patCount;
@end

@interface JHAudioRecorder : NSObject
+(instancetype)shareAudioRecorder;

@property (nonatomic, weak) id <JHAudioRecordDelegate> delegate;

- (BOOL)startRecording;
- (void)stopRecording;

- (void)playRecordingWith:(NSString *)filePath;
- (void)stopPlaying;
@end
