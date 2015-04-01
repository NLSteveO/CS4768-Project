//
//  Board.h
//  Project
//
//  Created by Stephen Douglas O'Keefe on 2015-03-31.
//  Copyright (c) 2015 NLSteveO. All rights reserved.
//

#import <foundation/Foundation.h>

@interface Board : NSObject {
    
}

@property float width;
@property float height;
@property float cellsX1;
@property float cellsX2;
@property float cellsX3;
@property float cellsY1;
@property float cellsY2;
@property float cellsY3;

- (id)initWithWidth:(float)width height:(float)height;
- (void)drawBoard;
- (int)getCellFromX:(float)x Y:(float)y;
- (float)getXPosForCell:(int)cell;
- (float)getYPosForCell:(int)cell;

@end
