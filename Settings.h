//
//  Settings.h
//  DinoPuzzleKids
//
//  Created by Anderson José da Silva on 08/05/15.
//  Copyright (c) 2015 Murilo Gasparetto. All rights reserved.
//  https://www.mobiledev.nl/how-to-save-and-load-user-preferences-nsuserdefaults-in-objective-c/
//

#import <Foundation/Foundation.h>

@interface Settings : NSObject

@property (nonatomic) NSString* settingsPlayBackgroundMusic;


+(NSString*)getStringForKey:(NSString*)key;
+(NSInteger)getIntForkey:(NSString*)key;
+(BOOL)getBoolForKey:(NSString*)key;

+(void)setStringForKey:(NSString*)key value:(NSString*)value;
+(void)setIntForKey:(NSString*)key value:(NSInteger)value;
+(void)setBoolForKey:(NSString*)key value:(BOOL)value;


@end

