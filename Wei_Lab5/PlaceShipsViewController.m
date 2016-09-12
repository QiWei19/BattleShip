//
//  PlaceShipsViewController.m
//  Wei_Lab5
//
//  Created by weiqi on 11/1/15.
//  Copyright (c) 2015 Qi Wei. All rights reserved.
//

#import "PlaceShipsViewController.h"


@interface PlaceShipsViewController ()

@end

@implementation PlaceShipsViewController

@synthesize player1Grid;
@synthesize player2Grid;
@synthesize player1Ships;
@synthesize player2Ships;
@synthesize player1ShipsIndex;
@synthesize player2ShipsIndex;
@synthesize currentPlayer;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"%@",gameMode);
    
    self.swithButton.hidden = YES;
    self.doneButton.hidden = NO;
    self.startGameButton.hidden = YES;
    
    player1Ships = [[NSMutableArray alloc]initWithCapacity:5];
    player2Ships = [[NSMutableArray alloc]initWithCapacity:5];
    player1ShipsIndex = [[NSMutableArray alloc]initWithCapacity:5];
    player2ShipsIndex = [[NSMutableArray alloc]initWithCapacity:5];

    currentPlayer = @"player1";
    [self player1placeShips];

}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSMutableArray *ship1 = player1ShipsIndex;
    NSMutableArray *ship2 = player2ShipsIndex;
    gameViewController * viewController = segue.destinationViewController;
    viewController.player1ShipsIndex = ship1;
    viewController.player2ShipsIndex = ship2;
}

- (void) player1placeShips{

    self.whosTrunLable.text = @"Player1, please place your ships";
    self.whosTrunLable.hidden = NO;
    
    float scale = 0.7;
    CGRect viewRect = self.view.frame;
    CGFloat width = CGRectGetWidth(viewRect);
    CGFloat height = CGRectGetWidth(viewRect);
    CGFloat x = (width - width*scale)/2.0;
    CGFloat y = (height - width*scale)/2.0;
    CGFloat lineSize = 3.0;
    CGFloat cellSize = (width*scale - lineSize*11)/10;
    
    //Create player1's game grid
    player1Grid = [[Grid alloc]initWithFrame:CGRectMake(x, y, width*scale, width*scale)];
    [self.view addSubview:self.player1Grid];
    player1Grid.owner = @"player1";
    
    //Create 5 ships
    float shiplength[5] = {5,4,3,3,2};
    for(int i = 0; i< 5; i++){
        CGFloat swidth = shiplength[i] * cellSize + (shiplength[i]-1)*lineSize;
        CGFloat sheight = cellSize;
        CGFloat sx = width/2.0 - swidth/2.0;
        CGFloat sy = y + width*scale*1.08 + i*(cellSize+6);
        Ship *ship = [[Ship alloc]initWithFrame:CGRectMake(sx, sy, swidth,sheight)];
        [self.view addSubview: ship];
        [player1Ships addObject:ship];
    }
}

-(void) player2placeShips{
    self.whosTrunLable.text = @"Player2, please place your ships";
    self.whosTrunLable.hidden = NO;
    
    float scale = 0.7;
    CGRect viewRect = self.view.frame;
    CGFloat width = CGRectGetWidth(viewRect);
    CGFloat height = CGRectGetWidth(viewRect);
    CGFloat x = (width - width*scale)/2.0;
    CGFloat y = (height - width*scale)/2.0;
    CGFloat lineSize = 3.0;
    CGFloat cellSize = (width*scale - lineSize*11)/10;
    
    //Create player2's game grid
    player2Grid = [[Grid alloc]initWithFrame:CGRectMake(x, y, width*scale, width*scale)];
    [self.view addSubview:self.player2Grid];
    player2Grid.owner = @"player2";
    
    //Create 5 ships
    int shiplength[5] = {5,4,3,3,2};
    for(int i = 0; i< 5; i++){
        CGFloat swidth = shiplength[i] * cellSize + (shiplength[i]-1)*lineSize;
        CGFloat sheight = cellSize;
        CGFloat sx = width/2.0 - swidth/2.0;
        CGFloat sy = y + width*scale*1.08 + i*(cellSize+6);
        Ship *ship = [[Ship alloc]initWithFrame:CGRectMake(sx, sy, swidth,sheight)];
        [self.view addSubview: ship];
        [player2Ships addObject:ship];
    }
}

