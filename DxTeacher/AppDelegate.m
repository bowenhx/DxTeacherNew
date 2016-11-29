//
//  AppDelegate.m
//  DxTeacher
//
//  Created by Stray on 16/10/24.
//  Copyright © 2016年 XXTechnology Co.,Ltd. All rights reserved.
//

#import "AppDelegate.h"
#import "MMDrawerController.h"
#import "MMExampleDrawerVisualStateManager.h"
#import "UserViewController.h"
#import "LoginViewController.h"
#import "GuideViewController.h"

static AppDelegate *_appDelegate;

@interface AppDelegate ()

@property (nonatomic , strong) MMDrawerController * drawerController;

@end

@implementation AppDelegate

+ (AppDelegate *)getAppDelegate{
    return _appDelegate;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window setTintColor:RGB(29,173,234)];
    self.window.backgroundColor = [UIColor whiteColor];
    _appDelegate = self;

    //[self showTabBarVC];
    
    if (isFinishGuide == 0) {
        [self welcomePage];
    }else if (isFinishGuide == 1) {
        [self beginShowLoginView];
    }else if (isFinishGuide == 2){
        [self showTabBarVC];
    }

    
    
    [self.window makeKeyAndVisible];
    return YES;
}
- (void)showTabBarVC{
    UserViewController *leftVC = [UserViewController share];
    
    //使用Storyboard初始化根界面
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle bundleForClass:[self class]]];
//    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *centVC = [storyboard instantiateInitialViewController];
    
    self.drawerController = [[MMDrawerController alloc]
                             initWithCenterViewController:centVC
                             leftDrawerViewController:leftVC
                             rightDrawerViewController:nil];
    [self.drawerController setShowsShadow:NO];
    [self.drawerController setRestorationIdentifier:@"MMDrawer"];
    [self.drawerController setMaximumLeftDrawerWidth:240.0];
    [self.drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [self.drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    
    MMExampleDrawerVisualStateManager *examleType = [MMExampleDrawerVisualStateManager sharedManager];
    examleType.leftDrawerAnimationType = MMDrawerAnimationTypeSwingingDoor;
    
    [self.drawerController
     setDrawerVisualStateBlock:^(MMDrawerController *drawerController, MMDrawerSide drawerSide, CGFloat percentVisible) {
         MMDrawerControllerDrawerVisualStateBlock block;
         block = [examleType drawerVisualStateBlockForDrawerSide:drawerSide];
         if(block){
             block(drawerController, drawerSide, percentVisible);
         }
     }];
    
    [self.window setRootViewController:self.drawerController];
    
    
    
    //    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    //使用Storyboard初始化根界面
    //    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //    self.window.rootViewController = [storyBoard instantiateInitialViewController];
    

}
- (void)showLoginVC{
    if (self.window.rootViewController.view != nil) {
        [self.window.rootViewController.view removeFromSuperview];
    }
    [self beginShowLoginView];
}

- (void)beginShowLoginView{
    //启动后首先进入登陆界面
    LoginViewController *loginVC = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
    self.window.rootViewController = nav;
    
}


/**
 *  加载欢迎页方法
 */
- (void)welcomePage
{
    GuideViewController *guideVC = [[GuideViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:guideVC];
    nav.navigationBar.hidden = YES;
    self.window.rootViewController = nav;
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
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
