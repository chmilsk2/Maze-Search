//
//  Frontier.h
//  CS-440-Maze-Search
//
//  Created by Troy Chmieleski on 9/25/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Frontier : NSObject

@property (readonly) NSUInteger count;

- (void)enqueue:(id)obj;

// Queue implementation (FIFO)
- (id)dequeueFirstObject;

// Stack implementation (FILO)
- (id)dequeueLastObject;

// dequeue lowest cost
- (BOOL)containsObject:(id)obj;
- (void)clear;

@end
