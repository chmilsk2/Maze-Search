//
//  BasicPathfindingViewController.m
//  CS-440-Maze-Search
//
//  Created by Troy Chmieleski on 9/23/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import "BasicPathfindingViewController.h"
#import "MazeManager.h"
#import "MazeAndAlgorithmListViewController.h"
#import "Maze.h"
#import "MazeView.h"
#import "Solver.h"
#import "SearchAlgorithmOperationFactory.h"
#import "SupportedAlgorithms.h"
#import "SearchAlgorithmOperation.h"

#define PARSED_MAZE_NOTIFICATON @"Parsed Maze Notification"

@interface BasicPathfindingViewController ()

@property (nonatomic, strong) MazeView *mazeView;
@property (nonatomic, strong) UIBarButtonItem *mazeAndAlgorithmListButton;
@property (nonatomic, strong) UIBarButtonItem *startButton;

@end

@implementation BasicPathfindingViewController {
	NSUInteger _selectedMazeIndex;
	NSUInteger _selectedAlgorithmIndex;
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
	
	SearchAlgorithmOperationFactory *searchAlgorithmOperationFactory = [SearchAlgorithmOperationFactory searchAlgorithmOperationFactory];
	
	NSString *algorithmOperationName = AlgorithmNameAtIndex(_selectedAlgorithmIndex);
	
	SearchAlgorithmOperation *algorithmOperation = [searchAlgorithmOperationFactory searchAlgorithmOperationForName:algorithmOperationName];
	
	[solver solveWithMaze:[[MazeManager sharedMazeManager] mazeAtIndex:_selectedMazeIndex] algorithmOperation:algorithmOperation];
}

#pragma mark- Solver Delegate

- (void)tookStep {
	[self reloadMazeViewData];
}

#pragma mark - Maze and Algorithm List

- (void)presentMazeAndAlgorithmList {
	MazeAndAlgorithmListViewController *mazeAndAlgorithmListViewController = [[MazeAndAlgorithmListViewController alloc] initWithStyle:UITableViewStylePlain];
	[mazeAndAlgorithmListViewController setDelegate:self];
	
	UINavigationController *mazeAndAlgorithmListNavController = [[UINavigationController alloc] initWithRootViewController:mazeAndAlgorithmListViewController];
	
	[self.navigationController presentViewController:mazeAndAlgorithmListNavController animated:YES completion:nil];
}

#pragma mark - Maze and Algorithm List Delegate

- (void)didSelectMazeAtIndex:(NSUInteger)selectedMazeIndex algorithmIndex:(NSUInteger)selectedAlgorithmIndex {
	// update the selected maze index
	_selectedMazeIndex = selectedMazeIndex;
	
	// update the selected algorithm index
	_selectedAlgorithmIndex = selectedAlgorithmIndex;
	
	[self reloadMazeViewData];
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
	CGFloat tabBarHeight = self.tabBarController.tabBar.bounds.size.height;
	CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
	
	CGFloat verticalPadding = (self.view.bounds.size.height - boardHeight - statusBarHeight - tabBarHeight - navBarHeight)/2;
	
	return verticalPadding + navBarHeight + statusBarHeight;
}

- (CGFloat)horizontalMarginForBoardWidth:(CGFloat)boardWidth {
	return (self.view.bounds.size.width - boardWidth)/2;
}

- (CGFloat)height {
	return self.view.bounds.size.height - self.tabBarController.tabBar.bounds.size.height - self.navigationController.navigationBar.bounds.size.height;
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
		
		state = [maze.cells[offset] integerValue];
	}
	
	return state;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
