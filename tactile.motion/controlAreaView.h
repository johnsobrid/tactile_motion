//
//  controlAreaView.h
//  tactile.motion
//
//  Created by Bridget Johnson on 4/02/14.
//  Copyright (c) 2014 bdj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "playAreaView.h"


#define SPEAKER_SIZE 40

@interface controlAreaView : UIView
@property int maxDistance;
@property int kNumofSpeakers;
@property playAreaView * playView;


@end
