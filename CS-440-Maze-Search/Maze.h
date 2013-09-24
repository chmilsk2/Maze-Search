//
//  Maze.h
//  CS-440-Maze-Search
//
//  Created by Troy Chmieleski on 9/23/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, CellState) {
	CellStateWall,
	CellStatePath,
	CellStateStart,
	CellStateGoal
};

@interface Maze : NSObject

@property (readonly) NSString *name;

@property (readonly) NSNumber *width;
@property (readonly) NSNumber *height;

@property NSArray *cells;

- (id)initWithName:(NSString *)name cells:(NSArray *)cells width:(NSNumber *)width height:(NSNumber *)height;

@end
