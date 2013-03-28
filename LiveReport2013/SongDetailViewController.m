//
//  SongDetailViewController.m
//  LiveReport2013
//
//  Created by Ueta Masamichi on 2013/03/28.
//  Copyright (c) 2013年 Ueta Masamichi. All rights reserved.
//

#import "SongDetailViewController.h"

#import "UIImage+Resize.h"

#import "PrettyKit.h"

@interface SongDetailViewController ()

@end

@implementation SongDetailViewController
@synthesize songDetailTable=_songDetailTable;
@synthesize songName=_songName;
@synthesize albumName=_albumName;
@synthesize albumPic=_albumPic;
@synthesize itunesLink=_itunesLink;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark -
#pragma mark Initialization
- (void) initTableView{
    _songDetailTable.delegate = self;
    _songDetailTable.dataSource = self;
    [_songDetailTable dropShadows];
    _songDetailTable.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationItem.title = _songName;
    self.navigationController.navigationBar.tintColor = [UIColor darkGrayColor];
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
    if([_itunesLink length] != 0) return 2;
    else return 1;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    switch (section) {
        case 0:{
            NSString* tableHeader = NSLocalizedString(@"Song Info", @"Song Link");
            return tableHeader;
        }
            break;
        case 1:{
            NSString* tableHeader = NSLocalizedString(@"iTunes Link", @"iTunes Link");
            return tableHeader;
        }
            break;
        default:
            break;
    }
    return 0;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
            return 130;
            break;
        case 1:
            return 60;
            break;
        default:
            break;
    }
    return 0;
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
    
    //Cell Content
    switch (indexPath.section) {
        case 0:{
            cell.textLabel.text = _albumName;
            NSString *picName = [NSString stringWithFormat:@"%@.jpg", _albumPic];
            cell.imageView.image = [UIImage getResizedImage:[UIImage imageNamed:picName] width:100.0f height:100.0f];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
            
            break;
        case 1:{
            cell.textLabel.text = NSLocalizedString(@"Buy this song in iTunes", @"Buy this song in iTunes");
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
            break;
            
        default:
            break;
    }
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
            break;
        case 1:
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString: _itunesLink]];
            break;
            
        default:
            break;
    }
    [_songDetailTable deselectRowAtIndexPath:[_songDetailTable indexPathForSelectedRow] animated:NO];
}


@end
