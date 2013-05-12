//
//  PostInfoUtil.h
//  LiveReport2013
//
//  Created by Ueta Masamichi on 2013/03/24.
//  Copyright (c) 2013年 Ueta Masamichi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PostInfoUtil : NSObject{
    
}

@property(copy, nonatomic) NSString* place;
@property(strong, nonatomic) NSMutableArray* songList;

+ (id)sharedCenter;
@end
