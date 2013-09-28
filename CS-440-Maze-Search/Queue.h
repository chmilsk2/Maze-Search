//
//  Queue.h
//  CS-440-Maze-Search
//
//  Created by Troy Chmieleski on 9/25/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Queue : NSObject

@property (readonly) NSUInteger count;

- (void)enqueue:(id)obj;
- (id)dequeue;
- (void)clear;

@end
