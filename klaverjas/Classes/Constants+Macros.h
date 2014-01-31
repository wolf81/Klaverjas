//
//  Constants+Macros.h
//  klaverjas
//
//  Created by Wolfgang Schreurs on 6/12/12.
//  Copyright (c) 2012 Wolfgang Schreurs. All rights reserved.
//

#ifndef klaverjas_Constants_Macros_h
#define klaverjas_Constants_Macros_h


#ifdef DEBUG
#   define DLog(fmt, ...) NSLog(@"%s: " fmt, __PRETTY_FUNCTION__, ##__VA_ARGS__)
#else
#   define DLog(...)
#endif


#define FONT_BIG    [UIFont fontWithName:@"Noteworthy-Bold" size:17.0f]
#define FONT_NORMAL [UIFont fontWithName:@"Noteworthy-Bold" size:15.0f]
#define FONT_SMALL  [UIFont fontWithName:@"Noteworthy-Bold" size:12.0f]


#define CPU_MINIMUM_ACCEPTED_HAND_VALUE   56


#endif
