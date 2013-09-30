//
//  Cell.h
//  CS-440-Maze-Search
//
//  Created by Troy Chmieleski on 9/25/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Cell : NSObject

@property NSUInteger state;
@property CGPoint coordinate;
@property BOOL visited;
@property BOOL isOnSolutionPath;

@property NSUInteger depth;
@property NSUInteger costIncurred;
@property Cell *parent;

- (id)initWithState:(NSUInteger)state coordinate:(CGPoint)coordinate;

@end
