//
//  MazeSearchViewController.m
//  CS-440-Maze-Search
//
//  Created by Troy Chmieleski on 9/23/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import "MazeSearchViewController.h"
#import "MazeManager.h"
#import "MazeSettingsViewController.h"
#import "Maze.h"
#import "Cell.h"
#import "MazeView.h"
#import "Solver.h"
#import "SearchAlgorithmOperationFactory.h"
#import "SupportedAlgorithms.h"
#import "SearchAlgorithmOperation.h"
#import "CostFunctions.h"
#import "CostFunctionBlock.h"

#define PARSED_MAZE_NOTIFICATON @"Parsed Maze Notification"

#define PATH_COST_LABEL_TEXT @"Path Cost:"
#define NUMBER_OF_NODES_EXPANDED_TEXT @"Number of Nodes Expanded:"
#define MAXIMUM_TREE_DEPTH_SEARCHED_TEXT @"Maximum Tree Depth:"
#define MAXIMUM_FRONTIER_SIZE_TEXT @"Maximum Frontier Size:"

@interface MazeSearchViewController ()

@property (nonatomic, strong) MazeView *mazeView;
@property (nonatomic, strong) UIBarButtonItem *mazeAndAlgorithmListButton;
@property (nonatomic, strong) UIBarButtonItem *startButton;

@end

@implementation MazeSearchViewController {
	NSUInteger _selectedMazeIndex;
	NSUInteger _selectedAlgorithmIndex;
	NSInteger _selectedCostFunctionIndex;
}

- (id)init {
	self = [super init];
	
	if (self) {
		_selectedMazeIndex = 0; // default selected maze index
		
		// register for parsed maze notifications
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(parsedMazeNotification:) name:PARSED_MAZE_NOTIFICATON object:nil];
	}
	
	return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
	[self setUpNavigation];
	
	[self.view addSubview:self.mazeView];
}

#pragma mark - Navigation

- (void)setUpNavigation {
	[self.navigationItem setTitle:self.navigationController.tabBarItem.title];
	
	[self.navigationItem setLeftBarButtonItem:self.mazeAndAlgorithmListButton];
	[self.navigationItem setRightBarButtonItem:self.startButton];
}

#pragma mark - Start Button

- (UIBarButtonItem *)startButton {
	if (!_startButton) {
		_startButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(start)];
	}
	
	return _startButton;
}

#pragma mark - Maze and Algorithm List Button

- (UIBarButtonItem *)mazeAndAlgorithmListButton {
	if (!_mazeAndAlgorithmListButton) {
		_mazeAndAlgorithmListButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:@selector(presentMazeAndAlgorithmList)];
	}
	
	return _mazeAndAlgorithmListButton;
}

#pragma mark - Maze View

- (MazeView *)mazeView {
	if (!_mazeView) {
		_mazeView = [[MazeView alloc] initWithFrame:self.view.bounds];
		[self.mazeView setDataSource:self];
	}
	
	return _mazeView;
}

#pragma mark - Start

- (void)start {
	Solver *solver = [[Solver alloc] init];
	[solver setDelegate:self];
	
	SearchAlgorithmOperationFactory *searchAlgorithmOperationFactory = [SearchAlgorithmOperationFactory searchAlgorithmOperationFactory];
	
	NSString *algorithmOperationName = AlgorithmNameAtIndex(_selectedAlgorithmIndex);
	
	NSString *costFunctionName = [CostFunctions costFunctionNameForAlgorithmName:algorithmOperationName atIndex:_selectedCostFunctionIndex];
	
	SearchAlgorithmOperation *algorithmOperation = [searchAlgorithmOperationFactory searchAlgorithmOperationForName:algorithmOperationName costFunctionName:costFunctionName];
	
	solver.solverCompletionHandler = ^(NSUInteger pathCost, NSUInteger numberOfNodesExpanded, NSUInteger maximumTreeDepthSearched, NSUInteger maximumFrontierSize) {
		dispatch_async(dispatch_get_main_queue(), ^{
			[self.mazeView.pathCostLabel setText:[NSString stringWithFormat:@"%@ %lu", PATH_COST_LABEL_TEXT, (unsigned long)pathCost]];
			[self.mazeView.numberOfNodesExpandedLabel setText:[NSString stringWithFormat:@"%@ %lu", NUMBER_OF_NODES_EXPANDED_TEXT, (unsigned long)numberOfNodesExpanded]];
			[self.mazeView.maximumTreeDepthSearchedLabel setText:[NSString stringWithFormat:@"%@ %lu", MAXIMUM_TREE_DEPTH_SEARCHED_TEXT, (unsigned long)maximumTreeDepthSearched]];
			[self.mazeView.maximumFrontierSizeLabel setText:[NSString stringWithFormat:@"%@ %lu", MAXIMUM_FRONTIER_SIZE_TEXT, (unsigned long)maximumFrontierSize]];
			
			[self.mazeView reloadData];
		});
	};
	
	[solver solveWithMaze:[[MazeManager sharedMazeManager] mazeAtIndex:_selectedMazeIndex] algorithmOperation:algorithmOperation];
}

#pragma mark- Solver Delegate

- (void)tookStep {
	[self reloadMazeViewData];
}

#pragma mark - Maze and Algorithm List

