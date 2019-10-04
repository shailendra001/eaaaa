//
//  UIUtils.m
//

//#import "SBJSON.h"
#include <sys/xattr.h>
#import "UIPrefix.h"
#import <SystemConfiguration/SCNetworkReachability.h>
#import <netinet/in.h>
#import <QuartzCore/CoreAnimation.h>

#import "UIUtils.h"

@implementation UIUtils

+ (void) messageAlert:(NSString*)msg title:(NSString*)title delegate:(id)delegate
{
	UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title message: msg
												   delegate: delegate cancelButtonTitle: @"Ok" otherButtonTitles: nil];
	[alert show];
//	[alert release];
}

+ (void) messageAlertWithOkCancel:(NSString*)msg title:(NSString*)title delegate:(id)delegate
{
	UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title message: msg
												   delegate: delegate cancelButtonTitle: @"No" otherButtonTitles:@"Yes", nil];
	[alert show];
//	[alert release];
}

+ (void) errorAlert:(NSString*)msg
{
	[UIUtils messageAlert:msg title:@"Error" delegate:nil];
}

+ (void) localizedErrorAlert:(NSString*)strId
{
	[UIUtils messageAlert:strId title:@"Message" delegate:nil];
}

+ (void) conditionFailedMsg:(NSString*)condition filename:(NSString*)fname line:(int)line
{
	NSString* str = [NSString stringWithFormat:@"Condition Failed (%@)\n\n%@\nLine No: %d", condition, fname, line];
	[UIUtils messageAlert:str title:@"DebugError (Please report)" delegate:nil];
}

# pragma mark -

+ (BOOL) isString:(NSString*)str inArray:(NSArray*)array
{
	for (id s in array)
	{
		if (_IsSameString(str, s))
			return YES;
	}
	return NO;
}

+ (UIImage*) cropImage:(UIImage*)inImage ofSize:(CGSize)inSize
{
	if (inImage)
	{
		CGRect thumbRect = CGRectMake(0, 0, inSize.width, inSize.height);
		UIGraphicsBeginImageContext(inSize);
		[inImage drawInRect:thumbRect];
		UIImage *thumbImage = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
		return thumbImage;
	}
	else 
		return nil;
}

#pragma mark -

+ (BOOL) isConnectedToNetwork
{
	// Create zero addy
	struct sockaddr_in zeroAddress;
	bzero(&zeroAddress, sizeof(zeroAddress));
	zeroAddress.sin_len = sizeof(zeroAddress);
	zeroAddress.sin_family = AF_INET;
	
	// Recover reachability flags
	SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
	SCNetworkReachabilityFlags flags;
	
	// synchronous model

	BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
	CFRelease(defaultRouteReachability);
	
	if (!didRetrieveFlags)
	{
		DLog(@"Error. Could not recover network reachability flags\n");
		return 0;
	}
	
	BOOL isReachable = flags & kSCNetworkFlagsReachable;
	BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
	//return (isReachable && !needsConnection) ? YES : NO;
	//BOOL nonWiFi = flags & kSCNetworkReachabilityFlagsTransientConnection;
	
	return (isReachable && !needsConnection);
}


+ (void) addNotificationToQueue:(NSString*)name object:(id)inObject userInfo:(NSDictionary*)dictionary postingStyle:(NSPostingStyle)style
{
	NSNotification* notification = [NSNotification notificationWithName:(NSString *)name object:(id)inObject userInfo:dictionary];

	[[NSNotificationQueue defaultQueue] dequeueNotificationsMatching:notification coalesceMask:NSNotificationCoalescingOnName];
	[[NSNotificationQueue defaultQueue] enqueueNotification:notification postingStyle:style];
}

+ (BOOL) checkForSpecialCharacter:(NSString*)string
{
	NSString* str = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWYZ1234567890.-_";
	NSCharacterSet* alfaNumericSet = [NSCharacterSet characterSetWithCharactersInString:str];
	for (int i = 0; i < string.length; ++i)
	{
		if (![alfaNumericSet characterIsMember:[string characterAtIndex:i]])
			return YES;
	}
	return NO;
}

