//
//  PlaceToggleControl.h
//  LiveReport2013
//
//  Created by Ueta Masamichi on 2013/03/24.
//  Copyright (c) 2013年 Ueta Masamichi. All rights reserved.
//

#import "ToggleImageControl.h"

@interface PlaceToggleControl : ToggleImageControl

@property(copy, nonatomic) NSString* placeName;
- (void) togglePushed;
@end
