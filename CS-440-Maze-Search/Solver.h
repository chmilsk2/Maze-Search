//
//  Solver.h
//  CS-440-Maze-Search
//
//  Created by Troy Chmieleski on 9/25/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SolverDelegate.h"
#import "AlgorithmOperationDelegate.h"

@class Maze, SearchAlgorithmOperation;

@interface Solver : NSObject <AlgorithmOperationDelegate>

@property (nonatomic, weak) id <SolverDelegate> delegate;

- (void)solveWithMaze:(Maze *)maze algorithmOperation:(SearchAlgorithmOperation *)algorithmOperation;

@end
