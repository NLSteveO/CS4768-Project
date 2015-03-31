//
//  OPiece.m
//  Project
//
//  Created by Stephen Douglas O'Keefe on 2015-03-31.
//  Copyright (c) 2015 NLSteveO. All rights reserved.
//

#import "OPiece.h"
#import <OpenGLES/ES1/glext.h>

@implementation OPiece {
    
}

- (id)initWithSize:(float)size xPosition:(float)xPos yPosition:(float)yPos {
    self.size = size;
    self.xPos = xPos;
    self.yPos = yPos;
    
    return self;
}

- (void)drawOPieceOnBoard {
    glEnable(GL_VERTEX_ARRAY);
    const GLfloat points[] = {
        (GLfloat)self.xPos, (GLfloat)self.yPos
    };
    glVertexPointer(2, GL_FLOAT, 0, points);
    glPointSize(self.size+5);
    glEnable(GL_POINT_SMOOTH);
    glColor4f(0, 0, 0, 1);
    glDrawArrays(GL_POINTS, 0, 1);
    glPointSize(self.size);
    glColor4f(1, 1, 1, 1);
    glDrawArrays(GL_POINTS, 2, 1);
}

@end