//
//  SocialViewController.m
//  LiveReport2013
//
//  Created by Ueta Masamichi on 2013/03/28.
//  Copyright (c) 2013年 Ueta Masamichi. All rights reserved.
//

#import "SocialViewController.h"

#import <Social/Social.h>

#import "PrettyKit.h"

@interface SocialViewController ()

@end

@implementation SocialViewController
@synthesize socialTable=_socialTable;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)FromInterfaceOrientation {
    if(bannerIsVisible){
        adBannerView.frame = CGRectMake(adBannerView.frame.origin.x, adBannerView.frame.origin.y, self.view.frame.size.width, adBannerView.frame.size.height);
        _socialTable.frame = CGRectMake(_socialTable.frame.origin.x, _socialTable.frame.origin.y + adBannerView.frame.size.height, _socialTable.frame.size.width, _socialTable.frame.size.height - adBannerView.frame.size.height);
    }
    else{
        _socialTable.frame = CGRectMake(_socialTable.frame.origin.x, 0, _socialTable.frame.size.width, self.view.frame.size.height);
    }
    
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
    _socialTable.delegate = self;
    _socialTable.dataSource = self;
    _socialTable.scrollsToTop = YES;
    [_socialTable dropShadows];
    _socialTable.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
}

-(void) initIAd{
    adBannerView = [[ADBannerView alloc] initWithAdType:ADAdTypeBanner];
    adBannerView.delegate = self;
    adBannerView.frame = CGRectOffset(adBannerView.frame, 0.0, -adBannerView.frame.size.height);
    bannerIsVisible=NO;
    [self.view addSubview:adBannerView];
}




#pragma mark -
#pragma mark View Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self customizeNavBar];
    [self initTableView];
    [self initIAd];
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
            NSString* tableHeader = NSLocalizedString(@"Facebook", @"Facebook");
            return tableHeader;
        }
            break;
        
        case 1:{
            //Localize
            NSString* tableHeader = NSLocalizedString(@"Twitter", @"Twitter");
            return tableHeader;
        }
            break;
            
        default:
            break;
    }
    return 0;
}

-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    if(section == ([_socialTable numberOfSections] -1)){
        //Localize
        NSString* tableFooter = NSLocalizedString(@"RockFordRecords Co., Ltd.", @"RockFordRecords Co., Ltd.");
        return tableFooter;
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
    
    //Cell Content
    switch (indexPath.section) {
        case 0:
            cell.textLabel.text = NSLocalizedString(@"Post to Facebook", @"Post to Facebook");
            cell.imageView.image = [UIImage imageNamed:@"facebook"];
            break;
        
        case 1:
            cell.textLabel.text = NSLocalizedString(@"Post to Twitter", @"Post to Twitter");
            cell.imageView.image = [UIImage imageNamed:@"twitter"];
            break;
            
        default:
            break;
    }
    
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [_socialTable deselectRowAtIndexPath:[_socialTable indexPathForSelectedRow] animated:NO];
    switch (indexPath.section) {
        case 0:{
            SLComposeViewController *facebookPostViewController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
            [facebookPostViewController setInitialText:@"facebook投稿テスト"];
            //[facebookPostVC addImage:[UIImage imageNamed:@"EUI.jpg"]];
            [self presentViewController:facebookPostViewController animated:YES completion:nil];
        }
            break;
            
        case 1:{
            SLComposeViewController *twitterPostViewController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
            [twitterPostViewController setInitialText:@"twitter投稿テスト"];
            [self presentViewController:twitterPostViewController animated:YES completion:nil];
        }
            
            break;
        default:
            break;
    }
}


#pragma mark -
#pragma mark AdBannerView Delegate Methods
-(void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    if (!bannerIsVisible)
    {
        [UIView beginAnimations:@"animateAdBannerOn" context:NULL];
        banner.frame = CGRectOffset(banner.frame, 0, adBannerView.frame.size.height);
        [UIView commitAnimations];
        
        bannerIsVisible = YES;
        adBannerView.frame = CGRectMake(adBannerView.frame.origin.x, adBannerView.frame.origin.y, self.view.frame.size.width, adBannerView.frame.size.height);
        _socialTable.frame = CGRectMake(_socialTable.frame.origin.x, _socialTable.frame.origin.y + adBannerView.frame.size.height, _socialTable.frame.size.width, _socialTable.frame.size.height - adBannerView.frame.size.height);
    }
}


-(void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    if (bannerIsVisible)
    {
        [UIView beginAnimations:@"animateAdBannerOff" context:NULL];
        banner.frame = CGRectOffset(banner.frame, 0, -adBannerView.frame.size.height);
        [UIView commitAnimations];
        bannerIsVisible = NO;
        _socialTable.frame = CGRectMake(_socialTable.frame.origin.x, 0, _socialTable.frame.size.width, self.view.frame.size.height);
    }
}


@end
