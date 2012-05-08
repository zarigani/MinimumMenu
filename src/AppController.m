//
//  AppController.m
//  minu
//
//  Created by bebe on 08/06/05.
//  Copyright 2008 bebekubou. All rights reserved.
//

#import "AppController.h"
#import "ClearWindow.h"


@implementation AppController

+ (void)initialize {
    [self setupDefaults];
}

+ (void)setupDefaults {
    // Appleのドキュメントでは、1>>、2>>の部分で余分な処理をしているように見えるが、
    // おそらく、特定のキーに限定してデフォルト値に戻すための処理だと思う。
    //    NSString *userDefaultsValuesPath;
    //    NSDictionary *userDefaultsValuesDict;
    //    NSDictionary *initialValuesDict;
    //    NSArray *resettableUserDefaultsKeys;
    //    
    //    // ユーザデフォルトに使用するデフォルト値を読み込む
    //    userDefaultsValuesPath=[[NSBundle mainBundle] pathForResource:@"UserDefaults" 
    //                                                           ofType:@"plist"];
    //    userDefaultsValuesDict=[NSDictionary dictionaryWithContentsOfFile:userDefaultsValuesPath];
    //    
    //    // 読み込んだ値を標準ユーザデフォルトに設定
    //    [[NSUserDefaults standardUserDefaults] registerDefaults:userDefaultsValuesDict];
    //    
    //    // アプリケーションがデフォルト値のサブセットを
    //    // 出荷時の値にリセットする手段をサポートする場合、出荷時の値を 
    //    // 共有ユーザデフォルトコントローラで設定する
    //1>> resettableUserDefaultsKeys=[NSArray arrayWithObjects:@"Value1",@"Value2",@"Value3",nil];
    //2>> initialValuesDict=[userDefaultsValuesDict dictionaryWithValuesForKeys:resettableUserDefaultsKeys];
    //    
    //    // 共有ユーザデフォルトコントローラで初期値を設定
    //    [[NSUserDefaultsController sharedUserDefaultsController] setInitialValues:initialValuesDict];
    
    NSString *userDefaultsValuesPath;
    NSDictionary *userDefaultsValuesDict;
    
    // アプリケーションとしてのデフォルト値を読み込む
    userDefaultsValuesPath = [[NSBundle mainBundle] pathForResource:@"UserDefaults" 
                                                             ofType:@"plist"];
    userDefaultsValuesDict = [NSDictionary dictionaryWithContentsOfFile:userDefaultsValuesPath];
    
    // 読み込んだ値をNSUserDefaultsに設定
    [[NSUserDefaults standardUserDefaults] registerDefaults:userDefaultsValuesDict];
    
    // NSUserDefaultsControllerにも設定
    [[NSUserDefaultsController sharedUserDefaultsController] setInitialValues:userDefaultsValuesDict];
    
    ////([[NSUserDefaultsController sharedUserDefaultsController] appliesImmediately]) ? 
    ////    NSLog(@"appliesImmediately:YES") : NSLog(@"appliesImmediately:NO");
}

- (void)awakeFromNib {
    //コード中の文字列翻訳のためのテスト
    //[self runTestAlertPanel];
}

- (void)applicationDidFinishLaunching:(NSNotification*)notification {
    //NSMenuItemでなく、NSMenuのタイトルを設定する
    //[[[NSApp mainMenu] itemAtIndex:0] setTitle:@""];
    [[[[NSApp mainMenu] itemAtIndex:0] submenu] setTitle:@""];
    
    //アイコンメニューを表示する
    NSImage *minu = [NSImage imageNamed:@"minu"];
    [minu setSize:NSMakeSize(20,20)];
    [[[NSApp mainMenu] itemAtIndex:0] setImage:minu];
}

- (void)applicationShouldHandleReopen:(NSApplication *)application hasVisibleWindows:(BOOL)flag {
    ////NSLog(@"applicationShouldHandleReopen");
    [preferenceWindow makeKeyAndOrderFront:self];
}

- (void)runTestAlertPanel {
    int result = NSRunAlertPanel(NSLocalizedString(@"testTitle", nil), 
                                 NSLocalizedString(@"testMessage", nil), 
                                 NSLocalizedString(@"testOK", nil), 
                                 NSLocalizedString(@"testCancel", nil),
                                 nil);
    switch (result) {
        case NSAlertDefaultReturn:
            NSLog(@"OK");
            break;
        case NSAlertAlternateReturn:
            NSLog(@"Cancel");
            [NSApp terminate:self];
            break;
        case NSAlertOtherReturn:
            NSLog(@"Other");
            break;
        default:
            NSLog(@"Error");
            break;
    }
}

/*
 *  PreferenceWindowのDelegate処理
 */
-(void) windowDidBecomeKey:(NSNotification *)notification {
    ////NSLog(@"windowDidBecomeKey");
    [window show];
}

-(void) windowDidResignKey:(NSNotification *)notification {
    ////NSLog(@"windowDidResignKey");
    [window hide_];
}

@end
