//
//  gameViewController.m
//  Wei_Lab5
//
//  Created by weiqi on 11/1/15.
//  Copyright (c) 2015 Qi Wei. All rights reserved.
//

#import "gameViewController.h"

@interface gameViewController()<gridDelegate>;
@end

@implementation gameViewController

@synthesize player1Grid;
@synthesize player1ShipsIndex;
@synthesize player2Grid;
@synthesize player2ShipsIndex;
@synthesize player;//sound player

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.okButton.hidden = NO;
    self.switchButton.hidden  = YES;
    self.whoWinsLabel.hidden = YES;
    self.playAgainButton.hidden = YES;
    self.middleNewModeButton.hidden = YES;

    self.player1SunkShipsLabel.text = @"0/5";
    self.player2SunkShipsLabel.text = @"0/5";
    
    [self hideGameBoard];
    [self initializeGrids];
}

-(void)initializeGrids{
    
    float scale = 0.5;
    CGRect viewRect = self.view.frame;
    CGFloat width = CGRectGetWidth(viewRect);
    CGFloat height = CGRectGetHeight(viewRect);
    CGFloat gridWidth = width*scale;
    CGFloat gridHeight = width*scale;
    CGFloat topGridX = (width-gridWidth)/2.0;
    CGFloat topGridY = (height/2.0 - gridHeight)/2.0 + 10;
    CGFloat bottomGridX = (width-gridWidth)/2.0;
    CGFloat bottomGridY = height - (height/2.0 - gridHeight)/2.0 - gridHeight - 5;
    CGRect topGridFrame = CGRectMake(topGridX, topGridY + 20 , gridWidth, gridHeight);
    CGRect bottomGridFrame = CGRectMake(bottomGridX, bottomGridY - 30, gridWidth, gridHeight);

    //initialize grid, player1's grid on bottom, player2's top on bottom
    player1Grid =[[Grid alloc]initWithFrame:bottomGridFrame];
    player1Grid.shipsIndex = player1ShipsIndex;
    player1Grid.owner = @"player1";
    player1Grid.delegate = self;
    [player1Grid createGridCells];
    
    player2Grid =[[Grid alloc]initWithFrame:topGridFrame];
    player2Grid.shipsIndex = player2ShipsIndex;
    player2Grid.owner = @"player2";
    player2Grid.delegate = self;
    [player2Grid createGridCells];
    
    //initialize who goes first
    int firstPlayer = arc4random() % 2;
    if(firstPlayer == 0){
        self.currentPlayer = @"player1";
        self.whoFirstLabel.text = @"Player 1 first";
    }
    else{
        self.currentPlayer = @"player2";
        self.whoFirstLabel.text = @"Player 2 first";
    }
    
    //initialize game board based on "game mode" & "current player"
    [player1Grid disableGridCells];
    [player2Grid hideShips];
    self.whosTurnLable.text = @"Player1's turn";
    if([self.currentPlayer isEqual:@"player2"] & [gameMode isEqual:@"two"]){
        self.whosTurnLable.text = @"Player2's turn";
        [player1Grid enableGridCells];
        [player1Grid hideShips];
        [player2Grid disableGridCells];
        [player2Grid showShips];
    }
    if([self.currentPlayer isEqual:@"player2"] & [gameMode isEqual:@"one"]){
        self.whoFirstLabel.text = @"AI first";
    }
    if([gameMode isEqual:@"one"]){
        self.whosTurnLable.text = @"Your turn";
        self.player1Label.text = @"You";
        self.player2Label.text = @"AI";
    }
    
    //add subviews
    [self.view addSubview:self.player1Grid];
    [self.view addSubview:self.player2Grid];
    self.player1Grid.hidden = YES;
    self.player2Grid.hidden = YES;
    
    //if ai goes first
    if([self.currentPlayer isEqual:@"player2"] & [gameMode isEqual:@"one"]){
        [self aiMove];
    }
    
}

-(void)viewDidAppear{
    NSLog(@"view did appear");
    if([self.currentPlayer isEqual:@"player2"] & [gameMode isEqual:@"one"]){
        [self aiMove];
    }
}

