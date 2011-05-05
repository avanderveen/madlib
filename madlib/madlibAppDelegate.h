//
//  madlibAppDelegate.h
//  madlib
//
//  Created by Andrew VanderVeen on 11-05-05.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MainViewController;

@interface madlibAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) MainViewController *theViewController;

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@end
