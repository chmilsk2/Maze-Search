//
//  Cell.h
//  CS-440-Maze-Search
//
//  Created by Troy Chmieleski on 9/25/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, CellState) {
	CellStateWall,
	CellStatePath,
	CellStateStart,
	CellStateGoal
};

@interface Cell : NSObject

@property NSUInteger state;
@property CGPoint coordinate;

- (id)initWithState:(NSUInteger)state coordinate:(CGPoint)coordinate;

@end
