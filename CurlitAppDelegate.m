//
//  CurlitAppDelegate.m
//  Curlit
//
//  Created by Robert Righter on 2/8/10.
//  Copyright 2010. All rights reserved.
//

#import "CurlitAppDelegate.h"
#import "Requestor.h"

@implementation CurlitAppDelegate

@synthesize window;
@synthesize urlInput;
@synthesize postInput;
@synthesize postCheckbox;
@synthesize webView;
@synthesize spinner;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	// Insert code here to initialize your application
	// Add any code here that needs to be executed once the windowController has loaded the document's window.
	if (self.spinner == nil) {
		NSLog(@"spinner input is nil");
	}
	else {
		NSLog(@"spinner is NOT nil");
	}
	
	[postCheckbox setIntValue:0];
	[postInput setEnabled:false];
	[postInput setBackgroundColor:[NSColor lightGrayColor]];
	[postInput setFont:[NSFont systemFontOfSize:10]];
	[postCheckbox setTarget:self];
	[postCheckbox setAction:@selector(postCheckoutClicked)];
	[urlInput setTextColor:[NSColor grayColor]];
	[urlInput setTarget:self];
	[urlInput setAction:@selector(enterPressed)];
	
	//[spinner setDisplayedWhenStopped:YES];
}

- (void)enterPressed {
	Requestor *r = [[Requestor alloc] init];
	[spinner performSelector:@selector(startAnimation:) withObject:self afterDelay:0.0];
	[urlInput setTitle:[self addHttpIfNeeded:[urlInput title]]];
	[r doRequestWith:[self getPostString] successAction:@selector(requestComplete:) failureAction:@selector(requestFailed) target:self url:[urlInput title]];
}

- (void)requestComplete: (NSDictionary*) response {
	NSString *body = (NSString*)[response objectForKey:@"body"];
	NSString *headers = (NSString*)[response objectForKey:@"headers"];
	
	NSString* filePath = [[NSBundle mainBundle] pathForResource: @"XMLSyntaxHighlighter" ofType: @"html"];
	NSURL *url = [NSURL fileURLWithPath:[filePath stringByDeletingLastPathComponent]];
	[[self.webView mainFrame] loadHTMLString: [NSString stringWithFormat:[NSString stringWithContentsOfFile: filePath],headers,[self getSyntaxType], [self replaceGtAndLtInString:body]] baseURL: url];
	[spinner stopAnimation:nil];
	
}

- (void)requestFailed {
	//[textScroller setString:@"Request Failed"];	 
}

-(void) postCheckoutClicked {
	if([self.postCheckbox intValue] == 0){
		//disable the postInput
		
		[postInput setEnabled:false];
		[postInput setBackgroundColor:[NSColor lightGrayColor]];
	}
	else {
		[postInput setEnabled:true];
		[postInput setBackgroundColor:[NSColor whiteColor]];
	}	
}

-(NSString *) getSyntaxType {
	NSRange textRange;
	textRange =[[[urlInput title] lowercaseString] rangeOfString:@".css"];
	if(textRange.location != NSNotFound)
	{
		return @"css";
	}
	textRange =[[[urlInput title] lowercaseString] rangeOfString:@".js"];
	if(textRange.location != NSNotFound)
	{
		return @"js";
	}
	else {
		return @"xml";
	}

}

-(NSString *) getPostString {
	if([self.postCheckbox intValue] == 0){
		//The user wants to GET not Post so return nil
		return nil;
	}
	else {
		NSLog(@"Returning the post string: %@",[postInput title]);
		return [postInput title];
		
	}
	
}

-(NSString *) replaceGtAndLtInString: (NSString *)s {
	return [[s stringByReplacingOccurrencesOfString:@"<" withString:@"&lt;"] stringByReplacingOccurrencesOfString:@">" withString:@"&gt;"];
}

-(NSString *) addHttpIfNeeded:(NSString*) url {
	NSRange textRange;
	textRange =[[url lowercaseString] rangeOfString:@"http"];
	if(textRange.location == NSNotFound)
	{
		return [[NSString stringWithFormat:@"http://%@",url] retain];
	}
	else {
		return url;
	}
	
}

@end
