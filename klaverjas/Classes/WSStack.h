//
//  WSStack.h
//  klaverjas
//
//  Created by Wolfgang Schreurs on 5/4/12.
//  Copyright (c) 2012 Wolfgang Schreurs. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface WSStack : NSObject

+ (WSStack *)stack;
+ (WSStack *)stackWithItems:(NSMutableArray *)items;

- (void)push:(id)item;
- (id)pop;

@property (nonatomic, copy, readonly) NSMutableArray *items;

@end
