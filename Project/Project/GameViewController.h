//
//  GameViewController.h
//  Project
//
//  Created by Stephen Douglas O'Keefe & Ryan Martin on 2015-03-28.
//  Copyright (c) 2015 NLSteveO & Ryan Martin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>

@interface GameViewController : GLKViewController

- (void)setTurn:(BOOL)turn;
- (void)recieveMove:(int)cell;

@end