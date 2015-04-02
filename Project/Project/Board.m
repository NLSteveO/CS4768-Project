//
//  Board.m
//  Project
//
//  Created by Stephen Douglas O'Keefe & Ryan Martin on 2015-03-28.
//  Copyright (c) 2015 NLSteveO & Ryan Martin. All rights reserved.
//

#import <foundation/Foundation.h>
#import "Board.h"
#import <OpenGLES/ES1/glext.h>

@implementation Board

- (id)initWithWidth:(float)width height:(float)height {
    self.width = width;
    self.height = height;
    
    self.cellsX1 = width/6;
    self.cellsX2 = width/2;
    self.cellsX3 = 5*width/6;
    self.cellsY1 = height/6;
    self.cellsY2 = height/2;
    self.cellsY3 = 5*height/6;
    
    return self;
}

- (void)drawBoard {
    GLfloat points[16];
    points[0] = (GLfloat)(self.width/3); points[1] = (GLfloat)(0);
    points[2] = (GLfloat)(self.width/3); points[3] = (GLfloat)(self.height-50);
    points[4] = (GLfloat)(2*self.width/3); points[5] = (GLfloat)(0);
    points[6] = (GLfloat)(2*self.width/3); points[7] = (GLfloat)(self.height-50);
    
    points[8] = (GLfloat)(0); points[9] = (GLfloat)(self.height/3);
    points[10] = (GLfloat)(self.width); points[11] = (GLfloat)(self.height/3);
    points[12] = (GLfloat)(0); points[13] = (GLfloat)(2*self.height/3);
    points[14] = (GLfloat)(self.width); points[15] = (GLfloat)(2*self.height/3);
    
    glColor4f(0, 0, 0, 1);
    glLineWidth(10);
    glEnable(GL_VERTEX_ARRAY);
    glVertexPointer(2, GL_FLOAT, 0, points);
    glDrawArrays(GL_LINES, 0, 8);
}

- (int)getCellFromX:(float)x Y:(float)y {
    int cell;
    if (x < self.width/3) {
        if (y < self.height/3) {
            cell = 0;
        }
        else if (y < (self.height*2)/3) {
            cell = 3;
        }
        else {
            cell = 6;
        }
    }
    else if (x < (self.width*2)/3) {
        if (y < self.height/3) {
            cell = 1;
        }
        else if (y < (self.height*2)/3) {
            cell = 4;
        }
        else {
            cell = 7;
        }
    }
    else {
        if (y < self.height/3) {
            cell = 2;
        }
        else if (y < (self.height*2)/3) {
            cell = 5;
        }
        else {
            cell = 8;
        }
    }
    return cell;
}

- (float)getXPosForCell:(int)cell {
    switch (cell) {
        case 0:
        case 3:
        case 6:
            return self.cellsX1;
            break;
        case 1:
        case 4:
        case 7:
            return self.cellsX2;
            break;
        case 2:
        case 5:
        case 8:
            return self.cellsX3;
            
        default:
            break;
    }
    return 0;
}

- (float)getYPosForCell:(int)cell {
    switch (cell) {
        case 0:
        case 1:
        case 2:
            return self.cellsY1;
            break;
        case 3:
        case 4:
        case 5:
            return self.cellsY2;
            break;
        case 6:
        case 7:
        case 8:
            return self.cellsY3;
            
        default:
            break;
    }
    return 0;
}

@end