- (void)presentMazeAndAlgorithmList {
	MazeSettingsViewController *mazeAndAlgorithmListViewController = [[MazeSettingsViewController alloc] initWithStyle:UITableViewStylePlain];
	[mazeAndAlgorithmListViewController setDelegate:self];
	
	UINavigationController *mazeAndAlgorithmListNavController = [[UINavigationController alloc] initWithRootViewController:mazeAndAlgorithmListViewController];
	
	[self.navigationController presentViewController:mazeAndAlgorithmListNavController animated:YES completion:nil];
}

#pragma mark - Maze and Algorithm List Delegate

- (void)didSelectMazeAtIndex:(NSUInteger)selectedMazeIndex algorithmIndex:(NSUInteger)selectedAlgorithmIndex costFunctionIndex:(NSUInteger)selectedCostFunctionIndex {
	// update the selected maze index
	_selectedMazeIndex = selectedMazeIndex;
	
	// update the selected algorithm index
	_selectedAlgorithmIndex = selectedAlgorithmIndex;
	
	// update the selected cost function index
	_selectedCostFunctionIndex = selectedCostFunctionIndex;
	
	dispatch_async(dispatch_get_main_queue(), ^{
		[self.mazeView.pathCostLabel setText:[NSString stringWithFormat:@"%@", PATH_COST_LABEL_TEXT]];
		[self.mazeView.numberOfNodesExpandedLabel setText:[NSString stringWithFormat:@"%@", NUMBER_OF_NODES_EXPANDED_TEXT]];
		[self.mazeView.maximumTreeDepthSearchedLabel setText:[NSString stringWithFormat:@"%@", MAXIMUM_TREE_DEPTH_SEARCHED_TEXT]];
		[self.mazeView.maximumFrontierSizeLabel setText:[NSString stringWithFormat:@"%@", MAXIMUM_FRONTIER_SIZE_TEXT]];
		
		[self.mazeView reloadData];
	});
}

#pragma mark - Parsed Maze Notification

- (void)parsedMazeNotification:(NSNotification *)notification {
	_selectedMazeIndex = [[notification.userInfo objectForKey:@"selectedMazeIndex"] integerValue];
	
	[self reloadMazeViewData];
}

- (void)reloadMazeViewData {
	dispatch_async(dispatch_get_main_queue(), ^{
		[_mazeView reloadData];
	});
}

#pragma mark - Maze View Delegate

- (CGFloat)verticalMarginForBoardHeight:(CGFloat)boardHeight {
	CGFloat navBarHeight = self.navigationController.navigationBar.bounds.size.height;
	CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
	
	CGFloat verticalPadding = (self.view.bounds.size.height - boardHeight - statusBarHeight - navBarHeight)/2;
	
	return verticalPadding + navBarHeight + statusBarHeight;
}

- (CGFloat)verticalMarginForTopMostLabel {
	CGFloat navBarHeight = self.navigationController.navigationBar.bounds.size.height;
	CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
	
	return navBarHeight + statusBarHeight;
}

- (CGFloat)horizontalMarginForBoardWidth:(CGFloat)boardWidth {
	return (self.view.bounds.size.width - boardWidth)/2;
}

- (CGFloat)height {
	return self.view.bounds.size.height - self.navigationController.navigationBar.bounds.size.height;
}

- (CGFloat)width {
	return self.view.bounds.size.width;
}

- (NSUInteger)numberOfRows {
	Maze *maze = [[MazeManager sharedMazeManager] mazeAtIndex:_selectedMazeIndex];
	
	NSUInteger numberOfRows = 0;
	
	if (maze) {
		numberOfRows = maze.height.integerValue;
	}
	
	return numberOfRows;
}

- (NSUInteger)numberOfCols {
	Maze *maze = [[MazeManager sharedMazeManager] mazeAtIndex:_selectedMazeIndex];
	
	NSUInteger numberOfCols = 0;
	
	if (maze) {
		numberOfCols = maze.width.integerValue;
	}
	
	return numberOfCols;
}

- (NSUInteger)stateForRow:(NSUInteger)row col:(NSUInteger)col {
	Maze *maze = [[MazeManager sharedMazeManager] mazeAtIndex:_selectedMazeIndex];
	
	NSUInteger state = 0;
	
	if (maze) {
		// row major order offset
		// offset = row*NUMCOLS + column
		NSUInteger numCols = maze.width.integerValue;
		NSUInteger offset = row*numCols + col;
		
		Cell *cell = maze.cells[offset];
		
		state = cell.state;
	}
	
	return state;
}

- (BOOL)isVisitedForRow:(NSUInteger)row col:(NSUInteger)col {
	BOOL isVisited = NO;
	
	Maze *maze = [[MazeManager sharedMazeManager] mazeAtIndex:_selectedMazeIndex];
	
	if (maze) {
		// row major order offset
		// offset = row*NUMCOLS + column
		NSUInteger numCols = maze.width.integerValue;
		NSUInteger offset = row*numCols + col;
		
		Cell *cell = maze.cells[offset];
		
		isVisited = cell.visited;
	}
	
	return isVisited;
}

- (BOOL)isOnSolutionPathForRow:(NSUInteger)row col:(NSUInteger)col {
	BOOL isOnSolutionPath = NO;
	
	Maze *maze = [[MazeManager sharedMazeManager] mazeAtIndex:_selectedMazeIndex];
	
	if (maze) {
		// row major order offset
		// offset = row*NUMCOLS + column
		NSUInteger numCols = maze.width.integerValue;
		NSUInteger offset = row*numCols + col;
		
		Cell *cell = maze.cells[offset];
		
		isOnSolutionPath = cell.isOnSolutionPath;
	}
	
	return isOnSolutionPath;
}

#pragma mark - Statistics



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
