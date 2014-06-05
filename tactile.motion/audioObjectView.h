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

@property CGRect ObjectFrame;

- (id)initWithFrame:(CGRect)frame
             colour:(UIColor*)col
              label:(NSString*)str;

@property (strong) UIColor *colour;
@property (strong) NSString *label;
@property CGPoint myCenter;
@property CGPoint startPoint;
@property CGPoint endPoint;

@property int animator;
@property float angularVelocity;
@property float globalSpeed;
@property int cavWidth;
@property int  cavHeight;
@property bool needsMessage;
@property CGPoint homePosition;
@property int myIndex;

@property CGPoint dragVelocity;

@property int numOfObjects;

@property (nonatomic) float theta, d, x, y;

@property BOOL motion;
-(void) dragging:(UIPanGestureRecognizer *)drag;
-(void) doubleTapOccured:(UITapGestureRecognizer *)doubleTap;
-(void)animateWithDT:(float)dt;
-(void) beginSpinWithAngularVelocity:(float)f;
-(void) beginVertDrag:(float)f;
-(void)beginHoroDrag:(float)f;

-(void)goHome;
- (void)setHome;






@end
