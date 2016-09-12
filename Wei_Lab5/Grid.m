//
//  Board.m
//  Wei_Lab5
//
//  Created by weiqi on 11/1/15.
//  Copyright (c) 2015 Qi Wei. All rights reserved.
//

#import "Grid.h"
#import "GridCell.h"

@interface Grid ()<gridCellDelegate>

@end

@implementation Grid

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
@synthesize owner;
@synthesize gridCellButtons;
@synthesize shipsIndex;
@synthesize countSunkShips;
@synthesize sunkships;
@synthesize hitships;

-(id)initWithFrame:(CGRect)frame{
    //initialize grid
    countSunkShips = 0;
    self = [super initWithFrame:frame];
    UIColor *backgroundColor = [UIColor groupTableViewBackgroundColor];
    UIColor *lineColor = [UIColor blackColor];
    [self setBackgroundColor: backgroundColor];
    
    CGRect viewFrame = self.frame;
    CGFloat width = CGRectGetWidth(viewFrame);
    CGFloat lineSize = 3.0;
    CGFloat cellSize = (width - lineSize*11)/10;
    
    //draw lines
    UIView *line;
    for(int i =0; i < 11; i++){
        //horizontal lines
        CGRect hlineRect = CGRectMake(0, i*(lineSize+cellSize), width, lineSize);
        line = [[UIView alloc] initWithFrame:hlineRect];
        [line setBackgroundColor:lineColor];
        [self addSubview:line];
        //vertical lines
        CGRect vlineRect = CGRectMake(i*(lineSize+cellSize), 0, lineSize, width);
        line = [[UIView alloc] initWithFrame:vlineRect];
        [line setBackgroundColor:lineColor];
        [self addSubview:line];
    }
    
    //initialze sunkships. 0: not sunk, 1: sunk
    int shipLength[5] = {5,4,3,3,2};
    sunkships = [[NSMutableArray alloc]initWithCapacity:5];
    for(int i =0; i < 5; i++){
        NSMutableArray *row =[[NSMutableArray alloc]initWithCapacity:i];
        for(int j = 0; j < shipLength[i]; j++){
            [row addObject:[NSNumber numberWithInt:0]];
        }
        [sunkships addObject:row];
    }
    //initialze hitships. 0: not been hit, 1: has been hit
    hitships = [[NSMutableArray alloc]initWithCapacity:5];
    for(int i =0; i < 5; i++){
        NSMutableArray *row =[[NSMutableArray alloc]initWithCapacity:i];
        for(int j = 0; j < shipLength[i]; j++){
            [row addObject:[NSNumber numberWithInt:0]];
        }
        [hitships addObject:row];
    }
    return self;
}

-(void)createGridCells{
    gridCellButtons = [[NSMutableArray alloc]initWithCapacity:10];
    CGRect viewFrame = self.frame;
    CGFloat width = CGRectGetWidth(viewFrame);
    CGFloat lineSize = 3.0;
    CGFloat cellSize = (width - lineSize*11)/10;
   
    //create 100 cells
    for(int i = 0; i < 10 ;i++){
        NSMutableArray *row = [[NSMutableArray alloc]initWithCapacity:10];
        for(int j = 0; j < 10; j++){
            CGRect buttonFrame = CGRectMake(j*cellSize+(j+1)*lineSize, i*cellSize+(i+1)*lineSize, cellSize, cellSize);
            GridCell *cell = [[GridCell alloc]initWithFrame:buttonFrame];
            cell.tag = i*10 + j;
            cell.onGrid = self;
            cell.delegate = self;
            cell.isPressed = NO;
            cell.isShip = NO;
            [self addSubview:cell];
            [row addObject:cell];
        }
        [gridCellButtons addObject:row];
    }
    
    //createShips on grid
    for(id row in shipsIndex){
        for(NSNumber *ship in row){
            int i = ship.intValue / 10;
            int j = ship.intValue % 10;
            GridCell *currentCell = gridCellButtons[i][j];
            currentCell.isShip = YES;
            currentCell.backgroundColor = [[UIColor blueColor]colorWithAlphaComponent:0.5];
        }
    }

}
-(void)hideShips{
    int shipLength[5] = {5,4,3,3,2};
    for(int i = 0; i < 5; i++){
        for(int j = 0; j < shipLength[i]; j++){
            int m = [shipsIndex[i][j] intValue] / 10;
            int n = [shipsIndex[i][j] intValue] % 10;
            GridCell *currentCell = gridCellButtons[m][n];
            if ([sunkships[i][j] intValue] == 1){
                currentCell.backgroundColor = [[UIColor redColor]colorWithAlphaComponent:0.5];
            }
            else{
                currentCell.backgroundColor = [UIColor groupTableViewBackgroundColor];
            }
        }
    }
}
-(void)showShips{
    int shipLength[5] = {5,4,3,3,2};
    for(int i = 0; i <5; i++){
        for(int j = 0; j < shipLength[i]; j++){
            int m = [shipsIndex[i][j] intValue] / 10;
            int n = [shipsIndex[i][j] intValue] % 10;
            GridCell *currentCell = gridCellButtons[m][n];
            if ([sunkships[i][j] intValue] == 1){
                currentCell.backgroundColor = [[UIColor redColor]colorWithAlphaComponent:0.5];
            }
            else{
                currentCell.backgroundColor = [[UIColor blueColor]colorWithAlphaComponent:0.5];
            }
        }
    }
}

