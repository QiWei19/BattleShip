//
//  ViewController.m
//  Wei_Lab5
//
//  Created by weiqi on 11/1/15.
//  Copyright (c) 2015 Qi Wei. All rights reserved.
//

#import "ViewController.h"
#import "PlaceShipsViewController.h"


@interface ViewController ()

@end

@implementation ViewController

@synthesize player;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSString *missMusicPath = [[NSBundle mainBundle]pathForResource:@"begin" ofType:@"mp3"];
    NSURL *missMusicURL = [[NSURL alloc]initFileURLWithPath:missMusicPath];
    player = [[AVAudioPlayer alloc] initWithContentsOfURL:missMusicURL error:nil];
    if(!player.playing){
        sleep(1);
        [player play];
    }
}
- (IBAction)onePlayerButton:(id)sender {
    gameMode = @"one";
    
}
- (IBAction)twoPlayersButton:(id)sender {
    gameMode = @"two";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
