//
//  NSArray+RandomObject.m
//  klaverjas
//
//  Created by Wolfgang Schreurs on 5/5/12.
//  Copyright (c) 2012 Sound of Data. All rights reserved.
//

#import "NSArray+RandomObject.h"


@implementation NSArray (RandomObject)

- (id)randomObject
{
    if (self.count > 0)
    {
        int i = arc4random() % self.count;
        return [self objectAtIndex:i];
    }
    else
    {
        return nil;
    }
}

@end