-(void)aiplaceShips{

    //randomly create 5 ships on player2Grid
    NSMutableArray *shipsDict = [[NSMutableArray alloc]initWithCapacity:17];
    int shiplength[5] = {5,4,3,3,2};
    int hasCreated = 0;

    while (hasCreated < 5) {
        BOOL fail = NO;
        int length = shiplength[hasCreated];
        
        // 100 cells, randomly pick up one
        int randomStartPsition = arc4random() % 100;
        int i = randomStartPsition / 10;
        int j = randomStartPsition % 10;
        
        // randomly decide ship orientation, 2 orientations: horizontal = 0, veritiacal = 1;
        int randomOrientation = arc4random()% 2;
        NSMutableArray *row = [[NSMutableArray alloc]initWithCapacity:length];
        if (randomOrientation == 0){
            if(j+length >= 10){
                fail = YES;
            }
            else{
                for(int k = 0; k < length; k++){
                    NSNumber *index =  [NSNumber numberWithInt:randomStartPsition+k];
                    if([shipsDict containsObject: index]){
                        fail = YES;
                        break;
                    }else{
                        [shipsDict addObject:index];
                        [row addObject:index];
                    }
                }
                if(fail == NO){
                    [player2ShipsIndex addObject:row];
                }
            }
        }
        else{
            if(i+length >= 10){
                fail = YES;
            }
            else{
                for(int k = 0; k < length; k++){
                    NSNumber *index =  [NSNumber numberWithInt:randomStartPsition+k*10];
                    if([shipsDict containsObject: index]){
                        fail = YES;
                        break;
                    }else{
                        [shipsDict addObject:index];
                        [row addObject:index];
                    }
                }
                if(fail == NO){
                    [player2ShipsIndex addObject:row];
                }
            }
        }
        if (fail == NO) {
            hasCreated += 1;
        }
    }
    /*
    for(int i = 0; i<17;i++){
        NSLog(@"@%@", shipsDict[i]);
    }
     */
}

- (IBAction)pressSwith:(id)sender {
    currentPlayer = @"player2";
    self.swithButton.hidden = YES;
    self.doneButton.hidden = NO;
    self.startGameButton.hidden = YES;
    self.whosTrunLable.hidden = YES;
    [self player2placeShips];

}
- (IBAction)pressStartGame:(id)sender {
    
}
- (IBAction)pressDone:(id)sender {

    if([gameMode isEqual:@"one"] & [currentPlayer  isEqual: @"player1"]){
        if ([self checkPlayer1Ships]) {
            [self aiplaceShips];
            self.startGameButton.hidden = NO;
            self.doneButton.hidden = YES;
        }
    }
    else if([gameMode isEqual:@"two"] & [currentPlayer isEqual:@"player1"]){
        if ([self checkPlayer1Ships]){
            
            //hidden player1's grid and ships, show up switch button
            self.doneButton.hidden = YES;
            self.startGameButton.hidden = YES;
            self.swithButton.hidden = NO;
            self.whosTrunLable.hidden = YES;
            player1Grid.hidden = YES;
            for(int i = 0; i < 5; i++){
                Ship *myship = player1Ships[i];
                myship.hidden = YES;
            }
        }
    }
    else if([gameMode isEqual:@"two"] & [currentPlayer isEqual:@"player2"]){
        if ([self checkPlayer2Ships]) {
            self.startGameButton.hidden = NO;
            self.doneButton.hidden = YES;
        }
    }
}

