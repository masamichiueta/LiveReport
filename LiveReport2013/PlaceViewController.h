//
//  PlaceViewController.h
//  LiveReport2013
//
//  Created by Ueta Masamichi on 2013/03/20.
//  Copyright (c) 2013年 Ueta Masamichi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LiveReportDAO.h"

@interface PlaceViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>{
    
    NSMutableArray *placeList;
    NSMutableArray *toggleControlList;
}

@property (strong, nonatomic) IBOutlet UITableView *placeListTable;
@property (strong, nonatomic) LiveReportDAO *liveReportObj;

@end
