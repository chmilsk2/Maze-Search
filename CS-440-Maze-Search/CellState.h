//
//  CellState.h
//  CS-440-Maze-Search
//
//  Created by Troy Chmieleski on 9/28/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, CellState) {
	CellStateWall,
	CellStatePath,
	CellStateStart,
	CellStateGoal
};
