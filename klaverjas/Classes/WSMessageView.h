//
//  WSMessageView.h
//  klaverjas
//
//  Created by Wolfgang Schreurs on 6/15/12.
//  Copyright (c) 2012 Wolfgang Schreurs. All rights reserved.
//

#import <UIKit/UIKit.h>


/* 
 TODO:
 
 This class could be improved by adding a message queue. This way a new animation 
 can start when the previous is finished. Currently animations can "override" each 
 other, resulting in a jerky transition.
 */


@interface WSMessageView : UIView

- (void)setMessage:(NSString *)string;

@end
