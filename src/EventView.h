//
//  EventView.h
//  minu
//
//  Created by bebe on 08/05/25.
//  Copyright 2008 bebekoubou. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface EventView : NSView {
    NSTrackingRectTag trackingTop, trackingBottom, trackingLeft, trackingRight;
    bool allAroundTrackingArea;
}

- (void)addTrackingRects;
- (void)removeTrackingRects;
- (void)setAllAroundTrackingArea:(bool)flag;

@end
