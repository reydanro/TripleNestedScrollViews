//
//  ViewController.h
//  TripleExample
//
//  Created by Andrei Stanescu on 7/24/13.
//  Copyright (c) 2013 Mind Treat Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIScrollView *mainScroll;
@property (nonatomic) BOOL fixEnabled;
- (IBAction)onFixSwitch:(id)sender;

@end
