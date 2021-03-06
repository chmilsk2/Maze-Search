//
//  MazeSettingsViewController.h
//  CS-440-Maze-Search
//
//  Created by Troy Chmieleski on 9/24/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MazeSettingsDelegate.h"

typedef NS_ENUM(NSInteger, ListSection) {
	ListSectionMaze,
	ListSectionAlgorithm,
	ListSectionCostFunction
};

@interface MazeSettingsViewController : UITableViewController

@property (nonatomic, weak) id <MazeSettingsDelegate> delegate;

@end
