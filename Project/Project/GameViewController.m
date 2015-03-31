//
//  GameViewController.m
//  Project
//
//  Created by Stephen Douglas O'Keefe & Ryan Martin on 2015-03-28.
//  Copyright (c) 2015 NLSteveO & Ryan Martin. All rights reserved.
//

#import "GameViewController.h"
#import "ChatViewController.h"
#import "XPiece.h"
#import "YPiece.h"
#import <OpenGLES/ES1/glext.h>

@interface GameViewController() {
    
}

@property (strong, nonatomic) EAGLContext *context;

- (void)setupGL;
- (void)tearDownGL;
- (void)setupOrthographicView: (CGSize)size;

@end

@implementation GameViewController

int board[3][3] = {
    {0,0,0},
    {0,0,0},
    {0,0,0}
};  // 3d array for checking whether a board position is free

- (void) viewDidLoad {
    
    [super viewDidLoad];
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];
    
    if (!self.context) {
        NSLog(@"Failed to create ES context");
    }
    
    GLKView *view = (GLKView *)self.view;
    view.context = self.context;
    [self setupGL];
}

- (void)didReceiveMemoryWarning {
    
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

- (void)dealloc {
    
    [self tearDownGL];
    
    if ([EAGLContext currentContext] == self.context) {
        [EAGLContext setCurrentContext:nil];
    }
}

- (void) setupGL {
    
    [EAGLContext setCurrentContext:self.context];
    
    //XPiece *xp = [[XPiece alloc] init];
    //YPiece *yp = [[YPiece alloc] init];
    
}

- (void) tearDownGL {
    
    [EAGLContext setCurrentContext:self.context];
}

- (void)setupOrthographicView: (CGSize)size {
    
    // set viewport based on display size
    glViewport(0, 0, size.width, size.height);
    float min = MIN(size.width, size.height);
    float width = size.width / min;  // class variable set above and checked below in event handler
    float height = size.height / min;  // used in 'zooming' the camera in and out
    
    // set up orthographic projection
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    glOrthof(-width, width, -height, height, -2, 2);
}

/* checks whether a board position is free or not */
- (BOOL) positionIsFree: (int)x andY: (int)y {
    
    return board[x][y] == 0;
}


#pragma mark - GLKView and GLKViewController delegate methods

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {  // *drawing happens here*
    
    // clear the rendering buffer
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    // set up the transformation for models
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
    
    glEnableClientState(GL_VERTEX_ARRAY);
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {  // screen touch event handler
    
    // get touch location & device display size
    CGPoint pos = [[touches anyObject] locationInView:self.view];
    float xDist = pos.x - (self.view.bounds.size.width/2.0);
    float yDist = pos.y - (self.view.bounds.size.height/2.0);
    float x = self.view.bounds.size.width/2.0 + (12.0 * cos(M_PI * sinangle / 180.0));
    float y = self.view.bounds.size.height/2.0 + (12.0 * sin(M_PI * cosangle / 180.0));
    /*
    if (fabs(pos.x) == x && fabs(pos.y) == y) {  // if earth is touched
        
        NSLog(@"> earth touched - zooming in");
        glRotatef(-_moveDist[1].y, 0, 0, 1);
        glTranslatef(-distanceAU, 0, 0);
        glRotatef(-_moveDist[1].x, 0, 0, 1);
    }
      else if (pos.x == (12 * cos() + ) && pos.y == ()) {
     
     
     }
     else if () {
     
     
     }
     else if () {
     
     
     }
     else if () {
     
     
     }*/
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {

}

@end
