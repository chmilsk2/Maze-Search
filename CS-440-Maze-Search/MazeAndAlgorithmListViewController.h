//
//  MazeAndAlgorithmListViewController.h
//  CS-440-Maze-Search
//
//  Created by Troy Chmieleski on 9/24/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MazeAndAlgorithmListDelegate.h"

typedef NS_ENUM(NSInteger, ListSection) {
	ListSectionMaze,
	ListSectionAlgorithm
};

@interface MazeAndAlgorithmListViewController : UITableViewController

@property (nonatomic, weak) id <MazeAndAlgorithmListDelegate> delegate;

@end
