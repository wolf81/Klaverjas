//
//  WSDeck.h
//  klaverjas
//
//  Created by Wolfgang Schreurs on 5/3/12.
//  Copyright (c) 2012 Wolfgang Schreurs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WSCard.h"


@interface WSDeck : NSObject

+ (WSDeck *)deck;

- (void)shuffle;
- (WSCard *)dealCard;

@property (nonatomic, assign, readonly) NSInteger size;

@end
