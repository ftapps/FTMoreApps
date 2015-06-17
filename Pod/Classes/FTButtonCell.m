//
//  FTButtonCell.m
//  MoreApps
//
//  Created by Felipe Tumonis on 12/05/15.
//  Copyright (c) 2015 FT Apps. All rights reserved.
//

#import "FTButtonCell.h"

@implementation FTButtonCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [NSOperationQueue.mainQueue addOperationWithBlock:^{ self.highlighted = YES; }];
}


- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    [self performSelector:@selector(setDefault) withObject:nil afterDelay:0.1];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    [self performSelector:@selector(setDefault) withObject:nil afterDelay:0.1];
}

- (void)setDefault
{
    [NSOperationQueue.mainQueue addOperationWithBlock:^{ self.highlighted = NO; }];
}

@end
