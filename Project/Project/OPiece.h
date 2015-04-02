//
//  OPiece.h
//  Project
//
//  Created by Stephen Douglas O'Keefe & Ryan Martin on 2015-03-28.
//  Copyright (c) 2015 NLSteveO & Ryan Martin. All rights reserved.
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
