//
//  Maze.h
//  CS-440-Maze-Search
//
//  Created by Troy Chmieleski on 9/23/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Cell;

@interface Maze : NSObject

@property (readonly) NSString *name;
@property (readonly) NSNumber *width;
@property (readonly) NSNumber *height;
@property NSArray *cells;
@property (readonly) Cell *startingCell;
@property (readonly) Cell *goalCell;
@property NSMutableArray *goalCells;

- (id)initWithName:(NSString *)name cells:(NSArray *)cells width:(NSNumber *)width height:(NSNumber *)height startingCell:(Cell *)startingCell goalCell:(Cell *)goalCell goalCells:(NSMutableArray *)goalCells;
- (id)initWithMaze:(Maze *)maze;
- (NSArray *)childrenForParent:(Cell *)cell;
- (BOOL)isGoalCell:(Cell *)cell;
- (void)removeAllTheGoals;
- (void)removeStartingCell;
- (void)removeAllSolutions;
- (void)addStartingCell:(Cell *)startingCell;
- (void)addGoal:(Cell *)goal;
- (void)setIsOnSolutionPathForMultiGoaledPath:(NSMutableArray *)multiGoaledPath;
- (void)setVisitedForCell:(Cell *)cell;

@end
