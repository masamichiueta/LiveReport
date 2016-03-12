//
//  UIDevice+VersionCheck_h.m
//  LiveReport2013
//
//  Created by Ueta Masamichi on 2013/10/05.
//  Copyright (c) 2013年 Ueta Masamichi. All rights reserved.
//

#import "UIDevice+VersionCheck_h.h"

@implementation UIDevice (VersionCheck_h)

- ( NSUInteger )systemMajorVersion
{
    NSString * versionString;
    
    versionString = [ self systemVersion ];
    
    return ( NSUInteger )[ versionString doubleValue ];
}

@end
