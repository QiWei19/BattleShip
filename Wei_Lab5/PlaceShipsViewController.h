//
//  PlaceShipsViewController.h
//  Wei_Lab5
//
//  Created by weiqi on 11/1/15.
//  Copyright (c) 2015 Qi Wei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Grid.h"
#import "Ship.h"
#import "gameViewController.h"

extern NSString *gameMode;

@interface PlaceShipsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *swithButton;
@property (weak, nonatomic) IBOutlet UIButton *startGameButton;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (weak, nonatomic) IBOutlet UILabel *whosTrunLable;


@property Grid *player1Grid;
@property NSMutableArray *player1Ships;
@property NSMutableArray *player1ShipsIndex;

@property Grid *player2Grid;
@property NSMutableArray *player2Ships;
@property NSMutableArray *player2ShipsIndex;

@property NSString* currentPlayer;

-(void)player1placeShips;
-(void)player2placeShips;
-(void)aiplaceShips;
-(BOOL)checkPlayer1Ships;
-(BOOL)checkPlayer2Ships;

@end
