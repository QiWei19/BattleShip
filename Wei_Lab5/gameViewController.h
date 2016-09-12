//
//  gameViewController.h
//  Wei_Lab5
//
//  Created by weiqi on 11/1/15.
//  Copyright (c) 2015 Qi Wei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#include "Grid.h"
extern NSString *gameMode;

@interface gameViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *whosTurnLable;
@property (weak, nonatomic) IBOutlet UIButton *switchButton;
@property (weak, nonatomic) IBOutlet UILabel *whoWinsLabel;
@property (weak, nonatomic) IBOutlet UIButton *playAgainButton;
@property (weak, nonatomic) IBOutlet UIButton *middleNewModeButton;
@property (weak, nonatomic) IBOutlet UILabel *whoFirstLabel;
@property (weak, nonatomic) IBOutlet UIButton *okButton;
@property (weak, nonatomic) IBOutlet UILabel *player1Label;
@property (weak, nonatomic) IBOutlet UILabel *player1SunkShipLabel2;
@property (weak, nonatomic) IBOutlet UILabel *player1SunkShipsLabel;
@property (weak, nonatomic) IBOutlet UILabel *player2Label;
@property (weak, nonatomic) IBOutlet UILabel *player2SunkShipLabel2;
@property (weak, nonatomic) IBOutlet UILabel *player2SunkShipsLabel;
@property (weak, nonatomic) IBOutlet UIButton *bottomeNewModeButton;
@property (weak, nonatomic) IBOutlet UIButton *restartButton;


@property Grid *player1Grid;
@property NSMutableArray *player1ShipsIndex;
@property Grid *player2Grid;
@property NSMutableArray *player2ShipsIndex;

@property NSString* currentPlayer;

@property(nonatomic, strong) AVAudioPlayer *player;

-(void)startOnePlayerGame;
-(void)startTwoPlayersGame;
-(void)aiMove;
-(void)gameOver;
-(void)showGameBoard;
-(void)hideGameBoard;


@end
