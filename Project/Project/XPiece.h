//
//  XPiece.h
//  Project
//
//  Created by Stephen Douglas O'Keefe on 2015-03-31.
//  Copyright (c) 2015 NLSteveO. All rights reserved.
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