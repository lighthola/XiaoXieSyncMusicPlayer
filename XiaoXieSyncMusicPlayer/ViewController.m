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

@interface ViewController () <UITableViewDataSource,UITableViewDelegate>
{
    AFNetworkingSingleton *link;
}
@property (weak, nonatomic) IBOutlet UITableView *musicTable;
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
            NSLog(@"%@",error);
            // 如果server端無回應3秒後重新嘗試
            [self performSelector:@selector(linkToServer) withObject:nil afterDelay:3.0];
        } else {
            NSLog(@"%@",result);
        }
    }];
}
#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    

    
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
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
