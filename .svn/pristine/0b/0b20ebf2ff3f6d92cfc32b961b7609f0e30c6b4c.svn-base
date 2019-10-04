//
//  UIUtils.h
//



@interface UIUtils : NSObject

+ (void) messageAlert: (NSString*)msg title: (NSString*)title delegate: (id)delegate;
+ (void) messageAlertWithOkCancel:(NSString*)msg title:(NSString*)title delegate:(id)delegate;
+ (void) errorAlert:(NSString*)msg;
+ (void) localizedErrorAlert:(NSString*)strId;

+ (void) conditionFailedMsg:(NSString*)condition filename:(NSString*)fname line:(int)line;

// pure UI utils function
+ (BOOL) isString:(NSString*)str inArray:(NSArray*)array;

+ (UIImage*) cropImage:(UIImage*)inImage ofSize:(CGSize) inSize;
+ (BOOL) isConnectedToNetwork;

+ (void) addNotificationToQueue:(NSString*)name object:(id)self userInfo:(NSDictionary*)dictionary postingStyle:(NSPostingStyle)style;

+ (void) moveView:(UIView*)view toX:(CGFloat)x andY:(CGFloat)y;
+ (void) moveView:(UIView*)view xOffset:(CGFloat)x yOffset:(CGFloat)y;
+ (void) moveViewFor:(UIViewController*)viewC xOffset:(CGFloat)x yOffset:(CGFloat)y;

+ (BOOL) checkForSpecialCharacter:(NSString*) string;

+ (NSString*) documentDirectoryWithSubpath:(NSString*)subpath;

+ (NSString*) urlEncodeValue:(NSString*) string;
+ (NSString*) urlDecodeValue:(NSString*) string;

+ (CGRect) drawImage:(UIImage*) image inRect:(CGRect) rect proportionally:(BOOL)proportionally;
+ (void) drawRoundRect:(CGRect) frame cornerRadius:(CGFloat) radius mode:(CGPathDrawingMode) mode;

+ (NSArray*) getSubViewsFromView:(UIView*)view withClass:(NSString*) className;
+ (void) viewTransitionWithAnimation:(NSString*)animationType animationSubType:(NSString*)animationSubType
							 forView:(UIView*)pView duration:(CGFloat)duration;

+ (UIImage*) giveSnapShotOfView:(UIView*) view;

+ (BOOL) addSkipBackupAttributeToItemAtURL:(NSURL*)URL;

+ (NSDate*) dateWithString: (NSString*) string dateFormat: (NSString*) dateFormat;
+ (NSString*) stringWithDateFormat:(NSDate*)date dateFormat:(NSString*)dateFormat;

+ (BOOL) isDevicePortrait;

+ (NSDate*) fileModifiedDate:(NSString*)path;

+ (void) printLog:(NSData*)data;

+ (void) networkFailureMessage;

+ (id) checkNull:(id)object;

+ (BOOL) checkNetworkConnection;

@end