-(BOOL)checkPlayer1Ships{
    
    CGRect gridRect = player1Grid.frame;
    CGFloat gridWidth = CGRectGetWidth(gridRect);
    CGFloat gridMinX = CGRectGetMinX(gridRect);
    CGFloat gridMinY = CGRectGetMinY(gridRect);
    CGFloat gridMaxX = CGRectGetMaxX(gridRect);
    CGFloat gridMaxY = CGRectGetMaxY(gridRect);
    CGFloat lineSize = 3.0;
    CGFloat cellSize = (gridWidth- lineSize*11)/10;
    
    NSMutableArray *shipsDict = [[NSMutableArray alloc]initWithCapacity:17];
    int shiplength[5] = {5,4,3,3,2};
    for(int i = 0; i <5; i++){
        Ship *ship = player1Ships[i];
        CGRect shipRect = ship.frame;
        CGFloat shipMinX = CGRectGetMinX(shipRect);
        CGFloat shipMaxX = CGRectGetMaxX(shipRect);
        CGFloat shipMinY = CGRectGetMinY(shipRect);
        CGFloat shipMaxY = CGRectGetMaxY(shipRect);
        
        //check if ships are in grid;
        if(shipMinX < gridMinX || shipMinY < gridMinY || shipMaxX > gridMaxX || shipMaxY > gridMaxY){
            UIAlertController *alertError = nil;
            alertError = [UIAlertController
                          alertControllerWithTitle:@"Error! Ships are not in the grid!"
                          message:@"Please place the ships correctly."
                          preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *ok = [UIAlertAction
                                 actionWithTitle:@"Ok"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction *action){}];
            [alertError addAction:ok];
            [self presentViewController:alertError animated:(YES) completion:^{}];
            return NO;
        }
        
        //check if overlap;
        int m = (shipMinY - gridMinY)/cellSize;
        int n = (shipMinX - gridMinX)/cellSize;
        NSMutableArray *row=[[NSMutableArray alloc]initWithCapacity:shiplength[i]];
        if(ship.ifRotated == NO){
            //the ship is not rotated
            for(int k = 0; k < shiplength[i]; k++){
                NSNumber *index = [NSNumber numberWithInt:m*10 + n+k];
                if([shipsDict containsObject:index]){
                    UIAlertController *alertError = nil;
                    alertError = [UIAlertController
                                  alertControllerWithTitle:@"Error! Ships are overlap!"
                                  message:@"Please place the ships correctly."
                                  preferredStyle:(UIAlertControllerStyleAlert)];
                    UIAlertAction *ok = [UIAlertAction
                                         actionWithTitle:@"Ok"
                                         style:UIAlertActionStyleDefault
                                         handler:^(UIAlertAction *action){}];
                    [alertError addAction:ok];
                    [self presentViewController:alertError animated:(YES) completion:^{}];
                    return NO;
                }else{
                    [shipsDict addObject:index];
                    [row addObject:index];
                }
            }
            [player1ShipsIndex addObject:row];
        }
        else{
            //the ship is rotated
            for(int k = 0; k < shiplength[i]; k++){
                NSNumber *index = [NSNumber numberWithInt:(m+k)*10 + n];
                if([shipsDict containsObject:index]){
                    UIAlertController *alertError = nil;
                    alertError = [UIAlertController
                                  alertControllerWithTitle:@"Error! Ships are overlap!"
                                  message:@"Please place the ships correctly."
                                  preferredStyle:(UIAlertControllerStyleAlert)];
                    UIAlertAction *ok = [UIAlertAction
                                         actionWithTitle:@"Ok"
                                         style:UIAlertActionStyleDefault
                                         handler:^(UIAlertAction *action){}];
                    [alertError addAction:ok];
                    [self presentViewController:alertError animated:(YES) completion:^{}];
                    return NO;
                }else{
                    [shipsDict addObject:index];
                    [row addObject:index];
                }
            }
            [player1ShipsIndex addObject:row];
        }
    }
    return YES;
}

