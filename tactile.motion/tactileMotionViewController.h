//
//  tactileMotionViewController.h
//  tactile.motion
//
//  Created by Bridget Johnson on 4/02/14.
//  Copyright (c) 2014 bdj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "controlAreaView.h"

@interface tactileMotionViewController : UIViewController {
    IBOutlet UITextField *statusField;
    IBOutlet controlAreaView *controlArea;
}
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context;
@property (strong) NSMutableArray *audioObjects;
@end
