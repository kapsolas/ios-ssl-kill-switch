#import <HookedNSURLConnectionDelegate.h>
#define PREFERENCEFILE "/User/Library/Preferences/com.nabla.SSLKillSwitchSettings.plist"


%hook NSURLConnection

- (id)initWithRequest:(NSURLRequest *)request delegate:(id < NSURLConnectionDelegate >)delegate {
    
    id hookedResult;
   	HookedNSURLConnectionDelegate* delegateProxy = [[HookedNSURLConnectionDelegate alloc] initWithOriginal: delegate];
    hookedResult = %orig(request, delegateProxy);	
    [delegateProxy release]; // NSURLConnection retains the delegate
   
    return hookedResult;
}


- (id)initWithRequest:(NSURLRequest *)request delegate:(id < NSURLConnectionDelegate >)delegate startImmediately:(BOOL)startImmediately {
    
    id hookedResult;
    HookedNSURLConnectionDelegate* delegateProxy = [[HookedNSURLConnectionDelegate alloc] initWithOriginal: delegate];
    hookedResult = %orig(request, delegateProxy, startImmediately);		
    [delegateProxy release]; // NSURLConnection retains the delegate
    
    return hookedResult;    
}

%end


%ctor {
	// Should we hook NSURLConnection ?
    NSString* preferenceFilePath = @PREFERENCEFILE; // Dirty ?
    BOOL shouldHook = [HookedNSURLConnectionDelegate shouldHookNSURLConnectionFromPreference:preferenceFilePath];
    [preferenceFilePath release];

	if (shouldHook) { // Yes => enable the %hook block
    	NSLog(@"SSL Kill Switch - Hook Enabled.");
        %init;
    }
    else {
    	NSLog(@"SSL Kill Switch - Hook Disabled.");
        }
}
