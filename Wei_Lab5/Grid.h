//
//  Board.h
//  Wei_Lab5
//
//  Created by weiqi on 11/1/15.
//  Copyright (c) 2015 Qi Wei. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *gameMode;

@protocol gridDelegate <NSObject>;

@optional
-(void) startOnePlayerGame;
-(void) startTwoPlayersGame;

@end

@interface Grid : UIView

@property(nonatomic,strong) id<gridDelegate> delegate;

@property NSMutableArray *gridCellButtons;
@property NSMutableArray *shipsIndex;
@property NSMutableArray *hitships;
@property NSMutableArray *sunkships;
@property NSString *owner;
@property int countSunkShips;

-(void)createGridCells;
-(void)disableGridCells;
-(void)enableGridCells;
-(void)hideShips;
-(void)showShips;
-(void)pressGridCell; //delegate
-(void)aiPressGridCell;

@end
