//
//  AppController.h
//  minu
//
//  Created by bebe on 08/06/05.
//  Copyright 2008 bebekubou. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface AppController : NSObject {
    IBOutlet id window;
    IBOutlet id preferenceWindow;
}

+ (void)setupDefaults;
//- (void)runTestAlertPanel;

@end
