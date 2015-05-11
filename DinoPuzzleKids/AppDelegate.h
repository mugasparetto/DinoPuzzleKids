//
//  AppDelegate.h
//  TesteImagemBotoes
//
//  Created by Murilo Gasparetto on 20/03/15.
//  Copyright (c) 2015 Murilo Gasparetto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property(nonatomic, retain) UINavigationController *navController;
@property(nonatomic) AVAudioPlayer *background;


@end

