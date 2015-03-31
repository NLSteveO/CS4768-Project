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
#import "Ball.h"
#import <OpenGLES/ES1/glext.h>

@interface GameViewController() {
    
}
@property (strong, nonatomic) EAGLContext *context;
@property (strong, nonatomic) NSMutableArray *pieces;
@property Board *gameBoard;

- (void)setupGL;
- (void)tearDownGL;
- (void)setupOrthographicView;

@end

@implementation GameViewController

/* when dealing with the board, we have it set up so that each x,y location in the 2D
 * array cooresponds to a 'flag' for determining whether that location in the tic-tac-toe
 * board is available or not. * 1 indicates not free; 0 indicates free *
 */
int board[3][3] = {
    {0,0,0},
    {0,0,0},
    {0,0,0}
};  // 3d array for checking whether a board position is free

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
    
    _pieces = [[NSMutableArray alloc] init];
    _gameBoard = [[Board alloc] initWithWidth:view.bounds.size.width height:view.bounds.size.height];
    
    XPiece *temp = [[XPiece alloc] initWithWidth:0 height:0 xPosition:0 yPosition:0];
    [_pieces addObject:temp];
    
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
- (BOOL) positionIsFree: (int)x andY: (int)y {
    
    return board[x][y] == 0;
}

- (void) setBoardPositionToNotFree: (int)x andY: (int)y {
    
    board[x][y] = 1;
}


#pragma mark - GLKView and GLKViewController delegate methods

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {  // *drawing happens here*
    
    glClearColor(1, 1, 1, 1);
    glClear(GL_COLOR_BUFFER_BIT);
    
    [_gameBoard drawBoard];
    
    for (XPiece *piece in _pieces) {
        [piece drawXPieceOnBoard];
    }
    /*for (Ball *b in _pieces) {
        [b drawBall];
    }*/
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {  // screen touch event handler
    
    // get touch location & device display size
    CGPoint pos = [[touches anyObject] locationInView:self.view];
    CGSize size = self.view.bounds.size;
    
    NSLog(@"Touch began at: %f,%f", pos.x, pos.y);
    
    XPiece *temp = [[XPiece alloc] initWithWidth:(size.width/3)-5 height:(size.height/3)-5 xPosition:pos.x yPosition:size.height-pos.y];
    [_pieces addObject:temp];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    // get touch location & device display size
    CGPoint pos = [[touches anyObject] locationInView:self.view];
    
    NSLog(@"Touch ended at: %f,%f", pos.x, pos.y);
}

@end
