//
//  AppDelegate.m
//  QuickSmileText
//  Written by scturtle. No rights reserved.
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

- (void) awakeFromNib {
    // init notification
    notification = [[NSUserNotification alloc] init];
    notification.title = @"In clipboard";
    notification.soundName = NSUserNotificationDefaultSoundName;
    
    // init menu
    [self loadSmileTexts];
    [self load_menu];

    // init statusbar
    statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    [statusItem setMenu:menu];
    [statusItem setHighlightMode:YES];
    [statusItem setImage:[NSImage imageNamed:@"smile16"]];
}

- (void) loadSmileTexts {
    /* e.p.: /Users/username/Documents */
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                          NSUserDomainMask, YES) objectAtIndex:0];
    /* e.p.: /Users/username/Documents/smileText.plist */
    plistPath = [rootPath stringByAppendingPathComponent:@"smileTexts.plist"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
        // new file
        smileTexts = [NSMutableArray arrayWithObjects:@"╮(￣▽￣\")╭", nil];
        prefs = [NSDictionary dictionaryWithObject:smileTexts forKey:@"smileTexts"];
        [prefs writeToFile:plistPath atomically: TRUE];
    } else {
        // load file
        prefs = [NSDictionary dictionaryWithContentsOfFile: plistPath];
        smileTexts = [prefs objectForKey:@"smileTexts"];
    }
}

- (void) load_menu{
    // clear
    NSUInteger n = [[menu itemArray] count];
    for(int i=0;i<n-3;i++)
        [menu removeItemAtIndex:0];
    // generate menu
    for(int i=0;i<[smileTexts count];i++){
        [menu insertItemWithTitle:[smileTexts objectAtIndex:i]
                           action:@selector(copyToClipboard:)
                    keyEquivalent:@""
                          atIndex:i];
    }
}

- (void) copyToClipboard:(NSMenuItem *) sender{
    
    // copy to clipboard
    NSPasteboard *pasteBoard = [NSPasteboard generalPasteboard];
    [pasteBoard declareTypes:[NSArray arrayWithObjects:NSStringPboardType, nil]
                       owner:nil];
    [pasteBoard setString:[sender title] forType:NSStringPboardType];
    
    // notification
    notification.informativeText = [sender title];
    [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notification];
}

- (IBAction)showPrefenceWindow:(id)sender {
    [NSApp activateIgnoringOtherApps:YES];
    [_window makeKeyAndOrderFront:nil];
    [arrayController removeObjects:[arrayController arrangedObjects]];
    for(id smile in smileTexts)
        [arrayController addObject:[NSMutableDictionary dictionaryWithObject:smile forKey:@"smile"]];
}

- (IBAction)refresh:(id)sender {
    // get all items from table
    [smileTexts removeAllObjects];
    NSArray *array = [arrayController arrangedObjects];
    for(NSMutableDictionary *dict in array)
        [smileTexts addObject:[dict objectForKey:@"smile"]];
    // refresh menu
    [self load_menu];
    // save to file
    prefs = [NSDictionary dictionaryWithObject:smileTexts forKey:@"smileTexts"];
    [prefs writeToFile:plistPath atomically: TRUE];
}

- (IBAction)add:(id)sender {
    [arrayController addObject: [NSMutableDictionary dictionaryWithObject:@"" forKey:@"smile"]];
}

- (IBAction)remove:(id)sender {
    [arrayController removeObjectAtArrangedObjectIndex:[arrayController selectionIndex]];
}

- (IBAction)up:(id)sender {
    unsigned long n = [arrayController selectionIndex];
    if(n==0) return;
    NSMutableArray *array = [NSMutableArray arrayWithArray:[arrayController arrangedObjects]];
    // exchange
    [array exchangeObjectAtIndex:n-1 withObjectAtIndex:n];
    // reload
    [arrayController removeObjects:[arrayController arrangedObjects]];
    for(id smile in array)
        [arrayController addObject:smile];
    [arrayController setSelectionIndex:n-1];
}

- (IBAction)down:(id)sender {
    unsigned long n = [arrayController selectionIndex];
    if(n==[[arrayController arrangedObjects] count]-1) return;
    NSMutableArray *array = [NSMutableArray arrayWithArray:[arrayController arrangedObjects]];
    // exchange
    [array exchangeObjectAtIndex:n withObjectAtIndex:n+1];
    // reload
    [arrayController removeObjects:[arrayController arrangedObjects]];
    for(id smile in array)
        [arrayController addObject:smile];
    [arrayController setSelectionIndex:n+1];
}

- (IBAction)quit:(id)sender {
    [NSApp terminate:nil];
}

@end