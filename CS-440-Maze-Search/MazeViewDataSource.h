//
//  MazeViewDataSource.h
//  CS-440-Maze-Search
//
//  Created by Troy Chmieleski on 9/24/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MazeViewDataSource <NSObject>

- (CGFloat)horizontalMarginForBoardWidth:(CGFloat)width;
- (CGFloat)verticalMarginForBoardHeight:(CGFloat)height;
- (CGFloat)width;
- (CGFloat)height;
- (NSUInteger)numberOfCols;
- (NSUInteger)numberOfRows;
- (NSUInteger)stateForRow:(NSUInteger)row col:(NSUInteger)col;
- (BOOL)isVisitedForRow:(NSUInteger)row col:(NSUInteger)col;

@end
