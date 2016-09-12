//
//  BoardCell.h
//  Wei_Lab5
//
//  Created by weiqi on 11/1/15.
//  Copyright (c) 2015 Qi Wei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "Grid.h"
extern NSString *gameMode;

//delegate protocol
@protocol gridCellDelegate <NSObject>;

@optional
-(void) pressGridCell;

@end

//interface
@interface GridCell : UIButton

@property(nonatomic,strong) id <gridCellDelegate> delegate;

@property BOOL isShip;
@property BOOL isPressed;
@property BOOL isSunk;
@property Grid* onGrid;
@property(nonatomic, strong) AVAudioPlayer *player;

-(id)initWithFrame:(CGRect)frame;
-(void)pressButton;//delegate

@end

