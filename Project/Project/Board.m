//
//  Board.m
//  Project
//
//  Created by Stephen Douglas O'Keefe on 2015-03-31.
//  Copyright (c) 2015 NLSteveO. All rights reserved.
//

#import "Board.h"
#import <OpenGLES/ES1/glext.h>

@implementation Board

- (id)initWithWidth:(float)width height:(float)height {
    self.width = width;
    self.height = height;
    
    return self;
}

- (void)drawBoard {
    GLfloat points[16];
    points[0] = (GLfloat)(self.width/3); points[1] = (GLfloat)(0);
    points[2] = (GLfloat)(self.width/3); points[3] = (GLfloat)(self.height);
    points[4] = (GLfloat)(2*self.width/3); points[5] = (GLfloat)(0);
    points[6] = (GLfloat)(2*self.width/3); points[7] = (GLfloat)(self.height);
    
    points[8] = (GLfloat)(0); points[9] = (GLfloat)(self.height/3);
    points[10] = (GLfloat)(self.width); points[11] = (GLfloat)(self.height/3);
    points[12] = (GLfloat)(0); points[13] = (GLfloat)(2*self.height/3);
    points[14] = (GLfloat)(self.width); points[15] = (GLfloat)(2*self.height/3);
    
    glColor4f(0, 0, 0, 1);
    glLineWidth(5);
    glEnable(GL_VERTEX_ARRAY);
    glVertexPointer(2, GL_FLOAT, 0, points);
    glDrawArrays(GL_LINES, 0, 8);
}

@end