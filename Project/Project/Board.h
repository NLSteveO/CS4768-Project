//
//  Board.h
//  Project
//
//  Created by Stephen Douglas O'Keefe & Ryan Martin on 2015-03-28.
//  Copyright (c) 2015 NLSteveO & Ryan Martin. All rights reserved.
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
