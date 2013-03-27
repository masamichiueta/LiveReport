//
//  PlaceToggleControl.m
//  LiveReport2013
//
//  Created by Ueta Masamichi on 2013/03/24.
//  Copyright (c) 2013年 Ueta Masamichi. All rights reserved.
//

#import "PlaceToggleControl.h"

@implementation PlaceToggleControl

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self addTarget: self action: @selector(togglePushed) forControlEvents: UIControlEventTouchUpInside];
    }
    return self;
}

- (void) togglePushed{
    [super togglePushed];
    
    NSDictionary *dict = [NSDictionary dictionaryWithObject: [NSNumber numberWithInt:self.tag] forKey: @"Place"];
    [[NSNotificationCenter defaultCenter] postNotificationName: @"PlaceTogglePushed" object: self userInfo: dict];
    
}


@end
