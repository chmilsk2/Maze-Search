//
//  UniformCostSearchOperation.h
//  CS-440-Maze-Search
//
//  Created by Troy Chmieleski on 9/28/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import "SearchAlgorithmOperation_Protected.h"

@interface UniformCostSearchOperation : SearchAlgorithmOperation

- (id)initWithCostFunctionBlock:(CostFunctionBlock)costFunctionBlock;

@end