-(void)disableGridCells{
    for(id row in gridCellButtons){
        for(GridCell *cell in row){
            cell.enabled = NO;
        }
    }
}
-(void)enableGridCells{
    for(id row in gridCellButtons){
        for(GridCell *cell in row){
            cell.enabled = YES;
        }
    }
}

//delegate
-(void)pressGridCell{
    if([gameMode isEqual:@"one"]){
        if([self.delegate respondsToSelector:@selector(startOnePlayerGame)]){
            [self.delegate startOnePlayerGame];
        }
    }else{
        if([self.delegate respondsToSelector:@selector(startTwoPlayersGame)]){
            [self.delegate startTwoPlayersGame];
        }
    }
}

//ai moves
-(void)aiPressGridCell{
    int shipLength[5] = {5,4,3,3,2};
    
    GridCell* currentCell;
    //find a ship has been hit, but not sunk
    for(int i = 0; i < 5; i++){
        int hitNoSunk = 0;
    
        //how many hit points on this ship
        int sum = 0;
        for(int j = 0; j < shipLength[i]; j++){
            sum += [hitships[i][j] intValue];
        }
        //only one, pick 1 of the 4 points next to this point.
        if(sum == 1){
            for(int j = 0; j < shipLength[i]; j++){
                //if the ship has been hit, but not sunk
                if([hitships[i][j]intValue] == 1 & [sunkships[i][j] intValue]==0){
                    hitNoSunk = 1;
                    //try 4 cells, left, right, up, down
                    int m = [shipsIndex[i][j] intValue] / 10;
                    int n = [shipsIndex[i][j] intValue] % 10;
                    
                    if(m+1 < 10){
                        currentCell = gridCellButtons[m+1][n];
                        if(currentCell.isPressed ==NO){
                            [currentCell sendActionsForControlEvents:UIControlEventTouchUpInside];
                            return;
                        }
                    }
                    if(m-1 > 0){
                        currentCell = gridCellButtons[m-1][n];
                        if(currentCell.isPressed ==NO){
                            [currentCell sendActionsForControlEvents:UIControlEventTouchUpInside];
                            return;
                        }
                    }
                    if(n+1 < 10){
                        currentCell = gridCellButtons[m][n+1];
                        if(currentCell.isPressed ==NO){
                            [currentCell sendActionsForControlEvents:UIControlEventTouchUpInside];
                            return;
                        }
                    }
                    if(n-1 < 10){
                        currentCell = gridCellButtons[m][n-1];
                        if(currentCell.isPressed ==NO){
                            [currentCell sendActionsForControlEvents:UIControlEventTouchUpInside];
                            return;
                        }
                    }
                }
            }
        }
        //if more than one, ai knows the direction of this ship
        else if(sum != shipLength[i]){
            int direction = 0; //horizontal
            if([shipsIndex[i][0] intValue]+ 10 == [shipsIndex[i][1] intValue]){
                direction = 1; //ship rotated. vertical
            }
            for(int j = 0; j < shipLength[i]; j++){
                //find a hit point
                if([hitships[i][j]intValue] == 1){
                    //horizontal
                    if(direction == 0){
                        int m = [shipsIndex[i][j] intValue] / 10;
                        int n = [shipsIndex[i][j] intValue] % 10;
                        currentCell = gridCellButtons[m][n];
                        if(n-1 < 0){
                            GridCell *rightCell = gridCellButtons[m][n+1];
                            if(rightCell.isPressed == NO){
                                [rightCell sendActionsForControlEvents:UIControlEventTouchUpInside];
                                return;
                            }
                        }
                        else if (n+1>9){
                            GridCell *leftCell = gridCellButtons[m][n-1];
                            if(leftCell.isPressed == NO){
                                [leftCell sendActionsForControlEvents:UIControlEventTouchUpInside];
                                return;
                            }
                        }
                        else{
                            GridCell *leftCell = gridCellButtons[m][n-1];
                            GridCell *rightCell = gridCellButtons[m][n+1];
                            if(leftCell.isPressed == NO & rightCell.isPressed == YES){
                                [leftCell sendActionsForControlEvents:UIControlEventTouchUpInside];
                                return;
                            }
                            if(rightCell.isPressed == NO & leftCell.isPressed == YES){
                                [rightCell sendActionsForControlEvents:UIControlEventTouchUpInside];
                                return;
                            }
                        }
                    }
                    //vertical
                    else{
                        int m = [shipsIndex[i][j] intValue] / 10;
                        int n = [shipsIndex[i][j] intValue] % 10;
                        currentCell = gridCellButtons[m][n];
                        if(m-1 < 0){
                            GridCell *rightCell = gridCellButtons[m+1][n];
                            if(rightCell.isPressed == NO){
                                [rightCell sendActionsForControlEvents:UIControlEventTouchUpInside];
                                return;
                            }
                        }
                        else if (m+1>9){
                            GridCell *leftCell = gridCellButtons[m-1][n];
                            if(leftCell.isPressed == NO){
                                [leftCell sendActionsForControlEvents:UIControlEventTouchUpInside];
                                return;
                            }
                        }
                        else{
                            GridCell *leftCell = gridCellButtons[m][n-1];
                            GridCell *rightCell = gridCellButtons[m][n+1];
                            if(leftCell.isPressed == NO & rightCell.isPressed == YES){
                                [leftCell sendActionsForControlEvents:UIControlEventTouchUpInside];
                                return;
                            }
                            if(rightCell.isPressed == NO & leftCell.isPressed == YES){
                                [rightCell sendActionsForControlEvents:UIControlEventTouchUpInside];
                                return;
                            }
                        }
                    }
                }
            }
        }
        
        //has find a postion has been hit, but the ship is not sunk
        if(hitNoSunk == 1){
            for(int j = 0; j < shipLength[i]; j++){
                if([hitships[i][j]intValue] == 0){
                    int m = [shipsIndex[i][j] intValue] / 10;
                    int n = [shipsIndex[i][j] intValue] % 10;
                    GridCell* currentCell = gridCellButtons[m][n];
                    NSLog(@"find hit but not sunk ship success");
                    [currentCell sendActionsForControlEvents:UIControlEventTouchUpInside];
                    return;
                }
            }
        }
    }
    
    //not found, then do a random hit
    while(YES){
        int randomIndex = arc4random()%100;
        int m = randomIndex / 10;
        int n = randomIndex % 10;
        currentCell = gridCellButtons[m][n];
        if(currentCell.isPressed == YES){
            NSLog(@"random fail");
            continue;
        }
        else{
            NSLog(@"random success");
            [currentCell sendActionsForControlEvents:UIControlEventTouchUpInside];
            return;
        }
    }
}

@end