+ (void) moveView:(UIView*)view toX:(CGFloat)x andY:(CGFloat)y
{
	_Assert(view);
	CGRect r = view.frame;
	view.frame = CGRectMake(x, y, r.size.width, r.size.height);
}

+ (void) moveView:(UIView*)view xOffset:(CGFloat)x yOffset:(CGFloat)y
{
	_Assert(view);
	CGRect r = view.frame;
	r.origin.x += x;
	r.origin.y += y;
	view.frame = r;
}

+ (void) moveViewFor:(UIViewController*)viewC xOffset:(CGFloat)x yOffset: (CGFloat)y
{
#ifdef _ShowStatusBar
	_Assert(viewC && viewC.view);
	CGRect r = viewC.view.frame;
	r.origin.y -= 20;
	viewC.view.frame = r;
#endif
	
}

#pragma mark -

+ (NSString*) documentDirectoryWithSubpath:(NSString*)subpath
{
	NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	if (paths.count <= 0)
		return nil;

	NSString* dirPath = [paths objectAtIndex:0];
	if (subpath)
		dirPath = [dirPath stringByAppendingFormat:@"/%@", subpath];

	return dirPath;
}

#pragma mark  url encoder

+ (NSString*) urlEncodeValue:(NSString*)string
{
	_Assert(string);
	
        NSString* result = (NSString*) CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                                 (CFStringRef)string,
                                                                                                 NULL,
                                                                                                 CFSTR("-/:;()$&@\"'!?,.[]{}#%^*+=><~|\\_£¥€•"),
                                                                                                 kCFStringEncodingUTF8));
//	return [result autorelease];
        return result;
}

+ (NSString*) urlDecodeValue:(NSString*) string
{
	_Assert(string);
	
        NSString* tmpResult = (NSString*) CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
                                                                                                                    (CFStringRef)string,
                                                                                                                    CFSTR("-/:;()$&@\"'!?,.[]{}#%^*+=><~|\\_£¥€•"),
                                                                                                                    // CFSTR(""),
                                                                                                                    kCFStringEncodingUTF8));
	//  kCFStringEncodingUnicode);
	//  kCFStringEncodingUTF16);
	NSString* result = [tmpResult stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]; 
//	[tmpResult release];
	return result;
}

#pragma mark -

+ (CGRect) drawImage:(UIImage*) image inRect:(CGRect) rect proportionally:(BOOL)proportionally
{
	assert(image);
	
	if (proportionally)
	{
		CGSize sz = rect.size;
		CGSize imgSz = image.size;
		
		CGFloat dx = sz.width / imgSz.width;
		CGFloat dy = sz.height / imgSz.height;
		
		CGFloat minScale = MIN(dx, dy);
		sz.width = imgSz.width * minScale;
		sz.height = imgSz.height * minScale;
		
		rect.origin.x += (rect.size.width - sz.width) * 0.5;
		rect.origin.y += (rect.size.height - sz.height) * 0.5;
		
		rect.size = sz;
	}
	
	[image drawInRect:rect];
	return rect;
}

+ (void) drawRoundRect:(CGRect) frame cornerRadius:(CGFloat) radius mode:(CGPathDrawingMode) mode
{
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGFloat minx = CGRectGetMinX(frame), midx = CGRectGetMidX(frame), maxx = CGRectGetMaxX(frame);
	CGFloat miny = CGRectGetMinY(frame), midy = CGRectGetMidY(frame), maxy = CGRectGetMaxY(frame);

	CGContextMoveToPoint(context, minx, midy);							// Start at 1
	CGContextAddArcToPoint(context, minx, miny, midx, miny, radius);	// Add an arc through 2 to 3
	CGContextAddArcToPoint(context, maxx, miny, maxx, midy, radius);	// Add an arc through 4 to 5
	CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);	// Add an arc through 6 to 7
	CGContextAddArcToPoint(context, minx, maxy, minx, midy, radius);	// Add an arc through 8 to 9
	CGContextClosePath(context);										// Close the path

	CGContextDrawPath(context, mode);							// Fill & stroke the path
}

