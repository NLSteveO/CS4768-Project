//
//  XPiece.h
//  Project
//
//  Created by Stephen Douglas O'Keefe & Ryan Martin on 2015-03-28.
//  Copyright (c) 2015 NLSteveO & Ryan Martin. All rights reserved.
//

#import <foundation/Foundation.h>

@interface XPiece : NSObject {
}

@property float width;
@property float height;
@property float xPos;
@property float yPos;

- (id)initWithWidth:(float)width height:(float)height xPosition:(float)xPos yPosition:(float)yPos;
- (void)drawXPieceOnBoard;

@end