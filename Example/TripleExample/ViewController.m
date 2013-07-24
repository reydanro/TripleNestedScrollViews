//
//  ViewController.m
//  TripleExample
//
//  Created by Andrei Stanescu on 7/24/13.
//  Copyright (c) 2013 Mind Treat Studios. All rights reserved.
//

#import "ViewController.h"
#import "TripleNestGestureRecognizer.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [self generateContent];
}

- (void)generateContent
{
    int row, col;
    
    // Clear everything
    for (UIView* v in _mainScroll.subviews)
    {
        if (v.tag == 99)
            [v removeFromSuperview];
    }
    
    float pagew = _mainScroll.frame.size.width;
    float pageh = _mainScroll.frame.size.height;
    
    for (row = 0; row < 4; row++)
    {
        // For each row, we create an additional horizontal scrollview
        UIScrollView* middleScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, row * pageh, pagew, pageh)];
        middleScroll.pagingEnabled = TRUE;
        middleScroll.tag = 99;
        for (col = 0; col < 4; col++)
        {
            UIView* page;
            if (row == 2)
                page = [self loadComplexPage];
            else
                page = [self loadSimplePage];
            page.frame = CGRectMake(col * pagew, 0, pagew, pageh);
            
            // Set the tag
            ((UILabel*)[page viewWithTag:111]).text = [NSString stringWithFormat:@"row %d, col %d", (row+1), (col+1)];
            
            if (row == 2)
            {
                // Generate the content in the inner scroll
                UIScrollView* innerScroll = (UIScrollView*)[page viewWithTag:222];
                int k;
                for (k = 0; k < 5; k++)
                {
                    UIView* innerPage = [self loadSimplePage];
                    innerPage.frame = CGRectMake(0, k * innerScroll.frame.size.height, innerScroll.frame.size.width, innerScroll.frame.size.height);
                    innerPage.backgroundColor = [UIColor colorWithRed:k / 5.0f green:k / 5.0f blue:1.0f alpha:1];
                    ((UILabel*)[innerPage viewWithTag:111]).text = [NSString stringWithFormat:@"inner %d", (k+1)];
                    [innerScroll addSubview:innerPage];
                }
                innerScroll.contentSize = CGSizeMake(innerScroll.frame.size.width, k * innerScroll.frame.size.height);
                
                if (_fixEnabled)
                {
                    TripleNestGestureRecognizer* recognizer = [[TripleNestGestureRecognizer alloc] initWithTarget:nil action:nil];
                    [innerScroll addGestureRecognizer:recognizer];
                }
            }
            
            [middleScroll addSubview:page];
        }
        
        middleScroll.contentSize = CGSizeMake(col * pagew, pageh);

        
        [_mainScroll addSubview:middleScroll];
    }
    
    _mainScroll.contentSize = CGSizeMake(pagew, row * pageh);
    _mainScroll.contentOffset = CGPointZero;
}

- (UIView*)loadSimplePage
{
    return [[[NSBundle mainBundle] loadNibNamed:@"PageSimple" owner:nil options:nil] objectAtIndex:0];
}

- (UIView*)loadComplexPage
{
    return [[[NSBundle mainBundle] loadNibNamed:@"PageComplex" owner:nil options:nil] objectAtIndex:0];
}

- (IBAction)onFixSwitch:(id)sender {
    _fixEnabled = ((UISwitch*)sender).on;
    [self generateContent];
}
@end
