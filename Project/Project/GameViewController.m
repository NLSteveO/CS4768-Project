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
@property Board *gameBoard;
@property BOOL turn;

- (void)setupGL;
- (void)tearDownGL;
- (void)setupOrthographicView;

@end

@implementation GameViewController

/* when dealing with the board, we have it set up so that each x,y location in the 2D
 * array cooresponds to a 'flag' for determining whether that location in the tic-tac-toe
 * board is available or not. * 1 indicates not free; 0 indicates free *
 */
int board[9] = {0,0,0,0,0,0,0,0,0};  // array for checking whether a board position is free

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
    
    _turn = YES;
    
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

- (void) setBoardPositionToNotFree: (int)cell {
    
    board[cell] = 1;
}

- (BOOL) myTurn {
    return _turn;
}

- (void) endTurn {
    _turn = !_turn;
}


#pragma mark - GLKView and GLKViewController delegate methods

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {  // *drawing happens here*
    
    glClearColor(1, 1, 1, 1);
    glClear(GL_COLOR_BUFFER_BIT);
    
    [_gameBoard drawBoard];
    
    for (XPiece *piece in _xPieces) {
        [piece drawXPieceOnBoard];
    }
    for (OPiece *piece in _oPieces) {
        [piece drawOPieceOnBoard];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {  // screen touch event handler
    
    // get touch location & device display size
    CGPoint pos = [[touches anyObject] locationInView:self.view];
    
    //NSLog(@"Touch began at: %f,%f", pos.x, pos.y);
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    // get touch location & device display size
    CGPoint pos = [[touches anyObject] locationInView:self.view];
    CGSize size = self.view.bounds.size;
    
    int cell = [_gameBoard getCellFromX:pos.x Y:pos.y];
    
    NSLog(@"Touch ended at: %f,%f --- %d", pos.x, pos.y, cell);
    
    if ([self myTurn]) {
        if ([self positionIsFree:cell]) {
            [self setBoardPositionToNotFree:cell];
            XPiece *temp = [[XPiece alloc] initWithWidth:(size.width/3)-20 height:(size.height/3)-20 xPosition:[_gameBoard getXPosForCell:cell] yPosition:size.height-[_gameBoard getYPosForCell:cell]];
            [_xPieces addObject:temp];
            [self endTurn];
        }
    }
    else {
        if ([self positionIsFree:cell]) {
            [self setBoardPositionToNotFree:cell];
            OPiece *temp = [[OPiece alloc] initWithSize:(size.width/3)+40 xPosition:[_gameBoard getXPosForCell:cell] yPosition:size.height-[_gameBoard getYPosForCell:cell]];
            [_oPieces addObject:temp];
            [self endTurn];
        }
    }
}

@end
