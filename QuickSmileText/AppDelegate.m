//
//  AppDelegate.m
//  QuickSmileText
//
//  Created by scturtle on 12-8-10.
//  Copyright (c) 2012年 scturtle. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize window = _window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // for notification
    [[NSUserNotificationCenter defaultUserNotificationCenter] setDelegate:self];
}

// show notification even self is current app
- (BOOL)userNotificationCenter:(NSUserNotificationCenter *)center shouldPresentNotification:(NSUserNotification *)notification{
    return YES;
}

- (NSMutableArray *) getSmileTexts {
    /* exp: /Users/username/Documents */
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                          NSUserDomainMask, YES) objectAtIndex:0];
    /* exp: /Users/username/Documents/smileText.plist */
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"smileTexts.plist"];
    
    NSMutableArray *smileTexts;
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
        // new
        prefs = [[NSMutableDictionary alloc] init];
        smileTexts = [NSArray arrayWithObjects:@"╮(￣▽￣\")╭", nil];
        [prefs setObject: smileTexts forKey:@"smileTexts"];
        [prefs writeToFile:plistPath atomically: TRUE];
    } else {
        // load file
        prefs = [NSDictionary dictionaryWithContentsOfFile: plistPath];
        smileTexts = [prefs objectForKey:@"smileTexts"];
    }
    return smileTexts;
}

- (void) awakeFromNib {
    statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    
    NSMutableArray *smileTexts = [self getSmileTexts];
    
    // dynamic generate menu
    for(int i=0;i<[smileTexts count];i++){
        [menu insertItemWithTitle:[smileTexts objectAtIndex:i]
                           action:@selector(copyToClipboard:)
                    keyEquivalent:@"" atIndex:i];
    }

    //status bar
    [statusItem setMenu:menu];
    [statusItem setHighlightMode:YES];
    [statusItem setImage:[NSImage imageNamed:@"smile16"]];
}
- (void) copyToClipboard:(NSMenuItem *) sender{
    
    // copy to clipboard
    NSPasteboard *pasteBoard = [NSPasteboard generalPasteboard];
    [pasteBoard declareTypes:[NSArray arrayWithObjects:NSStringPboardType, nil]
                       owner:nil];
    [pasteBoard setString: [sender title] forType:NSStringPboardType];
    
    // notification
    NSUserNotification *notification = [[NSUserNotification alloc] init];
    notification.title = @"In clipboard";
    notification.informativeText = [sender title];
    notification.soundName = NSUserNotificationDefaultSoundName;
    [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notification];
    // NSLog([sender title], nil);
}

//- (IBAction)showPrefenceWindow:(id)sender {
//    [NSApp activateIgnoringOtherApps:YES];
//    [_window makeKeyAndOrderFront:nil];
//}

- (IBAction)quit:(id)sender {
    [NSApp terminate:nil];
}

@end