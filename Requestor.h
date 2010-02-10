//
//  MyDocument.h
//  curly
//
//  Created by Robert Righter on 2/6/10.
//

#import <Cocoa/Cocoa.h>


@interface Requestor : NSObject {

	NSMutableData* responseData;
	NSMutableString* responseHeaders;
	SEL updateSuccess;
	SEL updateFailure;
	id  callbackTarget;
	
}

- (void) doRequestWith:(NSString*)poststring successAction:(SEL)success failureAction:(SEL)failure target:(id)target url:(NSString *)url; 
+ (NSString *)urlEncodeValue:(NSString *)str;

@end
