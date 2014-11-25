//
//  ClearWindow.m
//  minu
//
//  Created by bebe on 08/05/25.
//  Copyright 2008 bebekoubou. All rights reserved.
//

#import "ClearWindow.h"
#import "EventView.h"


@implementation ClearWindow

static NSString*	APP_BUNDLE_ID = @"com.bebekoubou.minu";

// メインスクリーン（メニューバーのあるスクリーン）と同じサイズの透明ウィンドウを初期化して生成
- (id)initWithContentRect:(NSRect)contentRect styleMask:(NSUInteger)aStyle backing:(NSBackingStoreType)bufferingType defer:(BOOL)flag
{
    //ウィンドウの初期化（NSBorderlessWindowMaskによってメニューバーを超えた移動が可能になる）
    id win = [super initWithContentRect:[[NSScreen mainScreen] frame] styleMask:NSBorderlessWindowMask backing:bufferingType defer:flag];
    
    //ウィンドウが描画される上下レベル（レイヤーレベル）を設定（メニューバーよりも上のレベルに）
    [win setLevel: NSPopUpMenuWindowLevel];
    
    //ウィンドウの背景色を透明色に設定
    [win setBackgroundColor: [NSColor clearColor]];
    
    //ウィンドウの透明度を設定（不透明1.0〜透明0.0）
    //[win setAlphaValue:0.0];
    
    //ウィンドウは不透明でない（つまり、透明である）
    [win setOpaque:NO];
    
    //ウィンドウの影を表示しない
    [win setHasShadow: NO];
    
    //ウィンドウをすべてのSpaceで表示する（Spaces対応のため）
    [win setCanBeVisibleOnAllSpaces: YES];
	
    return win;
}

- (void)awakeFromNib {
	activeApp = nil;
//	[[self contentView] addTrackingRect:[[self contentView] bounds] 
//								 owner:self 
//							  userData:nil 
//						  assumeInside:NO];

    // バインディングの確立（WindowのalphaVlueと、NSUserDefaultsControllerのvalues辞書のキーwindowTransparencyを関連付け）
    [self bind:@"alphaValue"
      toObject:[NSUserDefaultsController sharedUserDefaultsController]
   withKeyPath:@"values.windowTransparency"
       options:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES]
                                           forKey:@"NSContinuouslyUpdatesValue"]];
    [self hide_];
}

// canBecomeKeyWindowメソッドがYESを返すようにオーバーライドすることで、キーウィンドウ（キー入力を最優先に受け付けるウィンドウ）になれる
// mouseDownイベントについて
//   - YESを返すと、キーウィンドウになるまではmouseDownイベントが発生しない
//    （アプリケーションがアクティブでない時のクリックでは、mouseDownイベントが発生しない）
//   - NOを返すと、常にmouseDownイベントが発生する
//    （アプリケーションがアクティブでない時のクリックでも、mouseDownイベントが発生する）
- (BOOL) canBecomeKeyWindow {
    return YES;
}

// 直前にアクティブだったアプリケーションを保存する
- (void)storeActiveApp {
    ////NSLog(@"storeActiveApp");
    NSDictionary* currentApp = [[NSWorkspace sharedWorkspace] activeApplication];
    //@"NSApplicationName"では日本語ローカライズされたアプリケーション名ではlaunchApplication出来ない（例: Stickies、スティッキーズ）
    //NSString* appName = [activeApp valueForKey:@"NSApplicationName"];
    NSString* currentAppBundleID = [currentApp valueForKey:@"NSApplicationBundleIdentifier"];
    ////NSLog([currentAppBundleID description]);
    if (![currentAppBundleID isEqualToString:APP_BUNDLE_ID]) {
        [currentApp retain];
        if (activeApp) {
            [activeApp release];
        }
        activeApp = currentApp;
    }
}

// 直前にアクティブだったアプリケーションに戻す
- (void)restoreActiveApp {
    ////NSLog(@"restoreActiveApp");
    if (activeApp) {
        //@"NSApplicationName"では日本語ローカライズされたアプリケーション名ではlaunchApplication出来ない（例: Stickies、スティッキーズ）
        //NSString* appName = [activeApp valueForKey:@"NSApplicationName"];
        //[[NSWorkspace sharedWorkspace] launchApplication:appName];
        NSString* currentAppBundleID = [activeApp valueForKey:@"NSApplicationBundleIdentifier"];
        NSArray* runningApplications = [NSRunningApplication runningApplicationsWithBundleIdentifier:currentAppBundleID];
        if ([runningApplications count] > 0) {
            [runningApplications[0] activateWithOptions:NSApplicationActivateIgnoringOtherApps];
        }
    }
}

- (float)windowTransparency {
    NSUserDefaultsController *userDefaultsController = [NSUserDefaultsController sharedUserDefaultsController];
    return [[[userDefaultsController values] valueForKey:@"windowTransparency"] floatValue];
    //NSUserDefaults *userDefaults = [userDefaultsController defaults];
    //return [userDefaults floatForKey:@"windowTransparency"];
}

- (void)show {
    ////NSLog(@"show");
    [self setAlphaValue:[self windowTransparency]];
}

- (void)hide_ {
    ////NSLog(@"hide_");
    if ([preferenceWindow isKeyWindow] == NO) {
        [self setAlphaValue:0.0];
    }
}

- (void)mouseEntered:(NSEvent *)event {
    ////NSLog(@"mouseEntered");
    [self show];
    [self storeActiveApp];
    ////NSLog([NSRunningApplication currentApplication].bundleIdentifier);
    ////NSLog([currentApp valueForKey:@"NSApplicationBundleIdentifier"]);
    ////NSLog(NSStringFromPoint([NSEvent mouseLocation]));
    if (CGEventGetLocation(CGEventCreate(nil)).y > 22.0) {
        [[NSRunningApplication currentApplication] activateWithOptions:NSApplicationActivateIgnoringOtherApps];
    }
}

- (void)mouseExited:(NSEvent *)event {
    ////NSLog(@"mouseExited");
    [self hide_];
    ////NSLog([NSString stringWithFormat:@"%f", CGEventGetLocation(CGEventCreate(nil)).y]);
    if (CGEventGetLocation(CGEventCreate(nil)).y > 22.0) {
        [self restoreActiveApp];
    }
}

// 左マウスボタンを押した
- (void)mouseDown:(NSEvent *)event {
    ////NSLog(@"mouseDown: %d", [event clickCount]);
//	mouseDownLoc = [event locationInWindow];//クリックした位置
    [self restoreActiveApp];
    [self hide_];
}

// 左マウスボタンでドラッグ
//- (void)mouseDragged:(NSEvent *)event {
//	NSPoint mouseDragLoc = [event locationInWindow];
//	NSRect  winFrame       = [self frame];
//	NSPoint newOrigin;
//	newOrigin.x = winFrame.origin.x + mouseDragLoc.x - mouseDownLoc.x;
//	newOrigin.y = winFrame.origin.y + mouseDragLoc.y - mouseDownLoc.y;
//	[ self setFrameOrigin : newOrigin ];
//}

@end
