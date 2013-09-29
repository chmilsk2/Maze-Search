//
//  CostFunctions.h
//  CS-440-Maze-Search
//
//  Created by Troy Chmieleski on 9/28/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CostFunctionBlock.h"

@interface CostFunctions : NSObject

+ (NSArray *)costFunctionNamesForAlgorithmName:(NSString *)algorithmName;
+ (NSString *)costFunctionNameForAlgorithmName:(NSString *)algorithmName atIndex:(NSUInteger)index;
+ (CostFunctionBlock)costFunctionForName:(NSString *)costFunctionName;

@end
