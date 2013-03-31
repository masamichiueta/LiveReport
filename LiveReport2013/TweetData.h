//
//  TweetData.h
//  LiveReport2013
//
//  Created by Ueta Masamichi on 2013/03/28.
//  Copyright (c) 2013年 Ueta Masamichi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TweetData : NSObject

@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *status;
@property (strong, nonatomic) NSDate *createdAt;
@property (strong, nonatomic) NSString *iconImageURL;

@end
