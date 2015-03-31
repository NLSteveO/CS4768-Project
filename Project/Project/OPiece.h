//
//  OPiece.h
//  Project
//
//  Created by Stephen Douglas O'Keefe on 2015-03-31.
//  Copyright (c) 2015 NLSteveO. All rights reserved.
//

#import <foundation/Foundation.h>

@interface OPiece : NSObject {
}

@property float size;
@property float xPos;
@property float yPos;

- (id)initWithSize:(float)size xPosition:(float)xPos yPosition:(float)yPos;
- (void)drawOPieceOnBoard;

@end
