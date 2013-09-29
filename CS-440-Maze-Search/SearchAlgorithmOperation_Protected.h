//
//  SearchAlgorithmOperation_Protected.h
//  CS-440-Maze-Search
//
//  Created by Troy Chmieleski on 9/25/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import "SearchAlgorithmOperation.h"

@interface SearchAlgorithmOperation ()

@property Maze *maze;
@property (copy) CostFunctionBlock costFunctionBlock;

- (void)didFinish;

@end
