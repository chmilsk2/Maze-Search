//
//  AlgorithmOperation.h
//  CS-440-Maze-Search
//
//  Created by Troy Chmieleski on 9/25/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AlgorithmOperationDelegate.h"

@class Maze;

@protocol AlgorithmOperation <NSObject>

- (void)setDelegate:(id <AlgorithmOperationDelegate>)delegate;
- (void)setMaze:(Maze *)maze;

@end
