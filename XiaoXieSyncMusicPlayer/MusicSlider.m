//
//  MusicSlider.m
//  XiaoXieSyncMusicPlayer
//
//  Created by user on 2016/6/3.
//  Copyright © 2016年 Bevis, Chen. All rights reserved.
//

#import "MusicSlider.h"

#define imageName @"music_slider_circle"

@implementation MusicSlider

// 連接SB的元件需使用這個建構式
-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setSlider];
    }
    return self;
}

-(void)setSlider {
    
    UIImage *thumbImage = [UIImage imageNamed:imageName];
    [self setThumbImage:thumbImage forState:UIControlStateNormal];
}

-(CGRect)thumbRectForBounds:(CGRect)bounds trackRect:(CGRect)rect value:(float)value {
    
    rect.origin.x -= 10;
    rect.size.width += 20;
    return CGRectInset([super thumbRectForBounds:bounds trackRect:rect value:value], 10, 10);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
