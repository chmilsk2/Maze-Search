//
//  SearchAlgorithmOperationFactory.h
//  CS-440-Maze-Search
//
//  Created by Troy Chmieleski on 9/25/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SearchAlgorithmOperation;

@interface SearchAlgorithmOperationFactory : NSObject

+ (SearchAlgorithmOperationFactory *)searchAlgorithmOperationFactory;
- (SearchAlgorithmOperation *)searchAlgorithmOperationForName:(NSString *)name costFunctionName:(NSString *)costFunctionName;

@end
