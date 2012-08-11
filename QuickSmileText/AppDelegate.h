//
//  AppDelegate.h
//  QuickSmileText
//
//  Created by scturtle on 12-8-10.
//  Copyright (c) 2012年 scturtle. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate,
                                   NSUserNotificationCenterDelegate>{
    NSStatusItem *statusItem;
    IBOutlet NSMenu *menu;
    NSMutableDictionary *prefs;
}

@property (assign) IBOutlet NSWindow *window;

@end