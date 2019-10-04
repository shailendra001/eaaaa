//
//  Alert.m
//  Q-municate
//
//  Created by Sandeep Kumar on 18/07/15.
//  Copyright (c) 2015 Quickblox. All rights reserved.
//

#import "Alert.h"
#import <UIKit/UIKit.h>



#define BALANCE_DEBUG   0

@implementation Alert

+(void)alertWithMessageSimple:(NSString*)message navigation:(UINavigationController*)navigation gotoBack:(BOOL)goBack animation:(BOOL)animation{
    UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@""
                                                          message:message
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles: nil];
    
    [myAlertView show];
}


+(void)alertWithMessage:(NSString*)message navigation:(UINavigationController*)navigation gotoBack:(BOOL)goBack animation:(BOOL)animation{
    UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@""
                                                          message:message
                                                         delegate:nil
                                                cancelButtonTitle:nil
                                                otherButtonTitles: nil];
    
    [myAlertView show];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [myAlertView dismissWithClickedButtonIndex:0 animated:animation];
        goBack ? [navigation popViewControllerAnimated:YES]  :nil;
    });
}

+(void)alertWithMessage:(NSString*)message navigation:(UINavigationController*)navigation gotoBack:(BOOL)goBack animation:(BOOL)animation second:(int)second{
    UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@""
                                                          message:message
                                                         delegate:nil
                                                cancelButtonTitle:nil
                                                otherButtonTitles: nil];
    
    [myAlertView show];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(second * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [myAlertView dismissWithClickedButtonIndex:0 animated:animation];
        goBack ? [navigation popViewControllerAnimated:YES]  :nil;
    });
}

+(void)performBlockWithInterval:(double)interval completion:(void(^)(void))completion{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(interval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        completion();
        
    });
}


+(BOOL)validationName:(NSString *)checkString{
        
//        NSCharacterSet *alphaSet = [NSCharacterSet alphanumericCharacterSet];
//        BOOL valid = [[checkString stringByTrimmingCharactersInSet:alphaSet] isEqualToString:@""];
//        
//        return valid ? NO : YES;
    
    NSString *_username = checkString;
    
    NSCharacterSet * characterSetFromTextField = [NSCharacterSet characterSetWithCharactersInString: _username];
    if([[NSCharacterSet alphanumericCharacterSet] isSupersetOfSet: characterSetFromTextField] == NO)
    {
        //NSLog( @"there are bogus characters here, throw up a UIAlert at this point");
        return NO;
    }
    return YES;

   
}

+(BOOL)validationString:(NSString*)checkString {
        
        NSString *_username = checkString;
        
        NSCharacterSet *strCharSet = [NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ "];//1234567890_"];
        
        strCharSet = [strCharSet invertedSet];
        //And you can then use a string method to find if your string contains anything in the inverted set:
        
        NSRange r = [_username rangeOfCharacterFromSet:strCharSet];
        if (r.location != NSNotFound) {
                //NSLog(@"the string contains illegal characters");
                return NO;
        }
        else
                return YES;
}

// By CS Rai

+(BOOL)validationStringAndNumberCommaEtc:(NSString*)checkString {
        
        NSString *_string = checkString;
        
        NSCharacterSet *strCharSet = [NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890,_-.*$ "];//1234567890_"];
        
        strCharSet = [strCharSet invertedSet];
        //And you can then use a string method to find if your string contains anything in the inverted set:
        
        NSRange r = [_string rangeOfCharacterFromSet:strCharSet];
        if (r.location != NSNotFound) {
                //NSLog(@"the string contains illegal characters");
                return NO;
        }
        else
                return YES;
}

/*
+(BOOL)validationEmail:(NSString *)checkString{
    BOOL stricterFilter = YES;
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}
 
 */

+ (BOOL)validationEmail:(NSString *)checkString {
    NSString *emailRegex = @"[A-Z0-9a-z][A-Z0-9a-z._%+-]*@[A-Za-z0-9][A-Za-z0-9.-]*\\.[A-Za-z]{2,6}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    NSRange aRange;
    if([emailTest evaluateWithObject:checkString]) {
        aRange = [checkString rangeOfString:@"." options:NSBackwardsSearch range:NSMakeRange(0, [checkString length])];
        int indexOfDot = (int)aRange.location;
        //NSLog(@"aRange.location:%d - %d",aRange.location, indexOfDot);
        if(aRange.location != NSNotFound) {
            NSString *topLevelDomain = [checkString substringFromIndex:indexOfDot];
            topLevelDomain = [topLevelDomain lowercaseString];
            //NSLog(@"topleveldomains:%@",topLevelDomain);
            NSSet *TLD;
            TLD = [NSSet setWithObjects:
                   @".aero", @".asia", @".biz", @".cat", @".com", @".coop", @".edu", @".gov", @".info", @".int", @".jobs", @".mil", @".mobi", @".museum", @".name", @".net", @".org", @".pro", @".tel", @".travel", @".ac", @".ad", @".ae", @".af", @".ag", @".ai", @".al", @".am", @".an", @".ao", @".aq", @".ar", @".as", @".at", @".au", @".aw", @".ax", @".az", @".ba", @".bb", @".bd", @".be", @".bf", @".bg", @".bh", @".bi", @".bj", @".bm", @".bn", @".bo", @".br", @".bs", @".bt", @".bv", @".bw", @".by", @".bz", @".ca", @".cc", @".cd", @".cf", @".cg", @".ch", @".ci", @".ck", @".cl", @".cm", @".cn", @".co", @".cr", @".cu", @".cv", @".cx", @".cy", @".cz", @".de", @".dj", @".dk", @".dm", @".do", @".dz", @".ec", @".ee", @".eg", @".er", @".es", @".et", @".eu", @".fi", @".fj", @".fk", @".fm", @".fo", @".fr", @".ga", @".gb", @".gd", @".ge", @".gf", @".gg", @".gh", @".gi", @".gl", @".gm", @".gn", @".gp", @".gq", @".gr", @".gs", @".gt", @".gu", @".gw", @".gy", @".hk", @".hm", @".hn", @".hr", @".ht", @".hu", @".id", @".ie", @" No", @".il", @".im", @".in", @".io", @".iq", @".ir", @".is", @".it", @".je", @".jm", @".jo", @".jp", @".ke", @".kg", @".kh", @".ki", @".km", @".kn", @".kp", @".kr", @".kw", @".ky", @".kz", @".la", @".lb", @".lc", @".li", @".lk", @".lr", @".ls", @".lt", @".lu", @".lv", @".ly", @".ma", @".mc", @".md", @".me", @".mg", @".mh", @".mk", @".ml", @".mm", @".mn", @".mo", @".mp", @".mq", @".mr", @".ms", @".mt", @".mu", @".mv", @".mw", @".mx", @".my", @".mz", @".na", @".nc", @".ne", @".nf", @".ng", @".ni", @".nl", @".no", @".np", @".nr", @".nu", @".nz", @".om", @".pa", @".pe", @".pf", @".pg", @".ph", @".pk", @".pl", @".pm", @".pn", @".pr", @".ps", @".pt", @".pw", @".py", @".qa", @".re", @".ro", @".rs", @".ru", @".rw", @".sa", @".sb", @".sc", @".sd", @".se", @".sg", @".sh", @".si", @".sj", @".sk", @".sl", @".sm", @".sn", @".so", @".sr", @".st", @".su", @".sv", @".sy", @".sz", @".tc", @".td", @".tf", @".tg", @".th", @".tj", @".tk", @".tl", @".tm", @".tn", @".to", @".tp", @".tr", @".tt", @".tv", @".tw", @".tz", @".ua", @".ug", @".uk", @".us", @".uy", @".uz", @".va", @".vc", @".ve", @".vg", @".vi", @".vn", @".vu", @".wf", @".ws", @".ye", @".yt", @".za", @".zm", @".zw", nil];
            if(topLevelDomain != nil && ([TLD containsObject:topLevelDomain])) {
                //NSLog(@"TLD contains topLevelDomain:%@",topLevelDomain);
                return TRUE;
            }
            /*else {
             NSLog(@"TLD DOEST NOT contains topLevelDomain:%@",topLevelDomain);
             }*/
            
        }
    }
    return FALSE;
}

+ (BOOL)validateMobileNumber:(NSString*)number {
        
    NSString *numberRegEx = @"[0-9]{10}";
    NSPredicate *numberTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numberRegEx];
    if ([numberTest evaluateWithObject:number] == YES)
        return TRUE;
    else
        return FALSE;
}

+ (BOOL)validatePinCode:(NSString*)number {
        
    NSString *numberRegEx = @"[0-9]{6}";
    NSPredicate *numberTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numberRegEx];
    if ([numberTest evaluateWithObject:number] == YES)
        return TRUE;
    else
        return FALSE;
}

+ (BOOL)validateNumber:(NSString*)number {
        
    NSScanner *scanner = [NSScanner scannerWithString:number];
    BOOL isNumeric = [scanner scanInteger:NULL] && [scanner isAtEnd];
        
    return isNumeric;
}

