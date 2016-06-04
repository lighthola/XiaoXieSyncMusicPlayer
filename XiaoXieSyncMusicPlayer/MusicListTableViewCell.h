//
//  MusicListTableViewCell.h
//  XiaoXieSyncMusicPlayer
//
//  Created by user on 2016/6/3.
//  Copyright © 2016年 Bevis, Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

// Third Party
#import "NAKPlaybackIndicatorView.h"

@interface MusicListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *song;
@property (weak, nonatomic) IBOutlet UILabel *singer;
@property (weak, nonatomic) IBOutlet UILabel *number;

@property (weak, nonatomic) IBOutlet NAKPlaybackIndicatorView *muiscIndicator;

@end
