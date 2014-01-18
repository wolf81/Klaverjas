//
//  WSDialogView.h
//  klaverjas
//
//  Created by Wolfgang Schreurs on 6/12/12.
//  Copyright (c) 2012 Sound of Data. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WSDialogView.h"


@interface WSChooseTrumpsView : WSDialogView

+ (WSChooseTrumpsView *)chooseTrumpsViewWithImage:(UIImage *)image completionHandler:(void (^)(BOOL))completionHandler;

@end
