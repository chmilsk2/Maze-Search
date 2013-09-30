//
//  CostFunctions.m
//  CS-440-Maze-Search
//
//  Created by Troy Chmieleski on 9/28/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import "CostFunctions.h"
#import "costFunctionNames.h"
#import "SupportedAlgorithmNames.h"

@implementation CostFunctions

static CGFloat(^ManhattanDistance)(CGPoint point1, CGPoint point2) = ^CGFloat(CGPoint point1, CGPoint point2) {
	CGFloat manhattanDistance = fabs(point1.x - point2.x) + fabs(point1.y - point2.y);
	return manhattanDistance;
};

+ (NSArray *)costFunctionNamesForAlgorithmName:(NSString *)algorithmName {
	NSArray *costFunctionNames;
	
	if ([algorithmName isEqualToString:DEPTH_FIRST_SEARCH] || [algorithmName isEqualToString:BREADTH_FIRST_SEARCH]) {
		costFunctionNames = @[NONE];
	}
	
	else if ([algorithmName isEqualToString:UNIFORM_COST_SEARCH]) {
		costFunctionNames = @[C1_COST_FUNCTION_NAME, C2_COST_FUNCTION_NAME];
	}
	
	else if ([algorithmName isEqualToString:GREEDY_BEST_FIRST_SEARCH]) {
		costFunctionNames = @[GREEDY_MANHATTAN_COST_FUNCTION_NAME];
	}
	
	else if ([algorithmName isEqualToString:A_STAR_SEARCH]) {
		costFunctionNames = @[A_STAR_MANAHTTAN_PLUS_UNIFORM_STEP_COST_FUNCTION_NAME];
	}
	
	return costFunctionNames;
}

+ (NSString *)costFunctionNameForAlgorithmName:(NSString *)algorithmName atIndex:(NSUInteger)index {	
	NSArray *costFunctionNames = [self costFunctionNamesForAlgorithmName:algorithmName];
	
	return costFunctionNames[index];
}

+ (CostFunctionBlock)costFunctionForName:(NSString *)costFunctionName {
	
	CostFunctionBlock costFunctionBlock;
	if ([costFunctionName isEqualToString:NONE]) {
		costFunctionBlock = nil;
	}
	
	else if ([costFunctionName isEqualToString:C1_COST_FUNCTION_NAME]) {
		costFunctionBlock = [^(CGPoint point1, CGPoint point2, CGFloat costIncurred) {
			CGFloat c1 = (1/(powf(2, point1.x)));
			return c1;
		} copy];
	}
	
	else if ([costFunctionName isEqualToString:C2_COST_FUNCTION_NAME]) {
		costFunctionBlock = [^(CGPoint point1, CGPoint point2, CGFloat costIncurred){
			CGFloat c2 = powf(2, point1.x);
			return c2;
		} copy];
	}
	
	else if ([costFunctionName isEqualToString:GREEDY_MANHATTAN_COST_FUNCTION_NAME]) {
		costFunctionBlock = [^(CGPoint point1, CGPoint point2, CGFloat costIncurred) {
			CGFloat manhattantDistance = ManhattanDistance(point1, point2);
			return manhattantDistance;
		} copy];
	}
	
	else if ([costFunctionName isEqualToString:A_STAR_MANAHTTAN_PLUS_UNIFORM_STEP_COST_FUNCTION_NAME]) {
		costFunctionBlock = [^(CGPoint point1, CGPoint point2, CGFloat costIncurred) {
			CGFloat aStarManhattanPlusUniformStepCost = costIncurred + ManhattanDistance(point1, point2);
			return aStarManhattanPlusUniformStepCost;
		} copy];
	}
	
	return costFunctionBlock;
}

@end
