//
//  AppDelegate.h
//  QuickSmileText
//  Written by scturtle. No rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate, NSUserNotificationCenterDelegate>{

    IBOutlet NSMenu *menu;
    IBOutlet NSTableView *table;
    IBOutlet NSArrayController *arrayController;

    NSStatusItem *statusItem;
    NSString *plistPath;
    NSMutableDictionary *prefs;
    NSMutableArray* smileTexts;
    NSUserNotification *notification;
}

@property (assign) IBOutlet NSWindow *window;

@end