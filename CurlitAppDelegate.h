//
//  CurlitAppDelegate.h
//  Curlit
//
//  Created by Robert Righter on 2/8/10.
//  Copyright 2010. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>

@interface CurlitAppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *window;
	NSTextFieldCell* urlInput;
	NSTextFieldCell* postInput;
	NSButtonCell* postCheckbox;
	WebView* webView;
}
- (void)enterPressed;
-(NSString *) getPostString;
-(NSString *) replaceGtAndLtInString: (NSString *)s;

@property (assign) IBOutlet NSWindow *window;
@property (nonatomic, retain) IBOutlet WebView* webView;
@property (nonatomic, retain) IBOutlet NSTextFieldCell*  urlInput;
@property (nonatomic, retain) IBOutlet NSTextFieldCell*  postInput;
@property (nonatomic, retain) IBOutlet NSButtonCell*  postCheckbox;

@end
