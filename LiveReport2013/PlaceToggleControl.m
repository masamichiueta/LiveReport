//
//  PlaceToggleControl.m
//  LiveReport2013
//
//  Created by Ueta Masamichi on 2013/03/24.
//  Copyright (c) 2013年 Ueta Masamichi. All rights reserved.
//

#import "PlaceToggleControl.h"

@implementation PlaceToggleControl
@synthesize placeName=_placeName;

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
    
    NSDictionary *placeInfo = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:self.tag], @"tag",  _placeName,@"placeName", [NSNumber numberWithInt:self.selected], @"selected", nil];
    NSDictionary *sendDict = [NSDictionary dictionaryWithObject: placeInfo forKey: @"Place"];
    [[NSNotificationCenter defaultCenter] postNotificationName: @"PlaceTogglePushed" object: self userInfo: sendDict];
    
}


@end
