//
//  XPiece.m
//  Project
//
//  Created by Stephen Douglas O'Keefe & Ryan Martin on 2015-03-28.
//  Copyright (c) 2015 NLSteveO & Ryan Martin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XPiece.h"
#import <OpenGLES/ES1/glext.h>

@implementation XPiece {
    
}

- (id)initWithWidth:(float)width height:(float)height xPosition:(float)xPos yPosition:(float)yPos {
    self.width = width;
    self.height = height;
    self.xPos = xPos;
    self.yPos = yPos;
    
    return self;
}

- (void)drawXPieceOnBoard {
    glColor4f(0, 0, 0, 1);
    glEnableClientState(GL_VERTEX_ARRAY);
    GLfloat points[8];
    points[0] = (GLfloat)(self.xPos-self.width/2);
    points[1] = (GLfloat)(self.yPos+self.height/2);
    points[2] = (GLfloat)(self.xPos+self.width/2);
    points[3] = (GLfloat)(self.yPos-self.height/2);
    points[4] = (GLfloat)(self.xPos-self.width/2);
    points[5] = (GLfloat)(self.yPos-self.height/2);
    points[6] = (GLfloat)(self.xPos+self.width/2);
    points[7] = (GLfloat)(self.yPos+self.height/2);
    glVertexPointer(2, GL_FLOAT, 0, points);
    glDrawArrays(GL_LINES, 0, 4);
}

@end