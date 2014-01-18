//
//  NSMutableArray+Shuffle.m
//  klaverjas
//
//  Created by Wolfgang Schreurs on 5/4/12.
//  Copyright (c) 2012 Sound of Data. All rights reserved.
//

#import "NSMutableArray+Shuffle.h"


@implementation NSMutableArray (Shuffle)

- (void)shuffle
{
    for (int i = self.count; i > 0; i--)
    {
        int j = arc4random() % i;
        [self exchangeObjectAtIndex:j withObjectAtIndex:(i - 1)];
    }
}

@end
