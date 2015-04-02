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
@property (strong, nonatomic) NSMutableArray *xPieces;
@property (strong, nonatomic) NSMutableArray *oPieces;
@property (weak, nonatomic) IBOutlet UILabel *gameStatus;
@property Board *gameBoard;
@property BOOL over;

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
int board[9] = {0,0,0,0,0,0,0,0,0};  // array for checking whether a board position is free
BOOL turn;

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
    
    _xPieces = [[NSMutableArray alloc] init];
    _oPieces = [[NSMutableArray alloc] init];
    _gameBoard = [[Board alloc] initWithWidth:view.bounds.size.width height:view.bounds.size.height];
    
    XPiece *temp = [[XPiece alloc] initWithWidth:0 height:0 xPosition:0 yPosition:0];
    [_xPieces addObject:temp];
    
    turn = YES;
    _over = NO;
    
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
    return turn;
}

- (void) endTurn {
    turn = !turn;
    int winner = [self checkForWinner];
    if (winner == 1) {
        
        self.gameStatus.text = @"Game over - X wins! Tap to reset";
        _over = YES;
    }
    else if (winner == -1) {
        
        self.gameStatus.text = @"Game over - O wins! Tap to reset";
        _over = YES;
    }
    else if ([self boardFull]) {
        self.gameStatus.text = @"Game over - tie! Tap to clear!";
        _over = YES;
    }
}

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

- (void)clearAll {
    for (int i = 0; i < 9; i++) {
        board[i] = 0;
    }
    [_oPieces removeAllObjects];
    [_xPieces removeAllObjects];
}

- (void)setTurn:(BOOL)turn {
    turn = turn;
    NSLog(@"%d", turn);
}

- (void)recieveMove:(int)cell {
    [self setBoardPositionToNotFree:cell withXorO:-1];
    OPiece *temp = [[OPiece alloc] initWithSize:(self.view.bounds.size.width/3)+40 xPosition:[_gameBoard getXPosForCell:cell] yPosition:self.view.bounds.size.height-[_gameBoard getYPosForCell:cell]];
    [_oPieces addObject:temp];
    [self endTurn];
}

#pragma mark - GLKView and GLKViewController delegate methods

/* drawing happens in this function */
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    
    glClearColor(39/255.0f, 170/255.0f, 224/255.0f, 1);
    glClear(GL_COLOR_BUFFER_BIT);
    
    [_gameBoard drawBoard];  // draw the game board to screen
    
    if ([self myTurn] && !_over) {
        self.gameStatus.text = @"It is X's turn!";
    }
    else if (!_over) {
        self.gameStatus.text = @"It is O's turn!";
    }
    
    for (XPiece *piece in _xPieces) {
        [piece drawXPieceOnBoard];
    }
    for (OPiece *piece in _oPieces) {
        [piece drawOPieceOnBoard];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {  // screen touch event handler
    
    // get touch location & device display size
    //CGPoint pos = [[touches anyObject] locationInView:self.view];
    
    //NSLog(@"Touch began at: %f,%f", pos.x, pos.y);
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    // get touch location & device display size
    CGPoint pos = [[touches anyObject] locationInView:self.view];
    CGSize size = self.view.bounds.size;
    
    int cell = [_gameBoard getCellFromX:pos.x Y:pos.y];
    
    NSLog(@"Touch ended at: %f,%f --- %d", pos.x, pos.y, cell);
    
    if ([self myTurn] && !_over) {
        if ([self positionIsFree:cell]) {
            [self setBoardPositionToNotFree:cell withXorO:1];
            XPiece *temp = [[XPiece alloc] initWithWidth:(size.width/3)-20 height:(size.width/3)-20 xPosition:[_gameBoard getXPosForCell:cell] yPosition:size.height-[_gameBoard getYPosForCell:cell]];
            [_xPieces addObject:temp];
            [self endTurn];
            NSString *str = [NSString stringWithFormat:@"g:%d", cell];
            [session sendData:[str dataUsingEncoding:NSASCIIStringEncoding]
                      toPeers:session.connectedPeers
                     withMode:MCSessionSendDataReliable error:nil];
        }
    }
    else if ( !_over && [session.connectedPeers count] == 0) {
        if ([self positionIsFree:cell]) {
            [self setBoardPositionToNotFree:cell withXorO:-1];
            OPiece *temp = [[OPiece alloc] initWithSize:(size.width/3)+40 xPosition:[_gameBoard getXPosForCell:cell] yPosition:size.height-[_gameBoard getYPosForCell:cell]];
            [_oPieces addObject:temp];
            [self endTurn];
        }
    }
    else {
        [self clearAll];
        _over = NO;
    }
}


@end
