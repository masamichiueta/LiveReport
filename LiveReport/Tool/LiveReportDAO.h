//
//  LiveReportDAO.h
//  LiveReport2013
//
//  Created by Ueta Masamichi on 2013/03/21.
//  Copyright (c) 2013年 Ueta Masamichi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"

@interface LiveReportDAO : NSObject{
    
    
}

@property(strong, nonatomic) FMDatabase *db;

-(void)connect;
-(NSMutableArray *)getPlaceList;
-(NSMutableArray *)getSongList;
-(NSMutableArray *)getSongListByArtist:(NSString *) artist;


@end
