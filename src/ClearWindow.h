//
//  ClearWindow.h
//  minu
//
//  Created by bebe on 08/05/25.
//  Copyright 2008 bebekoubou. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface ClearWindow : NSWindow {
    IBOutlet id preferenceWindow;
    NSPoint mouseDownLoc;
	NSDictionary* activeApp;
}
- (void)storeActiveApp;
- (void)restoreActiveApp;
- (float)windowTransparency;
- (void)show;
- (void)hide_;

@end
