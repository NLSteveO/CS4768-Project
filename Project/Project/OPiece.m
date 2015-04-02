//
//  OPiece.m
//  Project
//
//  Created by Stephen Douglas O'Keefe on 2015-03-31.
//  Copyright (c) 2015 NLSteveO. All rights reserved.
//

#import <Foundation/Foundation.h>
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
    glEnableClientState(GL_VERTEX_ARRAY);
    glEnable(GL_POINT_SMOOTH);
    GLfloat points[2];
    points[0] = (GLfloat)self.xPos;
    points[1] = (GLfloat)self.yPos;
    glVertexPointer(2, GL_FLOAT, 0, points);
    glPointSize(self.size+25);
    glColor4f(0, 0, 0, 1);
    glDrawArrays(GL_POINTS, 0, 1);
    glPointSize(self.size);
    glColor4f(39/255.0f, 170/255.0f, 224/255.0f, 1);
    glDrawArrays(GL_POINTS, 0, 1);
}

@end