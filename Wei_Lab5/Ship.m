//
//  Ship.m
//  Wei_Lab5
//
//  Created by weiqi on 11/1/15.
//  Copyright (c) 2015 Qi Wei. All rights reserved.
//

#import "Ship.h"

@implementation Ship

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@synthesize centerPosition;
@synthesize startPosition;
@synthesize endPosition;
@synthesize ifRotated;

-(id) initWithFrame:(CGRect)frame{
    ifRotated = NO;
    self = [super initWithFrame:frame];
    UIColor *shipColor = [UIColor blueColor];
    [self setBackgroundColor: shipColor];
    [self setAlpha:0.5];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(rotateShip)];
    [self addGestureRecognizer:tap];
    return self;
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    centerPosition = self.center;
    startPosition =[[touches anyObject]locationInView: self.superview];
}

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    endPosition = [[touches anyObject]locationInView: self.superview];
    //CGFloat x = centerPosition.x - (startPosition.x - endPosition.x);
    //CGFloat y = centerPosition.y - (startPosition.y - endPosition.y);
    centerPosition =CGPointMake(endPosition.x, endPosition.y);
    self.center = centerPosition;
}

-(void)rotateShip{
    if(ifRotated == NO){
        ifRotated = YES;
        self.transform = CGAffineTransformRotate(self.transform, M_PI/2);
        return;
    }else{
        ifRotated = NO;
        self.transform = CGAffineTransformRotate(self.transform, M_PI/2);
        return;
    }
}

@end
