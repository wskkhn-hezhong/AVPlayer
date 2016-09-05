//
//  AppDelegate.m
//  EdgeNews
//
//  Created by lanouhn on 15/11/23.
//  Copyright (c) 2015年 lanouhn. All rights reserved.
//

#import "AppDelegate.h"
#import "FirstViewController.h"
#import "BtnSingleton.h"
#import "AFNetworking.h"
#import "TabViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)dealloc
{
    [_window release];
    [super dealloc];
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (![userDefaults boolForKey:@"FirstLanch"]) {
        [userDefaults setBool:YES forKey:@"FirstLanch"];//存入值
        [userDefaults synchronize];//在单例内,同步数据, 
        FirstViewController *vc = [[FirstViewController alloc] init];
        self.window.rootViewController = vc;
        [vc release];
    }
    
    sleep(1.0);
    
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"loadVideo"]) {
        [BtnSingleton mainSingleton].loadVideo = NO;
    } else {
        [BtnSingleton mainSingleton].loadVideo = YES;
    }
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"night"]) {
        self.window.alpha = 0.5;
    } else {
        self.window.alpha = 1;
    }

    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    /*
     typedef NS_ENUM(NSInteger, AFNetworkReachabilityStatus) {
     AFNetworkReachabilityStatusUnknown          = -1,//未识别的网络
     AFNetworkReachabilityStatusNotReachable     = 0,//不可达的网络(未连接)
     AFNetworkReachabilityStatusReachableViaWWAN = 1,//2G,3G,4G...
     AFNetworkReachabilityStatusReachableViaWiFi = 2,//wifi网络
     };
     */
    //设置监听
    
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                [BtnSingleton mainSingleton].mangeStatus = -1;
                break;
                
                case AFNetworkReachabilityStatusNotReachable:
                [BtnSingleton mainSingleton].mangeStatus = 0;
                break;
                
                case AFNetworkReachabilityStatusReachableViaWWAN:
                [BtnSingleton mainSingleton].mangeStatus = 1;
                break;
                
                case AFNetworkReachabilityStatusReachableViaWiFi:
                [BtnSingleton mainSingleton].mangeStatus = 2;
                
            default:
                break;
        }
    }];
    
    [manager startMonitoring];
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setActive:YES error:nil];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
