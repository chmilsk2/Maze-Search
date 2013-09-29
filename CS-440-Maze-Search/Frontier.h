//
//  Frontier.h
//  CS-440-Maze-Search
//
//  Created by Troy Chmieleski on 9/25/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CostFunctionBlock.h"

@interface Frontier : NSObject

@property (readonly) NSUInteger count;

- (void)enqueueObject:(id)obj;

// Queue implementation (FIFO)
- (id)dequeueFirstObject;

// Priority Queue implementation (remove object with lowest cost)
- (id)dequeueObjectWithLowestCostForBlock:(CostFunctionBlock)costFunction goalPoint:(CGPoint)goalPoint;

// Stack implementation (FILO)
- (id)dequeueLastObject;

// dequeue lowest cost
- (BOOL)containsObject:(id)obj;
- (void)clear;

@end
