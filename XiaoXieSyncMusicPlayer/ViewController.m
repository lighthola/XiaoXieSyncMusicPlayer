//
//  ViewController.m
//  XiaoXieSyncMusicPlayer
//
//  Created by user on 2016/6/1.
//  Copyright © 2016年 Bevis, Chen. All rights reserved.
//

#import "ViewController.h"

// self class
#import "AFNetworkingSingleton.h"
#import "MusicListTableViewCell.h"
#import "MusicSlider.h"

@interface ViewController () <UITableViewDataSource,UITableViewDelegate>
{
    AFNetworkingSingleton *link;
}
@property (weak, nonatomic) IBOutlet UITableView *musicTable;
@property (weak, nonatomic) IBOutlet MusicSlider *musicSlider;
@end

@implementation ViewController

-(void)awakeFromNib {
    [super awakeFromNib];

    link = [AFNetworkingSingleton sharedAFNetworkingSingleton];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Prepare Data
    _musicTable.delegate = self;
    _musicTable.dataSource = self;
    
    // Some methods
    [self linkToServer];
}

-(void)linkToServer {
    
    [link getAllInformation:^(NSError *error, id result) {
        if (error) {
            //NSLog(@"%@",error);
            // 如果server端無回應3秒後重新嘗試
            [self performSelector:@selector(linkToServer) withObject:nil afterDelay:3.0];
        } else {
            NSLog(@"%@",result);
        }
    }];
}


#pragma mark - Control Music Indicator
static NSIndexPath *lastPlaybackIndexPath = nil;
-(void)setMusicIndicatorStateAtIndexPath:(NSIndexPath*)indexPath {
    
    MusicListTableViewCell *currentCell = [_musicTable cellForRowAtIndexPath:indexPath];
    MusicListTableViewCell *lastCell = [_musicTable cellForRowAtIndexPath:lastPlaybackIndexPath];

    lastCell.muiscIndicator.state = NAKPlaybackIndicatorViewStateStopped;
    lastCell.muiscIndicator.hidden = true;
    lastCell.number.hidden = false;
    
    currentCell.muiscIndicator.state = NAKPlaybackIndicatorViewStatePlaying;
    currentCell.number.hidden = true;
    
    // 紀錄上一個播放的音樂的indexPath
    lastPlaybackIndexPath = indexPath;
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self setMusicIndicatorStateAtIndexPath:indexPath];
    
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // 分割線的長度調整
    tableView.separatorInset = UIEdgeInsetsMake(0, 40, 0, 0);
    
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MusicListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    cell.number.text = @"1";
    cell.song.text = @"百萬大歌星";
    cell.singer.text = @"庾澄慶";
    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
