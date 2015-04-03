//
//  GameViewController.h
//  Project
//
//  Created by Stephen Douglas O'Keefe & Ryan Martin on 2015-03-28.
//  Copyright (c) 2015 NLSteveO & Ryan Martin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>

static BOOL canMakeTurn;
static BOOL over;
static int board[9];
static NSMutableArray *oPieces;
static NSMutableArray *xPieces;

@interface GameViewController : GLKViewController {
}

+ (void)initialize;
//+ (void)clearAll;
- (void)setTurn:(BOOL)turn;
- (void)recieveMove:(int)cell;
- (void)clearAll;

@end