#pragma mark -

+ (NSArray*) getSubViewsFromView:(UIView*)view withClass:(NSString*) className
{
	NSMutableArray* classArray = [NSMutableArray array];
	NSArray* viewsArray = [view subviews];
	
	for (int i = 0; i < viewsArray.count; ++i)
	{
		UIView* view = [viewsArray objectAtIndex:i];
		
		if ([view isKindOfClass:NSClassFromString(className)]) 
		{
			[classArray addObject:view];
		}
		NSArray* array = [self getSubViewsFromView:view withClass:className];
		[classArray addObjectsFromArray:array];
	}
	
	return classArray;
}

+ (void) viewTransitionWithAnimation:(NSString*)animationType animationSubType:(NSString*)animationSubType
							 forView:(UIView*)pView duration:(CGFloat)duration
{
	CATransition* animation = [CATransition animation];
	[animation setDuration:duration];
	[animation setType:animationType];
	[animation setSubtype:animationSubType];
	[animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
	
	[[pView layer] addAnimation:animation forKey:@"SwitchToView1"];
}

+ (UIImage*) giveSnapShotOfView:(UIView*) view
{
	if (view == nil)
		return nil;
	
	UIGraphicsBeginImageContext(view.bounds.size);
	[view.layer renderInContext:UIGraphicsGetCurrentContext()];
	
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return image;
}

#pragma mark -

+ (BOOL) addSkipBackupAttributeToItemAtURL:(NSURL*)URL
{
    const char* filePath = [[URL path] fileSystemRepresentation];
    
    const char* attrName = "com.apple.MobileBackup";
    u_int8_t attrValue = 1;
    
    int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
    return result == 0;
}

#pragma mark -

+ (NSDate*) dateWithString: (NSString*) string dateFormat: (NSString*) dateFormat
{
    if (string)
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:dateFormat];
        return [dateFormatter dateFromString:string];
    }
    return nil;
}

+ (NSString*) stringWithDateFormat:(NSDate*)date dateFormat:(NSString*)dateFormat
{
    if (date == nil)
        return @"";
    
    NSDateFormatter *inFormat = [[NSDateFormatter alloc] init];
    [inFormat setDateFormat:dateFormat];
//    [inFormat autorelease];
    return [NSString stringWithFormat:@"%@",[inFormat stringFromDate:date]];
}

#pragma mark -

+ (BOOL) isDevicePortrait
{
    return UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation]);
}

#pragma mark -

+ (NSDate*) fileModifiedDate:(NSString*)path 
{
    NSFileManager* fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:path]) 
        return nil;

    NSError* error = nil;
    NSDictionary* attributes = [fileManager attributesOfItemAtPath:path error:&error];
    if (!attributes) 
        return nil;
    return [attributes fileCreationDate];
}

+ (void) printLog:(NSData*)data
{
	NSString* str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	DLog(@"==== \n %@ \n ====", str);
//	_ReleaseObject(str);
}

+ (void) networkFailureMessage
{
	NSString *alertTitle = NSLocalizedString (@"Reach",@"Reach");
	NSString *msgText = @"Internet connection is not available. Please check your wifi settings.";
	
	[UIUtils messageAlert:msgText title:alertTitle delegate:self];
}

#pragma mark -- Check for null values

+ (id) checkNull:(id)object
{
	return [object isKindOfClass:[NSNull class]] ? @"" : object;
}

+ (BOOL) checkNetworkConnection
{
	if (![self isConnectedToNetwork])
    {
        [self networkFailureMessage];
        return NO;
    }
	return YES;
}
@end

