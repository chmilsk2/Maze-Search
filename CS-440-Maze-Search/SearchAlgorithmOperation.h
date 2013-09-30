//
//  SearchAlgorithmOperation.h
//  CS-440-Maze-Search
//
//  Created by Troy Chmieleski on 9/25/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AlgorithmOperation.h"
#import "AlgorithmOperationDelegate.h"
#import "Maze.h"
#import "Cell.h"
#import "CostFunctionBlock.h"

typedef void(^AlgorithmHandler)(NSUInteger, NSUInteger, NSUInteger, NSUInteger);

@interface SearchAlgorithmOperation : NSOperation <AlgorithmOperation>

@property id <AlgorithmOperationDelegate> delegate;
@property (copy) AlgorithmHandler algorithmCompletionHandler;

@property NSUInteger pathCost;
@property NSUInteger numberOfNodesExpanded;
@property NSUInteger maximumTreeDepthSearched;
@property NSUInteger maximumFrontierSize;

@end
