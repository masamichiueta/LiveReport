//
//  SongToggleControl.m
//  LiveReport2013
//
//  Created by Ueta Masamichi on 2013/03/24.
//  Copyright (c) 2013年 Ueta Masamichi. All rights reserved.
//

#import "SongToggleControl.h"

@implementation SongToggleControl

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
    NSDictionary *songInfo = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:self.tag], @"table", [NSNumber numberWithInt:self.section], @"section", [NSNumber numberWithInt:self.row], @"row", nil];
    NSDictionary *sendDict = [NSDictionary dictionaryWithObject: songInfo forKey: @"Song"];
    [[NSNotificationCenter defaultCenter] postNotificationName: @"SongTogglePushed" object: self userInfo: sendDict];
}


@end