-(BOOL) checkPlayer2Ships{

    CGRect gridRect = player2Grid.frame;
    CGFloat gridWidth = CGRectGetWidth(gridRect);
    CGFloat gridMinX = CGRectGetMinX(gridRect);
    CGFloat gridMinY = CGRectGetMinY(gridRect);
    CGFloat gridMaxX = CGRectGetMaxX(gridRect);
    CGFloat gridMaxY = CGRectGetMaxY(gridRect);
    CGFloat lineSize = 3.0;
    CGFloat cellSize = (gridWidth- lineSize*11)/10;
    
    int shiplength[5] = {5,4,3,3,2};
    NSMutableArray *shipsDict = [[NSMutableArray alloc]initWithCapacity:17];
    for(int i = 0; i < 5; i++){
        Ship *ship = player2Ships[i];
        CGRect shipRect = ship.frame;
        CGFloat shipMinX = CGRectGetMinX(shipRect);
        CGFloat shipMaxX = CGRectGetMaxX(shipRect);
        CGFloat shipMinY = CGRectGetMinY(shipRect);
        CGFloat shipMaxY = CGRectGetMaxY(shipRect);
        
        //check if in grid;
        if(shipMinX < gridMinX || shipMinY < gridMinY || shipMaxX > gridMaxX || shipMaxY > gridMaxY){
            UIAlertController *alertError = nil;
            alertError = [UIAlertController
                          alertControllerWithTitle:@"Error! Ships are not in the Grid!"
                          message:@"Please place the ships correctly."
                          preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *ok = [UIAlertAction
                                 actionWithTitle:@"Ok"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction *action){}];
            [alertError addAction:ok];
            [self presentViewController:alertError animated:(YES) completion:^{}];
            return NO;
        }
        
        //check if overlap;
        int m = (shipMinY - gridMinY)/cellSize;
        int n = (shipMinX - gridMinX)/cellSize;
        NSMutableArray *row = [[NSMutableArray alloc]initWithCapacity:shiplength[i]];
        if(ship.ifRotated == NO){
            //the ship is not rotated
            for(int k = 0; k < shiplength[i]; k++){
                NSNumber *index = [NSNumber numberWithInt:m*10 + n+k];
                if([shipsDict containsObject:index]){
                    UIAlertController *alertError = nil;
                    alertError = [UIAlertController
                                  alertControllerWithTitle:@"Error! Ships are overlap!"
                                  message:@"Please place the ships correctly."
                                  preferredStyle:(UIAlertControllerStyleAlert)];
                    UIAlertAction *ok = [UIAlertAction
                                         actionWithTitle:@"Ok"
                                         style:UIAlertActionStyleDefault
                                         handler:^(UIAlertAction *action){}];
                    [alertError addAction:ok];
                    [self presentViewController:alertError animated:(YES) completion:^{}];
                    return NO;
                }else{
                    [shipsDict addObject:index];
                    [row addObject:index];
                }
            }
            [player2ShipsIndex addObject:row];
        }
        else{
            //the ship is rotated
            for(int k = 0; k < shiplength[i]; k++){
                NSNumber *index = [NSNumber numberWithInt:(m+k)*10 + n];
                if([shipsDict containsObject:index]){
                    UIAlertController *alertError = nil;
                    alertError = [UIAlertController
                                  alertControllerWithTitle:@"Error! Ships are overlap!"
                                  message:@"Please place the ships correctly."
                                  preferredStyle:(UIAlertControllerStyleAlert)];
                    UIAlertAction *ok = [UIAlertAction
                                         actionWithTitle:@"Ok"
                                         style:UIAlertActionStyleDefault
                                         handler:^(UIAlertAction *action){}];
                    [alertError addAction:ok];
                    [self presentViewController:alertError animated:(YES) completion:^{}];
                    return NO;
                }else{
                    [shipsDict addObject:index];
                    [row addObject:index];
                }
            }
            [player2ShipsIndex addObject:row];
        }
    }
    return YES;
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