// Assumes input like "#00FF00" (#RRGGBB).
+ (UIColor *)colorFromHexString:(NSString *)hexString {
        
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

+(void)setProgessView:(UIView*)view strloading:(NSString*)strloading{
    UIImageView * BilizTikLogo = [[UIImageView alloc]init];
    BilizTikLogo.frame = CGRectMake(0, 0, 200, 80);
    BilizTikLogo.image = [UIImage imageNamed:@"logo.png"];
    
    BilizTikLogo.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin |
                                      UIViewAutoresizingFlexibleRightMargin |
                                      UIViewAutoresizingFlexibleTopMargin |
                                      UIViewAutoresizingFlexibleBottomMargin);
    
    UIActivityIndicatorView *indicatorView=[[UIActivityIndicatorView alloc] init];
    indicatorView.activityIndicatorViewStyle=UIActivityIndicatorViewStyleWhiteLarge;
    [indicatorView startAnimating];
    indicatorView.frame=CGRectMake(0,0, 40, 40);
    indicatorView.backgroundColor = [UIColor clearColor];
    indicatorView.color = [UIColor whiteColor];
    indicatorView.autoresizesSubviews = YES;
    indicatorView.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin |
                                      UIViewAutoresizingFlexibleRightMargin |
                                      UIViewAutoresizingFlexibleTopMargin |
                                      UIViewAutoresizingFlexibleBottomMargin);
    
    
    UILabel *lbl=[[UILabel alloc]init];
    lbl.frame=CGRectMake(0,indicatorView.frame.origin.y-indicatorView.frame.size.height, view.frame.size.width, 50);
    lbl.backgroundColor=[UIColor clearColor];
    lbl.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin |
                            UIViewAutoresizingFlexibleRightMargin |
                            UIViewAutoresizingFlexibleTopMargin |
                            UIViewAutoresizingFlexibleBottomMargin);
    //    }
    [lbl setText:strloading];
    lbl.textColor=[UIColor whiteColor];
    lbl.textAlignment=NSTextAlignmentCenter;
    lbl.font=[UIFont fontWithName:@"MyriadPro-Regular" size:20.0f];
      lbl.autoresizesSubviews = YES;
        lbl.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin |
                                UIViewAutoresizingFlexibleRightMargin |
                                UIViewAutoresizingFlexibleTopMargin |
                                UIViewAutoresizingFlexibleBottomMargin);
    
    
    UIView *v=[[UIView alloc] init];
    v.frame=view.bounds;
    v.tag=-1000;
    //v.backgroundColor=[UIColor clearColor];
    v.backgroundColor=[UIColor colorWithRed:83/255.0f green:86/255.0f blue:104/255.0f alpha:1];
    v.autoresizesSubviews = YES;
    v.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    indicatorView.center = v.center;
    
    lbl.center = CGPointMake(v.center.x, v.center.y+60);// v.center;
    BilizTikLogo.center = CGPointMake(v.center.x, v.center.y -200);
    
    [v addSubview:BilizTikLogo];
    [v addSubview:indicatorView];
    [v addSubview:lbl];
    [view bringSubviewToFront:v];
    [view addSubview:v];
    
}


+(void)CloseProgress:(UIView*)ViewProg{
    for (UIView *view in [ViewProg subviews] )
    {
        if (view.tag==-1000)
        {
            [view removeFromSuperview];
        }
    }
}



#pragma mark image Scaling
+(UIImage *)scaleAndRotateImage:(UIImage *)image{
    int kMaxResolution = 375; // Or whatever
    
    CGImageRef imgRef = image.CGImage;
    
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    if (width > kMaxResolution || height > kMaxResolution) {
        CGFloat ratio = width/height;
        if (ratio > 1) {
            bounds.size.width = kMaxResolution;
            bounds.size.height = bounds.size.width / ratio;
        }
        else {
            bounds.size.height = kMaxResolution;
            bounds.size.width = bounds.size.height * ratio;
        }
    }
    
    CGFloat scaleRatio = bounds.size.width / width;
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
    CGFloat boundHeight;
    UIImageOrientation orient = image.imageOrientation;
    switch(orient) {
            
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
            
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
            
        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
            
    }
    
    UIGraphicsBeginImageContext(bounds.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }
    else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    
    CGContextConcatCTM(context, transform);
    
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageCopy;
}


#pragma mark  reachability .......
+(BOOL)networkStatus{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    
    return networkStatus;
}


+(NSString*)getFirstName:(NSString*)name{
    
        NSArray* arr=[name componentsSeparatedByString:@" "];
        NSString *firstWord;
        if(arr.count){

                firstWord = [arr objectAtIndex:0];
        }
        else
                firstWord=@"";
    
    return firstWord;
}

+(NSString*)getLastName:(NSString*)name{
        
        NSArray* arr=[name componentsSeparatedByString:@" "];
        NSString *lastWord;
        if(arr.count==2){
                
                lastWord = [arr objectAtIndex:1];
        }
        else
                lastWord=@"";
        
        return lastWord;

}

+(NSDateFormatter*)getDateFormatWithString:(NSString*)string{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:string];
        
//    NSTimeZone* destinationTimeZone = [NSTimeZone systemTimeZone];
        [df setTimeZone:[NSTimeZone systemTimeZone]];
    return df;
    
}

+(NSDateFormatter*)getDateFormatFromServerWithString:(NSString*)string
{
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:string];
        [df setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
        return df;
        
}

+(NSDate*)getDateWithDateString:(NSString*)dateString setFormat:(NSString*)format{
    
    NSDate* date= [[self getDateFormatWithString:format] dateFromString:dateString];
    return date;
}

+(NSString*)getDateWithString:(NSString*)string getFormat:(NSString*)format1 setFormat:(NSString*)format2{
    
    NSDate* date= [[self getDateFormatWithString:format1] dateFromString:string];
    NSString *dateString = [[self getDateFormatWithString:format2] stringFromDate:date];
    
    return dateString;
    
}

+ (int)calculateAge:(NSDate*)date{
        
        NSInteger age;
        
        if(date){
                NSDate* now = [NSDate date];
                NSDateComponents* ageComponents = [[NSCalendar currentCalendar]
                                                   components:NSCalendarUnitYear
                                                   fromDate:date
                                                   toDate:now
                                                   options:0];
                age = [ageComponents year];
        }
        else age=0;
        
        return  (int)age;
}

