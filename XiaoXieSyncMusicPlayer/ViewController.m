//
//  ViewController.m
//  XiaoXieSyncMusicPlayer
//
//  Created by user on 2016/6/1.
//  Copyright © 2016年 Bevis, Chen. All rights reserved.
//

#import "ViewController.h"

// self class
#import "Constants.h"
#import "AFNetworkingSingleton.h"
#import "MusicListTableViewCell.h"
#import "MusicSlider.h"
#import <XiaoXieSyncMusicPlayer-Swift.h>

// Third Party
#import "Track.h"
#import <DOUAudioStreamer/DOUAudioStreamer.h>
#import <SocketIOClientSwift/SocketIOClientSwift-Swift.h>
#import "GVUserDefaults+Properties.h"

@interface ViewController () <UITableViewDataSource,UITableViewDelegate>
{
    AFNetworkingSingleton *link;
    BOOL playbackFlag;
    MusicCycleType musicCycleType;
    DOUAudioStreamer *streamer;
    SocketIOClient* socket;
    NSArray *musicList;
    
}
@property (weak, nonatomic) IBOutlet UITableView *musicTable;
@property (weak, nonatomic) IBOutlet MusicSlider *musicSlider;
@property (weak, nonatomic) IBOutlet UIButton *playbackModeBtn;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Prepare Class
    link = [AFNetworkingSingleton sharedAFNetworkingSingleton];
    streamer = [DOUAudioStreamer new];
    musicList = [NSArray new];
    
    // Prepare Delegate
    _musicTable.delegate = self;
    _musicTable.dataSource = self;
    
    // Prepare Flag
    playbackFlag = true;
    musicCycleType = MusicCycleTypeLoopAll;
    
    // Some methods
//    [self linkToServer];
    
    // Socket.io
    [self doSocketIO];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

#pragma mark - Streamer Music
-(void)getStreamFromServerAtIndex:(NSInteger)index {
    
    Track *track = [Track new];
    
    
    NSString *uRLString = [NSString stringWithFormat:@"http://192.168.1.86:3162/music/%@",musicList[index]];
    
    NSLog(@"\n-----------\n%@\n------------",uRLString);
//    NSURL *musicURL = [NSURL URLWithString:[uRLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURL *musicURL = [NSURL URLWithString:[uRLString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    track.audioFileURL = musicURL;
    
    streamer = [DOUAudioStreamer streamerWithAudioFile:track];
}

#pragma mark - Socket.io
-(void)doSocketIO {
    
    NSURL* url = [[NSURL alloc] initWithString:@"http://192.168.1.86:3162"];
    socket = [[SocketIOClient alloc] initWithSocketURL:url options:nil];
    
    
    
    [socket on:@"chat message" callback:^(NSArray * _Nonnull data, SocketAckEmitter * _Nonnull ack) {
        
        NSLog(@"Data: %@\nAck: %@",data,ack);
        
        if ([data[0] isEqualToString:@"play"]) {
            [streamer play];
        }
        else if ([data[0] isEqualToString:@"pause"]) {
            [streamer pause];
        }
        else if ([data[0] isEqualToString:@"client connected!!"]) {
            [self nextMusicBtnPressed:nil];
        }
    }];
    
    [socket on:@"musicList" callback:^(NSArray * _Nonnull data, SocketAckEmitter * _Nonnull ack) {
        
        NSLog(@"Data: %@\nAck: %@",data,ack);
        
        musicList = data[0];
        [_musicTable reloadData];
    }];
    
    [socket connect];
}

#pragma mark - IBAction
- (IBAction)playbackBtnpressed:(id)sender {
    
    if (playbackFlag) {
        [(UIButton*)sender setImage:[UIImage imageNamed:PAUSE_BTN_IMAGE] forState:UIControlStateNormal];
        [socket emit:@"chat message" withItems:@[@"play"]];
        
        playbackFlag = false;
    }
    else {
        [(UIButton*)sender setImage:[UIImage imageNamed:PLAYBACK_BTN_IMAGE] forState:UIControlStateNormal];
        [socket emit:@"chat message" withItems:@[@"pause"]];
        
        playbackFlag = true;
    }
}
- (IBAction)lastMusicBtnPressed:(id)sender {
    [socket emit:@"chat message" withItems:@[@"I GOT YOU！！"]];
}
- (IBAction)nextMusicBtnPressed:(id)sender {
    [socket emit:@"musicList" withItems:@[@"I GOT YOU！！"]];
}
- (IBAction)playbackModeBtnPresssed:(id)sender {
    
    [(UIButton*)sender setImage:[UIImage imageNamed:LOOP_SINGLE_BTN_IMAGE] forState:UIControlStateNormal];
    
    switch (musicCycleType) {
        case MusicCycleTypeLoopAll:
            [(UIButton*)sender setImage:[UIImage imageNamed:LOOP_SINGLE_BTN_IMAGE] forState:UIControlStateNormal];
            
            musicCycleType = MusicCycleTypeLoopSingle;
            break;
        case MusicCycleTypeLoopSingle:
            [(UIButton*)sender setImage:[UIImage imageNamed:SHUFFLE_BTN_IMAGE] forState:UIControlStateNormal];
            musicCycleType = MusicCycleTypeShuffle;
            break;
        case MusicCycleTypeShuffle:
            [(UIButton*)sender setImage:[UIImage imageNamed:LOOP_ALL_BTN_IMAGE] forState:UIControlStateNormal];
            musicCycleType = MusicCycleTypeLoopAll;
            break;
            
        default:
            break;
    }
}
- (IBAction)moreBtnPressed:(id)sender {
    
}


#pragma mark - Link To Server
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

#pragma mark - SET_UP_UI
#pragma mark Normal UI

#pragma mark Control Music Indicator
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
    
    [self getStreamFromServerAtIndex:indexPath.row];
    
    [socket emit:@"chat message" withItems:@[@"play"]];
    
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // 分割線的長度調整
    tableView.separatorInset = UIEdgeInsetsMake(0, 40, 0, 0);
    
    return musicList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MusicListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    cell.number.text = [NSString stringWithFormat:@"%ld",indexPath.row + 1];
    cell.song.text = [musicList objectAtIndex:indexPath.row];
    cell.singer.text = @"庾澄慶";
    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
