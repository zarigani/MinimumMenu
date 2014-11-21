//
//  EventView.m
//  minu
//
//  Created by bebe on 08/05/25.
//  Copyright 2008 bebekoubou. All rights reserved.
//

#import "ClearWindow.h"
#import "EventView.h"


@implementation EventView

static float TRACKING_HEIGHT = 1;
static float LINE_WIDTH = 1;

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)awakeFromNib {
    [self addTrackingRects];
    
    // バインディングの確立（EventViewのallAroundTrackingAreaと、NSUserDefaultsControllerのvalues辞書のキーallAroundTrackingAreaを関連付け）
    [self bind:@"allAroundTrackingArea"
      toObject:[NSUserDefaultsController sharedUserDefaultsController]
   withKeyPath:@"values.allAroundTrackingArea"
       options:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES]
                                           forKey:@"NSContinuouslyUpdatesValue"]];
}

- (void)addTrackingRects {
    [self removeTrackingRects];
    //自分の高さに合わせてウィンドウ上限に再配置する
    //[self setFrame:[[self window] frame]]; //IBのAutosizingで自動サイズ調整で設定
    //マウスの出入りmouseEntered、mouseExitedを監視する範囲をスクリーントップの1pxに設定
    NSRect	bounds = [self bounds];
    NSRect  rect;
    //addTrackingRect...はinitの中で設定しても無効、awakeFromNibの中で設定する必要あり
    rect = NSMakeRect(bounds.origin.x, 
                      bounds.size.height - TRACKING_HEIGHT, 
                      bounds.size.width, 
                      TRACKING_HEIGHT);
    trackingTop     = [self addTrackingRect:rect owner:[self window] userData:nil assumeInside:NO];
    
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"allAroundTrackingArea"]) {
        rect = NSMakeRect(bounds.origin.x, 
                          bounds.origin.y, 
                          bounds.size.width, 
                          TRACKING_HEIGHT);
        trackingBottom  = [self addTrackingRect:rect owner:[self window] userData:nil assumeInside:NO];
        
        rect = NSMakeRect(bounds.origin.x, 
                          bounds.origin.y, 
                          TRACKING_HEIGHT, 
                          bounds.size.height);
        trackingLeft    = [self addTrackingRect:rect owner:[self window] userData:nil assumeInside:NO];
        
        rect = NSMakeRect(bounds.size.width - TRACKING_HEIGHT, 
                          bounds.origin.y, 
                          TRACKING_HEIGHT, 
                          bounds.size.height);
        trackingRight   = [self addTrackingRect:rect owner:[self window] userData:nil assumeInside:NO];
    }
    
    ////NSLog(@"%@", NSStringFromRect(rect)); //{{0, 799}, {1280, 1}}
    ////NSLog(@"%d, %d, %d, %d", trackingTop, trackingBottom, trackingLeft, trackingRight);
}

- (void)removeTrackingRects {
    [self removeTrackingRect:trackingTop];
    [self removeTrackingRect:trackingBottom];
    [self removeTrackingRect:trackingLeft];
    [self removeTrackingRect:trackingRight];
}


// canBecomeKeyWindowがYESの場合
//   アクティブになる前の最初のマウスイベントを許可するかどうか
//     NO : アプリケーションをアクティブにするだけで、mouseDownイベントは発生しない
//     YES: アプリケーションがアクティブになり、mouseDownイベントも発生する
// canBecomeKeyWindowがNOの場合はacceptsFirstMouseが返す値に影響されず、常にYESの状態になる
- (BOOL)acceptsFirstMouse:(NSEvent *)event {
    return NO;
}

/*
- (BOOL)acceptsFirstResponder {
    NSLog(@"Accepting");
    return YES;
}

- (BOOL)becomeFirstResponder {
    BOOL okToChange = [super becomeFirstResponder];
    if (okToChange) {
		NSLog(@"Becoming");
		[super setKeyboardFocusRingNeedsDisplayInRect: [self bounds]];
	}
    return okToChange;
}
 
- (BOOL)resignFirstResponder {
    BOOL okToChange = [super resignFirstResponder];
    if (okToChange) {
		NSLog(@"Resigning");
		[super setKeyboardFocusRingNeedsDisplayInRect: [self bounds]];
	}
    return okToChange;
}
*/

- (void)drawRect:(NSRect)rect {
    /*
    //影を付けてぼかす
    NSShadow *shadow = [[[NSShadow alloc] init] autorelease];
    [shadow setShadowColor:[NSColor keyboardFocusIndicatorColor]];
    [shadow setShadowOffset:NSMakeSize(0, -1)];
    [shadow setShadowBlurRadius:2];
    [shadow set];
    */

	/*
	//ベジェ曲線で一番上に水平ラインを描画
    NSRect frame = [self frame];
	NSPoint point0 = NSMakePoint(frame.origin.x, NSHeight(frame));
	NSPoint point1 = NSMakePoint(NSWidth(frame), NSHeight(frame));
	//[[[NSColor blackColor] colorWithAlphaComponent:1.0] set];
	[[NSColor keyboardFocusIndicatorColor] set];
	[NSBezierPath setDefaultLineWidth:2];
    [NSBezierPath strokeLineFromPoint:point0 toPoint:point1];
    */

    //グラフィック関数で一番上に水平ラインを描画
    //[[NSColor blueColor] set];
	//[[[NSColor blackColor] colorWithAlphaComponent:1.0] set];
    [[[NSColor keyboardFocusIndicatorColor] colorWithAlphaComponent:1.0] set];
    NSSetFocusRingStyle(NSFocusRingOnly);//このあと描画した図形の周囲にフォーカスリングが表示される
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"allAroundTrackingArea"]) {
        NSFrameRect([self bounds]);
    }else {
        NSRectFill(NSMakeRect([self bounds].origin.x, 
                              [self bounds].size.height - LINE_WIDTH, 
                              [self bounds].size.width, 
                              LINE_WIDTH));
    }
    
    //フォーカスリングを描画する
	//[self setFocusRingType:NSFocusRingTypeExterior];
	//[NSGraphicsContext saveGraphicsState];
	//NSSetFocusRingStyle(NSFocusRingOnly);
	//NSRectFill([self bounds]);
	//NSRectFill(NSMakeRect(100,5,200,10));
	//NSFrameRect(NSMakeRect(100,5,200,10));
	//NSFrameRect(NSMakeRect(500,5,200,10));
	//[NSGraphicsContext restoreGraphicsState];

	//NSLog(@"defaultLineWidth: %f", [NSBezierPath defaultLineWidth]);
	//NSLog(@"LineWidth: %f", [[NSBezierPath bezierPath] lineWidth]);
    //([[NSUserDefaults standardUserDefaults] boolForKey:@"allAroundTrackingArea"])? NSLog(@"YES") : NSLog(@"NO");
}

- (void)setAllAroundTrackingArea:(bool)flag {
    allAroundTrackingArea = flag;
    [self addTrackingRects];
    [self setNeedsDisplay:YES];
}

/*
- (void)mouseEntered:(NSEvent *)event {
	[[self window] setAlphaValue:0.8];
}

- (void)mouseExited:(NSEvent *)event {
	[[self window] setAlphaValue:0.0];
}

- (void)mouseDown:(NSEvent *)event {
	[[self window] mouseDown:event];
}
*/

@end
