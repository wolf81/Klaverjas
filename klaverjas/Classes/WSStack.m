//
//  WSStack.m
//  klaverjas
//
//  Created by Wolfgang Schreurs on 5/4/12.
//  Copyright (c) 2012 Wolfgang Schreurs. All rights reserved.
//

#import "WSStack.h"


@interface WSStack ()

@property (nonatomic, copy) NSMutableArray *items;

@end


@implementation WSStack

@synthesize items = _items;

- (id)init
{
    self = [super init];
    if (self)
    {
        self.items = [NSMutableArray array];    
    }
    return self;
}

+ (WSStack *)stackWithItems:(NSMutableArray *)items
{
    WSStack *stack = [[WSStack alloc] init];
    if (stack)
    {
        stack.items = items;
    }
    return stack;
}

+ (WSStack *)stack
{
    WSStack *stack = [[WSStack alloc] init];
    if (stack)
    {
        
    }
    return stack;
}

#pragma mark - Public instance methods

- (void)push:(id)item
{
    [_items addObject:item];
}

- (id)pop
{
    id item = [_items lastObject];
    if (item)
    {
        [_items removeLastObject];
    }
    return item;
}

#pragma mark - Properties

- (void)setItems:(NSMutableArray *)items
{
    if (_items == items)
    {
        return;
    }
    
    _items = [items mutableCopy];
}

@end
