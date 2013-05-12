//
//  SongToggleControl.h
//  LiveReport2013
//
//  Created by Ueta Masamichi on 2013/03/24.
//  Copyright (c) 2013年 Ueta Masamichi. All rights reserved.
//

#import "ToggleImageControl.h"

@interface SongToggleControl : ToggleImageControl

@property(assign) int section;
@property(assign) int row;
@property(copy, nonatomic) NSString *songName;

- (void) togglePushed;

@end