+(NSDictionary*)getAllCountryNameWithCodeList{
    // Country code
    NSDictionary *codes = @{
                            @"Canada"                                       : @"+1",
                            @"China"                                        : @"+86",
                            @"France"                                       : @"+33",
                            @"Germany"                                      : @"+49",
                            @"India"                                        : @"+91",
                            @"Japan"                                        : @"+81",
                            @"Pakistan"                                     : @"+92",
                            @"United Kingdom"                               : @"+44",
                            @"United States"                                : @"+1",
                            @"Abkhazia"                                     : @"+7 840",
                            @"Abkhazia"                                     : @"+7 940",
                            @"Afghanistan"                                  : @"+93",
                            @"Albania"                                      : @"+355",
                            @"Algeria"                                      : @"+213",
                            @"American Samoa"                               : @"+1 684",
                            @"Andorra"                                      : @"+376",
                            @"Angola"                                       : @"+244",
                            @"Anguilla"                                     : @"+1 264",
                            @"Antigua and Barbuda"                          : @"+1 268",
                            @"Argentina"                                    : @"+54",
                            @"Armenia"                                      : @"+374",
                            @"Aruba"                                        : @"+297",
                            @"Ascension"                                    : @"+247",
                            @"Australia"                                    : @"+61",
                            @"Australian External Territories"              : @"+672",
                            @"Austria"                                      : @"+43",
                            @"Azerbaijan"                                   : @"+994",
                            @"Bahamas"                                      : @"+1 242",
                            @"Bahrain"                                      : @"+973",
                            @"Bangladesh"                                   : @"+880",
                            @"Barbados"                                     : @"+1 246",
                            @"Barbuda"                                      : @"+1 268",
                            @"Belarus"                                      : @"+375",
                            @"Belgium"                                      : @"+32",
                            @"Belize"                                       : @"+501",
                            @"Benin"                                        : @"+229",
                            @"Bermuda"                                      : @"+1 441",
                            @"Bhutan"                                       : @"+975",
                            @"Bolivia"                                      : @"+591",
                            @"Bosnia and Herzegovina"                       : @"+387",
                            @"Botswana"                                     : @"+267",
                            @"Brazil"                                       : @"+55",
                            @"British Indian Ocean Territory"               : @"+246",
                            @"British Virgin Islands"                       : @"+1 284",
                            @"Brunei"                                       : @"+673",
                            @"Bulgaria"                                     : @"+359",
                            @"Burkina Faso"                                 : @"+226",
                            @"Burundi"                                      : @"+257",
                            @"Cambodia"                                     : @"+855",
                            @"Cameroon"                                     : @"+237",
                            @"Canada"                                       : @"+1",
                            @"Cape Verde"                                   : @"+238",
                            @"Cayman Islands"                               : @"+ 345",
                            @"Central African Republic"                     : @"+236",
                            @"Chad"                                         : @"+235",
                            @"Chile"                                        : @"+56",
                            @"China"                                        : @"+86",
                            @"Christmas Island"                             : @"+61",
                            @"Cocos-Keeling Islands"                        : @"+61",
                            @"Colombia"                                     : @"+57",
                            @"Comoros"                                      : @"+269",
                            @"Congo"                                        : @"+242",
                            @"Congo, Dem. Rep. of (Zaire)"                  : @"+243",
                            @"Cook Islands"                                 : @"+682",
                            @"Costa Rica"                                   : @"+506",
                            @"Ivory Coast"                                  : @"+225",
                            @"Croatia"                                      : @"+385",
                            @"Cuba"                                         : @"+53",
                            @"Curacao"                                      : @"+599",
                            @"Cyprus"                                       : @"+537",
                            @"Czech Republic"                               : @"+420",
                            @"Denmark"                                      : @"+45",
                            @"Diego Garcia"                                 : @"+246",
                            @"Djibouti"                                     : @"+253",
                            @"Dominica"                                     : @"+1 767",
                            @"Dominican Republic"                           : @"+1 809",
                            @"Dominican Republic"                           : @"+1 829",
                            @"Dominican Republic"                           : @"+1 849",
                            @"East Timor"                                   : @"+670",
                            @"Easter Island"                                : @"+56",
                            @"Ecuador"                                      : @"+593",
                            @"Egypt"                                        : @"+20",
                            @"El Salvador"                                  : @"+503",
                            @"Equatorial Guinea"                            : @"+240",
                            @"Eritrea"                                      : @"+291",
                            @"Estonia"                                      : @"+372",
                            @"Ethiopia"                                     : @"+251",
                            @"Falkland Islands"                             : @"+500",
                            @"Faroe Islands"                                : @"+298",
                            @"Fiji"                                         : @"+679",
                            @"Finland"                                      : @"+358",
                            @"France"                                       : @"+33",
                            @"French Antilles"                              : @"+596",
                            @"French Guiana"                                : @"+594",
                            @"French Polynesia"                             : @"+689",
                            @"Gabon"                                        : @"+241",
                            @"Gambia"                                       : @"+220",
                            @"Georgia"                                      : @"+995",
                            @"Germany"                                      : @"+49",
                            @"Ghana"                                        : @"+233",
                            @"Gibraltar"                                    : @"+350",
                            @"Greece"                                       : @"+30",
                            @"Greenland"                                    : @"+299",
                            @"Grenada"                                      : @"+1 473",
                            @"Guadeloupe"                                   : @"+590",
                            @"Guam"                                         : @"+1 671",
                            @"Guatemala"                                    : @"+502",
                            @"Guinea"                                       : @"+224",
                            @"Guinea-Bissau"                                : @"+245",
                            @"Guyana"                                       : @"+595",
                            @"Haiti"                                        : @"+509",
                            @"Honduras"                                     : @"+504",
                            @"Hong Kong SAR China"                          : @"+852",
                            @"Hungary"                                      : @"+36",
                            @"Iceland"                                      : @"+354",
                            @"India"                                        : @"+91",
                            @"Indonesia"                                    : @"+62",
                            @"Iran"                                         : @"+98",
                            @"Iraq"                                         : @"+964",
                            @"Ireland"                                      : @"+353",
                            @"Israel"                                       : @"+972",
                            @"Italy"                                        : @"+39",
                            @"Jamaica"                                      : @"+1 876",
                            @"Japan"                                        : @"+81",
                            @"Jordan"                                       : @"+962",
                            @"Kazakhstan"                                   : @"+7 7",
                            @"Kenya"                                        : @"+254",
                            @"Kiribati"                                     : @"+686",
                            @"North Korea"                                  : @"+850",
                            @"South Korea"                                  : @"+82",
                            @"Kuwait"                                       : @"+965",
                            @"Kyrgyzstan"                                   : @"+996",
                            @"Laos"                                         : @"+856",
                            @"Latvia"                                       : @"+371",
                            @"Lebanon"                                      : @"+961",
                            @"Lesotho"                                      : @"+266",
                            @"Liberia"                                      : @"+231",
                            @"Libya"                                        : @"+218",
                            @"Liechtenstein"                                : @"+423",
                            @"Lithuania"                                    : @"+370",
                            @"Luxembourg"                                   : @"+352",
                            @"Macau SAR China"                              : @"+853",
                            @"Macedonia"                                    : @"+389",
                            @"Madagascar"                                   : @"+261",
                            @"Malawi"                                       : @"+265",
                            @"Malaysia"                                     : @"+60",
                            @"Maldives"                                     : @"+960",
                            @"Mali"                                         : @"+223",
                            @"Malta"                                        : @"+356",
                            @"Marshall Islands"                             : @"+692",
                            @"Martinique"                                   : @"+596",
                            @"Mauritania"                                   : @"+222",
                            @"Mauritius"                                    : @"+230",
                            @"Mayotte"                                      : @"+262",
                            @"Mexico"                                       : @"+52",
                            @"Micronesia"                                   : @"+691",
                            @"Midway Island"                                : @"+1 808",
                            @"Micronesia"                                   : @"+691",
                            @"Moldova"                                      : @"+373",
                            @"Monaco"                                       : @"+377",
                            @"Mongolia"                                     : @"+976",
                            @"Montenegro"                                   : @"+382",
                            @"Montserrat"                                   : @"+1664",
                            @"Morocco"                                      : @"+212",
                            @"Myanmar"                                      : @"+95",
                            @"Namibia"                                      : @"+264",
                            @"Nauru"                                        : @"+674",
                            @"Nepal"                                        : @"+977",
                            @"Netherlands"                                  : @"+31",
                            @"Netherlands Antilles"                         : @"+599",
                            @"Nevis"                                        : @"+1 869",
                            @"New Caledonia"                                : @"+687",
                            @"New Zealand"                                  : @"+64",
                            @"Nicaragua"                                    : @"+505",
                            @"Niger"                                        : @"+227",
                            @"Nigeria"                                      : @"+234",
                            @"Niue"                                         : @"+683",
                            @"Norfolk Island"                               : @"+672",
                            @"Northern Mariana Islands"                     : @"+1 670",
                            @"Norway"                                       : @"+47",
                            @"Oman"                                         : @"+968",
                            @"Pakistan"                                     : @"+92",
                            @"Palau"                                        : @"+680",
                            @"Palestinian Territory"                        : @"+970",
                            @"Panama"                                       : @"+507",
                            @"Papua New Guinea"                             : @"+675",
                            @"Paraguay"                                     : @"+595",
                            @"Peru"                                         : @"+51",
                            @"Philippines"                                  : @"+63",
                            @"Poland"                                       : @"+48",
                            @"Portugal"                                     : @"+351",
                            @"Puerto Rico"                                  : @"+1 787",
                            @"Puerto Rico"                                  : @"+1 939",
                            @"Qatar"                                        : @"+974",
                            @"Reunion"                                      : @"+262",
                            @"Romania"                                      : @"+40",
                            @"Russia"                                       : @"+7",
                            @"Rwanda"                                       : @"+250",
                            @"Samoa"                                        : @"+685",
                            @"San Marino"                                   : @"+378",
                            @"Saudi Arabia"                                 : @"+966",
                            @"Senegal"                                      : @"+221",
                            @"Serbia"                                       : @"+381",
                            @"Seychelles"                                   : @"+248",
                            @"Sierra Leone"                                 : @"+232",
                            @"Singapore"                                    : @"+65",
                            @"Slovakia"                                     : @"+421",
                            @"Slovenia"                                     : @"+386",
                            @"Solomon Islands"                              : @"+677",
                            @"South Africa"                                 : @"+27",
                            @"South Georgia and the South Sandwich Islands" : @"+500",
                            @"Spain"                                        : @"+34",
                            @"Sri Lanka"                                    : @"+94",
                            @"Sudan"                                        : @"+249",
                            @"Suriname"                                     : @"+597",
                            @"Swaziland"                                    : @"+268",
                            @"Sweden"                                       : @"+46",
                            @"Switzerland"                                  : @"+41",
                            @"Syria"                                        : @"+963",
                            @"Taiwan"                                       : @"+886",
                            @"Tajikistan"                                   : @"+992",
                            @"Tanzania"                                     : @"+255",
                            @"Thailand"                                     : @"+66",
                            @"Timor Leste"                                  : @"+670",
                            @"Togo"                                         : @"+228",
                            @"Tokelau"                                      : @"+690",
                            @"Tonga"                                        : @"+676",
                            @"Trinidad and Tobago"                          : @"+1 868",
                            @"Tunisia"                                      : @"+216",
                            @"Turkey"                                       : @"+90",
                            @"Turkmenistan"                                 : @"+993",
                            @"Turks and Caicos Islands"                     : @"+1 649",
                            @"Tuvalu"                                       : @"+688",
                            @"Uganda"                                       : @"+256",
                            @"Ukraine"                                      : @"+380",
                            @"United Arab Emirates"                         : @"+971",
                            @"United Kingdom"                               : @"+44",
                            @"United States"                                : @"+1",
                            @"Uruguay"                                      : @"+598",
                            @"U.S. Virgin Islands"                          : @"+1 340",
                            @"Uzbekistan"                                   : @"+998",
                            @"Vanuatu"                                      : @"+678",
                            @"Venezuela"                                    : @"+58",
                            @"Vietnam"                                      : @"+84",
                            @"Wake Island"                                  : @"+1 808",
                            @"Wallis and Futuna"                            : @"+681",
                            @"Yemen"                                        : @"+967",
                            @"Zambia"                                       : @"+260",
                            @"Zanzibar"                                     : @"+255",
                            @"Zimbabwe"                                     : @"+263"
                            };
    
    return codes;
}

+(NSDictionary*)getCountryFromServerData{
    
    NSDictionary* country=[[NSUserDefaults standardUserDefaults]objectForKey:COUNTRY_LIST];
    return country;
}

+(NSString*)getSelectedCountryKeyWithValue:(NSString*)value{
    
    NSDictionary* country=[[NSUserDefaults standardUserDefaults]objectForKey:COUNTRY_LIST];
    
    NSArray* arrCountryKeys=[country allKeysForObject:value];
    NSString* countryKey=arrCountryKeys.count ? arrCountryKeys[0]: nil;
    
    return countryKey;
    
}

+(NSString*)getSelectedCountryValueWithKey:(NSString*)key{
    
    NSDictionary* country=[[NSUserDefaults standardUserDefaults]objectForKey:COUNTRY_LIST];
    
    
    NSString* countryKey=[country objectForKey:key];
    
    return countryKey;
    
}

