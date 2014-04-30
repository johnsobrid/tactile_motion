//
//  audioObjectView.h
//  tactile.motion
//
//  Created by Bridget Johnson on 5/02/14.
//  Copyright (c) 2014 bdj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "controlAreaView.h"

@interface audioObjectView : UIView
- (id)initWithFrame:(CGRect)frame
             colour:(UIColor*)col
              label:(NSString*)str;

@property (strong) UIColor *colour;
@property (strong) NSString *label;
@property CGPoint myCenter;
@property CGPoint startPoint;
@property CGPoint endPoint;

@property CGPoint dragVelocity;
@property BOOL motion;
-(void) dragging:(UIPanGestureRecognizer *)drag;
-(void) doubleTapOccured:(UITapGestureRecognizer *)doubleTap;
-(void) spin;


@property CGFloat currentAngle;
@property CGFloat currentD;


@end
