//
//  MainViewController.h
//  madlib
//
//  Created by Andrew VanderVeen on 11-05-05.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController <UITextViewDelegate> {
    
    UIView *hintView;
    UILabel *hintLabel;
    UITextField *resultTextField;
    UITextView *libTextField;
}

@property (nonatomic) NSRange blankLoc;
@property (nonatomic, copy) NSString *theLib;
@property (nonatomic, copy) NSString *replace;
@property (nonatomic, retain) IBOutlet UIView *hintView;
@property (nonatomic, retain) IBOutlet UILabel *hintLabel;
@property (nonatomic, retain) IBOutlet UITextField *resultTextField;
@property (nonatomic, retain) IBOutlet UITextView *libTextField;

@end
