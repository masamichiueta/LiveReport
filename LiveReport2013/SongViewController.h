//
//  SongViewController.h
//  LiveReport2013
//
//  Created by Ueta Masamichi on 2013/03/20.
//  Copyright (c) 2013年 Ueta Masamichi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LiveReportDAO.h"

@interface SongViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>{
    
    NSMutableArray *songList_SF;
    NSMutableArray *songList_19;
    NSMutableArray *songList_3B;
    NSMutableArray *songList_OK;
    
    NSMutableArray *rowNumList_SF;
    NSMutableArray *rowNumList_19;
    NSMutableArray *rowNumList_3B;
    NSMutableArray *rowNumList_OK;

}

@property (strong, nonatomic) IBOutlet UITableView *songListTable;
@property (strong, nonatomic) LiveReportDAO *liveReportObj;

-(NSMutableArray *) getSectionRowNumList:(NSMutableArray *)songList;

@end
