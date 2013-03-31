//
//  InfoViewController.m
//  LiveReport2013
//
//  Created by Ueta Masamichi on 2013/03/28.
//  Copyright (c) 2013年 Ueta Masamichi. All rights reserved.
//

#import "InfoViewController.h"

#import "PrettyKit.h"

@interface InfoViewController ()

@end

@implementation InfoViewController
@synthesize infoTable=_infoTable;

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
    navBar.roundedCornerRadius = 10;
    
}

#pragma mark -
#pragma mark Initialization
- (void) initTableView{
    _infoTable.delegate = self;
    _infoTable.dataSource = self;
    _infoTable.scrollsToTop = YES;
    [_infoTable dropShadows];
    _infoTable.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
}


#pragma mark -
#pragma mark View Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self customizeNavBar];
    [self initTableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark UITableView Delegate Methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:{
            //Localize
            NSString* tableHeader = NSLocalizedString(@"RockFordRecords Co,. Ltd.", @"RockFordRecords Co,. Ltd.");
            return tableHeader;
        }
        
        case 1:{
            //Localize
            NSString* tableHeader = NSLocalizedString(@"Developer", @"Developer");
            return tableHeader;
        }
            
            break;
            
        default:
            break;
    }
    return 0;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
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
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    //Cell Content
    switch (indexPath.section) {
        case 0:
            cell.textLabel.text = @"RockFordRecords Co,. Ltd.";
            break;
            
        case 1:
            cell.textLabel.text = @"Developer";
            break;
            
        default:
            break;
    }
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString: ROCKFORDRECORDS_URL]];
            break;
        case 1:
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString: DEVELOPER_URL]];
            break;
            
        default:
            break;
    }
    [_infoTable deselectRowAtIndexPath:[_infoTable indexPathForSelectedRow] animated:NO];
}



@end
