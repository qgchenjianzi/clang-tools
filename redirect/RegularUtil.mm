//
//  RegularUtil.mm
//  MicroMessenger
//
//  Created by isalin on 12-08-27.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "RegularUtil.h"
#import <MMCommon/GTMNSString+URLArguments.h>

#define MINACCOUNTCHAR 6
#define MAXACCOUNTCHAR 20

#define MINDIGITALPWDCHAR 9
#define MINUUNDIGITALPWDCHAR  8

@implementation RegularUtil

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//RegularUtil.mm
 * Method Name: isUsrNameQQ:
 * Returning Type: id
 */ 
+(BOOL) isUsrNameQQ  : (NSString*) nsUsrName {
	if( nsUsrName == nil )
		return NO ;
	
    return ([nsUsrName rangeOfString:@"@qqim" options:NSBackwardsSearch].location != NSNotFound);
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//RegularUtil.mm
 * Method Name: isUsrNameSX:
 * Returning Type: id
 */ 
+(BOOL) isUsrNameSX  : (NSString*) nsUsrName {
	if( nsUsrName == nil ) 
		return NO ;
    
    return ([nsUsrName rangeOfString:@"@t.qq.com" options:NSBackwardsSearch].location != NSNotFound);
}


/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//RegularUtil.mm
 * Method Name: isLegalAccount:
 * Returning Type: id
 */ 
+(BOOL) isLegalAccount:(NSString *) nsAccount{
	if(nsAccount == nil || nsAccount.length < MINACCOUNTCHAR || nsAccount.length > MAXACCOUNTCHAR)// the 'if' part
	{
		return NO;
	}
	
	BOOL bLegal = YES;
	for (NSUInteger i = 0; i < nsAccount.length; ++i) {
		unichar uniC = [nsAccount characterAtIndex:i];
		if( (uniC >= 'A' && uniC <= 'Z') || 
		   (uniC >= 'a' && uniC <= 'z'))// the 'if' part
		   {
		}
		else // the 'else' part
		if((uniC >= '0' && uniC <= '9') ||
				uniC == '_' || uniC == '-')// the 'if' part
				{
			if( i == 0)// the 'if' part
			{
				bLegal = NO;
				break;
			}
		}
		else // the 'else' part
		{
			bLegal = NO;
			break;
		}
	}
	
	return bLegal;
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//RegularUtil.mm
 * Method Name: isLegalEmail:
 * Returning Type: id
 */ 
+(BOOL) isLegalEmail:(NSString *) nsEmail{
	if(nsEmail == nil || nsEmail.length == 0)// the 'if' part
	{
		return NO;
	}
	
	NSRange range = [nsEmail rangeOfString:@"@"];
	if(range.length > 0)// the 'if' part
	{
		return YES;
	}
	else // the 'else' part
	{
		return NO;
	}
	//NSString * emailRegex = @"^[a-z0-9._+-]+@[a-z0-9.-]+\\.[a-z]+$"; 
	//return [nsEmail isMatchedByRegex:emailRegex];
}

#define PHONE_NUMBER_LENGTH 11

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//RegularUtil.mm
 * Method Name: isLegalPhoneNumber:
 * Returning Type: id
 */ 
+(BOOL) isLegalPhoneNumber:(NSString *) nsPhoneNumber {    
	if ([nsPhoneNumber length] <= 0) // the 'if' part
	{
		return NO;
	}
	for (int i = 0; i < [nsPhoneNumber length]; i++) {
		unichar uniC = [nsPhoneNumber characterAtIndex:i];
		if (!isnumber(uniC)) // the 'if' part
		{
			return NO;
		}
	}
	return YES;
}

#define QQNUMBERMINLENGTH 5

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//RegularUtil.mm
 * Method Name: isLegalQQNum:
 * Returning Type: id
 */ 
+(BOOL) isLegalQQNum:(NSString *)nsString{
	
	if(nsString == nil)// the 'if' part
	{
		return NO;
	}
	
	uint32_t length = (uint32_t)nsString.length;
	
	if(length < QQNUMBERMINLENGTH)// the 'if' part
	{
		return NO;
	}
	
	for(uint32_t i = 0; i < length; ++i){
		unichar uniC = [nsString characterAtIndex:i];
		if(!isnumber(uniC))// the 'if' part
		{
			return NO;
		}
	}
	
	return YES;
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//RegularUtil.mm
 * Method Name: isPhoneNumberChina:
 * Returning Type: id
 */ 
+(BOOL) isPhoneNumberChina:(NSString*)nsPhoneNumber{
    NSRange range = [nsPhoneNumber rangeOfString:@"+"];
    if (range.length != 0 && range.location == 0) // the 'if' part
    {
        
        NSRange range86 = [nsPhoneNumber rangeOfString:@"+86"];
        if (range86.length != 0 && range86.location == 0) // the 'if' part
        {
            return YES;
        }
        return NO;
    }
    return YES;
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//RegularUtil.mm
 * Method Name: getPhoneText:
 * Returning Type: id
 */ 
+(NSString*) getPhoneText:(NSString*)nsPhoneNumber
{
    if (nsPhoneNumber == nil || [nsPhoneNumber length] == 0)
    // the 'if' part
    {
        //the return stmt
        return @"";
    }
    NSMutableString* string = [NSMutableString stringWithString:nsPhoneNumber];
    if (string.length >= 5)
    // the 'if' part
    {
        for (NSInteger i = 3; i < string.length - 2; i ++)
        {
            NSRange range;
            range.location = i;
            range.length = 1;
            [string replaceCharactersInRange:range withString:@"*"];
        }
    }
    return string;
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//RegularUtil.mm
 * Method Name: parseURLParams:
 * Returning Type: id
 */ 
+(NSDictionary*) parseURLParams:(NSString *)query {
	NSArray *pairs = [query componentsSeparatedByString:@"&"];
	NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
	for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        if([kv count] < 2)
        {
            continue;
        }
		NSString *val =
        [[[kv objectAtIndex:1]
          stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] gtm_stringByUnescapingFromURLArgument];
        
		[params setObject:val forKey:[kv objectAtIndex:0]];
	}
    return params;
}

@end