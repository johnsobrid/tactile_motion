//
//  phantomView.h
//  tactile.motion
//
//  Created by Timothy J on 9/05/14.
//  Copyright (c) 2014 bdj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface phantomView : UIView

- (id)initWithFrame:(CGRect)frame
             colour:(UIColor*)col
              label:(NSString*)str;

-(void) singleTapOccured:(UIPanGestureRecognizer *)singleTap;
-(void) doubleTapOccured:(UITapGestureRecognizer *)doubleTap;

@property (strong) UIColor *colour;
@property (strong) NSString *label;

@property bool doubletapflag;
@property bool singletapflag;
@property int myIndex;

@end