-(void)startOnePlayerGame{
    //one-player mode, player1's grid is always on bottom grid and ships are not hidden
    //player2(ai player)'s grid is always on the top grid and ships are hidden
    //cells in bottom grid are disables
    //after click a cell in top grid, the cell call back to this function
    
    [player2Grid hideShips];
    [player1Grid showShips];
    
    //player 1(bottom) has maken a move on player 2's grid(ai)(top) just now
    if([self.currentPlayer isEqual:@"player1"]){
        //check if top player (me) wins
        if(player2Grid.countSunkShips == 5){
            self.whoWinsLabel.text = @"You has win!";
            [self gameOver];
        }
        else{
            NSString *s1 =[NSString stringWithFormat:@"%d",player2Grid.countSunkShips] ;
            NSString *s2 = @"/5";
            self.player2SunkShipsLabel.text = [s1 stringByAppendingString:s2];
            self.currentPlayer = @"player2";
            [self aiMove];
            //[player2Grid disableGridCells];
        }
    }
    
    //player 2(ai)(top) has maken a move on player 1's grid(bottom) just now
    else{
        //check if ai wins
        if(player1Grid.countSunkShips == 5){
            self.whoWinsLabel.text = @"AI has win!";
            [self gameOver];
        }
        else{
            NSString *s1 =[NSString stringWithFormat:@"%d",player1Grid.countSunkShips] ;
            NSString *s2 = @"/5";
            self.player1SunkShipsLabel.text = [s1 stringByAppendingString:s2];
            self.currentPlayer = @"player1";
            [player2Grid enableGridCells];
        }
    }
}

-(void)startTwoPlayersGame{
    
    //player 1(bottom) has maken a move on player 2's grid(top) just now
    if([self.currentPlayer isEqual:@"player1"]){
        //if win
        if(player2Grid.countSunkShips == 5){
            self.whoWinsLabel.text = @"Player1 has win!";
            [self gameOver];
        }
        else{
            NSString *s1 =[NSString stringWithFormat:@"%d",player2Grid.countSunkShips] ;
            NSString *s2 = @"/5";
            self.player2SunkShipsLabel.text = [s1 stringByAppendingString:s2];
            
            //switch players
            self.currentPlayer = @"player2";
            self.switchButton.hidden = NO;
            self.whosTurnLable.text = @"Player2's turn";
            [self hideGameBoard];
            
            //bottom player
            [player1Grid enableGridCells];
            [player1Grid hideShips];
            
            //top player
            [player2Grid showShips];
            [player2Grid disableGridCells];
        }
    }
    //player 2(bottom) has maken a move on player 1's grid(top) just now
    else{
        //if win
        if(player1Grid.countSunkShips == 5){
            self.whoWinsLabel.text = @"Player2 has win!";
            [self gameOver];
        }
        else{
            NSString *s1 =[NSString stringWithFormat:@"%d",player1Grid.countSunkShips] ;
            NSString *s2 = @"/5";
            self.player1SunkShipsLabel.text = [s1 stringByAppendingString:s2];
            
            //switch players
            self.currentPlayer = @"player1";
            self.switchButton.hidden = NO;
            self.whosTurnLable.text = @"Player1's turn";
            [self hideGameBoard];

            //bottom
            [player1Grid showShips];
            [player1Grid disableGridCells];
            
            //top
            [player2Grid hideShips];
            [player2Grid enableGridCells];
        }
    }
}

-(void)aiMove{
    NSLog(@"ai moves");
    //make a "randomly" ai move
    [player1Grid aiPressGridCell];
}

-(void)gameOver{
    
    [self hideGameBoard];
    self.whoWinsLabel.hidden = NO;
    self.middleNewModeButton.hidden =NO;
    self.playAgainButton.hidden = NO;
    //play sound
    NSString *missMusicPath = [[NSBundle mainBundle]pathForResource:@"win" ofType:@"mp3"];
    NSURL *missMusicURL = [[NSURL alloc]initFileURLWithPath:missMusicPath];
    player = [[AVAudioPlayer alloc] initWithContentsOfURL:missMusicURL error:nil];
    if(!player.playing){
        sleep(1);
        [player play];        
    }
}

- (IBAction)pressSwitchPlayer:(id)sender {
    [self showGameBoard];
    self.switchButton.hidden = YES;
}

- (IBAction)pressOk:(id)sender {
    [self showGameBoard];
    self.okButton.hidden = YES;
    self.switchButton.hidden = YES;
    self.whoFirstLabel.hidden = YES;
}

-(void)hideGameBoard{
    self.whosTurnLable.hidden = YES;
    self.player1Grid.hidden = YES;
    self.player1Label.hidden = YES;
    self.player1SunkShipsLabel.hidden = YES;
    self.player1SunkShipLabel2.hidden = YES;
    self.player2Grid.hidden = YES;
    self.player2Label.hidden = YES;
    self.player2SunkShipsLabel.hidden = YES;
    self.player2SunkShipLabel2.hidden = YES;
    self.bottomeNewModeButton.hidden = YES;
    self.restartButton.hidden = YES;
}

-(void)showGameBoard{
    self.whosTurnLable.hidden = NO;
    self.player1Grid.hidden = NO;
    self.player1Label.hidden = NO;
    self.player1SunkShipsLabel.hidden = NO;
    self.player1SunkShipLabel2.hidden = NO;
    self.player2Grid.hidden = NO;
    self.player2Label.hidden = NO;
    self.player2SunkShipsLabel.hidden = NO;
    self.player2SunkShipLabel2.hidden = NO;
    self.bottomeNewModeButton.hidden = NO;
    self.restartButton.hidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
