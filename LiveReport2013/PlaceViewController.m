//
//  PlaceViewController.m
//  LiveReport2013
//
//  Created by Ueta Masamichi on 2013/03/20.
//  Copyright (c) 2013年 Ueta Masamichi. All rights reserved.
//

#import "PlaceViewController.h"


#import "PrettyKit.h"

@interface PlaceViewController ()

@end

@implementation PlaceViewController
@synthesize placeListTable = _placeListTable;
@synthesize liveReportObj = _liveReportObj;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark -
#pragma mark Pretty Kit
- (void) customizeNavBar {
    PrettyNavigationBar *navBar = (PrettyNavigationBar *)self.navigationController.navigationBar;
    
    navBar.topLineColor = [UIColor darkGrayColor];
    navBar.gradientStartColor = [UIColor darkGrayColor];
    navBar.gradientEndColor = [UIColor colorWithHex:0x000000];
    navBar.bottomLineColor = [UIColor colorWithHex:0xCC3599];
    navBar.shadowOpacity = 0.0;
    //navBar.tintColor = navBar.gradientEndColor;
    navBar.roundedCornerRadius = 10;
    
}


#pragma mark -
#pragma mark View Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self customizeNavBar];
    
    _placeListTable.delegate = self;
    _placeListTable.dataSource = self;
    
    [_placeListTable dropShadows];
    _placeListTable.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
    
    _liveReportObj = [[LiveReportDAO alloc] init];
    placeList = [NSMutableArray array];
    placeList = _liveReportObj.getPlaceList;
        
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma mark UITableView Delegate Methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    //Localize
    NSString* tableHeader = NSLocalizedString(@"Select Place", @"Select Place");
    return tableHeader;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [placeList count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    
    PrettyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[PrettyTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.tableViewBackgroundColor = tableView.backgroundColor;
    }
    
    //PrettyKitSetting
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    cell.textLabel.numberOfLines = 2;
    cell.textLabel.minimumScaleFactor = 10;
    cell.textLabel.font = [UIFont boldSystemFontOfSize:10];
    cell.cornerRadius = 5;
    cell.customSeparatorColor = [UIColor colorWithHex:0xCC3599];
    cell.borderColor = [UIColor colorWithHex:0xCC3599];
    [cell prepareForTableView:tableView indexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    cell.textLabel.text = [[placeList objectAtIndex:indexPath.row] objectForKey:@"name"];
    cell.detailTextLabel.text = [[placeList objectAtIndex:indexPath.row] objectForKey:@"date"];
    cell.detailTextLabel.textAlignment = NSTextAlignmentRight;
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [_placeListTable deselectRowAtIndexPath:[_placeListTable indexPathForSelectedRow] animated:NO];
}


@end
