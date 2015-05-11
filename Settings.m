//
//  Settings.m
//  DinoPuzzleKids
//
//  Created by Anderson José da Silva on 08/05/15.
//  Copyright (c) 2015 Murilo Gasparetto. All rights reserved.
//  https://www.mobiledev.nl/how-to-save-and-load-user-preferences-nsuserdefaults-in-objective-c/
//

#import "Settings.h"

@implementation Settings

+(NSString*)getStringForKey:(NSString*)key
{
    NSString* val = @"";
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if (standardUserDefaults) val = [standardUserDefaults stringForKey:key];
    if (val == NULL) val = @"";
    return val;
}

+(NSInteger)getIntForkey:(NSString *)key
{
    NSInteger val = 0;
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if (standardUserDefaults) val = [standardUserDefaults integerForKey:key];
    return val;
}


+(BOOL)getBoolForKey:(NSString*)key
{
    BOOL val = FALSE;
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if (standardUserDefaults) val = [standardUserDefaults boolForKey:key];
    return val;
}

+(void)setStringForKey:(NSString *)key value:(NSString *)value
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if (standardUserDefaults)
    {
        [standardUserDefaults setObject:value forKey:key];
        [standardUserDefaults synchronize];
    }
}

+(void)setIntForKey:(NSString *)key value:(NSInteger)value
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if (standardUserDefaults)
    {
        [standardUserDefaults setInteger:value forKey:key];
        [standardUserDefaults synchronize];
    }
}


+(void)setBoolForKey:(NSString *)key value:(BOOL)value
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if (standardUserDefaults)
    {
        [standardUserDefaults setBool:value forKey:key];
        [standardUserDefaults synchronize];
    }
}

@end

