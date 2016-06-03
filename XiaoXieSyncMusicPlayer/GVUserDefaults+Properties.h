//
//  GVUserDefaults+Properties.h
//  XiaoXieSyncMusicPlayer
//
//  Created by user on 2016/6/3.
//  Copyright © 2016年 Bevis, Chen. All rights reserved.
//

#import <GVUserDefaults/GVUserDefaults.h>

typedef NS_ENUM(NSInteger, MusicCycleType) {
    MusicCycleTypeLoopAll = 0,
    MusicCycleTypeLoopSingle,
    MusicCycleTypeShuffle
};

@interface GVUserDefaults (Properties)

@property (nonatomic,assign) MusicCycleType musicCycleType;

@end
