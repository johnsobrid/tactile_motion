//
//  audioObjectView.h
//  tactile.motion
//
//  Created by Bridget Johnson on 5/02/14.
//  Copyright (c) 2014 bdj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface audioObjectView : UIView
- (id)initWithFrame:(CGRect)frame
             colour:(UIColor*)col
              label:(NSString*)str;

@property (strong) UIColor *colour;
@property (strong) NSString *label;
//making a change to test
//and another
@end
