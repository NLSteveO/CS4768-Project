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

- (id)initWithWidth:(float)width height:(float)height;
- (void)drawBoard;

@end
