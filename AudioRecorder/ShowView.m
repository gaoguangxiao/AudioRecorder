//
//  ShowView.m
//  FFTDemo
//
//  Created by sensology on 2016/11/2.
//  Copyright © 2016年 智觅智能. All rights reserved.
//

#import "ShowView.h"

#define ScreenHeight [[UIScreen mainScreen] bounds].size.height
#define ScreenWidth  [[UIScreen mainScreen] bounds].size.width

@implementation ShowView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _pointArr = [[NSMutableArray alloc]init];
        self.backgroundColor = [UIColor clearColor];

        [self initView];
    }
    return self;
}
-(void)initView{
    UILabel *l = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 60)];
    l.numberOfLines = 0;
    
    l.text = @"顶部是和视图融合计算的高度数值，下面的数值是原始的分贝值";
    [self addSubview:l];
}

-(void)setPointArr:(NSMutableArray *)pointArr{
    
    _pointArr = pointArr;
    [self setNeedsDisplay];
}
//柱形
-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    if (!self.pointArr||[self.pointArr count] == 0) {
        return;
    }
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, 2.0);
    CGContextSetLineCap(context, kCGLineCapRound);
    
    CGFloat height = self.frame.size.height/4;//总的高度为
    
    float channelCenterY = self.frame.size.height/2;//中间线是
    
    for (NSInteger i = 0; i < self.pointArr.count; i++){
        NSNumber *point = self.pointArr[i];
        
        double peakPowerForChannel = pow(10, (0.05 * [point floatValue]));
        float val = height * peakPowerForChannel;
        
        float x = i * (self.frame.size.width - 20) / self.pointArr.count;
        
        NSString *value = [NSString stringWithFormat:@"%.1f",val];
        [value drawInRect:CGRectMake(x, channelCenterY - val/2 - 20, 45, 20) withAttributes:nil];
        
        NSString *valueAfter = [NSString stringWithFormat:@"%.1f",[point floatValue]];
        [valueAfter drawInRect:CGRectMake(x, channelCenterY + val/2 + 20, 45, 20) withAttributes:nil];
        
        CGContextMoveToPoint(context, x, channelCenterY - val/2);
        CGContextAddLineToPoint(context, x, channelCenterY + val/2);
        CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:240/255.0 green:70255.0 blue:135255.0 alpha:1.0].CGColor);
        CGContextStrokePath(context);
    }
//    CGContextSetLineWidth(context, 1.0);
//    float channelCenterY = imageSize.height / 2;
//    for (int i = 0; i < [self.pointArr count]; i++) {
//        CGPoint point = [self.pointArr[i] CGPointValue];
//
//        if (i%10 == 0) {
//
//            //柱形图顶部线段
////            CGContextAddLineToPoint(context, prePoint.x, point.y);
////            CGContextAddLineToPoint(context, point.x, point.y);
////            CGContextStrokePath(context);
//
//            float  docsSpace = 10 ;
//
////            CGContextMoveToPoint(context, x, channelCenterY - val / 2.0);
////            CGContextAddLineToPoint(context, x, channelCenterY + val / 2.0);
//            //动态圆柱体
//            CGContextMoveToPoint(context, prePoint.x,prePoint.y);
//            CGContextAddLineToPoint(context, prePoint.x, point.y);
//            CGContextAddLineToPoint(context, point.x + docsSpace, point.y);
//            if (i > 765) {
//                [K_RGBColor(240, 70, 135) setFill];
////                [[UIColor colorWithRed:(255 -(i - 765))/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0] setFill];
//            }
//            else{
////                [K_RGBColor(240, 70, 135) setFill];
//                [[UIColor colorWithRed:(i<255?i:255.0)/255.0 green:((i>255)?((i-255)>255?255:(i-255)):0.0)/255.0 blue:(i>510?(i - 510):0.0)/255.0 alpha:1.0] setFill];
//            }
//            CGContextAddLineToPoint(context, point.x + docsSpace, height);
//            CGContextAddLineToPoint(context, prePoint.x, height);
//            CGContextFillPath(context);
////            CGContextMoveToPoint(context, point.x+ docsSpace,point.y);
//            prePoint = point;
//        }
    
//    }
//    [[UIColor blueColor] setStroke];
//    CGContextSetLineWidth(context, 1.0);
//    CGContextAddLineToPoint(context, ScreenWidth - 10, self.frame.size.height/2.0);
//    CGContextAddLineToPoint(context, ScreenWidth - 10, height);
//    CGContextAddLineToPoint(context, 10, height);
//    CGContextAddLineToPoint(context, 10, self.frame.size.height/2.0);
//    CGContextStrokePath(context);
}

//波形
//-(void)drawRect:(CGRect)rect
//{
//    [super drawRect:rect];
//    if (!self.pointArr) {
//        return;
//    }
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    [[UIColor blueColor] setStroke];
//    CGContextSetLineWidth(context, 1.0);
//    CGContextBeginPath(context);
//    CGContextMoveToPoint(context, 0, self.frame.size.height/2.0);
//    for (int i = 0; i < [self.pointArr count]; i++) {
//        CGPoint point = [self.pointArr[i] CGPointValue];
//        CGContextAddLineToPoint(context, point.x, point.y);
//    }
//    CGContextAddLineToPoint(context, ScreenWidth, self.frame.size.height/2.0);
//    CGContextStrokePath(context);
//}



@end
