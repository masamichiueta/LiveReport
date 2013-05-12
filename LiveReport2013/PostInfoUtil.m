//
//  PostInfoUtil.m
//  LiveReport2013
//
//  Created by Ueta Masamichi on 2013/03/24.
//  Copyright (c) 2013年 Ueta Masamichi. All rights reserved.
//

#import "PostInfoUtil.h"

@implementation PostInfoUtil
@synthesize place=_place;
@synthesize songList=_songList;

//Singleton

static PostInfoUtil* sharedInstance = nil;

- (id)init
{
    self = [super init];
    if (self) {
        _songList = [[NSMutableArray alloc] init];
    }
    return self;
}


+ (id)allocWithZone:(NSZone *)zone {
	@synchronized(self) {
		if (!sharedInstance) {
			sharedInstance = [super allocWithZone:zone];
		}
	}
	return sharedInstance;
}

+ (id)sharedCenter {
    
	static PostInfoUtil* sharedInstance = nil;
	@synchronized(self) {
		if(!sharedInstance) {
			sharedInstance = [[self alloc] init];
		}
	}
	return sharedInstance;
}

- (id)copyWithZone:(NSZone *)zone {
	return self;
}

@end
