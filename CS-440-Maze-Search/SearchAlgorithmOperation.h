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

typedef void(^AlgorithmHandler)();

@interface SearchAlgorithmOperation : NSOperation <AlgorithmOperation>

@property id <AlgorithmOperationDelegate> delegate;
@property (copy) AlgorithmHandler algorithmCompletionHandler;

- (id)initWithCostFunctionBlock:(CostFunctionBlock)costFunctionBlock;

@end
