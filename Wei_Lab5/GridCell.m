//
//  BoardCell.m
//  Wei_Lab5
//
//  Created by weiqi on 11/1/15.
//  Copyright (c) 2015 Qi Wei. All rights reserved.
//

#import "GridCell.h"
@implementation GridCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@synthesize player;
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    //[self setTitle:@"-1" forState:UIControlStateNormal];
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.isShip = NO;
    self.isPressed = NO;
    [self addTarget:self action:@selector(pressButton) forControlEvents:UIControlEventTouchUpInside];
    return self;
}

-(void)pressButton{
    if(self.isPressed == NO){
        self.isPressed = YES;
        self.enabled = NO;
        if(self.isShip == NO){
            [self setTitle:@"O" forState:UIControlStateNormal];
            if([gameMode isEqual:@"two"] || ([gameMode isEqual:@"one"] & [self.onGrid.owner isEqual:@"player2"])){
                NSString *missMusicPath = [[NSBundle mainBundle]pathForResource:@"miss" ofType:@"wav"];
                NSURL *missMusicURL = [[NSURL alloc]initFileURLWithPath:missMusicPath];
                player = [[AVAudioPlayer alloc] initWithContentsOfURL:missMusicURL error:nil];
                [player play];
                sleep(0.2);
            }
        }
        else{
            [self setTitle:@"X" forState:UIControlStateNormal];
            [self updateHitShips];
            [self checkSunkShips];
            if([gameMode isEqual:@"two"] || ([gameMode isEqual:@"one"] & [self.onGrid.owner isEqual:@"player2"])){
                NSString *missMusicPath = [[NSBundle mainBundle]pathForResource:@"hit" ofType:@"wav"];
                NSURL *missMusicURL = [[NSURL alloc]initFileURLWithPath:missMusicPath];
                player = [[AVAudioPlayer alloc] initWithContentsOfURL:missMusicURL error:nil];
                [player play];
                sleep(0.5);
                if(self.isSunk == YES){
                    NSString *missMusicPath = [[NSBundle mainBundle]pathForResource:@"sunk" ofType:@"mp3"];
                    NSURL *missMusicURL = [[NSURL alloc]initFileURLWithPath:missMusicPath];
                    player = [[AVAudioPlayer alloc] initWithContentsOfURL:missMusicURL error:nil];
                    [player play];
                    sleep(0.5);
                }
            }
        }
        if([self.delegate respondsToSelector:@selector(pressGridCell)]){
            [self.delegate pressGridCell];
        }
    }
}

-(void) updateHitShips{
    NSLog(@"update hitships");
    Grid* parentGrid = self.onGrid;
    int hitIndex = self.tag;
    NSLog(@"%d",hitIndex);
    int shipLength[5] = {5,4,3,3,2};
    for(int i = 0; i < 5; i++){
        for(int j = 0; j < shipLength[i]; j++){
            if([parentGrid.shipsIndex[i][j] intValue] == hitIndex){
                parentGrid.hitships[i][j] = [NSNumber numberWithInt:1];
                return;
            }
        }
    }
}


-(void)checkSunkShips{
    NSLog(@"check sunkships");
    Grid* parentGrid = self.onGrid;
    int count = 0;
    int shipLength[5] = {5,4,3,3,2};
    for(int i = 0; i < 5; i++){
        int sum = 0;
        for(int j = 0; j < shipLength[i]; j++){
            sum += [parentGrid.hitships[i][j] intValue];
        }
        //if sunk
        if(sum == shipLength[i]){
            count += 1;
            NSLog(@"sunk ship!!@%d", i);
            for(int j = 0; j < shipLength[i]; j++){
                parentGrid.sunkships[i][j] =[NSNumber numberWithInt:1];
                int m = [parentGrid.shipsIndex[i][j] intValue] / 10;
                int n = [parentGrid.shipsIndex[i][j] intValue]  % 10;
                GridCell* currentCell = parentGrid.gridCellButtons[m][n];
                currentCell.isSunk = YES;
            }
        }
    }
    parentGrid.countSunkShips = count;
}

@end
