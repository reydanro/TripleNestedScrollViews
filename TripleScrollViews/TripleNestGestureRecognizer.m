//
//  TripleNestGestureRecognizer.m
//  TripleExample
//
//  Created by Andrei Stanescu on 7/24/13.
//  Copyright (c) 2013 Mind Treat Studios. All rights reserved.
//

#import "TripleNestGestureRecognizer.h"
#import <UIKit/UIGestureRecognizerSubclass.h>


#define EDGE_THRESHOLD 10

@implementation TripleNestGestureRecognizer

- (id)initWithTarget:(id)target action:(SEL)action
{
    self = [super initWithTarget:target action:action];
    if (self)
    {
        [self customInit];
    }
    return self;
}


- (void)awakeFromNib
{
    [self customInit];
}

- (void)customInit
{
    self.cancelsTouchesInView = FALSE;
    self.delaysTouchesBegan = TRUE;
    
    self.state = UIGestureRecognizerStatePossible;
}

- (void)reset
{
    self.state = UIGestureRecognizerStatePossible;
}

- (void)setState:(UIGestureRecognizerState)state
{
    [super setState:state];
    
    if (state == UIGestureRecognizerStateCancelled)
        [self setEnableOtherGestureRecognizers:FALSE];
    else
        [self setEnableOtherGestureRecognizers:TRUE];
}

- (void)setEnableOtherGestureRecognizers:(BOOL)enabled
{
    if (self.view == nil)
        return;
    
    for (UIGestureRecognizer* recognizer in self.view.gestureRecognizers)
    {
        if (recognizer == self)
            continue;
        
        recognizer.enabled = enabled;
    }
}



- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    self.state = UIGestureRecognizerStatePossible;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    self.state = UIGestureRecognizerStateFailed;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    self.state = UIGestureRecognizerStateFailed;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];

    //
    
    if ([self.view isKindOfClass:[UIScrollView class]] == FALSE)
        return ;

    if (self.state != UIGestureRecognizerStatePossible)
        return ;

    UITouch* touch = [touches anyObject];
    if (touch == nil)
        return ;

    CGPoint location = [touch locationInView:self.view];
    CGPoint prevlocation = [touch previousLocationInView:self.view];
    
    UIGestureRecognizerState newstate = UIGestureRecognizerStateFailed;
    UIScrollView* scroll = (UIScrollView*)self.view;

    // Compute the real content rectangle
    float minX = -scroll.contentInset.left;
    float minY = -scroll.contentInset.top;
    float maxX = scroll.contentSize.width - scroll.contentInset.right;
    float maxY = scroll.contentSize.height - scroll.contentInset.bottom;
    
    // TOP EDGE
    if (scroll.contentOffset.y <= minY + EDGE_THRESHOLD)
    {
        if (location.y > prevlocation.y && fabsf(location.x - prevlocation.x) < 8)
        {
            newstate = UIGestureRecognizerStateCancelled;
        }
    }
    
    // BOTTOM EDGE
    if (scroll.contentOffset.y + scroll.bounds.size.height >= maxY - EDGE_THRESHOLD)
    {
        if (location.y < prevlocation.y && fabsf(location.x - prevlocation.x) < 8)
        {
            newstate = UIGestureRecognizerStateCancelled;
        }
    }
    
    
    self.state = newstate;
}


@end
