//
//  LiveReportDAO.m
//  LiveReport2013
//
//  Created by Ueta Masamichi on 2013/03/21.
//  Copyright (c) 2013年 Ueta Masamichi. All rights reserved.
//

#import "LiveReportDAO.h"



@implementation LiveReportDAO
@synthesize db=_db;

-(void)connect{
    BOOL success;
    NSError *error;
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"livereport2013.db"];
    NSLog(@"%@",writableDBPath);
    success = [fm fileExistsAtPath:writableDBPath];
    if(!success){
        NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"livereport2013.db"];
        success = [fm copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
        if(!success){
            NSLog(@"%@",[error localizedDescription]);
        }
    }
    
    _db = [FMDatabase databaseWithPath:writableDBPath];
    
}

-(NSMutableArray *)getPlaceList{
    [self connect];
    NSMutableArray *placeList = [NSMutableArray array];
    if ([_db open]) {
        [_db setShouldCacheStatements:YES];
        
        // SELECT
        FMResultSet *rs = [_db executeQuery:@"SELECT * FROM place"];

        while ([rs next]) {
            NSMutableDictionary *place = [NSMutableDictionary dictionary];
            [place setObject:[rs stringForColumn:@"id"] forKey:@"id"];
            [place setObject:[rs stringForColumn:@"name"] forKey:@"name"];
            [place setObject:[rs stringForColumn:@"date"] forKey:@"date"];
            [place setObject:[rs stringForColumn:@"hash"] forKey:@"hash"];
            
            [placeList addObject:place];
            
        }
        [rs close];
        [_db close];
        
    }else{
        NSLog(@"Could not open db.");
    }
    return placeList;

}


-(NSMutableArray *)getSongList{
    [self connect];
    NSMutableArray *songList = [NSMutableArray array];
    if ([_db open]) {
        [_db setShouldCacheStatements:YES];
        
        // SELECT
        FMResultSet *rs = [_db executeQuery:@"SELECT * FROM songs"];
        
        while ([rs next]) {
            NSMutableDictionary *song = [NSMutableDictionary dictionary];
            [song setObject:[rs stringForColumn:@"id"] forKey:@"id"];
            [song setObject:[rs stringForColumn:@"name"] forKey:@"name"];
            [song setObject:[rs stringForColumn:@"album"] forKey:@"album"];
            [song setObject:[rs stringForColumn:@"artist"] forKey:@"artist"];
            [song setObject:[rs stringForColumn:@"itunes"] forKey:@"itunes"];
            [song setObject:[rs stringForColumn:@"album_pic"] forKey:@"album_pic"];
            
            [songList addObject:song];
            
        }
        [rs close];
        [_db close];
        
    }else{
        NSLog(@"Could not open db.");
    }
    return songList;
    
}

-(NSMutableArray *)getSongListByArtist:(NSString *) artist{
    [self connect];
    NSMutableArray *songList = [NSMutableArray array];
    if ([_db open]) {
        [_db setShouldCacheStatements:YES];
        
        // SELECT
        NSString *sql = @"SELECT DISTINCT album FROM songs WHERE artist = ?";
        FMResultSet *rs = [_db executeQuery:sql, artist];
        
        while ([rs next]) {
            NSMutableArray *album_song = [NSMutableArray array];
            NSString *sql_album = @"SELECT * FROM songs WHERE artist = ? AND album = ?";
            FMResultSet *rs_album = [_db executeQuery:sql_album, artist,[rs stringForColumn:@"album"]];
            
            while([rs_album next]){
                NSMutableDictionary *song = [NSMutableDictionary dictionary];
                [song setObject:[rs_album stringForColumn:@"id"] forKey:@"id"];
                [song setObject:[rs_album stringForColumn:@"name"] forKey:@"name"];
                [song setObject:[rs_album stringForColumn:@"album"] forKey:@"album"];
                [song setObject:[rs_album stringForColumn:@"artist"] forKey:@"artist"];
                [song setObject:[rs_album stringForColumn:@"itunes"] forKey:@"itunes"];
                [song setObject:[rs_album stringForColumn:@"album_pic"] forKey:@"album_pic"];
                [album_song addObject:song];
            }
            
            [songList addObject:album_song];
            
        }
        [rs close];
        [_db close];
        
    }else{
        NSLog(@"Could not open db.");
    }
    return songList;
}



@end