+(NSArray*)getAllValuesFromDictionary:(NSDictionary*)data{
        
        NSArray* keys=[data allKeys];
        NSMutableArray* arrObjects=[[NSMutableArray alloc]init];
        
        for (NSString* key in keys) {
                
                [arrObjects addObject:[data objectForKey:key]];
                
        }
        arrObjects=arrObjects.count ? arrObjects :nil;
        
        return arrObjects;
        
}


+(NSString*)getSelectedLanguageKeyWithValue:(NSString*)value data:(NSDictionary*)data{
    
    NSArray* arrCountryKeys=[data allKeysForObject:value];
    NSString* countryKey=arrCountryKeys.count ? arrCountryKeys[0]: nil;
    
    return countryKey;
    
}

+(NSArray*)getLanguageNamelist{
    NSArray* language=[[NSArray alloc]initWithObjects:
                       @"English (U.S.)",
                       @"English (UK)",
                       @"French (France)",
                       @"German",
                       @"Traditional Chinese",
                       @"Simplified Chinese",
                       @"Dutch",
                       @"Italian",
                       @"Spanish",
                       @"Portuguese (Brazil)",
                       @"Portuguese (Portugal)",
                       @"Danish",
                       @"Swedish",
                       @"Finnish",
                       @"Norwegian",
                       @"Korean",
                       @"Japanese",
                       @"Russian",
                       @"Polish",
                       @"Turkish",
                       @"Ukrainian",
                       @"Hungarian",
                       @"Arabic",
                       @"Thai",
                       @"Czech",
                       @"Greek",
                       @"Hebrew",
                       @"Indonesi",
                       @"Malay",
                       @"Romanian",
                       @"Slovak",
                       @"Croatian",
                       @"Catalan",
                       @"Vietnamese"
                       , nil];
    return language;
}

+(NSMutableArray *)removeViewControllFromNavArray:(int)number navigation:(UINavigationController*)class{
    
    NSMutableArray *navigationArray = [[NSMutableArray alloc] initWithArray: class.viewControllers];
    int count=0;
    if(number<navigationArray.count)
        for (int i= (int)navigationArray.count; i>=1; i--) {
            
            if(count==number)   break;
            
            [navigationArray removeLastObject];
            
            count++;
        }
    return navigationArray;
    
}


+(NSString*) bv_jsonStringWithDictionary:(NSDictionary*)dictionary {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    if (! jsonData) {
        NSLog(@"bv_jsonStringWithPrettyPrint: error: %@", error.localizedDescription);
        return @"{}";
    } else {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
}

+(NSString*)jsonStringWithDictionary:(NSDictionary*)data{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
        return nil;
    } else {
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        NSLog(@"jsonString->%@",jsonString);
        return jsonString;
    }
}


+(NSDictionary*)getDictionaryWithJsonString:(NSString*)string{
        NSError *error;
        
        NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data
                                                                     options:kNilOptions
                                                                       error:&error];
        
        return jsonResponse;
}

+(NSString*)getDeviceToken:(NSData*)deviceToken{
        
        NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"<>"]];
        token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        NSLog(@"*------------------------------*");
        NSLog(@"Device Token---%@", token);
        NSLog(@"*------------------------------*");
        return token;
}


/*
+(UIViewController*)getNavRoot{
        
        UIWindow *window;
        NSArray* arr=[UIApplication sharedApplication].windows;
        
        if(arr.count>=2)
                window= [[UIApplication sharedApplication].windows firstObject];
        else return nil;
        
        NSArray *viewControllers;
        
        
        if([window.rootViewController isKindOfClass:[CCKFNavDrawer class]])
                viewControllers= ((CCKFNavDrawer *)window.rootViewController).viewControllers;
        else return  nil;
        
        UIViewController* vc=[viewControllers lastObject];
        
        return vc;
        
        
//        if([vc isKindOfClass:[IIViewDeckController class]]){
//                IIViewDeckController* rvc=(IIViewDeckController*)vc;
//                NSArray *rvcArray=((UINavigationController *)rvc.centerController).viewControllers;
//                
//                
//                UIViewController* lastVC=[rvcArray lastObject];
//                
//                if(lastVC!=nil )
//                {
//                        
//                        return lastVC;
//                }
//                return nil;
//        }
        
        return nil;
}
*/
+(void)viewButtonCALayer:(UIColor *)yourColor viewButton:(UIButton *)yourButton{
        yourButton.layer.cornerRadius=0.0F;
        yourButton.layer.masksToBounds=YES;
        yourButton.layer.borderColor=[yourColor CGColor];
        yourButton.layer.borderWidth= 1.0f;
        
        [yourButton setTitleShadowColor:yourColor forState:UIControlStateNormal];
        yourButton.layer.shadowOffset = CGSizeMake(1.0, 1.0);
        yourButton.layer.shadowOpacity = 1.0;
        
        [yourButton setTitleColor:yourColor forState:UIControlStateNormal];
        
}

+(void)viewButtonCALayerClear:(UIButton *)yourButton{
        yourButton.layer.cornerRadius=0.0F;
        yourButton.layer.masksToBounds=YES;
        yourButton.layer.borderColor=[[UIColor clearColor] CGColor];
        yourButton.layer.borderWidth= 0.0f;
        
        [yourButton setTitleShadowColor:[UIColor clearColor] forState:UIControlStateNormal];
        yourButton.layer.shadowOffset = CGSizeMake(0.0, 0.0);
        yourButton.layer.shadowOpacity = 0.0;
         [yourButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

        
}

+(void)shadowAtBottom:(id)sender{
        UIView* view=(UIView*)sender;
        
        view.layer.cornerRadius = 1;
        view.layer.shadowColor = [[UIColor grayColor] CGColor];
        view.layer.shadowOpacity = 1;
        view.layer.shadowRadius = 2;
        view.layer.shadowOffset = CGSizeMake(0, 2);
}

+(void)shadowAtBottom1:(id)sender{
        UIView* view;
       
         if([sender isKindOfClass:[UITextView class]])
                view=(UITextView*)sender;
        else if([sender isKindOfClass:[UITextField class]])
                view=(UITextField*)sender;
        else if([sender isKindOfClass:[UILabel class]])
                view=(UILabel*)sender;       
        else if([sender isKindOfClass:[UIScrollView class]])
                view=(UIScrollView*)sender;
        else
                view=(UIView*)sender;

        view.layer.cornerRadius = 1;
        view.layer.shadowColor = [[self colorFromHexString:@"#D3D3D3"] CGColor];
        view.layer.shadowOpacity = 0.8;
        view.layer.shadowRadius = 0.5;
        view.layer.shadowOffset = CGSizeMake(0, 1);
}

+(void)shadowOnButtons:(UIButton*)sender{
        
        UIView* view;

        view = [[UIView alloc] initWithFrame:sender.bounds];
        view.backgroundColor = [UIColor clearColor];

        view.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:sender.frame
                                                           cornerRadius:sender.frame.size.height/2].CGPath;
        view.layer.shadowColor = [UIColor blackColor].CGColor;
        view.layer.shadowRadius = 3;
        view.layer.shadowOffset = CGSizeMake(0, 5);
        view.layer.shadowOpacity = .25;
        view.layer.cornerRadius = sender.frame.size.height/2;

        [sender.superview insertSubview:view belowSubview:sender];


}


+(NSString*)getTableNameWithUsername:(NSString*)name{
        
        
        //NSString *s = @"foo/bar:baz.foo";
        NSCharacterSet *doNotWant = [NSCharacterSet characterSetWithCharactersInString:@"-/:.@#$%^&*!"];
        name = [[name componentsSeparatedByCharactersInSet: doNotWant] componentsJoinedByString: @"_"];
        
        return name;
}

+(void)setShadowOnView:(UIView*)view{
        //Adds a shadow to sampleView
        CALayer *layer = view.layer;
        //        layer.shadowColor = [UIColor blackColor].CGColor;
        //        layer.shadowOpacity = 3;
        //        layer.shadowRadius = 1;
        //        layer.shadowOffset = CGSizeMake(0, 0);
        //        layer.masksToBounds = NO;
        
        layer.masksToBounds = NO;
        layer.shadowRadius = 0.8;
        layer.shadowOpacity = 0.95;
        layer.shadowColor = [[UIColor grayColor] CGColor];
        layer.shadowOffset = CGSizeMake(2, 3);;
        //        layer.shadowPath = [[UIBezierPath bezierPathWithRect:cell.viContainerUnread.bounds] CGPath];
}

+(NSString*)getRandomStringWithLength:(int)length{
        
        NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
        
        NSMutableString *randomString = [NSMutableString stringWithCapacity: length];
        
        for (int i=0; i<length; i++) {
                [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform((int)[letters length])]];
        }
        
        return randomString;
        
}

+ (void)downloadImageWithURL:(NSURL *)url completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock
{
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [NSURLConnection sendAsynchronousRequest:request
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                       if ( !error )
                                       {
                                               UIImage *image = [[UIImage alloc] initWithData:data];
                                               completionBlock(YES,image);
                                       } else{
                                               completionBlock(NO,nil);
                                       }
                               }];
}
/*
+(BLMultiColorLoader*)getLoaderWith:(CGRect)frame center:(CGPoint)center colors:(NSArray*)colors{
        
//        CGRect frame=CGRectMake(50, 50, 40, 40);
//        CGPoint center=CGPointMake( [UIScreen mainScreen].bounds.size.width/2,[UIScreen mainScreen].bounds.size.height/2);
//        
//        NSArray* colors=[NSArray arrayWithObjects:
//                         [UIColor redColor],
//                         [UIColor purpleColor],
//                         [UIColor greenColor],
//                         [UIColor blueColor], nil];
        
        BLMultiColorLoader *multiColorLoader=[[BLMultiColorLoader alloc]initWithFrame:frame];
        multiColorLoader.center=center;
        
        multiColorLoader.lineWidth = 3.0;
        multiColorLoader.colorArray = colors;
        
        return multiColorLoader;
        
}
*/
+(NSString*)getNameForImage{
        
        NSString* name = [NSString stringWithFormat:@"%lu.jpg",(unsigned long)([[NSDate date] timeIntervalSince1970]*10.0)];
        
        return name;
}

