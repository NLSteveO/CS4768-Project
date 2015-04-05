//
//  GameViewController.m
//  Project
//
//  Created by Stephen Douglas O'Keefe & Ryan Martin on 2015-03-28.
//  Copyright (c) 2015 NLSteveO & Ryan Martin. All rights reserved.
//

#import "GameViewController.h"
#import "ChatViewController.h"
#import "Board.h"
#import "XPiece.h"
#import "OPiece.h"
#import <OpenGLES/ES1/glext.h>

@interface GameViewController() {
    
}

@property (strong, nonatomic) EAGLContext *context;
//@property (strong, nonatomic) NSMutableArray *xPieces;
//@property (strong, nonatomic) NSMutableArray *oPieces;
@property (weak, nonatomic) IBOutlet UILabel *gameStatus;
@property Board *gameBoard;
@property BOOL over;  // denotes whether the game is over
//@property (nonatomic) BOOL canMakeTurn;  // denotes whether the player can make a move
@property BOOL localTurn;
- (void)setupGL;
- (void)tearDownGL;
- (void)setupOrthographicView;
- (void)setBoardPositionToNotFree:(int)cell withXorO:(int)val;

@end

@implementation GameViewController

/* when dealing with the board, we have it set up so that each x,y location in the 2D
 * array cooresponds to a 'flag' for determining whether that location in the tic-tac-toe
 * board is available or not. * 1 indicates not free and occupied by X; 0 indicates free;
 * -1 indicates not free and occupied by O *
 */
//oard = {0,0,0,0,0,0,0,0,0};  // array for checking whether a board position is free
//static bool canMakeTurn;

+ (void)initialize {
    canMakeTurn = YES;
    xPieces = [[NSMutableArray alloc] init];
    oPieces = [[NSMutableArray alloc] init];
    for (int i = 0; i < 9; i++) {
        board[i] = 0;
    }
    over = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];
    
    if (!self.context) {
        NSLog(@"Failed to create ES context");
    }
    
    GLKView *view = (GLKView *)self.view;
    view.context = self.context;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    
    _gameBoard = [[Board alloc] initWithWidth:view.bounds.size.width height:view.bounds.size.height];
    dispatch_async(dispatch_get_main_queue(), ^{
    XPiece *temp = [[XPiece alloc] initWithWidth:0 height:0 xPosition:0 yPosition:0];
    [xPieces addObject:temp];
    OPiece *temp2 = [[OPiece alloc] initWithSize:0 xPosition:0 yPosition:0];
    [oPieces addObject:temp2];
    });
    //canMakeTurn = YES;            /* should this be set to yes upon load? */
    _localTurn = YES;  // logical
    
    if ([session.connectedPeers count] == 0) {
        self.gameStatus.text = @"It is your turn!";
    }
    
    [self setupGL];
}

