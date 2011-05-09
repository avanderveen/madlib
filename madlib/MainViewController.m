//
//  MainViewController.m
//  madlib
//
//  Created by Andrew VanderVeen on 11-05-05.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MainViewController.h"


@implementation MainViewController
@synthesize libTextField;
@synthesize theLib, replace, resultTextField, hintLabel, hintView, blankLoc;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [theLib release];
    [resultTextField release];
    [hintView release];
    [hintLabel release];
    [libTextField release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    theLib = @"Some kinda Mad Lib. With [verbs], [adverbs], [nouns], [adjectives], etc.. Placeholder text may contain a description: [adjective:Job Title] if required.";
    [self.libTextField setText:theLib];
}

- (void)viewDidUnload
{
    [self setResultTextField:nil];
    [self setHintView:nil];
    [self setHintLabel:nil];
    [self setLibTextField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    self.blankLoc = NSMakeRange(-1, 0);
    resultTextField.text = @"";
    self.replace  = NULL;
    [self.hintView setHidden:NO];
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    [self.hintView setHidden:YES];
    [textView resignFirstResponder];
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if([text compare:@"\n"] == NSOrderedSame || [text compare:@"\r"] == NSOrderedSame) {
        if(blankLoc.location == -1)
            return NO;
        NSLog([theLib substringWithRange:blankLoc]);
        NSString *pre  = [theLib substringToIndex:blankLoc.location];
        NSString *post = [theLib substringFromIndex:blankLoc.location + blankLoc.length];
        theLib = [NSString stringWithFormat:@"%@%@%@", pre, replace, post];
        libTextField.text = theLib;

        [self.hintView setHidden:YES];
        [textView resignFirstResponder];
        return NO;
    }
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:[NSString stringWithFormat:@"\\w"] options:0 error:nil];
    NSInteger nMatches = [regex numberOfMatchesInString:text options:0 range:NSMakeRange(0, [text length])];
    if(nMatches == 0 && [text length] > 0)
        return NO;

    if(range.length == 0 && [text length] == 1) {
        // user types a character
        if(self.replace == NULL) {
            self.replace = text;
        } else {
            self.replace = [NSString stringWithFormat:@"%@%@",self.replace,text];
        }
    } else if(range.length == 1 && [text length] == 0 && [[self replace] length] > 0) {
        // user backspaces (and there's text to delete)
        self.replace = [self.replace substringToIndex:[self.replace length] - 1];
    }

    [self.resultTextField setText:self.replace];

    if(blankLoc.location == -1) {
        // search range
        range.length   = range.location;
        range.location = 0;

        // search left of insertion point
        NSRange right;
        NSRange left = [self.theLib rangeOfString:@"[" options:NSBackwardsSearch range:range];
        if(left.location != NSNotFound) {
            left.length = [self.theLib length] - left.location;
            right = [self.theLib rangeOfString:@"]" options:0 range:left];
            left.length = right.location - left.location + 1;
        }

        // search right of insertion
        range.location = range.length;
        range.length = [theLib length] - range.location;
        right = [theLib rangeOfString:@"[" options:0 range:range];
        NSLog(@"loc: %d, len: %d", right.location, right.length);

        // Check if the right side is closer, if so: use it
        if(right.location != NSNotFound && (right.location - range.location < range.location - left.location || left.location == NSNotFound)) {
            // use result on right
            left = right;
            left.length = [theLib length] - left.location;
            right = [theLib rangeOfString:@"]" options:0 range:left];
            left.length = right.location - left.location + 1;
        }

        blankLoc.location = left.location;
        blankLoc.length   = left.length;

        NSRange l2  = blankLoc;
        l2.location = l2.location + 1;
        l2.length   = l2.length   - 2;
        hintLabel.text = [theLib substringWithRange:l2];
    }

    return NO;
}

@end
