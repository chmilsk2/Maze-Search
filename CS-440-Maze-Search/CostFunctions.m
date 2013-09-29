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

+ (NSArray *)costFunctionNamesForAlgorithmName:(NSString *)algorithmName {
	NSArray *costFunctionNames;
	
	if ([algorithmName isEqualToString:DEPTH_FIRST_SEARCH] || [algorithmName isEqualToString:BREADTH_FIRST_SEARCH]) {
		costFunctionNames = @[C1_COST_FUNCTION_NAME, C2_COST_FUNCTION_NAME];
	}
	
	else if ([algorithmName isEqualToString:GREEDY_BEST_FIRST_SEARCH] || [algorithmName isEqualToString:A_STAR_SEARCH]) {
		costFunctionNames = @[MANHATTAN_DISTANCE_COST_FUNCTION_NAME, C1_COST_FUNCTION_NAME, C2_COST_FUNCTION_NAME];
	}
	
	return costFunctionNames;
}

+ (NSString *)costFunctionNameForAlgorithmName:(NSString *)algorithmName atIndex:(NSUInteger)index {
	NSArray *costFunctionNames = [self costFunctionNamesForAlgorithmName:algorithmName];
	
	return costFunctionNames[index];
}

+ (CostFunctionBlock)costFunctionForName:(NSString *)costFunctionName {
	CostFunctionBlock costFunctionBlock;
	
	if ([costFunctionName isEqualToString:MANHATTAN_DISTANCE_COST_FUNCTION_NAME]) {
		costFunctionBlock = [^(CGPoint point1, CGPoint point2) {
			return fabs(point1.x - point2.x) + fabs(point1.y - point2.y);
		} copy];
	}
	
	else if ([costFunctionName isEqualToString:C1_COST_FUNCTION_NAME]) {
		costFunctionBlock = [^(CGPoint point) {
			return (1/(powf(2, point.x)));
		} copy];
	}
	
	else if ([costFunctionName isEqualToString:C2_COST_FUNCTION_NAME]) {
		costFunctionBlock = [^(CGPoint point){
			return powf(2, point.x);
		} copy];
	}
	
	return costFunctionBlock;
}

@end