- (void)dealloc
{
    [self tearDownGL];
    
    if ([EAGLContext currentContext] == self.context) {
        [EAGLContext setCurrentContext:nil];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    if ([self isViewLoaded] && ([[self view] window] == nil)) {
        self.view = nil;
        
        [self tearDownGL];
        
        if ([EAGLContext currentContext] == self.context) {
            [EAGLContext setCurrentContext:nil];
        }
        self.context = nil;
    }
    
    // Dispose of any resources that can be recreated.
}

- (void)update
{
    [self setupOrthographicView];
}

- (void)setupGL
{
    [EAGLContext setCurrentContext:self.context];
}

- (void)tearDownGL
{
    [EAGLContext setCurrentContext:self.context];
}

- (void)setupOrthographicView
{
    // get iPhone display size & aspect ratio
    CGSize size = self.view.bounds.size;
    
    // set viewport based on display size
    glViewport(0, 0, size.width, size.height);
    
    // set up orthographic projection
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    glOrthof(0, size.width, 0, size.height, -1, 1);
}

/* checks whether a board position is free or not */
- (BOOL) positionIsFree: (int)cell {
    
    return board[cell] == 0;
}
/* sets an array index, mimicing the game board, to 0, -1, or 1 (depending on X, O or free) */
- (void)setBoardPositionToNotFree: (int)cell withXorO: (int)val {
    board[cell] = val;
}

/* checks whether a player has won.
 * returns 0   if tie
 *         1   if X has won
 *         -1  if O has won
 */
-(int) checkForWinner {
    
    // check for diagonal win
    if (board[0] == board[4] && board[0] == board[8] && board[0] != 0) return board[0];
    else if (board[2] == board[4] && board[2] == board[6] && board[2] != 0) return board[2];
    
    // check for vertical win
    else if (board[0] == board[3] && board[0] == board[6] && board[0] != 0) return board[0];
    else if (board[1] == board[4] && board[1] == board[7] && board[1] != 0) return board[1];
    else if (board[2] == board[5] && board[2] == board[8] && board[2] != 0) return board[2];
    
    // check for horizontal win
    else if (board[0] == board[1] && board[0] == board[2] && board[0] != 0) return board[0];
    else if (board[3] == board[4] && board[3] == board[5] && board[3] != 0) return board[3];
    else if (board[6] == board[7] && board[6] == board[8] && board[6] != 0) return board[6];
    
    // tie game
    else return 0;
}

- (BOOL) myTurn {
    return canMakeTurn;
}

/* Negates canMakeTurn and determines whether game is over */
- (void) endTurn {
    int winner = [self checkForWinner];
    if (winner == 1) {
        
        self.gameStatus.text = @"Game over - X wins! Tap to reset";
        over = YES;
    }
    else if (winner == -1) {
        
        self.gameStatus.text = @"Game over - O wins! Tap to reset";
        over = YES;
    }
    else if ([self boardFull]) {
        self.gameStatus.text = @"Game over - tie! Tap to clear!";
        over = YES;
    }
    if (canMakeTurn && !over) {
        self.gameStatus.text = @"It is your turn!";
    }
    else if (!over) {
        self.gameStatus.text = @"It is opponents turn!";
    }
}

/* Determines whether the board cells are all taken */
- (BOOL)boardFull {
    BOOL full = YES;
    for (int i = 0; i < 9; i++) {
        if (board[i] == 0) {
            full = NO;
            break;
        }
    }
    return full;
}

/* Resets array back to 0's and removes O and X Piece objects from arrays */
- (void)clearAll {
    dispatch_async(dispatch_get_main_queue(), ^{
    for (int i = 0; i < 9; i++) {
        board[i] = 0;
    }
    [oPieces removeAllObjects];
    [xPieces removeAllObjects];
    });
    over = NO;
    NSLog(@"%d", [oPieces count]);
}

/*+ (void)clearAll {
    for (int i = 0; i < 9; i++) {
        board[i] = 0;
    }
    [oPieces removeAllObjects];
    [xPieces removeAllObjects];
}*/

/* sets a value for turn and updates game status label */
- (void)setTurn:(BOOL)turn {
    canMakeTurn = turn;  // should this be here?
    NSLog(@"turn: %d", canMakeTurn);
    dispatch_async(dispatch_get_main_queue(), ^{
    XPiece *temp = [[XPiece alloc] initWithWidth:0 height:0 xPosition:0 yPosition:1];
    [xPieces addObject:temp];
    });
}

/* creates O object and places it in array to be drawn in function below */
- (void)recieveMove:(int)cell {
    dispatch_async(dispatch_get_main_queue(), ^{
        //NSLog(@"HI---%d", cell);
        [self setBoardPositionToNotFree:cell withXorO:-1];
        OPiece *temp = [[OPiece alloc] initWithSize:(self.view.bounds.size.width/3)+40 xPosition:[_gameBoard getXPosForCell:cell] yPosition:self.view.bounds.size.height-[_gameBoard getYPosForCell:cell]];
        [oPieces addObject:temp];
        NSLog(@"Just added o to array");
        NSLog(@"o count: %lu",(unsigned long)[oPieces count]);
        //NSLog(@"%@---%d",temp, _canMakeTurn);
    });
}

#pragma mark - GLKView and GLKViewController delegate methods

/* drawing happens in this function */
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    
    glClearColor(39/255.0f, 170/255.0f, 224/255.0f, 1);
    glClear(GL_COLOR_BUFFER_BIT);
    
    [_gameBoard drawBoard];  // draw the game board to screen
    
    if (canMakeTurn && !over) {
        self.gameStatus.text = @"It is your turn!";
    }
    else if (!over) {
        self.gameStatus.text = @"It is their turn!";
    }
    
    [self endTurn];
    
    for (XPiece *piece in xPieces) {
        [piece drawXPieceOnBoard];
    }
    for (OPiece *piece in oPieces) {
        [piece drawOPieceOnBoard];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
}

/* called when a user lifts finger from the screen, where game piece will be drawn */
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    // get touch location & device display size
    CGPoint pos = [[touches anyObject] locationInView:self.view];
    CGSize size = self.view.bounds.size;
    int cell = [_gameBoard getCellFromX:pos.x Y:pos.y];
    
    //NSLog(@"Touch ended at: %f,%f --- %d", pos.x, pos.y, cell);
    //NSLog(@"%@", session.connectedPeers);
    NSLog(@"Turn: %d", canMakeTurn);
    if (canMakeTurn && !over) {  // if the game is NOT over
        
        if ([session.connectedPeers count] == 0 && [self positionIsFree:cell]) {  // pass and play multiplayer

            if (_localTurn) {  // starting a game, O is first
                self.gameStatus.text = @"It is your turn!";
                dispatch_async(dispatch_get_main_queue(), ^{
                OPiece *temp = [[OPiece alloc] initWithSize:(size.width/3)+40 xPosition:[_gameBoard getXPosForCell:cell] yPosition:size.height-[_gameBoard getYPosForCell:cell]];
                [oPieces addObject:temp];
                });
                NSLog(@"Just added o to array");
                NSLog(@"o count: %lu",(unsigned long)[oPieces count]);
                [self setBoardPositionToNotFree:cell withXorO:-1];
            }
            else {
                self.gameStatus.text = @"It is opponents turn!";
                dispatch_async(dispatch_get_main_queue(), ^{
                XPiece *temp = [[XPiece alloc] initWithWidth:(size.width/3)-20 height:(size.width/3)-20 xPosition:[_gameBoard getXPosForCell:cell] yPosition:size.height-[_gameBoard getYPosForCell:cell]];
                [xPieces addObject:temp];
                });
                NSLog(@"Just added x to array");
                NSLog(@"x count: %lu",(unsigned long)[xPieces count]);
                [self setBoardPositionToNotFree:cell withXorO:1];
            }
            _localTurn = !_localTurn;  // negate because its pass and play
            [self endTurn];  /*   ?   */
        }
        else if ([self positionIsFree:cell]) {  // LAN multiplayer
            
            [self setBoardPositionToNotFree:cell withXorO:1];
            dispatch_async(dispatch_get_main_queue(), ^{
            XPiece *temp = [[XPiece alloc] initWithWidth:(size.width/3)-20 height:(size.width/3)-20 xPosition:[_gameBoard getXPosForCell:cell] yPosition:size.height-[_gameBoard getYPosForCell:cell]];
            [xPieces addObject:temp];
            });
            NSLog(@"Just added x to array");
            NSLog(@"x count: %lu",(unsigned long)[xPieces count]);
            [self setTurn:NO];
            //_canMakeTurn = NO;  // set local var _canMakeTurn to false to wait for other player to make a turn
            [self endTurn];  /*   ?    */
            NSString *str = [NSString stringWithFormat:@"g:%d", cell];
            [session sendData:[str dataUsingEncoding:NSASCIIStringEncoding]
                      toPeers:session.connectedPeers
                     withMode:MCSessionSendDataReliable error:nil];
        }
    }
    else if (over) {  // my have to move this to the second else if of outer if conditional
        NSString *str = [NSString stringWithFormat:@"clear"];
        [session sendData:[str dataUsingEncoding:NSASCIIStringEncoding]
                  toPeers:session.connectedPeers
                 withMode:MCSessionSendDataReliable error:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
        [self clearAll];
        });
    }
}

/* shake gesture event handler */
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    
    if (motion == UIEventSubtypeMotionShake && over) {  // resets game with shake
        NSString *str = [NSString stringWithFormat:@"clear"];
        [session sendData:[str dataUsingEncoding:NSASCIIStringEncoding]
                  toPeers:session.connectedPeers
                 withMode:MCSessionSendDataReliable error:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self clearAll];
        });
    }
}

@end
