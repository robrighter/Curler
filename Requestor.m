//
//  MyDocument.h
//  curly
//
//  Created by Robert Righter on 2/6/10.
//

#import "Requestor.h"


@implementation Requestor

- (void) doRequestWith:(NSString*)poststring successAction:(SEL)success failureAction:(SEL)failure target:(id)target url:(NSString *)url {
	
	updateSuccess = success;
	updateFailure = failure;
	callbackTarget = target;
	responseData = [[NSMutableData data] retain];
	NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
	
	if (poststring == nil) {
		[request setHTTPMethod:@"GET"];
	}
	else{
		[request setHTTPMethod:@"POST"];
	    //[request setHTTPBody:[[Requestor urlEncodeValue:poststring] dataUsingEncoding:NSUTF8StringEncoding]];
		[request setHTTPBody:[poststring dataUsingEncoding:NSUTF8StringEncoding]];
	}
	
	//send off the request
	[[NSURLConnection alloc] initWithRequest:request delegate:self];	
}



+ (NSString *)urlEncodeValue:(NSString *)str {
	NSString *result = (NSString *) CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)str, NULL, CFSTR(":/?#[]@!$&’()*+,;="), kCFStringEncodingUTF8);
	return [result autorelease];
}



- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    [responseData setLength:0];
	//NSLog([response URL]);
	
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    [callbackTarget performSelector:updateFailure];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // Once this method is invoked, "responseData" contains the complete result
	//NSLog(@"%@",[[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding]);
	//TODO: Should probably check and make sure that responseData actually has a success message in it (IE just because it didnt 500 error doesnt mean everything is perfect
	[callbackTarget performSelector:updateSuccess withObject:[[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding]];
}





@end
