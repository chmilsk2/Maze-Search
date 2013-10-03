//
//  CostFunctionNames.h
//  CS-440-Maze-Search
//
//  Created by Troy Chmieleski on 9/28/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#define NONE @"None"
#define UNIFORM_STEP_COST_FUNCTION_NAME @"Uniform Step"
#define MANHATTAN_DISTANCE_COST_FUNCTION_NAME @"Manhattan"
#define C1_COST_FUNCTION_NAME @"g(n)=C1"
#define C2_COST_FUNCTION_NAME @"g(n)=C2"
#define GREEDY_MANHATTAN_COST_FUNCTION_NAME [NSString stringWithFormat:@"g(n)=%@", MANHATTAN_DISTANCE_COST_FUNCTION_NAME]
#define A_STAR_MANAHTTAN_PLUS_UNIFORM_STEP_COST_FUNCTION_NAME [NSString stringWithFormat:@"g(n)=%@, h(n)=%@", MANHATTAN_DISTANCE_COST_FUNCTION_NAME, UNIFORM_STEP_COST_FUNCTION_NAME]