+(NSString*)trimString:(NSString*)string{
        
        [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        return string;
        
}

+(UIImage*)imageFromColor:(UIColor*)color {
        CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
        UIGraphicsBeginImageContext(rect.size);
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGContextSetFillColorWithColor(context, [color CGColor]);
        CGContextFillRect(context, rect);
        
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return image;
}

+(UIImage*)imageResize:(CGRect)size image:(UIImage*)image{
        
        CGRect rect = size;
        UIGraphicsBeginImageContext( rect.size );
        [image drawInRect:rect];
        UIImage *picture1 = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        NSData *imageData = UIImagePNGRepresentation(picture1);
        UIImage *img=[UIImage imageWithData:imageData];
        return img;
}

+(UIImage*)imageResizeScale:(CGSize)size image:(UIImage*)image{
        
        float oldWidth = image.size.width;
        float scaleFactor = size.width/ oldWidth;
        
        float newHeight = image.size.height * scaleFactor;
        float newWidth = oldWidth * scaleFactor;
        
        UIGraphicsBeginImageContext( CGSizeMake(newWidth, newHeight) );
        [image drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
        UIImage *picture1 = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        NSData *imageData = UIImagePNGRepresentation(picture1);
        UIImage *img=[UIImage imageWithData:imageData];
        return img;
}

+(UIImage*)imageResizeScale: (UIImage*) sourceImage scaledToWidth: (float) i_width
{
        float oldWidth = sourceImage.size.width;
        float scaleFactor = i_width / oldWidth;
        
        float newHeight = sourceImage.size.height * scaleFactor;
        float newWidth = oldWidth * scaleFactor;
        
        UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
        [sourceImage drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return newImage;
}

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)size {
        if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
                UIGraphicsBeginImageContextWithOptions(size, NO, [[UIScreen mainScreen] scale]);
        } else {
                UIGraphicsBeginImageContext(size);
        }
        [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return newImage;
}

+ (UIImage *)imageWithImage:(UIImage *)image scaledToMaxWidth:(CGFloat)width maxHeight:(CGFloat)height {
        CGFloat oldWidth = image.size.width;
        CGFloat oldHeight = image.size.height;
        
        CGFloat scaleFactor = (oldWidth > oldHeight) ? width / oldWidth : height / oldHeight;
        
        CGFloat newHeight = oldHeight * scaleFactor;
        CGFloat newWidth = oldWidth * scaleFactor;
        CGSize newSize = CGSizeMake(newWidth, newHeight);
        
        return [self imageWithImage:image scaledToSize:newSize];
}

+(void)changeImageColor:(UIImage* )image imageView:(UIImageView*)imageView andColor:(UIColor *)yourColor{
        imageView.image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [imageView setTintColor: yourColor];
}

+ (CGFloat)getLabelHeight:(UILabel*)label{
        
        
        CGSize constraint = CGSizeMake(label.frame.size.width, 20000.0f);
        CGSize size;
        
        CGSize boundingBox = [label.text boundingRectWithSize:constraint
                                                      options:NSStringDrawingUsesLineFragmentOrigin
                                                   attributes:@{NSFontAttributeName:label.font}
                                                      context:nil].size;
        
        size = CGSizeMake(ceil(boundingBox.width), ceil(boundingBox.height));
        
        return size.height;
}

+ (int)getLabelLength:(UILabel*)label height:(int)height{
        
        NSString* text=label.text;
        int i=0;
        while (true) {
                
                NSString *newString = [text substringWithRange:NSMakeRange(0, i)];
                
                label.text=newString;
                int h=[self getLabelHeight:label];
                
                if(h>=height) break;
                
                i++;
                
        }
        return i;
}

+ (NSUInteger)getLength:(NSString *)string intoLabel:(UILabel *)label{
        UIFont *font           = label.font;
        NSLineBreakMode mode   = label.lineBreakMode;
        
        CGFloat labelWidth     = label.frame.size.width;
        CGFloat labelHeight    = label.frame.size.height;
        CGSize  sizeConstraint = CGSizeMake(labelWidth, CGFLOAT_MAX);
        
        if (SYSTEM_VERSION_GREATER_THAN(@"7"))
        {
                NSDictionary *attributes = @{ NSFontAttributeName : font };
                NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:string attributes:attributes];
                CGRect boundingRect = [attributedText boundingRectWithSize:sizeConstraint options:NSStringDrawingUsesLineFragmentOrigin context:nil];
                {
                        if (boundingRect.size.height > labelHeight)
                        {
                                NSUInteger index = 0;
                                NSUInteger prev;
                                NSCharacterSet *characterSet = [NSCharacterSet whitespaceAndNewlineCharacterSet];
                                
                                do
                                {
                                        prev = index;
                                        if (mode == NSLineBreakByCharWrapping)
                                                index++;
                                        else
                                                index = [string rangeOfCharacterFromSet:characterSet options:0 range:NSMakeRange(index + 1, [string length] - index - 1)].location;
                                }
                                
                                while (index != NSNotFound && index < [string length] && [[string substringToIndex:index] boundingRectWithSize:sizeConstraint options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.height <= labelHeight);
                                
                                return prev;
                        }
                }
        }
        else
        {
                if ([string sizeWithFont:font constrainedToSize:sizeConstraint lineBreakMode:mode].height > labelHeight)
                {
                        NSUInteger index = 0;
                        NSUInteger prev;
                        NSCharacterSet *characterSet = [NSCharacterSet whitespaceAndNewlineCharacterSet];
                        
                        do
                        {
                                prev = index;
                                if (mode == NSLineBreakByCharWrapping)
                                        index++;
                                else
                                        index = [string rangeOfCharacterFromSet:characterSet options:0 range:NSMakeRange(index + 1, [string length] - index - 1)].location;
                        }
                        
                        while (index != NSNotFound && index < [string length] && [[string substringToIndex:index] sizeWithFont:font constrainedToSize:sizeConstraint lineBreakMode:mode].height <= labelHeight);
                        
                        return prev;
                }
        }
        
        return [string length];
}


+ (CGFloat)getLabelLines:(UILabel*)label{
        
        
        CGSize constraint = CGSizeMake(label.frame.size.width, 20000.0f);
        CGSize size;
        
        CGSize boundingBox = [label.text boundingRectWithSize:constraint
                                                      options:NSStringDrawingUsesLineFragmentOrigin
                                                   attributes:@{NSFontAttributeName:label.font}
                                                      context:nil].size;
        
        size = CGSizeMake(ceil(boundingBox.width), ceil(boundingBox.height));
        
        return size.height/label.font.pointSize;
}

+ (CGFloat)getTextViewHeight:(UITextView*)label{
        
        
        CGFloat fixedWidth = label.frame.size.width;
        CGSize newSize = [label sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
        CGRect newFrame = label.frame;
        newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
        label.frame = newFrame;
        
        return label.frame.size.height;
}


+(NSString *)removeHTMLTags:(NSString*)text {
        NSRange r;
        if(text==nil) return nil;
        NSString *s = text;
        while ((r = [s rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
                s = [s stringByReplacingCharactersInRange:r withString:@""];
        return s;
}

+(NSArray*)getSortedList:(NSArray*)list key:(NSString*)key ascending:(BOOL)ascending{
        NSSortDescriptor * brandDescriptor = [[NSSortDescriptor alloc] initWithKey:key
                                                                         ascending:ascending];
        
        NSArray * sortedArray = [list sortedArrayUsingDescriptors:@[brandDescriptor]];
        
        return sortedArray;
}

/*
+(void)addAlertView:(UIViewController*)vc{
        AlertCustomView* alertView = [[[NSBundle mainBundle] loadNibNamed:@"AlertCustomView" owner:self options:nil] objectAtIndex:0];
        alertView.tag=1001;
        //        [alertView.btnOk addTarget:self action:@selector(okbuttonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        
        UITapGestureRecognizer *tapIt = [[UITapGestureRecognizer alloc] initWithTarget:alertView
                                                                                action:@selector(tapOnAlert:)];
        //        for (UIView* subview in self.view.subviews) {
        //
        //                [subview addGestureRecognizer:tapIt];
        //        }
        [vc.view addGestureRecognizer:tapIt];
        
        CGRect frame=alertView.frame;
        frame.origin=CGPointMake(vc.view.frame.size.width/2-frame.size.width/2,
                                 vc.view.frame.size.height/3-frame.size.height/2);
        alertView.frame=frame;
        [alertView config];
        
        [Alert shadowAtBottom:alertView];
        
//        [vc.view addSubview:alertView];
        
        UIView* viBackground=[[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        viBackground.tag=1000;
        viBackground.backgroundColor=[UIColor clearColor];
        [viBackground addSubview:alertView];

       
//        self.view.barStyle = UIBarStyleBlack; // this will give a black blur as in the original post
        viBackground.opaque = NO;
        viBackground.alpha = 0.5;
        viBackground.backgroundColor = [UIColor colorWithWhite:0.3 alpha:1];
        [vc.view addSubview:viBackground];
        [vc.view addSubview:alertView];
        

        
        alertView.hidden = NO;
        alertView.alpha = 0.1;
        [UIView animateWithDuration:0.25 animations:^{
                alertView.alpha = 1.0f;
        } completion:^(BOOL finished) {
                // do some
        }];
        
}

+(void)addAlertViewWithMessage:(NSString*)msg view:(UIViewController*)vc{
        AlertCustomView* alertView = [[[NSBundle mainBundle] loadNibNamed:@"AlertCustomView" owner:self options:nil] objectAtIndex:0];
        alertView.tag=1001;
        //        [alertView.btnOk addTarget:self action:@selector(okbuttonAction:) forControlEvents:UIControlEventTouchUpInside];
        if(msg) alertView.message=msg;
        
        UITapGestureRecognizer *tapIt = [[UITapGestureRecognizer alloc] initWithTarget:alertView
                                                                                action:@selector(tapOnAlert:)];
        //        for (UIView* subview in self.view.subviews) {
        //
        //                [subview addGestureRecognizer:tapIt];
        //        }
        
        
//        [alertView.btnOk addTarget:alertView action:@selector(tapOnAlert:) forControlEvents:UIControlEventTouchUpInside];
        
//        [vc.view addGestureRecognizer:tapIt];
        
        [alertView.btnOk addGestureRecognizer:tapIt];
        
        CGRect frame=alertView.frame;
        frame.origin=CGPointMake(vc.view.frame.size.width/2-frame.size.width/2,
                                 vc.view.frame.size.height/3-frame.size.height/2);
        alertView.frame=frame;
        [alertView config];
        
        [Alert shadowAtBottom:alertView];
        
        //        [vc.view addSubview:alertView];
        
        UIView* viBackground=[[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        viBackground.tag=1000;
        viBackground.backgroundColor=[UIColor clearColor];
//        [viBackground addSubview:alertView];
        
        
        //        self.view.barStyle = UIBarStyleBlack; // this will give a black blur as in the original post
        viBackground.opaque = NO;
        viBackground.alpha = 0.5;
        viBackground.backgroundColor = [UIColor colorWithWhite:0.3 alpha:1];
        [vc.view addSubview:viBackground];
        [vc.view addSubview:alertView];
        
        
        
        alertView.hidden = NO;
        alertView.alpha = 0.1;
        [UIView animateWithDuration:0.25 animations:^{
                alertView.alpha = 1.0f;
        } completion:^(BOOL finished) {
                // do some
        }];
        
}

+(void)removeAlertView:(UIViewController*)vc{
        
        
        for (UIView* view in vc.view.subviews) {
                if(view.tag==1000 || view.tag==1001)//if([view isKindOfClass:[AlertCustomView class]])
                {
                        [UIView animateWithDuration:0.25 animations:^{
                                [view setAlpha:0.1f];
                        } completion:^(BOOL finished) {
                                view.hidden = YES;
                                [view removeFromSuperview];
                        }];
                }
        }
        
}


+(void)addToolTipView:(UIViewController*)vc{
        AlertCustomView* alertView = [[[NSBundle mainBundle] loadNibNamed:@"AlertCustomView" owner:self options:nil] objectAtIndex:0];
        alertView.tag=1001;
        //        [alertView.btnOk addTarget:self action:@selector(okbuttonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        
        UITapGestureRecognizer *tapIt = [[UITapGestureRecognizer alloc] initWithTarget:alertView
                                                                                action:@selector(tapOnAlert:)];
        //        for (UIView* subview in self.view.subviews) {
        //
        //                [subview addGestureRecognizer:tapIt];
        //        }
        [vc.view addGestureRecognizer:tapIt];
        
        CGRect frame=alertView.frame;
        frame.origin=CGPointMake(vc.view.frame.size.width/2-frame.size.width/2,
                                 vc.view.frame.size.height/3-frame.size.height/2);
        alertView.frame=frame;
        [alertView config];
        
        [Alert shadowAtBottom:alertView];
        
        //        [vc.view addSubview:alertView];
        
        UIView* viBackground=[[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        viBackground.tag=1000;
        viBackground.backgroundColor=[UIColor clearColor];
        [viBackground addSubview:alertView];
        
        
        //        self.view.barStyle = UIBarStyleBlack; // this will give a black blur as in the original post
        viBackground.opaque = NO;
        viBackground.alpha = 0.5;
        viBackground.backgroundColor = [UIColor colorWithWhite:0.3 alpha:1];
        [vc.view addSubview:viBackground];
        [vc.view addSubview:alertView];
        
        
        
        alertView.hidden = NO;
        alertView.alpha = 0.1;
        [UIView animateWithDuration:0.25 animations:^{
                alertView.alpha = 1.0f;
        } completion:^(BOOL finished) {
                // do some
        }];
        
}
 
 */

+(void)openMapWithSourceName:(NSString*)source destinationName:(NSString*)destination{
        
        NSString *webUrl = [NSString stringWithFormat:@"http://maps.apple.com/?daddr=%@&saddr=%@",destination,source];
        NSURL *url = [NSURL URLWithString:[webUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        [[UIApplication sharedApplication] openURL: url];
}

+(void)openMapWithSource:(NSString*)sourceName
             destination:(NSString*)destinationName
                    sLat:(float)sLat
                   sLong:(float)sLong
                    dLat:(float)dLat
                  dLong:(float)dLong{
        
//        String uri = String.format(Locale.ENGLISH, "http://maps.google.com/maps?saddr=%f,%f(%s)&daddr=%f,%f (%s)", fromLatitude, fromLongitude, sourceText, toLatitude, toLongitude, destinationText);
        
        NSString *webUrl = [NSString stringWithFormat:@"http://maps.apple.com/?saddr=%@ (%f,%f)&daddr=%@ (%f,%f)",sourceName,sLat,sLong,destinationName,dLat,dLong];
        NSURL *url = [NSURL URLWithString:[webUrl stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
        NSString *urlStr = [NSString stringWithFormat:@"%@",url];
        [[UIApplication sharedApplication] openURL: [NSURL URLWithString: urlStr]];
}

+(NSIndexPath*)getIndexPath:(NSInteger)index section:(NSInteger)section{
        
        return [NSIndexPath indexPathForRow:index inSection:section];
}

+(NSIndexPath *) getIndexPathWithButton:(UIButton *)button table:(UITableView*)table{
        CGRect buttonFrame = [button convertRect:button.bounds toView:table];
        return [table indexPathForRowAtPoint:buttonFrame.origin];
}

+(NSIndexPath *) getIndexPathWithButton:(UIButton *)button collection:(UICollectionView*)collection{
        CGRect buttonFrame = [button convertRect:button.bounds toView:collection];
        return [collection indexPathForItemAtPoint:buttonFrame.origin];
}

+(NSIndexPath*)getIndexPathWithTextfield:(UITextField*)textField table:(UITableView*)table{
        
        UITableViewCell *textFieldRowCell;
        
        if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
                // Load resources for iOS 6.1 or earlier
                textFieldRowCell = (UITableViewCell *) textField.superview.superview;
                
        } else {
                // Load resources for iOS 7 or later
                textFieldRowCell = (UITableViewCell *) textField.superview.superview.superview;
                // TextField -> UITableVieCellContentView -> (in iOS 7!)ScrollView -> Whoola!
        }
        
        NSIndexPath *indexPath = [table indexPathForCell:textFieldRowCell];
        
        return indexPath;
}

+(NSIndexPath*)getIndexPathWithTextView:(UITextView*)textView table:(UITableView*)table{
        
        UIView *cell = textView;
        while (cell && ![cell isKindOfClass:[UITableViewCell class]])
                cell = cell.superview;
        
        //use the UITableViewCell superview to get the NSIndexPath
        NSIndexPath *indexPath = [table indexPathForRowAtPoint:cell.center];
        
        return indexPath;
}

+(NSString*)getYoutubeVideoThumbnail:(NSString*)youTubeVideoId{
        
        NSString* thumbImageUrl = [NSString stringWithFormat:@"http://img.youtube.com/vi/%@/0.jpg",youTubeVideoId];
        
        return thumbImageUrl;
}


+ (NSString *)getYoutubeIdFromLink:(NSString *)link {
        NSString *regexString = @"((?<=(v|V)/)|(?<=be/)|(?<=(\\?|\\&)v=)|(?<=embed/))([\\w-]++)";
        NSRegularExpression *regExp = [NSRegularExpression regularExpressionWithPattern:regexString
                                                                                options:NSRegularExpressionCaseInsensitive
                                                                                  error:nil];
        
        NSArray *array = [regExp matchesInString:link options:0 range:NSMakeRange(0,link.length)];
        if (array.count > 0) {
                NSTextCheckingResult *result = array.firstObject;
                return [link substringWithRange:result.range];
        }
        return nil;
}

+(void)attributedString:(UITextField*)txt msg:(NSString*)msg color:(UIColor*)color{
        
        if(txt && msg && color)
        txt.attributedPlaceholder = [[NSAttributedString alloc] initWithString:msg attributes:@{ NSForegroundColorAttributeName : color }];
}


+(UIImage *)thumbnailFromVideoAtURL:(NSURL *)contentURL{
        UIImage *theImage = nil;
        AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:contentURL options:nil];
        AVAssetImageGenerator *generator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
        generator.appliesPreferredTrackTransform = YES;
        NSError *err = NULL;
        CMTime time = CMTimeMake(1, 60);
        CGImageRef imgRef = [generator copyCGImageAtTime:time actualTime:NULL error:&err];
        
        theImage = [[UIImage alloc] initWithCGImage:imgRef];
        
        CGImageRelease(imgRef);
        
        return theImage;
}

- (BOOL)isNull{
        if (!self) return YES;
        else if ((id)self == [NSNull null]) return YES;
        else if ([self isKindOfClass:[NSString class]]) {
                return ([((NSString *)self)isEqualToString : @""]
                        || [((NSString *)self)isEqualToString : @"null"]
                        || [((NSString *)self)isEqualToString : @"<null>"]
                        || [((NSString *)self)isEqualToString : @"(null)"]
                        );
        }
        return NO;
        
}

+ (NSDictionary *) dictionaryByReplacingNullsWithString:(NSString*)string  dic:(NSDictionary*)dic{
        NSMutableDictionary *replaced = [NSMutableDictionary dictionaryWithDictionary: dic];
        
        
        NSString *blank = string;
        
        [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                if ([obj isNull]) {
                        [replaced setObject:blank forKey: key];
                }
                else if ([obj isKindOfClass: [NSDictionary class]]) {
                        [replaced setObject: [self dictionaryByReplacingNullsWithString:string dic:(NSDictionary *) obj] forKey: key];
                }
                else if ([obj isKindOfClass: [NSArray class]]) {
                        [replaced setObject: [self dictionaryByReplacingNullsWithString:string arr:(NSArray *) obj] forKey: key];
                }
        }];
        
        return replaced ;
}

+ (NSArray *) dictionaryByReplacingNullsWithString:(NSString*)string  arr:(NSArray*)arr{
        
        NSMutableArray* arrResult=[[NSMutableArray alloc]initWithArray:arr];
        for (int i=0; i<arrResult.count; i++) {
                
                id dic = arrResult[i];
                
                if ([dic isKindOfClass: [NSString class]] || [dic isKindOfClass: [NSNumber class]]) {
                
                        arrResult[i]=dic;
                }
                else  if ([dic isNull]){
                        arrResult[i]=string;
                }
                else{
                        NSMutableDictionary *replaced = [NSMutableDictionary dictionaryWithDictionary: dic];                        
                        
                        NSString *blank = string;
                        
                        [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                                if ([obj isNull]) {
                                        [replaced setObject:blank forKey: key];
                                }
                                else if ([obj isKindOfClass: [NSDictionary class]]) {
                                        [replaced setObject: [self dictionaryByReplacingNullsWithString:string dic:(NSDictionary *) obj] forKey: key];
                                }
                                else if ([obj isKindOfClass: [NSArray class]]) {
                                        [replaced setObject: [self dictionaryByReplacingNullsWithString:string arr:(NSArray *) obj] forKey: key];
                                }
                        }];
                        arrResult[i]=replaced;
                }
                
                
        }
        
        return arrResult ;
}

+(id)removedNullsWithString:(NSString*)string obj:(id)obj{
        
        id result;
        
        if([obj isKindOfClass:[NSDictionary class]])
                result=[self dictionaryByReplacingNullsWithString:string dic:obj];
        else if([obj isKindOfClass:[NSArray class]])
                result=[self dictionaryByReplacingNullsWithString:string arr:obj];
        else result=obj;
        return result;
        
}


+(NSMutableURLRequest*)getRequestUploadImageWithPostString:(NSString*)postString
                                                 urlString:(NSString*)urlString
                                                    images:(NSArray*)images
{
        
        NSData *postData = [postString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        NSURL *url = [NSURL URLWithString:urlString];
        NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
        [theRequest setHTTPMethod:@"POST"];
        [theRequest setValue:nil forHTTPHeaderField:@"Content-Length"];
        
        //imagename
        //imagedata
        //imagekey
        if(images.count){
                NSMutableData *body = [NSMutableData data];
                NSString *boundary = @"---------------------------14737809831466499882746641449";
                NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
                [theRequest addValue:contentType forHTTPHeaderField: @"Content-Type"];
                
                //Images
                for (NSDictionary* dic in images) {
                        
                        
                        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                        
                        NSString *profileImageName=[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n",[dic objectForKey:@"imagekey"],[dic objectForKey:@"imagename"]];
                        [body appendData:[profileImageName dataUsingEncoding:NSUTF8StringEncoding]];
                        
                        [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                        [body appendData:[NSData dataWithData:[dic objectForKey:@"imagedata"]]];
                        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                        
                }
                
                
                //  parameter username
                
                [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                
                [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"data\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
                
                [body appendData:postData];
                
                [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                
                [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                
                
                // setting the body of the post to the reqeust
                [theRequest setHTTPBody:body];
        }
        else{
                [theRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                [theRequest setHTTPBody:postData];
        }
        
        return theRequest;
        
}

+(NSMutableURLRequest*)getRequesteWithPostString:(NSString*)postString
                                       urlString:(NSString*)urlString
                                      methodType:(NSString*)methodType
                                          images:(NSArray*)images
{
        
        
        NSData *postData = [postString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        NSURL *url = [NSURL URLWithString:urlString];
        NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
        [theRequest setHTTPMethod:methodType];
        [theRequest setValue:nil forHTTPHeaderField:@"Content-Length"];
        
        if([methodType isEqualToString:@"GET"]) {
                postData=nil;
                images=nil;
        }
        
        //imagename
        //imagedata
        //imagekey
        if(images.count){
                NSMutableData *body = [NSMutableData data];
                NSString *boundary = @"---------------------------14737809831466499882746641449";
                NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
                [theRequest addValue:contentType forHTTPHeaderField: @"Content-Type"];
                
                //Images
                for (NSDictionary* dic in images) {
                        
                        
                        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                        
                        NSString *profileImageName=[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n",[dic objectForKey:@"imagekey"],[dic objectForKey:@"imagename"]];
                        [body appendData:[profileImageName dataUsingEncoding:NSUTF8StringEncoding]];
                        
                        [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                        [body appendData:[NSData dataWithData:[dic objectForKey:@"imagedata"]]];
                        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                        
                }
                
                
                //  parameter username
                
                [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                
                [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"data\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
                
                [body appendData:postData];
                
                [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                
                [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                
                
                // setting the body of the post to the reqeust
                [theRequest setHTTPBody:body];
        }
        else{
                [theRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                [theRequest setHTTPBody:postData];
        }
        
        return theRequest;
        
}

+(NSMutableURLRequest*)getOnlyRequesteWithUrlString:(NSString*)postString
                                          urlString:(NSString*)urlString
                                      methodType:(NSString*)methodType
                                          images:(NSArray*)images
{
        
        NSData *postData = [postString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        NSURL *url = [NSURL URLWithString:urlString];
        NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
        [theRequest setHTTPMethod:methodType];
        [theRequest setValue:nil forHTTPHeaderField:@"Content-Length"];
        
        if(images.count){
                NSString *boundary = @"---------------------------14737809831466499882746641449";
                NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
                [theRequest addValue:contentType forHTTPHeaderField: @"Content-Type"];
        }
        else{
                [theRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                [theRequest setHTTPBody:postData];
        }
        
        return theRequest;
        
}

+(NSMutableData*)getBodyForMultipartDataWithPostString:(NSString*)postString
                                                images:(NSArray*)images{

        NSMutableData *body = [NSMutableData data];
        NSData *postData = [postString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];

        //imagename
        //imagedata
        //imagekey
        if(images.count){
                NSString *boundary = @"---------------------------14737809831466499882746641449";
                
                //Images
                for (NSDictionary* dic in images) {
                        
                        
                        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                        
                        NSString *profileImageName=[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n",[dic objectForKey:@"imagekey"],[dic objectForKey:@"imagename"]];
                        [body appendData:[profileImageName dataUsingEncoding:NSUTF8StringEncoding]];
                        
                        [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                        [body appendData:[NSData dataWithData:[dic objectForKey:@"imagedata"]]];
                        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                        
                }
                
                
                //  parameter username
                
                [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                
                [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"data\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
                
                [body appendData:postData];
                
                [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                
                [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                
                
        }
        
        return  images.count ? body : nil;
        
        
}




+(NSString*)getClassNameFromObject:(id)obj{
        return  NSStringFromClass([obj class]);
}

+(NSString*)getFormatedNumber:(NSString*)number{
        
        //        int value = 200000;
        NSNumberFormatter * formatter = [NSNumberFormatter new];
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
        NSString * newString =  [formatter stringFromNumber:[NSNumber numberWithFloat:[number floatValue]]];
        
        return newString;
}

+(void)setShadowOnViewAtTop:(UIView*)view{
        
        view.layer.masksToBounds = NO;
        view.layer.shadowColor = [UIColor grayColor].CGColor;
        view.layer.shadowOpacity = 1;
        view.layer.shadowRadius = 3;
        view.layer.shadowOffset = CGSizeMake(0.0f, -1.0f);
}
+(void)setShadowOnViewAtBottom:(UIView*)view{
        
        view.layer.masksToBounds = NO;
        view.layer.shadowColor = [UIColor grayColor].CGColor;
        view.layer.shadowOpacity = 1;
        view.layer.shadowRadius = 3;
        view.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
}

#pragma User Defaults custom methods

+(BOOL)saveToLocal:(id)object  key:(NSString*)key{
        
        [[NSUserDefaults standardUserDefaults]setObject:object forKey:key];
        
      return  [[NSUserDefaults standardUserDefaults]synchronize];
}

+(BOOL)removeFromLocalWithKey:(NSString*)key{
        
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:key];
        
        return  [[NSUserDefaults standardUserDefaults]synchronize];
}

+(id)getFromLocal:(NSString*)key{
        
        return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

//Metallic grey gradient background
+ (CAGradientLayer*) greyGradient {
        
        UIColor *colorOne = [UIColor colorWithWhite:0.9 alpha:1.0];
        UIColor *colorTwo = [UIColor colorWithHue:0.625 saturation:0.0 brightness:0.85 alpha:1.0];
        UIColor *colorThree     = [UIColor colorWithHue:0.625 saturation:0.0 brightness:0.7 alpha:1.0];
        UIColor *colorFour = [UIColor colorWithHue:0.625 saturation:0.0 brightness:0.4 alpha:1.0];
        
        NSArray *colors =  [NSArray arrayWithObjects:(id)colorOne.CGColor, colorTwo.CGColor, colorThree.CGColor, colorFour.CGColor, nil];
        
        NSNumber *stopOne = [NSNumber numberWithFloat:0.0];
        NSNumber *stopTwo = [NSNumber numberWithFloat:0.02];
        NSNumber *stopThree     = [NSNumber numberWithFloat:0.99];
        NSNumber *stopFour = [NSNumber numberWithFloat:1.0];
        
        NSArray *locations = [NSArray arrayWithObjects:stopOne, stopTwo, stopThree, stopFour, nil];
        CAGradientLayer *headerLayer = [CAGradientLayer layer];
        headerLayer.colors = colors;
        headerLayer.locations = locations;
        
        return headerLayer;
        
}

//Blue gradient background
+ (CAGradientLayer*) blueGradient {
        
        UIColor *colorOne = [UIColor colorWithRed:(120/255.0) green:(135/255.0) blue:(150/255.0) alpha:1.0];
        UIColor *colorTwo = [UIColor colorWithRed:(57/255.0)  green:(79/255.0)  blue:(96/255.0)  alpha:1.0];
        
        NSArray *colors = [NSArray arrayWithObjects:(id)colorOne.CGColor, colorTwo.CGColor, nil];
        NSNumber *stopOne = [NSNumber numberWithFloat:0.0];
        NSNumber *stopTwo = [NSNumber numberWithFloat:1.0];
        
        NSArray *locations = [NSArray arrayWithObjects:stopOne, stopTwo, nil];
        
        CAGradientLayer *headerLayer = [CAGradientLayer layer];
        headerLayer.colors = colors;
        headerLayer.locations = locations;
        
        return headerLayer;
        
}

+(void)setGradientWithGrayColor:(UIView*)view{
        
        CAGradientLayer *bg = [self greyGradient];
        bg.frame = view.bounds;
        [view.layer insertSublayer:bg atIndex:0];
}

+(void)setGradientWithBlueColor:(UIView*)view{
        
        CAGradientLayer *bg = [self blueGradient];
        bg.frame = view.bounds;
        [view.layer insertSublayer:bg atIndex:0];
}

+(void)reloadSection:(NSInteger)section table:(UITableView*)table {
        
        NSRange range = NSMakeRange(section, 1);
        NSIndexSet *sectionToReload = [NSIndexSet indexSetWithIndexesInRange:range];
        [table reloadSections:sectionToReload withRowAnimation:UITableViewRowAnimationNone];
}


+ (BOOL)isValidImageUrl:(NSString *)urlString{
//        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
//        return [NSURLConnection canHandleRequest:request];
//        NSString *urlRegEx = @"^(http(s)?://)?((www)?\.)?[\w]+\.[\w]+";
//        
//        NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegEx];
//        return [urlTest evaluateWithObject:urlString];
        
        NSArray *imageExtensions = @[@"cal" ,
                                     @"fax" ,
                                     @"gif" ,
                                     @"img" ,
                                     @"jbg" ,
                                     @"jpe" ,
                                     @"jpeg",
                                     @"jpg" ,
                                     @"mac" ,
                                     @"pbm" ,
                                     @"pcd" ,
                                     @"pcx" ,
                                     @"pct" ,
                                     @"pgm" ,
                                     @"png" ,
                                     @"ppm" ,
                                     @"psd" ,
                                     @"ras" ,
                                     @"tga" ,
                                     @"tiff",
                                     @"wmf"];
        
        
        NSString *extension = [urlString pathExtension];
        extension=[extension lowercaseString];
        if ([imageExtensions containsObject:extension]) {
                
                return YES;
                // Do something with it
        }
        return NO;
        
}

+(NSArray*)getValidImageUrl:(NSArray*)arr{
        NSMutableArray* arrResult=[[NSMutableArray alloc]init];
        
        for (NSString* url in arr) {
                if([self isValidImageUrl:url])       [arrResult addObject:url];
                        
        }
        
        return arrResult.count ? arrResult : nil;
}

/*
+(void)createPDFWithFileName:(NSString*)fileName allInfo:(NSDictionary*)allInfo{
        
        [PDFRenderer drawPDF:fileName allInfo:allInfo];
}
 */

+(NSArray*)splitPDFIntoImages:(NSURL *)sourcePDFUrl
               withOutputName:(NSString *)outputBaseName
                intoDirectory:(NSString *)directory{
        CGPDFDocumentRef SourcePDFDocument = CGPDFDocumentCreateWithURL((__bridge CFURLRef)sourcePDFUrl);
        size_t numberOfPages = CGPDFDocumentGetNumberOfPages(SourcePDFDocument);
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *filePathAndDirectory = [documentsDirectory stringByAppendingPathComponent:directory];
        NSError *error;
        
        if(![[NSFileManager defaultManager] fileExistsAtPath:filePathAndDirectory]){
                if (![[NSFileManager defaultManager] createDirectoryAtPath:filePathAndDirectory
                                               withIntermediateDirectories:NO
                                                                attributes:nil
                                                                     error:&error])
                {
                        NSLog(@"Create directory error: %@", error);
                        return nil;
                }
        }
        NSMutableArray* arrResult=[[NSMutableArray alloc]init];
        for(int currentPage = 1; currentPage <= numberOfPages; currentPage ++ )
        {
                CGPDFPageRef SourcePDFPage = CGPDFDocumentGetPage(SourcePDFDocument, currentPage);
                // CoreGraphics: MUST retain the Page-Refernce manually
                CGPDFPageRetain(SourcePDFPage);
                NSString *relativeOutputFilePath = [NSString stringWithFormat:@"%@/%@_%d.png", directory, outputBaseName, currentPage];
                NSString *ImageFileName = [documentsDirectory stringByAppendingPathComponent:relativeOutputFilePath];
                CGRect sourceRect = CGPDFPageGetBoxRect(SourcePDFPage, kCGPDFMediaBox);
                UIGraphicsBeginPDFContextToFile(ImageFileName, sourceRect, nil);
                UIGraphicsBeginImageContext(CGSizeMake(sourceRect.size.width,sourceRect.size.height));
                CGContextRef currentContext = UIGraphicsGetCurrentContext();
                CGContextTranslateCTM(currentContext, 0.0, sourceRect.size.height); //596,842 //640×960,
                CGContextScaleCTM(currentContext, 1.0, -1.0);
                CGContextDrawPDFPage (currentContext, SourcePDFPage); // draws the page in the graphics context
                UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                //                NSString *imagePath = [documentsDirectory stringByAppendingPathComponent: relativeOutputFilePath];
                //                [UIImagePNGRepresentation(image) writeToFile: imagePath atomically:YES];
                
                [arrResult addObject:image];
                //                return image;
        }
        
        return arrResult.count ? arrResult : nil;
}


+(NSString*)getDocumentoryPathWithFolder:(NSString*)folderName{
        
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *filePathAndDirectory = [documentsDirectory stringByAppendingPathComponent:folderName];
        
        return filePathAndDirectory;
}

+(BOOL)saveFile:(NSString*)fileName data:(NSData*)data path:(NSString*)path{
        
        BOOL result=NO;
        NSString* fullPath=[path stringByAppendingPathComponent:fileName];
        
        
        //Create Folder if not exist
        if (![[NSFileManager defaultManager] fileExistsAtPath:path])
                [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:NO attributes:nil error:nil];
        
        
        //Save file if not exist
        if(![[NSFileManager defaultManager] fileExistsAtPath:fullPath]){
                
                BOOL success = [data writeToFile:fullPath atomically:NO];
                
                result=success;
                
                NSLog(@"Successs:::: %@", success ? @"YES" : @"NO");
                
        }
        else NSLog(@"'%@' file already exist ",fileName);
        NSLog(@"file path --> %@",fullPath);
        
        return result;
}

+(NSString*)trimSpaces:(NSString*)string{
        
        NSArray* words = [string componentsSeparatedByCharactersInSet :[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSString* nospacestring = [words componentsJoinedByString:@""];
        
        return nospacestring ? nospacestring : @"";
}

+(NSString *)getOSVersionValue:(NSNumber *)number{
        
        
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        formatter.numberStyle = NSNumberFormatterDecimalStyle;
        formatter.maximumFractionDigits = 20;
        
        //        NSString *result = [formatter stringFromNumber:@1.20];
        //        NSLog(@"%@", result);
        //
        //        result = [formatter stringFromNumber:number];
        
        return  [formatter stringFromNumber:number];
        
}

+(void)updateConstraintsWithView:(UIView*)view constant:(float)constant constraintType:(NSLayoutAttribute)constraintType{
        
        NSLayoutConstraint *tempConstraint;
        for (NSLayoutConstraint *constraint in view.constraints) {
                if (constraint.firstAttribute == constraintType) {
                        tempConstraint = constraint;
                        break;
                }
        }
        tempConstraint.constant = constant;
        
        //        dispatch_async(dispatch_get_main_queue(), ^{
        [view layoutIfNeeded];
        //        });
        //        [view setNeedsLayout];
        //        [view.superview layoutIfNeeded];
        //        [view updateConstraintsIfNeeded];
        
}



@end
