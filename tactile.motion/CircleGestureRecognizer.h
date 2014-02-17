//
//  CircleGestureRecognizer.h
//  tactile.motion
//
//  Created by Bridget Johnson on 13/02/14.
//  Copyright (c) 2014 bdj. All rights reserved.
//

//
//  CircleGestureRecognizer.h
//  Circle
//
//  Created by Federico Mestrone on 28/01/2012.
//  Copyright (c) 2012 Moodsdesign Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIGestureRecognizerSubclass.h>

CGFloat distanceBetweenPoints (CGPoint first, CGPoint second);
CGFloat angleBetweenPoints(CGPoint first, CGPoint second);
CGFloat angleBetweenLines(CGPoint line1Start, CGPoint line1End, CGPoint line2Start, CGPoint lin2End);

@class CircleGestureRecognizer;

@protocol CircleGestureFailureDelegate <UIGestureRecognizerDelegate>

- (void) circleGestureFailed:(CircleGestureRecognizer *)gr;

@end

typedef enum CircleGestureError {
   CircleGestureErrorNone,
   CircleGestureErrorNotClosed,
   CircleGestureErrorTooSlow,
   CircleGestureErrorTooShort,
   CircleGestureErrorRadiusVarianceTolerance,
   CircleGestureErrorOverlapTolerance,
} CircleGestureError;

@interface CircleGestureRecognizer : UIGestureRecognizer
{
   NSMutableArray *points_;
   CGPoint firstTouch_;
   NSTimeInterval firstTouchTime_;
}

@property CGFloat circleClosureAngleVariance;
/// Maximum distance allowed between the two end points, in pixels
@property CGFloat circleClosureDistanceVariance;
/// Maximum time allowed to complete a circle, in seconds
@property CGFloat maximumCircleTime;
@property CGFloat radiusVariancePercent;
@property NSInteger overlapTolerance;
/// The minimum number of points that should make up a circle
@property NSInteger minimumNumPoints;

@property (readonly) CGPoint center;
@property (readonly) CGFloat radius;
@property (readonly) NSArray *points;
@property (readonly) CircleGestureError error;

@end
